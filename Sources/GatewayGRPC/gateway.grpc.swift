//
// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the protocol buffer compiler.
// Source: gateway/v1/gateway.proto
//
import GRPC
import NIO
import NIOConcurrencyHelpers
import SwiftProtobuf

/// The API Gateway service definition.
///
/// Usage: instantiate `Gateway_V1_APIGatewayServiceClient`, then call methods of this protocol to make API calls.
protocol Gateway_V1_APIGatewayServiceClientProtocol: GRPCClient {
    var serviceName: String { get }
    var interceptors: Gateway_V1_APIGatewayServiceClientInterceptorFactoryProtocol? { get }

    func requestPrompt(
        _ request: Gateway_V1_PromptRequest,
        callOptions: CallOptions?
    ) -> UnaryCall<Gateway_V1_PromptRequest, Gateway_V1_PromptResponse>

    func requestStreamingPrompt(
        _ request: Gateway_V1_PromptRequest,
        callOptions: CallOptions?,
        handler: @escaping (Gateway_V1_StreamingPromptResponse) -> Void
    ) -> ServerStreamingCall<Gateway_V1_PromptRequest, Gateway_V1_StreamingPromptResponse>
}

extension Gateway_V1_APIGatewayServiceClientProtocol {
    var serviceName: String {
        "gateway.v1.APIGatewayService"
    }

    /// Request a regular LLM prompt
    ///
    /// - Parameters:
    ///   - request: Request to send to RequestPrompt.
    ///   - callOptions: Call options.
    /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
    func requestPrompt(
        _ request: Gateway_V1_PromptRequest,
        callOptions: CallOptions? = nil
    ) -> UnaryCall<Gateway_V1_PromptRequest, Gateway_V1_PromptResponse> {
        makeUnaryCall(
            path: Gateway_V1_APIGatewayServiceClientMetadata.Methods.requestPrompt.path,
            request: request,
            callOptions: callOptions ?? defaultCallOptions,
            interceptors: interceptors?.makeRequestPromptInterceptors() ?? []
        )
    }

    /// Request a streaming LLM prompt
    ///
    /// - Parameters:
    ///   - request: Request to send to RequestStreamingPrompt.
    ///   - callOptions: Call options.
    ///   - handler: A closure called when each response is received from the server.
    /// - Returns: A `ServerStreamingCall` with futures for the metadata and status.
    func requestStreamingPrompt(
        _ request: Gateway_V1_PromptRequest,
        callOptions: CallOptions? = nil,
        handler: @escaping (Gateway_V1_StreamingPromptResponse) -> Void
    ) -> ServerStreamingCall<Gateway_V1_PromptRequest, Gateway_V1_StreamingPromptResponse> {
        makeServerStreamingCall(
            path: Gateway_V1_APIGatewayServiceClientMetadata.Methods.requestStreamingPrompt.path,
            request: request,
            callOptions: callOptions ?? defaultCallOptions,
            interceptors: interceptors?.makeRequestStreamingPromptInterceptors() ?? [],
            handler: handler
        )
    }
}

@available(*, deprecated)
extension Gateway_V1_APIGatewayServiceClient: @unchecked Sendable {}

@available(*, deprecated, renamed: "Gateway_V1_APIGatewayServiceNIOClient")
final class Gateway_V1_APIGatewayServiceClient: Gateway_V1_APIGatewayServiceClientProtocol {
    private let lock = Lock()
    private var _defaultCallOptions: CallOptions
    private var _interceptors: Gateway_V1_APIGatewayServiceClientInterceptorFactoryProtocol?
    let channel: GRPCChannel
    var defaultCallOptions: CallOptions {
        get { lock.withLock { self._defaultCallOptions } }
        set { lock.withLockVoid { self._defaultCallOptions = newValue } }
    }

    var interceptors: Gateway_V1_APIGatewayServiceClientInterceptorFactoryProtocol? {
        get { lock.withLock { self._interceptors } }
        set { lock.withLockVoid { self._interceptors = newValue } }
    }

    /// Creates a client for the gateway.v1.APIGatewayService service.
    ///
    /// - Parameters:
    ///   - channel: `GRPCChannel` to the service host.
    ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
    ///   - interceptors: A factory providing interceptors for each RPC.
    init(
        channel: GRPCChannel,
        defaultCallOptions: CallOptions = CallOptions(),
        interceptors: Gateway_V1_APIGatewayServiceClientInterceptorFactoryProtocol? = nil
    ) {
        self.channel = channel
        _defaultCallOptions = defaultCallOptions
        _interceptors = interceptors
    }
}

