# BaseMind.AI Swift (iOS/MacOS) SDK

This repository hosts the BaseMind.AI Swift SDK. The SDK is a gRPC client library for connecting with the BaseMind.AI platform.

It supports iOS >= 13 and MacOS >= 12.

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

### Installation

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
