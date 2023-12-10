import BaseMindClient
import BaseMindGateway
import struct Foundation.Date
import GRPC
import NIOConcurrencyHelpers
import NIOCore
import NIOPosix
import NIOSSL
import SwiftProtobuf
import XCTest

private let serverCert = """
-----BEGIN CERTIFICATE-----
MIICmjCCAYICAQEwDQYJKoZIhvcNAQELBQAwEjEQMA4GA1UEAwwHc29tZS1jYTAe
Fw0yMzA3MDUxMDI4NDRaFw0yNDA3MDQxMDI4NDRaMBQxEjAQBgNVBAMMCWxvY2Fs
aG9zdDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKTZdzuWLHyxPM/F
sviBBXpSzl2MxJxDkmir8DSdXO5E1sHCAymTaxy9bOdi1XUZbRTyKfTv3x6sdRdT
0Gs2WjhL0yFT9IEVrGZADt3GIYoHYZU56Yn/nLglGQZqIeo33wyPEIAkbWL6X4RG
1Hc6nJQxhw1aaVtsYNAoWjAVzP773TZgyRcsGliqHtYpD0q0b+EfmPkb0GM1yvBa
j88dWWFFlG00aZFQatSkIrPbkXG0Mu4/1UxYDEuxOYrIFkFMfR8V8h6ZQ2x3H6cS
cTJ2TpIlw3rO6E0J/HYaVhmvJpevIPQhvH/Q+vM1bkvaIkckLchW7VgU4P+ZzHEw
r/xMcqMCAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAGpBsuzx72mOBa9o7m1eNh2cY
H6MrNi1b6vTaA3SOH68RDxg2qx6UrKxI34/No7FaOzRrfs9vUaKXHwwBnDxMskH5
iTmVAGegumDQE3Bd11j+v1tKxXWS/bvWH7tfK6taoex76ktR3L8qO+Hp8n4YKuSb
qJScIhMPIg7fWPonLvcszGFPdBIxU3YkAZJZFeom/s1WhWCYXsJZSYOXv4YRlaU5
ozeV3v9icDptaxNY7n4U6C32eykMjowJJ9dcOD+ib3PF88S+utmZnSEGYu+5bnXy
6MGWZcYH1wQ0RpNC+YzjQcGsKwHfaoBS4WFEK2fJdRfX4owZOu6HO1zhyoLpqw==
-----END CERTIFICATE-----
"""

private let serverKey = """
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEApNl3O5YsfLE8z8Wy+IEFelLOXYzEnEOSaKvwNJ1c7kTWwcID
KZNrHL1s52LVdRltFPIp9O/fHqx1F1PQazZaOEvTIVP0gRWsZkAO3cYhigdhlTnp
if+cuCUZBmoh6jffDI8QgCRtYvpfhEbUdzqclDGHDVppW2xg0ChaMBXM/vvdNmDJ
FywaWKoe1ikPSrRv4R+Y+RvQYzXK8FqPzx1ZYUWUbTRpkVBq1KQis9uRcbQy7j/V
TFgMS7E5isgWQUx9HxXyHplDbHcfpxJxMnZOkiXDes7oTQn8dhpWGa8ml68g9CG8
f9D68zVuS9oiRyQtyFbtWBTg/5nMcTCv/ExyowIDAQABAoIBAAq5FpdqqlQmF0WQ
n5aoldmiH0hYisV7Y7+pR4O0pMHe+nU6EIiYzUPeUoIunKH0WHMfWXlUTRgqsacl
zY3byDyXOhGV63amGUPBcPYeGDppRoC1dqqCVQhpaVpQdwpMPhcMC0+6jt78WFA7
Z0CmMF83ZYiJ1AadYyLHLS6pjF8dmkj/Rd6yeLIVkKr4xHxou7au/6WKorop5XLM
fEyWC2iotha2dkXw3i324n0qrbR2v/EYLnAn75uA9FF/pJWe6iPc6H5tfBSnzmO6
fkZ2rCrDt4ANabg6WMmRdrZXFHSR/JlPPyh4T4iJGenkLltKZG+wWSm2nVXE0DYt
JQdmhiECgYEAz3EclGIrk63Hp/2mAHAOIOUGh6+Tk4JA+ibHSzziVZZqJsGQ9jcK
eOn6TX5674+aNzo2ROnHCT6u2tCQEl5/lrB8YpYh3F6aaNqPvFwqRhDViOw2l8KL
Ic40x19o5ur3Ss914htwTxiEzQVB/n+5zhE7W4N/RaDIT2hedWR19PECgYEAy3AF
CiHa6P+pbhskoSETtxbWkhDENpXat2dlFRDrNN9T2NZNVmIxCjAE52arduCxaLTP
hazyq4d7FZ4OkxfbJY9D2HnBS6mF0RHB0gZXZ7iB/uEr0KcTex5saqX9TF3YA5Wj
PNVtOM37IIaLJ1qOmfXf4yL3EVlI30eNwfoMkNMCgYAv0VAYOET5Rs7GP6b7ZNks
5f5KWsO29giKYVQBWOiHeCPCCU6kIu3sD2teX7Bw9nZDEs0dt5Hk5Kkj0X3UbioV
D1us0hS+GqSXVQJbFhe8jPbcGC9BblvqEAGEj867pCAbA5WV6GNMKEe8huC+jKzE
/p3jK320DCsAevuDLgQu0QKBgHvE60v+zPB0muAiI2bkeNorSuAS001iXm62uQjY
AkFondqOhv7HPo60KEegbzEkAstxNdBeKEWzZ27/el6DZRC02NIbQT6HJKLN6t2c
fhDccDphRAbtnyyIle1Mj46miYWkxGt+bbThnKdtM7v9nESPEmdeHnKvn2Y4YkZh
msOBAoGAaarkv8JjjmIgjRZrJ7r4dkzZwZa/msm+/NHr3nlXK227ExMeFRPmzYls
zIofM+DoEk1sDXRfnv+8EU8Dn1DYSq6M6W8xrm7Ulpzj0kXE4f9TD+MUwSNCQ6Gg
zLRkHQBKblIa0lEvlulLtJT2UN9AnCmvTH2R11wD87DWjFDZKD8=
-----END RSA PRIVATE KEY-----
"""