struct Gateway_V1_APIGatewayServiceNIOClient: Gateway_V1_APIGatewayServiceClientProtocol {
    var channel: GRPCChannel
    var defaultCallOptions: CallOptions
    var interceptors: Gateway_V1_APIGatewayServiceClientInterceptorFactoryProtocol?

    /// Creates a client for the gateway.v1.APIGatewayService service.
    ///
    /// - Parameters:
    ///   - channel: `GRPCChannel` to the service host.
    ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
    ///   - interceptors: A factory providing interceptors for each RPC.
    init(
        channel: GRPCChannel,
        defaultCallOptions: CallOptions = CallOptions(),
        interceptors: Gateway_V1_APIGatewayServiceClientInterceptorFactoryProtocol? = nil
    ) {
        self.channel = channel
        self.defaultCallOptions = defaultCallOptions
        self.interceptors = interceptors
    }
}

/// The API Gateway service definition.
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
protocol Gateway_V1_APIGatewayServiceAsyncClientProtocol: GRPCClient {
    static var serviceDescriptor: GRPCServiceDescriptor { get }
    var interceptors: Gateway_V1_APIGatewayServiceClientInterceptorFactoryProtocol? { get }

    func makeRequestPromptCall(
        _ request: Gateway_V1_PromptRequest,
        callOptions: CallOptions?
    ) -> GRPCAsyncUnaryCall<Gateway_V1_PromptRequest, Gateway_V1_PromptResponse>

