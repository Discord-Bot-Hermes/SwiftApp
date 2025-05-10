# Bot Model Documentation

## Overview

The `Bot` class is the central data model in the SwiftApp Discord Bot application, representing a Discord bot instance with its configuration, state, and capabilities. It serves as the core persistent entity that connects the user interface with backend functionality and leverages SwiftData for persistence.

## Model Definition

The `Bot` class is defined as a SwiftData model:

```swift
@Model
class Bot {
    var name: String
    var apiClient: APIClient!
    var isActive: Bool
    var role: String
    var token: String?
    var devToken: String?
    var isDeveloperMode: Bool
    @Relationship(deleteRule: .cascade) var groups: [GroupModel] = []
}
```

Key model attributes:

1. **Identity**: Each bot has a user-defined `name`
2. **Connection Details**: `apiClient` for backend communication
3. **State Tracking**: `isActive` flag to track running state
4. **Discord Configuration**: `role` for Discord role management
5. **Authentication**: `token` and `devToken` for Discord API access
6. **Development Toggle**: `isDeveloperMode` for switching between production and development
7. **Group Management**: Relationship to `GroupModel` entities for organizing Discord server groups

## GroupModel Definition

The Bot model works closely with the GroupModel:

```swift
@Model
class GroupModel {
    var name: String
    var isValid: Bool
    var attendanceActive: Bool
    
    init(name: String, isValid: Bool = false, attendanceActive: Bool = false) {
        self.name = name
        self.isValid = isValid
        self.attendanceActive = attendanceActive
    }
}
```

This associated model:
1. Represents Discord server groups or categories
2. Tracks validation state with `isValid`
3. Manages feature activation with `attendanceActive`

## SwiftData Integration

As a SwiftData model, `Bot` leverages several key features of Apple's persistence framework:

### Persistence Annotations

```swift
@Model
class Bot {
    // Model properties
    
    @Relationship(deleteRule: .cascade) 
    var groups: [GroupModel] = []
}
```

These annotations provide:
1. **Automatic Schema Generation**: SwiftData creates the underlying storage schema
2. **Change Tracking**: Property modifications are automatically tracked
3. **Relationship Management**: Related entities are properly maintained
4. **Cascade Behaviors**: Deletions properly clean up related entities

### Query Support

The `Bot` model supports SwiftData's query capabilities, as demonstrated in ContentView:

```swift
@Query private var bots: [Bot]
```

This enables:
1. **Collection Access**: Easy access to all bot instances
2. **Dynamic Updates**: UI automatically refreshes when data changes
3. **Optional Filtering**: Could be extended with predicates for specific queries

## Initialization and Lifecycle

The `Bot` model provides a comprehensive initializer:

```swift
init(name: String, apiClient: APIClient!, role: String = "", 
     token: String? = nil, devToken: String? = nil, isDeveloperMode: Bool = false) {
    self.name = name
    self.apiClient = apiClient
    self.role = role
    self.token = token
    self.devToken = devToken
    self.isDeveloperMode = isDeveloperMode
    self.isActive = false
    self.groups = [
        GroupModel(name: "G1", isValid: true),
        GroupModel(name: "G2", isValid: true)
    ]
}
```

Key aspects:
1. **Default Values**: Sets reasonable defaults for optional parameters
2. **Required Properties**: Ensures essential data is provided
2. **Initial State**: Sets `isActive` to false by default
4. **Default Groups**: Creates two default groups ("G1" and "G2")

## Sample Data

The `Bot` model includes a static property for sample data:

```swift
static let sampleData = [
    Bot(
        name: "Master Mind",
        apiClient: APIClient(serverIP: "http://127.0.0.1:5000", apiKey: "025002"),
        token: "",
        devToken: ""
    )
]
```

This facilitates:
1. **Preview Support**: Provides consistent data for SwiftUI previews
2. **Development**: Enables testing without creating live instances
3. **Demo Mode**: Supports demonstration scenarios

## Integration with APIClient

The `Bot` model contains a direct reference to an APIClient:

```swift
var apiClient: APIClient!
```

This approach provides:
1. **Direct Access**: Immediate access to the API client methods
2. **Configuration Storage**: Maintains the API connection settings within the model
3. **Simplified Usage**: Views can access the API through the bot model

## Group Management

The `Bot` model includes default groups in its initializer:

```swift
self.groups = [
    GroupModel(name: "G1", isValid: true),
    GroupModel(name: "G2", isValid: true)
]
```

This structure enables:
1. **Default Organization**: Provides initial group structure
2. **Validation Status**: Sets initial validation state
3. **Feature Foundation**: Creates the basis for group-specific features

## SwiftUI Integration

The `Bot` model is designed for seamless SwiftUI integration:

```swift
// ContentView.swift example
if let bot = bots.first {
    BotView(bot: bot)
}
```

This design supports:
1. **View Binding**: Bot instances can be passed directly to views
2. **Data Dependency**: Views can depend on the bot's data
3. **Persistence Integration**: Changes are automatically saved through SwiftData

## Developer Mode Support

The model includes specific support for development workflows:

```swift
var isDeveloperMode: Bool
var devToken: String?
```

These properties enable:
1. **Environment Switching**: Toggle between development and production
2. **Alternative Authentication**: Use different tokens for different environments
3. **Testing Isolation**: Test features without affecting production data

## Conclusion

The `Bot` class forms the foundation of the SwiftApp Discord Bot application's data model. Through its integration with SwiftData, it provides persistence, state management, and relationship handling with the GroupModel entities. Its structure supports authentication management, developer mode operation, and default group configuration, enabling the core functionality of Discord bot management within the application. 