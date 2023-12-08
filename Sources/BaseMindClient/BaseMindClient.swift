import BaseMindGateway
import Foundation
import GRPC
import Logging

enum BaseMindError: Error {
    case missingToken
    case connectionFailure
}

let DEFAULT_API_GATEWAY_ADDRESS = "gateway.basemind.ai"
let DEFAULT_API_GATEWAY_PORT = 443

public struct Options {
    /* The gRPC server address. */
    var host: String = DEFAULT_API_GATEWAY_ADDRESS
    /* The gRPC server port. */
    var port: Int = DEFAULT_API_GATEWAY_PORT
    /* A flag dictating whether debug messages will be logged. */
    var debug: Bool = false
    /* The ID of the prompt configuration to use.

     This value is optional. If not provided, the default prompt configuration will be used.
     */
    var promptConfigId: String?
    /* The logger instance to use.

     Note: messages are logged only when 'debug' is set to true.
     */
    var logger: Logger = .init(label: "BaseMindClient")
}

public class BaseMindClient {
    private let client: BaseMindGateway.Gateway_V1_APIGatewayServiceAsyncClient
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
            client = BaseMindGateway.Gateway_V1_APIGatewayServiceAsyncClient(channel: channel)

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

    func requestPrompt(templateVariables _: [String: String]? = nil) async -> BaseMindGateway.Gateway_V1_PromptResponse {
        do {}
    }

    func requestStream(templateVariables _: [String: String]? = nil) async -> BaseMindGateway.Gateway_V1_StreamingPromptResponse {}
}
