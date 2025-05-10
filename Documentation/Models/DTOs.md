# Data Transfer Objects Documentation

## Overview

The `DTOs.swift` file implements a comprehensive set of Data Transfer Objects (DTOs) that facilitate the structured exchange of information between the SwiftApp Discord Bot application and its backend API. These models provide type-safe representations of API responses, ensuring reliable serialization and deserialization of network data.

## Purpose and Pattern

The DTO pattern serves several critical functions in the application architecture:

1. **API Contract Definition**: Provides concrete Swift types that mirror the API's data structures
2. **Type Safety**: Ensures API responses conform to expected structures
3. **Separation of Concerns**: Isolates network data models from application domain models
4. **Serialization Logic**: Centralizes JSON parsing and encoding behavior
5. **Documentation**: Self-documents the API's data requirements

## Core Response Structure

The DTOs follow a consistent pattern for API responses:

```swift
// Base response pattern
struct BaseResponse: Codable {
    let status: String
    let message: String?
}

// Typed response pattern
struct TypedResponse<T>: Codable {
    let data: T?
    let status: String
    let message: String?
}

// Result enum pattern
enum OperationResult {
    case success(associatedData)
    case failure(String)
}
```

This pattern provides:
1. **Uniform Response Structure**: Consistent handling of API responses
2. **Optional Data Payloads**: Handles both successful and failed responses
3. **Error Information**: Captures error messages when available
4. **Type-Safe Results**: Transforms network responses into strongly-typed results

## Discord Entity DTOs

### Member Count Data

```swift
struct MemberCountData: Codable {
    let offline: Int
    let online: Int
    let total: Int
}

struct MemberCountResponse: Codable {
    let data: MemberCountData?
    let status: String
    let message: String?
}

enum MemberCountResult {
    case success(online: Int, offline: Int, total: Int)
    case failure
}
```

This structure:
1. Models server member presence statistics
2. Provides typed access to online/offline/total counts
3. Encapsulates success and failure states

### Member Representation

```swift
struct Member: Codable, Identifiable, Hashable {
    let avatarUrl: String?
    let bot: Bool
    let discriminator: String
    let displayName: String
    let id: String
    let joinedAt: String
    let name: String
    let roles: [String]
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
        case bot
        case discriminator
        case displayName = "display_name"
        case id
        case joinedAt = "joined_at"
        case name
        case roles
        case status
    }
}

struct MembersResponse: Codable {
    let data: [String: [Member]]?
    let status: String
    let message: String?
}

enum MembersResult {
    case success(members: [Member])
    case failure(String)
}
```

This structure:
1. Models Discord server members with comprehensive attributes
2. Maps between JSON field names and Swift property names using `CodingKeys`
3. Conforms to Swift protocols for collection handling and identity
4. Provides guild-to-members mapping in responses

### Role Management

```swift
struct Role: Codable, Identifiable, Hashable {
    let color: String
    let id: String
    let mentionable: Bool
    let name: String
    let permissions: String
    let position: Int
}

struct RolesResponse: Codable {
    let data: [String: [Role]]?
    let status: String
    let message: String?
}

enum RolesResult {
    case success(roles: [Role])
    case failure(String)
}

struct GiveRoleResponse: Codable {
    let status: String
    let message: String
}

enum GiveRoleResult {
    case success(message: String)
    case failure(message: String)
}
```

This structure:
1. Models Discord role attributes completely
2. Supports role assignment operations
3. Provides guild-to-roles mapping in responses

### Channel Information

```swift
struct Channel: Codable, Identifiable, Hashable {
    let categoryId: String?
    let id: String
    let name: String
    let position: Int
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case categoryId = "category_id"
        case id
        case name
        case position
        case type
    }
}

struct ChannelsResponse: Codable {
    let data: [String: [Channel]]?
    let status: String
    let message: String?
}

enum ChannelsResult {
    case success(channels: [Channel])
    case failure(String)
}
```

This structure:
1. Models Discord channels with their attributes
2. Maps JSON fields to Swift properties with custom coding keys
3. Supports nested channel categories

### Bot Configuration

```swift
struct AccessRole: Codable, Identifiable {
    let id: String
    let name: String
    let color: String
    let mentionable: Bool
    let permissions: String
    let position: Int
}

struct BotData: Codable {
    let token: String
    let devToken: String
    let developmentMode: Bool
    
    enum CodingKeys: String, CodingKey {
        case token
        case devToken = "dev_token"
        case developmentMode = "development_mode"
    }
}

struct SettingsData: Codable {
    let bot: BotData
    let groups: [String]
    let accessRoles: [AccessRole]
    
    enum CodingKeys: String, CodingKey {
        case bot
        case groups
        case accessRoles = "access_roles"
    }
}

struct SettingsResponse: Codable {
    let data: SettingsData?
    let status: String
    let message: String?
}

struct BotSettings {
    let developmentMode: Bool
    let token: String
    let devToken: String
    let groups: [String]
    let accessRoles: [AccessRole]
}

enum BotSettingsResult {
    case success(message: String)
    case failure(message: String)
}

enum UpdateGroupsResult {
    case success(message: String)
    case failure(message: String)
}
```

This structure:
1. Models Discord bot configuration comprehensively
2. Handles authentication tokens and development mode
3. Manages server group definitions
4. Supports access role configuration

### Operational Status

```swift
struct PingResponse: Codable {
    let latency: String
    let message: String
    let status: String
}

enum PingResult {
    case success(latency: String, message: String)
    case failure(String)
}
```

This structure:
1. Provides connectivity verification
2. Includes latency measurement for performance monitoring

## Command and Feature DTOs

### Message Management

```swift
struct ClearResponse: Codable {
    let status: String
    let message: String
}

enum ClearResult {
    case success(message: String)
    case failure(message: String)
}
```

