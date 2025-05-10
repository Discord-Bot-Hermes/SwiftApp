# SampleData Documentation

## Overview

`SampleData` is a utility class that provides consistent, in-memory sample data for SwiftUI previews and development workflows. It creates a controlled data environment that simulates the application's production data model without requiring backend connectivity or persistent storage. This approach enables rapid UI development, consistent preview states, and isolated component testing.

## Implementation Pattern

The class implements a singleton pattern with in-memory SwiftData storage:

```swift
@MainActor
class SampleData {
    static let shared = SampleData()

    let modelContainer: ModelContainer
    private let defaultBot: Bot
    
    var context: ModelContext {
        modelContainer.mainContext
    }
    
    var bot: Bot {
        defaultBot
    }
    
    // Initialization logic
}
```

Key aspects of this implementation:

1. **Singleton Design**: The `shared` static property provides a centralized, application-wide sample data source
2. **MainActor Annotation**: Ensures all access to the sample data happens on the main thread, preventing threading issues
3. **Controlled Access**: Exposes the model container, context, and sample bot through read-only properties
4. **Memory-Only Storage**: Uses SwiftData's `isStoredInMemoryOnly` flag to prevent disk persistence

## Sample Data Configuration

The class sets up an in-memory SwiftData environment:

```swift
// Set up the model container
let schema = Schema([Bot.self])
let modelConfiguration = ModelConfiguration(
    schema: schema,
    isStoredInMemoryOnly: true
)

modelContainer = try ModelContainer(
    for: schema,
    configurations: [modelConfiguration]
)

// Insert the default bot
context.insert(defaultBot)
try context.save()
```

This configuration:
1. Defines a schema that includes only necessary model types
2. Creates a memory-only model configuration that won't persist to disk
3. Initializes a model container with this configuration
4. Pre-populates the container with sample data

## Development Benefits

### SwiftUI Preview Support

The sample data enables consistent, data-driven SwiftUI previews:

```swift
#Preview {
    ContentView()
        .modelContainer(SampleData.shared.modelContainer)
}
```

Benefits for preview-driven development:
1. **Immediate Feedback**: Enables real-time UI updates during development
2. **Consistent Data States**: Ensures previews always have the same data setup
3. **Multiple State Testing**: Can be extended to provide different data scenarios
4. **Isolated Development**: Allows UI work without backend dependencies

### Component Development

Sample data facilitates component-level development by providing realistic data models:

```swift
BotView(bot: SampleData.shared.bot)
    .previewLayout(.sizeThatFits)
```

This approach supports:
1. **Component Isolation**: Develop individual components independently
2. **Edge Case Exploration**: Easily modify sample data to test different scenarios
3. **Designer-Developer Collaboration**: Share consistent preview states with design teams
4. **Documentation**: Generate screenshots with consistent data representation

## Design Considerations

### Memory Management

The implementation uses memory-only storage to:
1. Prevent interference with actual application data
2. Avoid persistent storage overhead
3. Ensure clean state on application restart
4. Simulate transient backend data effectively

### Extensibility

The pattern can be extended to support more complex scenarios:

```swift
// Example extension for alternative data scenarios
extension SampleData {
    var activatedBot: Bot {
        let bot = Bot(/* alternative configuration */)
        bot.isActive = true
        return bot
    }
    
    var offlineServer: APIClient {
        return APIClient(serverIP: "http://invalid.url", apiKey: "invalid")
    }
}
```

This extensibility allows:
1. Testing different application states
2. Simulating various edge cases
3. Providing specialized data for different components
4. Supporting A/B design comparisons

## Modern Development Workflow Integration

The `SampleData` class supports modern SwiftUI development practices:

### Swift Package Development

For reusable components packaged as Swift Packages, sample data enables:
1. Self-contained preview capabilities
2. Documentation generation with realistic examples
3. Package-level testing without external dependencies

### Iterative Design Process

The sample data approach facilitates rapid design iteration:
1. Change UI components and immediately see results with realistic data
2. Try multiple data configurations to verify design robustness
3. Share previews with stakeholders without requiring backend setup
4. Validate accessibility features with representative content

### Hot Reload Development

With tools like Xcode previews, sample data enables:
1. Real-time UI feedback during code changes
2. Multiple simultaneous preview states
3. Rapid experimentation with different data configurations
4. Device and orientation variant testing

## Best Practices

When extending or modifying `SampleData`:

1. **Keep It Representative**: Sample data should realistically represent production data
2. **Maintain Determinism**: Avoid randomization that could make previews inconsistent
3. **Scope Appropriately**: Include only the models needed for the current development task
4. **Parameterize When Needed**: Create functions to generate variations of sample data
5. **Document Assumptions**: Comment on expectations about data structure and relationships

## Conclusion

The `SampleData` class demonstrates a sophisticated approach to providing consistent, realistic data for SwiftUI development. By leveraging SwiftData's in-memory storage capabilities and a centralized singleton pattern, it enables rapid UI development with immediate feedback loops while maintaining isolation from production data concerns.

This pattern aligns with modern iOS development practices by supporting preview-driven development, component isolation, and iterative design—all without requiring backend connections or persistent storage configurations during the development process. 