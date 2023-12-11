import BaseMindGateway
import Foundation
import GRPC
import NIOCore
import NIOSSL
import OSLog

/// Error types thrown by the BaseMindClient
public enum BaseMindError: Error {
    /// generic error thrown whenever there is an error communicating with the server
    case serverError
    /// thrown when the server responds to a request with the gRPC 'invalid argument' status
    case invalidArgument
    /// thrown when the token passed to the SDK is empty
    case missingToken
    /// thrown when a stream is cancelled
    case cancelled
}

public let DEFAULT_API_GATEWAY_ADDRESS = "gateway.basemind.ai"
public let DEFAULT_API_GATEWAY_PORT = 443
public let DEFAULT_LOGGER = Logger(subsystem: "BaseMindClient", category: "client logs")

/// Client Options container.
///
/// Example usage:
///
///     let options = ClientOptions(debug: true)
///     let client = BaseMindClient(apiKey: "<API_KEY>", options: options)
///
public struct ClientOptions {
    public init(
        host: String? = nil,
        port: Int? = nil,
        debug: Bool? = nil,
        promptConfigId: String? = nil,
        logger: Logger? = nil
    ) {
        if let host {
            self.host = host
        }
        if let port {
            self.port = port
        }
        if let debug {
            self.debug = debug
        }
        if let promptConfigId {
            self.promptConfigId = promptConfigId
        }
        if let logger {
            self.logger = logger
        }
    }

    /// The gRPC server address.
    public var host: String = DEFAULT_API_GATEWAY_ADDRESS
    /// The gRPC server port.
    public var port: Int = DEFAULT_API_GATEWAY_PORT
    /// A flag dictating whether debug messages will be logged.
    public var debug: Bool = false
    /// The ID of the prompt configuration to use.
    ///
    /// Note: This value is optional. If not provided, the default prompt configuration will be used.
    public var promptConfigId: String?
    /// The logger instance to use.
    ///
    /// Note: messages are logged only when 'debug' is set to true.
    public var logger: Logger = DEFAULT_LOGGER
}

/// The BaseMindClient
///
/// Initialize the client by passing the initializer the api key that you created on the BaseMind dashboard.
/// You can also pass an options object.
public class BaseMindClient {
    private let client: Gateway_V1_APIGatewayServiceAsyncClient
    private let apiKey: String
    private let options: ClientOptions

    public init(apiKey: String, options: ClientOptions = ClientOptions()) throws {
        if apiKey.isEmpty {
            throw BaseMindError.missingToken
        }

        self.apiKey = apiKey
        self.options = options

        if self.options.debug {
            self.options.logger.debug("initializing client")
        }

        let eventLoopGroup = PlatformSupport.makeEventLoopGroup(loopCount: 1)
        let connection = ClientConnection
            .usingTLSBackedByNIOSSL(on: eventLoopGroup)
            .withTLS(trustRoots: .certificates([]))
            .withTLS(certificateVerification: .none)
            .connect(host: options.host, port: options.port)

        client = Gateway_V1_APIGatewayServiceAsyncClient(channel: connection)

        if self.options.debug {
            self.options.logger.debug("connected to BaseMind.AI server on \(options.host):\(options.port).")
        }
    }

    private func createCallOptions() -> CallOptions {
        var options = CallOptions()

        options.customMetadata.add(
            name: "authorization",
            value: "Bearer \(apiKey)"
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

    /// Close the client, and any connections associated with it. Any ongoing RPCs may fail.
    ///
    /// - Returns: Returns a future which will be resolved when shutdown has completed.
    public func close() -> EventLoopFuture<Void> {
        client.channel.close()
    }

    /// Request an LLM Prompt.
    ///
    /// - Parameter templateVariables: A dictionary of key/value strings. This dictionary should supply the values required for any template variables defined in the BaseMind dashboard.
    ///
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
                if status.code == GRPCStatus.Code.invalidArgument {
                    throw BaseMindError.invalidArgument
                }
            }
            throw BaseMindError.serverError
        }
    }

    /// Request an LLM Streaming Prompt
    ///
    /// - Parameter templateVariables: A dictionary of key/value strings. This dictionary should supply the values required for any template variables defined in the BaseMind dashboard.
    ///
    /// - Returns: A stream conforming to the AsyncIterator protocol. Iterate the stream to access each chunk of the result in the order it is
    /// being transmitted by the server.
    public func requestStream(_ templateVariables: [String: String]? = nil) async throws -> ThrowingRequestStream<Gateway_V1_StreamingPromptResponse> {
        if options.debug {
            options.logger.debug("requesting streaming prompt")
        }

        let request = createRequest(templateVariables)
        let stream = client.requestStreamingPrompt(request, callOptions: createCallOptions())

        let logError = {
            (error: Error) in

            if self.options.debug {
                self.options.logger.debug("erroring streaming prompt \(error)")
            }
        }

        return ThrowingRequestStream(stream: stream, logError: logError)
    }
}

/// An AsyncIterator of StreamingPromptResponse elements.
///
/// Throws BaseMindError.
public struct ThrowingRequestStream<Value: Sendable>: AsyncSequence, AsyncIteratorProtocol {
    public typealias AsyncIterator = ThrowingRequestStream<Value>
    public typealias Element = Value

    private var iterator: GRPCAsyncResponseStream<Element>.AsyncIterator
    private let logError: (_ error: Error) -> Void

    init(stream: GRPCAsyncResponseStream<Value>, logError: @escaping (_ error: Error) -> Void) {
        iterator = stream.makeAsyncIterator()
        self.logError = logError
    }

    public mutating func next() async throws -> Element? {
        if Task.isCancelled { throw BaseMindError.cancelled }
        do {
            return try await iterator.next()
        } catch {
            logError(error)

            if let status = error as? GRPCStatus {
                if status.code == GRPCStatus.Code.invalidArgument {
                    throw BaseMindError.invalidArgument
                }
            }

            throw BaseMindError.serverError
        }
    }

    public func makeAsyncIterator() -> AsyncIterator {
        self
    }
}
