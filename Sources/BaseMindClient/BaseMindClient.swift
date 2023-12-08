import BaseMindGateway
import Foundation
import GRPC

enum BaseMindError: Error {
    case connectionFailure
}

let DEFAULT_API_GATEWAY_ADDRESS = "gateway.basemind.ai"
let DEFAULT_API_GATEWAY_PORT = 443

public struct Options {
    var host: String = DEFAULT_API_GATEWAY_ADDRESS
    var port: Int = DEFAULT_API_GATEWAY_PORT
    var debug: Bool = false
    var promptConfigId: String?
    var logger: Logger = .init(
        subsystem: Bundle.main.bundleIdentifier!,
        category: "BaseMindClient"
    )
}

public class BaseMindClient {
    private let apiToken: String = ""
    private let promptConfigId: String?

    init(apiToken: String, options: Options = Options()) throws {
        self.apiToken = apiToken

        if options.debug {
            options.logger.debug("initializing client")
        }

        let eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1)

        do {
            let channel = try GRPCChannelPool.with(
                target: .host(options.host, port: options.port),
                transportSecurity: .tls,
                eventLoopGroup: eventLoopGroup
            )
        } catch {
            if options.debug {
                options.logger.debug("Failed to connect to BaseMind server on \(options.host):\(options.port). Error: \(error).")
            }

            throw BaseMindError.connectionFailure
        }
    }
}
