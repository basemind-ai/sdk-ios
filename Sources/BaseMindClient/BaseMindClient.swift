import BaseMindGateway
import Foundation
import GRPC
import Logging

enum BaseMindError: Error {
    /// generic error thrown whenever there is an error communicating with the server
    case serverError
    /// thrown when the server responds to a request with the gRPC 'invalid argument' status
    case invalidArgument
    /// thrown when the token passed to the SDK is empty
    case missingToken
    /// thrown when the connection to the server fails
    case connectionFailure
}

let DEFAULT_API_GATEWAY_ADDRESS = "gateway.basemind.ai"
let DEFAULT_API_GATEWAY_PORT = 443

public struct Options {
    /// The gRPC server address.
    var host: String = DEFAULT_API_GATEWAY_ADDRESS
    /// The gRPC server port.
    var port: Int = DEFAULT_API_GATEWAY_PORT
    /// A flag dictating whether debug messages will be logged.
    var debug: Bool = false
    /// The ID of the prompt configuration to use.
    ///
    /// Note: This value is optional. If not provided, the default prompt configuration will be used.
    var promptConfigId: String?
    /// The logger instance to use.
    ///
    /// Note: messages are logged only when 'debug' is set to true.
    var logger: Logger = .init(label: "BaseMindClient")
}

/// The BaseMindClient
///
/// Initialize the client by passing the initializer the api key that you created on the BaseMind dashboard.
/// You can also pass an options object.
public class BaseMindClient {
    private let client: Gateway_V1_APIGatewayServiceAsyncClient
    private let apiToken: String
    private let options: Options

    init(apiToken: String, options: Options = Options()) throws {
        if apiToken == "" {
            throw BaseMindError.missingToken
        }

        self.apiToken = apiToken
        self.options = options

        if self.options.debug {
            self.options.logger.debug("initializing client")
        }

        let eventLoopGroup = PlatformSupport.makeEventLoopGroup(loopCount: 1)
        do {
            let channel = try GRPCChannelPool.with(
                target: .host(options.host, port: options.port),
                transportSecurity: .plaintext,
                eventLoopGroup: eventLoopGroup
            )
            client = Gateway_V1_APIGatewayServiceAsyncClient(channel: channel)

            if self.options.debug {
                self.options.logger.debug("Successfully connected to BaseMind.AI server on \(options.host):\(options.port).")
            }
        } catch {
            if self.options.debug {
                self.options.logger.debug("Failed to connect to the BaseMind.AI server on \(options.host):\(options.port). Error: \(error).")
            }

            throw BaseMindError.connectionFailure
        }
    }

    private func createCallOptions() -> CallOptions {
        var options = CallOptions()

        options.customMetadata.add(
            name: "authorization",
            value: "Bearer \(apiToken)"
        )

        return options
    }

    private func createRequest(_ templateVariables: [String: String]? = nil) -> Gateway_V1_PromptRequest {
        var request = Gateway_V1_PromptRequest()

        if let variables = templateVariables {
            request.templateVariables = variables
        }

        if let configId = options.promptConfigId {
            request.promptConfigID = configId
        }

        return request
    }

    /// Request an LLM Prompt.
    /// - Parameter templateVariables: A dictionary of key/value strings. This dictionary should supply the values required for any template variables defined in the BaseMind dashboard.
    /// - Returns: A prompt response object.
    public func requestPrompt(_ templateVariables: [String: String]? = nil) async throws -> Gateway_V1_PromptResponse {
        do {
            if options.debug {
                options.logger.debug("requesting prompt")
            }

            let request = createRequest(templateVariables)
            return try await client.requestPrompt(request, callOptions: createCallOptions())
        } catch {
            if options.debug {
                options.logger.debug("error requesting prompt \(error)")
            }

            if let status = error as? GRPCStatus {
                throw status.code == GRPCStatus.Code.invalidArgument ? BaseMindError.invalidArgument : BaseMindError.serverError
            }
            throw BaseMindError.serverError
        }
    }

    public func requestStream(_ templateVariables: [String: String]? = nil) async throws -> ThrowingRequestStream<Gateway_V1_StreamingPromptResponse> {
        if options.debug {
            options.logger.debug("requesting streaming prompt")
        }

        let request = createRequest(templateVariables)
        let stream = client.requestStreamingPrompt(request, callOptions: createCallOptions())

        return ThrowingRequestStream(stream: stream,
                                     logError: {
                                         (error: Error) in
                                         if self.options.debug {
                                             self.options.logger.debug("erroring streaming prompt \(error)")
                                         }

                                     })
    }
}

public struct ThrowingRequestStream<Element: Sendable>: AsyncIteratorProtocol {
    private var iterator: GRPCAsyncResponseStream<Element>.AsyncIterator
    private let logError: (_ error: Error) -> Void

    init(stream: GRPCAsyncResponseStream<Element>, logError: @escaping (_ error: Error) -> Void) {
        iterator = stream.makeAsyncIterator()
        self.logError = logError
    }

    public mutating func next() async throws -> Element? {
        if Task.isCancelled { throw GRPCStatus(code: .cancelled) }
        do {
            return try await iterator.next()
        } catch {
            logError(error)

            if let status = error as? GRPCStatus {
                throw status.code == GRPCStatus.Code.invalidArgument ? BaseMindError.invalidArgument : BaseMindError.serverError
            }
            throw BaseMindError.serverError
        }
    }
}
