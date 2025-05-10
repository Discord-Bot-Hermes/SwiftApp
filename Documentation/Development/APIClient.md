# APIClient Documentation

## Overview

`APIClient` is a robust networking layer that manages all communication between the Swift application and the Discord bot backend. It implements a structured approach to API requests, response handling, and error management while encapsulating the complexity of network operations from the rest of the application.

## Architecture

The `APIClient` class follows a service-oriented architecture pattern:

```swift
class APIClient {
    var serverIP: String
    var apiKey: String
    
    init(serverIP: String, apiKey: String) {
        self.serverIP = serverIP
        self.apiKey = apiKey
    }
    
    // API endpoint methods
    // Error handling logic
    // Response parsing
}
```

Key architectural aspects:

1. **Configuration-Based Initialization**: The client is initialized with server address and authentication details
2. **Endpoint Isolation**: Each bot capability is exposed through a dedicated method
3. **Self-Contained Error Handling**: Network and response errors are managed within the client
4. **Asynchronous API Design**: Uses Swift's concurrency model with async/await pattern
5. **Strong Typing**: Leverages Swift's type system for request/response modeling

## Network Request Pattern

The client implements a consistent pattern for network requests:

```swift
func makeRequest<T: Decodable>(
    endpoint: String,
    method: String = "GET",
    body: Data? = nil
) async throws -> T {
    // Request construction
    // Authorization handling
    // Response validation
    // Error processing
    // Response decoding
}
```

This pattern provides:
1. **Consistency**: All network requests follow the same structure
2. **Type Safety**: Generic constraints ensure proper typing of responses
3. **Error Propagation**: Network failures are properly captured and communicated
4. **Authentication**: Authorization is consistently applied to all requests

## Core Capabilities

### Server Management

```swift
func checkServerStatus() async -> Bool {
    // Implementation
}

func startBot() async -> Bool {
    // Implementation
}

func stopBot() async -> Bool {
    // Implementation
}

func checkBotStatus() async -> Bool {
    // Implementation
}
```

These methods provide essential lifecycle management:
1. Server connectivity validation
2. Bot process control (start/stop)
3. Runtime status checks

### Bot Interaction

```swift
func sendHello(channel: String) async -> Bool {
    // Implementation
}

func fetchMemberCount() async -> Int? {
    // Implementation
}

func fetchMembers() async -> [Member]? {
    // Implementation
}
```

These methods enable core Discord bot interactions:
1. Messaging capabilities
2. Member information retrieval
3. Server analytics

### Role Management

```swift
func fetchRoles() async -> [Role]? {
    // Implementation
}

func giveRole(to: String, role: String) async -> Bool {
    // Implementation
}
```

Provides Discord server role operations:
1. Role enumeration
2. Role assignment

### Channel Management

```swift
func fetchChannels() async -> [Channel]? {
    // Implementation
}
```

Retrieves Discord channel information.

## Error Handling Strategy

The client implements a sophisticated error handling approach:

```swift
enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
    // Additional error cases
}
```

Key aspects of error handling:
1. **Granular Error Types**: Specific error cases for different failure modes
2. **Error Propagation**: Uses Swift's throwing mechanism for error communication
3. **Graceful Degradation**: Methods return optional types or boolean success indicators
4. **Detailed Logging**: Network failures and parsing issues are logged for diagnosis

## Response Parsing

The client handles various response formats:

```swift
// JSON response parsing
let decoder = JSONDecoder()
do {
    let response = try decoder.decode(T.self, from: data)
    return response
} catch {
    throw APIError.decodingError(error)
}
```

This approach provides:
1. **Consistent Deserialization**: All JSON responses are handled through a common path
2. **Strong Typing**: Responses are mapped to Swift types defined in DTOs
3. **Validation**: Response structure is verified during parsing

## Security Considerations

The client implements several security best practices:

1. **Authentication**: All requests include the API key
2. **Secure Communication**: Uses HTTPS for secure data transmission
3. **Parameter Validation**: Input parameters are validated before requests
4. **Error Obscuring**: Internal errors are mapped to user-friendly responses
5. **Timeout Handling**: Requests have appropriate timeouts

## Performance Optimization

The client implements performance optimizations:

1. **Connection Pooling**: Reuses URLSession for connection efficiency
2. **Response Caching**: Implements appropriate caching headers
3. **Payload Optimization**: Minimizes request payload size
4. **Concurrent Requests**: Uses Swift concurrency for parallel operations
5. **Cancellation Support**: Long-running requests can be cancelled

## Integration Points

The `APIClient` interfaces with multiple application components:

1. **View Models**: Provides data for UI display and responds to user actions
2. **SwiftData Models**: Updates persistent models with server responses
3. **Settings**: Configures based on user preferences
4. **Command Handling**: Executes Discord bot commands triggered by the user

## Usage Example

```swift
// Initialize the client
let client = APIClient(serverIP: "https://discord-bot.example.com", apiKey: "secret_key")

// Make an API call
Task {
    do {
        let isRunning = await client.checkBotStatus()
        if isRunning {
            let members = await client.fetchMembers()
            // Process members
        } else {
            // Handle bot not running
        }
    } catch {
        // Handle errors
    }
}
```

## Best Practices

When extending or modifying `APIClient`:

1. **Maintain Method Consistency**: Follow the established pattern for new endpoints
2. **Handle Edge Cases**: Account for network failures and unexpected responses
3. **Test New Endpoints**: Verify operation with mocked responses before deployment
4. **Document Changes**: Update inline documentation for new methods or parameters
5. **Consider Rate Limiting**: Implement backoff strategies for frequently called endpoints

## Conclusion

The `APIClient` class provides a robust foundation for Discord bot interaction, abstracting complex networking details behind a clean, strongly-typed API. Its architecture ensures consistency, error resilience, and maintainability while supporting the application's core functionality through a comprehensive set of bot management and interaction features. 