private let caCert = """
-----BEGIN CERTIFICATE-----
MIICoDCCAYgCCQCgCA1/0dKfFjANBgkqhkiG9w0BAQsFADASMRAwDgYDVQQDDAdz
b21lLWNhMB4XDTIzMDcwNTEwMjg0NFoXDTI0MDcwNDEwMjg0NFowEjEQMA4GA1UE
AwwHc29tZS1jYTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALTi2aJy
Vw3E0OQwNIm9GZOG4E/Rc0atKoJes9yWaMrMPGwoenLEc2JNIvJSdBGZHKO7HKAG
OnffpqVIXtRBIU7l8HEhX97Q+knI6wPz8O7JaGVf6KznLa2eFO6xGM1pogO7m+/M
0mw8LSftn2IEiJk9v00qj+WgfwJJqL/TUZRoT5M2+u99uiaW7bnI1+1vawo5i7A1
zfN6SBud5K/BaEYcAjxX1JMWCJLWSuOFZArWX7Je2MP+LqZkjh8kQO+d8ZZaLSIs
ujd6x6/r365Sl24l4auNfWy/5V1Ctfxl4avupAm7CpmEFpswe/ucNHkD0drUCzvt
hBeR3coLXWgbQs0CAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAJm1Yntrrl6WxPbsA
s1DrI9YHdQjUNkouX0PtGp4yKrP7hwTclIhHjlGaQRJ2p1I7hllCMCPDa2YZa714
XhtvEmpWOeLXMFolpKEn83kccvkQviZ3yd2lKH64jDX1/g2Rf6dXhDZMKrMAkEdx
X3JwZwPxwb8VDtac7TkVgOcQFHRzdX2g6pQXz3eNsjckGNJgzzl/ln6DrHHDbruI
M7bfnc2ZCBcHUCLWts8LnX2ekUq9KOxMe4e3sD27sKPizklNfGH4Rdg4LByhkx3S
GGR3ziWyixfcs4BNhA5mbsvb8vpPdtOh1oFt+TtPxlQ2FQOnSHk6wF285XggYYgv
p8pG5Q==
-----END CERTIFICATE-----
"""

let certificate = try! NIOSSLCertificate(bytes: .init(serverCert.utf8), format: .pem)
let key = try! NIOSSLPrivateKey(
    bytes: .init(serverKey.utf8),
    format: .pem
)
let caCertificate = try! NIOSSLCertificate(bytes: .init(caCert.utf8), format: .pem)

final class MockGatewayServer: Gateway_V1_APIGatewayServiceAsyncProvider {
    public var exc: Error?
    public var authHeader: String?
    public var templateVariables: [String: String]?
    public var promptConfigId: String?
    public var request: Gateway_V1_PromptRequest?

    init() {}

    func requestPrompt(request: BaseMindGateway.Gateway_V1_PromptRequest, context _: GRPC.GRPCAsyncServerCallContext) async throws -> BaseMindGateway.Gateway_V1_PromptResponse {
        self.request = request

        if let exc {
            throw exc
        }

        var response = BaseMindGateway.Gateway_V1_PromptResponse()
        response.content = "abc"

        return response
    }

    func requestStreamingPrompt(request: BaseMindGateway.Gateway_V1_PromptRequest, responseStream _: GRPC.GRPCAsyncResponseStreamWriter<BaseMindGateway.Gateway_V1_StreamingPromptResponse>, context _: GRPC.GRPCAsyncServerCallContext) async throws {
        self.request = request

        if let exc {
            throw exc
        }
    }
}

/// Client test suite
///
/// See: https://github.com/grpc/grpc-swift/blob/main/Tests/GRPCTests for examples
final class BaseMindClientTests: XCTestCase {
    let token = "abcJeronimo"

    var server: Server!
    var provider: MockGatewayServer!
    var group: EventLoopGroup!

    override func setUp() {
        super.setUp()

        group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        provider = MockGatewayServer()
    }

    override func tearDown() async throws {
        try await server.close().get()
        server = nil

        try await group.shutdownGracefully()
        group = nil

        provider = nil

        try await super.tearDown()
    }

    private func startServer() throws {
        server = try Server.insecure(group: group)
            .withServiceProviders([provider])
            .bind(host: "127.0.0.1", port: 0)
            .wait()
    }

    func makeClient() throws -> BaseMindClient {
        var options = ClientOptions()
        options.host = "127.0.0.1"
        options.port = server.channel.localAddress!.port!

        return try BaseMindClient(apiKey: token, options: options)
    }

    func testThrowsWhenTokenIsEmpty() throws {
        XCTAssertThrowsError(try BaseMindClient(apiKey: ""))
    }

    func testReturnsReponse() async throws {
        try startServer()

        let client = try makeClient()
        let response = try await client.requestPrompt()
        XCTAssertEqual(response.content, "abc")
    }
}
