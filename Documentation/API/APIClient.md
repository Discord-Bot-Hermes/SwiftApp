# APIClient Documentation

## Overview

`APIClient` is a crucial component of the SwiftUI Discord Bot application that serves as the networking layer responsible for facilitating communication between the iOS client and Flask-based backend server. The class is designed to encapsulate all network-related functionality, providing a clean abstraction that separates the concerns of network communication from the presentation layer.

## Architecture and Design Principles

### Modular Programming Paradigm

The `APIClient` class exemplifies the principles of modular programming through its implementation of the Single Responsibility Principle. Its sole responsibility is managing network interactions, which promotes:

1. **Separation of Concerns**: By isolating network-related logic, the codebase maintains a clear distinction between UI components and data retrieval mechanisms.
2. **Reusability**: The class can be instantiated multiple times with different server configurations.
3. **Testability**: Network operations can be tested independently of UI components.
4. **Maintainability**: Changes to the network layer don't necessitate modifications to UI components.

### SwiftData Integration

The `APIClient` class is annotated with the `@Model` attribute, indicating its integration with SwiftData, Apple's modern framework for data persistence. This integration allows instances of the `APIClient` to be:

1. Persisted across application launches
2. Observed for changes through SwiftUI's reactive mechanisms
3. Managed within a model context

## Implementation Details

### Core Properties

The `APIClient` maintains two essential properties:

```swift
var serverIP: String
var apiKey: String
```

These properties form the foundation for constructing API endpoints and authenticating requests to the server.

### Asynchronous Programming Model

The `APIClient` leverages Swift's modern concurrency features:

1. **async/await Pattern**: All network methods are marked with the `async` keyword, enabling non-blocking execution and simplifying asynchronous code.

2. **Structured Concurrency**: The implementation uses Swift's structured concurrency model, which provides better error handling and task management compared to traditional callback-based approaches.

Example implementation:
```swift
func checkServerStatus() async -> Bool {
    // URL construction and validation
    do {
        let (_, response) = try await URLSession.shared.data(from: url)
        // Response processing
        return isOnline
    } catch {
        // Error handling
        return false
    }
}
```

### URLSession Implementation

The `APIClient` utilizes `URLSession.shared` for performing HTTP requests, demonstrating:

1. **Resource Efficiency**: By using the shared session, the application avoids unnecessary session creation and management.

2. **Request Configuration**: Various HTTP methods (GET, POST) are configured as appropriate for each endpoint.

3. **Error Handling**: Comprehensive error capture and processing provide robust fault tolerance.

### Response Handling and Decoding

A sophisticated response handling mechanism is implemented:

1. **JSON Decoding**: The `JSONDecoder` class is used to convert JSON responses into Swift objects.

2. **Type-Safe Responses**: Strongly-typed response structures ensure type safety and compiler validation.

3. **Multi-Layer Error Handling**: The implementation includes several fallback mechanisms:
   - Standard response decoding
   - Alternative error message decoding
   - Raw response inspection
   - HTTP status code evaluation

Example pattern:
```swift
// Primary decoding attempt
let decodedResponse = try decoder.decode(ResponseType.self, from: data)

// Fallback error handling
if decodedResponse.status == "success" {
    return .success(/* parsed data */)
} else {
    return .failure(message: decodedResponse.message)
}
```

## API Endpoints

The `APIClient` provides methods for interacting with various Discord bot functionalities:

1. **Server and Bot Management**:
   - `checkServerStatus()`: Validates server connectivity
   - `startBot()`, `stopBot()`: Controls bot execution
   - `checkBotStatus()`: Monitors bot operational status

2. **Discord Interactions**:
   - `sendHello()`: Sends messages to Discord members
   - `fetchMemberCount()`: Retrieves server member statistics
   - `fetchMembers()`: Gets detailed member information
   - `fetchRoles()`, `giveMemberRole()`: Manages Discord roles
   - `fetchChannels()`: Obtains channel information
   - `clearMessages()`: Removes messages from channels

3. **Advanced Bot Commands**:
   - `createComplexSurvey()`: Creates interactive surveys
   - Additional specialized commands for specific Discord interactions

## Result Types

The `APIClient` employs a clear, type-safe approach to handling operation outcomes through custom result types:

```swift
// Example result types
enum HelloResult {
    case success(message: String)
    case failure(message: String)
}

enum MemberCountResult {
    case success(online: Int, offline: Int, total: Int)
    case failure
}
```

These result types:
1. Clearly communicate success or failure states
2. Include relevant data or error information
3. Enable pattern matching in consuming code
4. Provide explicit type safety for response handling

## Conclusion

The `APIClient` exemplifies modern iOS development practices through its:

1. **Clean Architecture**: Clear separation between networking and UI layers
2. **Modern Swift Features**: Usage of async/await, structured concurrency, and SwiftData
3. **Robust Error Handling**: Comprehensive approach to network failures and unexpected responses
4. **Type Safety**: Strong typing throughout the networking stack

This design ensures the Discord Bot application can reliably communicate with its backend while maintaining a clean, modular codebase that isolates networking concerns from UI implementation. 