    func makeRequestStreamingPromptCall(
        _ request: Gateway_V1_PromptRequest,
        callOptions: CallOptions?
    ) -> GRPCAsyncServerStreamingCall<Gateway_V1_PromptRequest, Gateway_V1_StreamingPromptResponse>
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Gateway_V1_APIGatewayServiceAsyncClientProtocol {
    static var serviceDescriptor: GRPCServiceDescriptor {
        Gateway_V1_APIGatewayServiceClientMetadata.serviceDescriptor
    }

    var interceptors: Gateway_V1_APIGatewayServiceClientInterceptorFactoryProtocol? {
        nil
    }

    func makeRequestPromptCall(
        _ request: Gateway_V1_PromptRequest,
        callOptions: CallOptions? = nil
    ) -> GRPCAsyncUnaryCall<Gateway_V1_PromptRequest, Gateway_V1_PromptResponse> {
        makeAsyncUnaryCall(
            path: Gateway_V1_APIGatewayServiceClientMetadata.Methods.requestPrompt.path,
            request: request,
            callOptions: callOptions ?? defaultCallOptions,
            interceptors: interceptors?.makeRequestPromptInterceptors() ?? []
        )
    }

    func makeRequestStreamingPromptCall(
        _ request: Gateway_V1_PromptRequest,
        callOptions: CallOptions? = nil
    ) -> GRPCAsyncServerStreamingCall<Gateway_V1_PromptRequest, Gateway_V1_StreamingPromptResponse> {
        makeAsyncServerStreamingCall(
            path: Gateway_V1_APIGatewayServiceClientMetadata.Methods.requestStreamingPrompt.path,
            request: request,
            callOptions: callOptions ?? defaultCallOptions,
            interceptors: interceptors?.makeRequestStreamingPromptInterceptors() ?? []
        )
    }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Gateway_V1_APIGatewayServiceAsyncClientProtocol {
    func requestPrompt(
        _ request: Gateway_V1_PromptRequest,
        callOptions: CallOptions? = nil
    ) async throws -> Gateway_V1_PromptResponse {
        try await performAsyncUnaryCall(
            path: Gateway_V1_APIGatewayServiceClientMetadata.Methods.requestPrompt.path,
            request: request,
            callOptions: callOptions ?? defaultCallOptions,
            interceptors: interceptors?.makeRequestPromptInterceptors() ?? []
        )
    }

    func requestStreamingPrompt(
        _ request: Gateway_V1_PromptRequest,
        callOptions: CallOptions? = nil
    ) -> GRPCAsyncResponseStream<Gateway_V1_StreamingPromptResponse> {
        performAsyncServerStreamingCall(
            path: Gateway_V1_APIGatewayServiceClientMetadata.Methods.requestStreamingPrompt.path,
            request: request,
            callOptions: callOptions ?? defaultCallOptions,
            interceptors: interceptors?.makeRequestStreamingPromptInterceptors() ?? []
        )
    }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
struct Gateway_V1_APIGatewayServiceAsyncClient: Gateway_V1_APIGatewayServiceAsyncClientProtocol {
    var channel: GRPCChannel
    var defaultCallOptions: CallOptions
    var interceptors: Gateway_V1_APIGatewayServiceClientInterceptorFactoryProtocol?

    init(
        channel: GRPCChannel,
        defaultCallOptions: CallOptions = CallOptions(),
        interceptors: Gateway_V1_APIGatewayServiceClientInterceptorFactoryProtocol? = nil
    ) {
        self.channel = channel
        self.defaultCallOptions = defaultCallOptions
        self.interceptors = interceptors
    }
}

protocol Gateway_V1_APIGatewayServiceClientInterceptorFactoryProtocol: Sendable {
    /// - Returns: Interceptors to use when invoking 'requestPrompt'.
    func makeRequestPromptInterceptors() -> [ClientInterceptor<Gateway_V1_PromptRequest, Gateway_V1_PromptResponse>]

    /// - Returns: Interceptors to use when invoking 'requestStreamingPrompt'.
    func makeRequestStreamingPromptInterceptors() -> [ClientInterceptor<Gateway_V1_PromptRequest, Gateway_V1_StreamingPromptResponse>]
}

enum Gateway_V1_APIGatewayServiceClientMetadata {
    static let serviceDescriptor = GRPCServiceDescriptor(
        name: "APIGatewayService",
        fullName: "gateway.v1.APIGatewayService",
        methods: [
            Gateway_V1_APIGatewayServiceClientMetadata.Methods.requestPrompt,
            Gateway_V1_APIGatewayServiceClientMetadata.Methods.requestStreamingPrompt,
        ]
    )

    enum Methods {
        static let requestPrompt = GRPCMethodDescriptor(
            name: "RequestPrompt",
            path: "/gateway.v1.APIGatewayService/RequestPrompt",
            type: GRPCCallType.unary
        )

        static let requestStreamingPrompt = GRPCMethodDescriptor(
            name: "RequestStreamingPrompt",
            path: "/gateway.v1.APIGatewayService/RequestStreamingPrompt",
            type: GRPCCallType.serverStreaming
        )
    }
}

/// The API Gateway service definition.
///
/// To build a server, implement a class that conforms to this protocol.
protocol Gateway_V1_APIGatewayServiceProvider: CallHandlerProvider {
    var interceptors: Gateway_V1_APIGatewayServiceServerInterceptorFactoryProtocol? { get }

    /// Request a regular LLM prompt
    func requestPrompt(request: Gateway_V1_PromptRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Gateway_V1_PromptResponse>

    /// Request a streaming LLM prompt
    func requestStreamingPrompt(request: Gateway_V1_PromptRequest, context: StreamingResponseCallContext<Gateway_V1_StreamingPromptResponse>) -> EventLoopFuture<GRPCStatus>
}

extension Gateway_V1_APIGatewayServiceProvider {
    var serviceName: Substring {
        Gateway_V1_APIGatewayServiceServerMetadata.serviceDescriptor.fullName[...]
    }

    /// Determines, calls and returns the appropriate request handler, depending on the request's method.
    /// Returns nil for methods not handled by this service.
    func handle(
        method name: Substring,
        context: CallHandlerContext
    ) -> GRPCServerHandlerProtocol? {
        switch name {
        case "RequestPrompt":
            UnaryServerHandler(
                context: context,
                requestDeserializer: ProtobufDeserializer<Gateway_V1_PromptRequest>(),
                responseSerializer: ProtobufSerializer<Gateway_V1_PromptResponse>(),
                interceptors: interceptors?.makeRequestPromptInterceptors() ?? [],
                userFunction: requestPrompt(request:context:)
            )

        case "RequestStreamingPrompt":
            ServerStreamingServerHandler(
                context: context,
                requestDeserializer: ProtobufDeserializer<Gateway_V1_PromptRequest>(),
                responseSerializer: ProtobufSerializer<Gateway_V1_StreamingPromptResponse>(),
                interceptors: interceptors?.makeRequestStreamingPromptInterceptors() ?? [],
                userFunction: requestStreamingPrompt(request:context:)
            )

        default:
            nil
        }
    }
}

/// The API Gateway service definition.
///
/// To implement a server, implement an object which conforms to this protocol.
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
protocol Gateway_V1_APIGatewayServiceAsyncProvider: CallHandlerProvider, Sendable {
    static var serviceDescriptor: GRPCServiceDescriptor { get }
    var interceptors: Gateway_V1_APIGatewayServiceServerInterceptorFactoryProtocol? { get }

    /// Request a regular LLM prompt
    func requestPrompt(
        request: Gateway_V1_PromptRequest,
        context: GRPCAsyncServerCallContext
    ) async throws -> Gateway_V1_PromptResponse

    /// Request a streaming LLM prompt
    func requestStreamingPrompt(
        request: Gateway_V1_PromptRequest,
        responseStream: GRPCAsyncResponseStreamWriter<Gateway_V1_StreamingPromptResponse>,
        context: GRPCAsyncServerCallContext
    ) async throws
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Gateway_V1_APIGatewayServiceAsyncProvider {
    static var serviceDescriptor: GRPCServiceDescriptor {
        Gateway_V1_APIGatewayServiceServerMetadata.serviceDescriptor
    }

    var serviceName: Substring {
        Gateway_V1_APIGatewayServiceServerMetadata.serviceDescriptor.fullName[...]
    }

    var interceptors: Gateway_V1_APIGatewayServiceServerInterceptorFactoryProtocol? {
        nil
    }

    func handle(
        method name: Substring,
        context: CallHandlerContext
    ) -> GRPCServerHandlerProtocol? {
        switch name {
        case "RequestPrompt":
            GRPCAsyncServerHandler(
                context: context,
                requestDeserializer: ProtobufDeserializer<Gateway_V1_PromptRequest>(),
                responseSerializer: ProtobufSerializer<Gateway_V1_PromptResponse>(),
                interceptors: interceptors?.makeRequestPromptInterceptors() ?? [],
                wrapping: { try await self.requestPrompt(request: $0, context: $1) }
            )

        case "RequestStreamingPrompt":
            GRPCAsyncServerHandler(
                context: context,
                requestDeserializer: ProtobufDeserializer<Gateway_V1_PromptRequest>(),
                responseSerializer: ProtobufSerializer<Gateway_V1_StreamingPromptResponse>(),
                interceptors: interceptors?.makeRequestStreamingPromptInterceptors() ?? [],
                wrapping: { try await self.requestStreamingPrompt(request: $0, responseStream: $1, context: $2) }
            )

        default:
            nil
        }
    }
}

protocol Gateway_V1_APIGatewayServiceServerInterceptorFactoryProtocol: Sendable {
    /// - Returns: Interceptors to use when handling 'requestPrompt'.
    ///   Defaults to calling `self.makeInterceptors()`.
    func makeRequestPromptInterceptors() -> [ServerInterceptor<Gateway_V1_PromptRequest, Gateway_V1_PromptResponse>]

    /// - Returns: Interceptors to use when handling 'requestStreamingPrompt'.
    ///   Defaults to calling `self.makeInterceptors()`.
    func makeRequestStreamingPromptInterceptors() -> [ServerInterceptor<Gateway_V1_PromptRequest, Gateway_V1_StreamingPromptResponse>]
}

enum Gateway_V1_APIGatewayServiceServerMetadata {
    static let serviceDescriptor = GRPCServiceDescriptor(
        name: "APIGatewayService",
        fullName: "gateway.v1.APIGatewayService",
        methods: [
            Gateway_V1_APIGatewayServiceServerMetadata.Methods.requestPrompt,
            Gateway_V1_APIGatewayServiceServerMetadata.Methods.requestStreamingPrompt,
        ]
    )

    enum Methods {
        static let requestPrompt = GRPCMethodDescriptor(
            name: "RequestPrompt",
            path: "/gateway.v1.APIGatewayService/RequestPrompt",
            type: GRPCCallType.unary
        )

        static let requestStreamingPrompt = GRPCMethodDescriptor(
            name: "RequestStreamingPrompt",
            path: "/gateway.v1.APIGatewayService/RequestStreamingPrompt",
            type: GRPCCallType.serverStreaming
        )
    }
}