### Survey and Feedback System

```swift
// Complex survey
struct ComplexSurveyResponse: Codable {
    let status: String
    let message: String
}

enum ComplexSurveyResult {
    case success(message: String)
    case failure(message: String)
}

// Simple survey
struct SimpleSurveyResponse: Codable {
    let status: String
    let message: String
}

enum SimpleSurveyResult {
    case success(message: String)
    case failure(message: String)
}

// Surveys file management
struct SurveyFile: Codable, Identifiable {
    let created: String
    let modified: String
    let name: String
    let size: Int
    var id: String { name }
}

struct SurveyFilesResponse: Codable {
    let files: [SurveyFile]
}

enum SurveyFilesResult {
    case success(files: [SurveyFile])
    case failure(message: String)
}

// Dynamic survey entry parsing
struct SurveyEntry: Codable {
    let Name: String
    private let additionalData: [String: String]
    
    var responsePairs: [(key: String, value: String)] {
        additionalData.filter { $0.key != "Name" }
            .map { ($0.key, $0.value) }
            .sorted { $0.key < $1.key }
    }
    
    var responsePair: (key: String, value: String)? {
        additionalData.first { $0.key != "Name" }
    }
    
    // Custom decoder implementation with dynamic keys
    enum CodingKeys: String, CodingKey {
        case Name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        Name = try container.decode(String.self, forKey: DynamicCodingKeys(stringValue: "Name")!)
        var data = [String: String]()
        for key in container.allKeys where key.stringValue != "Name" {
            data[key.stringValue] = try container.decode(String.self, forKey: key)
        }
        additionalData = data
    }
    
    struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int?
        init?(stringValue: String) { self.stringValue = stringValue }
        init?(intValue: Int) { stringValue = "\(intValue)"; self.intValue = intValue }
    }
}
```

### Attendance System

```swift
struct AttendanceResponse: Codable {
    let status: String
    let message: String
}

enum AttendanceResult {
    case success(message: String)
    case failure(message: String)
}

struct AttendanceFile: Codable, Identifiable {
    let created: String
    let modified: String
    let name: String
    let size: Int
    var id: String { name }
}

struct AttendanceFilesResponse: Codable {
    let files: [AttendanceFile]
}

enum AttendanceFilesResult {
    case success(files: [AttendanceFile])
    case failure(message: String)
}

struct AttendanceEntry: Codable {
    let Attendance: String
}

struct AttendanceContentResponse: Codable {
    let content: [AttendanceEntry]
}

enum AttendanceContentResult {
    case success(content: [AttendanceEntry])
    case failure(message: String)
}
```

### Feedback System

```swift
struct FeedbackFile: Codable, Identifiable {
    let created: String
    let modified: String
    let name: String
    let size: Int
    var id: String { name }
}

struct FeedbackFilesResponse: Codable {
    let files: [FeedbackFile]
}

enum FeedbackFilesResult {
    case success(files: [FeedbackFile])
    case failure(message: String)
}

struct FeedbackEntry: Codable {
    let Feedback: String
    let Name: String
}

struct FeedbackContentResponse: Codable {
    let content: [FeedbackEntry]
}

enum FeedbackContentResult {
    case success(content: [FeedbackEntry])
    case failure(message: String)
}
```

### Greeting Feature

```swift
enum HelloResult {
    case success(message: String)
    case failure(message: String)
}
```

## Technical Implementation

### Protocol Conformance

The DTOs implement several Swift protocols for enhanced functionality:

#### Codable

```swift
struct Member: Codable {
    // Properties and implementation
    
    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
        // Other keys
    }
}
```

This enables:
1. Automatic JSON encoding and decoding
2. Custom key mapping between JSON and Swift naming conventions
3. Selective property inclusion

#### Identifiable

```swift
struct Channel: Identifiable {
    let id: String
    // Other properties
}

// Or with computed ID
struct SurveyFile: Identifiable {
    let name: String
    var id: String { name }
}
```

This supports:
1. SwiftUI list and collection rendering
2. Unique identification in collections
3. Efficient diffing and updates

#### Hashable

```swift
struct Role: Hashable {
    // Properties
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Role, rhs: Role) -> Bool {
        lhs.id == rhs.id
    }
}
```

This enables:
1. Use in Set collections
2. Dictionary key functionality
3. Efficient equality checking

### Advanced Decoding Strategies

The DTOs implement sophisticated JSON parsing:

#### Dynamic Key Handling

```swift
struct SurveyEntry: Codable {
    // Properties
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        Name = try container.decode(String.self, forKey: DynamicCodingKeys(stringValue: "Name")!)
        // Additional dynamic decoding
    }
    
    struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int?
        init?(stringValue: String) { self.stringValue = stringValue }
        init?(intValue: Int) { stringValue = "\(intValue)"; self.intValue = intValue }
    }
}
```

This approach enables:
1. Handling of dynamic or unknown field names
2. Selective decoding of relevant fields
3. Structured access to dynamic data

### Result Pattern

The DTO system uses a consistent result enum pattern:

```swift
enum MembersResult {
    case success(members: [Member])
    case failure(String)
}
```

This provides:
1. Type-safe representation of operation outcomes
2. Associated values for success and failure cases
3. Exhaustive pattern matching in consuming code
4. Elimination of optional chaining and nil checks

## Conclusion

The `DTOs.swift` file implements a comprehensive set of data transfer objects that form the boundary between the SwiftApp Discord Bot application and its backend API. Through careful implementation of Swift's Codable protocol, strategic protocol conformance, and advanced decoding techniques, it ensures reliable data exchange while maintaining a clean separation between network representation and application domain models. The consistent result pattern enhances error handling and type safety throughout the application. 