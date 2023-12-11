# BaseMind.AI Swift (iOS/MacOS) SDK

<div align="center">

[![Discord](https://img.shields.io/discord/1153195687459160197)](https://discord.gg/ZSV2CQ86yg)

</div>

This repository hosts the BaseMind.AI Swift SDK. The SDK is a gRPC client library for connecting with the BaseMind.AI platform.

It supports iOS >= 13 and MacOS >= 12.

## Installation

Add the sdk in your `Package.swift` file dependencies:

```swift
    dependencies: [
        .package(url: "https://github.com/basemind-ai/sdk-ios.git", from: "1.0.0"),
    ]
```

Then add the dependency to a target:

```swift
    targets: [
        .target(
            name: "MyApp",
            dependencies: ["BaseMindClient"]
        ),
    ]
```

## Usage

Before using the client you have to initialize it. The init function requires an `apiKey` that you can create using the BaseMind platform (visit https://basemind.ai):

```swift
import BaseMindClient

let client = BaseMindClient(apiKey: "<MyApiKey>")
```

Once the client is initialized, you can use it to interact with the AI model(s) you configured in the BaseMind dashboard.

### Prompt Request/Response

You can request an LLM prompt using the `requestPrompt` method, which expects a dictionary of string key/value pairs - correlating with any template variables defined in the dashboard (if any):

```swift
import BaseMindClient

let client = BaseMindClient(apiKey: "<MyApiKey>")

func handlePromptRequest(userInput: String) async throws -> String {
    let templateVariables = ["userInput": userInput]

    let response = try client.requestPrompt(templateVariables)

    return response.content
}
```

### Prompt Streaming

You can also stream a prompt response using the `requestStream` method:

```swift
import BaseMindClient

let client = BaseMindClient(apiKey: "<MyApiKey>")

func handlePromptStream(userInput: String) async throws -> [String] {
    let templateVariables = ["userInput": userInput]

    let stream = try client.requestStream(templateVariables)

    var chunks: [String] = []

    for try await response in stream {
        chunks.append(response.content)
    }

    return chunks
}
```

Similarly to the `requestPrompt` method, `requestStream` expects a dictionary of strings (if any template variables are defined in the dashboard).

It returns a data container that is both an AsyncSequence and an AsyncIterator. You can therefore loop and iterate through the results as fits your use case.

### Error Handling

All errors thrown by the client are instances of `BaseMindError`. Errors are thrown in the following cases:

1. The api key is empty (`BaseMindError.missingToken`).
2. A server side or connectivity error occured (`BaseMindError.serverError`)
3. A required template variable was not provided in the dictionary of the request (`BaseMindError.invalidArgument`).
4. The task containing streaming is cancelled (`BaseMindError.cancelled`).

### Options

You can pass an options struct to the client:

```swift
import BaseMindClient
import OSLog

let options = ClientOptions(
    debug: true,
    host: "127.0.0.1",
    logger: Logger(subsystem: "my-sub-system", category: "client"),
    port: 443,
    promptConfigId: "c5f5d1fd-d25d-4ba2-b103-8c85f48a679d"
)

let client = BaseMindClient(apiKey: "<MyApiKey>", options: options)
```

-   `debug`: if set to true (default false) the client will log debug messages.
-   `host`: the host of the BaseMind Gateway server to use.
-   `logger`: an OSLog.Logger instance. If provided it will override the default logger used.
-   `port`: the server port.
-   `promptConfigId`: the ID of the prompt config to use. If given this value will be used by the server. If not provided, the default prompt configuration will be used.

**Note**: you can have multiple client instances with different `promptConfigId` values set. This allows you to use multiple model configurations within a single application.

## Local Development

<u>Repository Structure:</u>

```text
root                            # repository root, holding all tooling configurations
├─── .github                    # GitHub CI/CD and other configurations
├─── .swiftpm                   # Swift Package Manager Workspace
├─── proto/gateway              # Git submodule that includes the protobuf schema
├─── Tests                      # Tests
├─── Sources/BaseMindGateway    # Protobuf and gRPC stubs generated from the proto file
└─── Sources/BaseMindClient     # The SDK source code
```

### Repository Setup

1. Clone to repository to your local machine including the submodules.

```shell
git clone --recurse-submodules https://github.com/basemind-ai/sdk-ios.git
```

2. Install [TaskFile](https://taskfile.dev/) and the following prerequisites:

    - Python >= 3.11
    - Swift >= 5.9
    - XCode (optional but recommended)

3. If you're using MacOS - execute the setup task with:

```shell
task setup
```

This will setup [pre-commit](https://pre-commit.com/) and the protobuf dependencies.

If you're using a linux or windows machine, you will need to setup the components manually.

### Linting

To lint the project, execute the lint command:

```shell
task lint
```

### Updating Dependencies

To update the dependencies, execute the update-dependencies command:

```shell
task update
```

This will update the swift dependencies and the the pre-commit hooks.

### Executing Tests

```shell
swift test
```

### Generating Protobuf and gRPC Stubs

```shell
task generate
```

This command will generate new protobuf and grpc stubs, replacing those in `Sources/BaseMindGateway`.

## Contribution

The SDK is open source.

Pull requests are welcome - as long as they address an issue or substantially improve the SDK or the test app.

Note: Tests are mandatory for the SDK - untested code will not be merged.
