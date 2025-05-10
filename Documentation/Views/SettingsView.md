# SettingsView Documentation

## Overview

`SettingsView` is a comprehensive configuration interface for the Discord Bot application that adheres to Apple's Human Interface Guidelines. This view provides a structured environment for users to configure server connections, bot authentication, and group management. The view implements progressive disclosure patterns and contextual controls to simplify complex configuration tasks.

## Functional Purpose

The settings interface serves multiple critical functions:

1. **Server Configuration**: Allows users to specify the backend server IP address and API key
2. **Bot Authentication**: Manages bot tokens for both production and development environments
3. **Group Management**: Configures Discord server groups with validation states
4. **Operational Mode Selection**: Toggles between standard and developer modes

## UI Structure and Composition

The view employs a modal presentation with a navigation bar and form-based layout:

```swift
NavigationStack {
    // Content conditional on bot active state
    Form {
        Section(header: Text("Server Settings")) {
            // Server configuration fields
        }
        
        Section(header: Text("Management")) {
            // Bot settings and group management
        }
    }
}
.presentationDragIndicator(.visible)
```

This structure follows Apple's HIG recommendations for settings interfaces by:
- Using a form layout for related settings
- Organizing options into logical sections with headers
- Implementing clear navigation with a title and done button
- Showing a drag indicator for modal sheets

## Adaptive Content Based on State

The interface adapts its content based on several contextual states:

### Bot Running State

```swift
if bot.isActive {
    // Show simplified view with running indicator
} else {
    // Show full settings interface
}
```

This implementation prevents configuration changes while the bot is operational, adhering to the HIG principle of contextual relevance by:
1. Displaying a clear status message with visual feedback
2. Explaining why settings are unavailable
3. Providing guidance on how to enable settings (stop the bot)

### Server Connectivity State

```swift
if !isServerOnline {
    // Show offline indicator and help text
} else {
    // Show management settings
}
```

This pattern follows HIG recommendations for network-dependent features by:
1. Clearly indicating connectivity status
2. Providing visual differentiation using color and iconography
3. Offering guidance on resolving connectivity issues

### Editing Mode States

```swift
if isEditingServer {
    // Show editable text fields
} else {
    // Show read-only text display
}
```

This implements the HIG principle of progressive disclosure by:
1. Starting with a simplified read-only view
2. Expanding to editable controls only when needed
3. Providing clear edit/save actions for state transitions

## User Input Components

The view employs appropriate input controls for different data types:

### Text Input Fields
```swift
TextField("Server IP", text: $serverIP)
    .textInputAutocapitalization(.never)
    .autocorrectionDisabled()
```

### Toggle Switches
```swift
Toggle("Developer Mode", isOn: $isDeveloperMode)
    .tint(Color.tumBlue)
```

### Pickers
```swift
Picker("Number of Groups", selection: $numberOfGroups) {
    ForEach(groupOptions, id: \.self) { number in
        Text("\(number)").tag(number)
    }
}
```

These controls follow HIG recommendations by:
- Using appropriate control types for each data type
- Disabling autocorrection for technical fields
- Providing clear labels for all inputs
- Using consistent styling and tinting

## State Management

The view implements comprehensive state management using a combination of approaches:

### Dependency Injection
```swift
@Bindable var bot: Bot
```
Receives the main data model as a bindable reference.

### Environment Values
```swift
@Environment(\.dismiss) private var dismiss
@Environment(\.modelContext) private var context
```
Accesses SwiftUI environment for modal dismissal and SwiftData persistence.

### Local State
```swift
@State private var serverIP: String
@State private var apiKey: String
@State private var isEditingServer = false
@State private var isEditingManagement = false
// Additional state variables for UI control
```

This approach follows HIG recommendations for state management by:
- Maintaining a clear separation between model and view state
- Using appropriate state scopes for different data types
- Supporting reactive UI updates based on state changes
- Preserving user context during configuration

## Feedback and Loading States

The interface provides clear feedback during asynchronous operations:

```swift
if isLoadingSettings {
    HStack {
        Spacer()
        ProgressView()
            .padding(.vertical, 20)
        Spacer()
    }
}

// Success feedback
if managementSaveSuccess {
    HStack {
        Image(systemName: "checkmark.circle.fill")
            .foregroundColor(Color.tumGreen)
        Text("Successfully Saved")
            .foregroundColor(Color.tumGreen)
    }
}

// Error feedback
if let error = errorMessage {
    HStack {
        Image(systemName: "exclamationmark.triangle.fill")
            .foregroundColor(Color.tumRed)
        Text(error)
            .foregroundColor(Color.tumRed)
    }
}
```

This implementation adheres to HIG guidelines for feedback by:
- Showing loading indicators during network operations
- Providing clear success confirmations
- Displaying specific error messages when problems occur
- Using consistent iconography and color semantics

## Data Persistence

The view implements a multi-layered approach to settings persistence:

### Local SwiftData Persistence
```swift
// Save changes to the model context
do {
    try context.save()
    print("DEBUG: Server settings saved to persistent storage")
} catch {
    print("DEBUG: Failed to save server settings: \(error)")
}
```

### Backend Synchronization
```swift
private func saveManagementSettings() {
    Task {
        // Step 1: Update development mode
        let devModeResult = await apiClient.updateDevelopmentMode(isDeveloperMode)
        
        // Step 2: Update the appropriate token
        let tokenResult = await apiClient.updateBotToken(isDeveloperMode: isDeveloperMode, token: tokenToUse)
        
        // Step 3: Update groups on the server
        let groupsResult = await apiClient.updateGroups(groups: groupNames)
        
        // Update local model and persistence
    }
}
```

This approach follows best practices for data persistence by:
1. Saving settings locally for immediate availability
2. Synchronizing critical settings with the backend server
3. Providing clear feedback on persistence operations
4. Handling network errors gracefully

## Form Validation and Error Prevention

The interface implements several strategies to prevent user errors:

### Confirmation Dialogs
```swift
.confirmationDialog(
    "Are you sure you want to discard your changes?",
    isPresented: $showConfirmationDialog,
    titleVisibility: .visible
) {
    Button("Discard Changes", role: .destructive) { /* ... */ }
    Button("Cancel", role: .cancel) { /* ... */ }
}
```

### Environmental Constraints
```swift
.disabled(isLoadingSettings || !isServerOnline)
```

These patterns follow HIG recommendations for error prevention by:
- Requiring confirmation for destructive actions
- Disabling controls when their actions would be invalid
- Providing clear explanations of constraints
- Using standard dialog patterns for confirmations

## Data Flow and Backend Integration

The view implements structured data flow between UI, model, and backend:

### UI to Model Flow
```swift
bot.token = token
bot.devToken = devToken
bot.isDeveloperMode = isDeveloperMode

// Update groups in the bot model
updateBotGroups()
```

### Model to Backend Flow
```swift
let groupNames = groups.map { $0.name }
let groupsResult = await apiClient.updateGroups(groups: groupNames)
```

### Backend to UI Flow
```swift
private func updateUIWithSettings(_ settings: BotSettings) {
    // Update UI state variables
    isDeveloperMode = settings.developmentMode
    token = settings.token
    devToken = settings.devToken
    
    // Update the bot model
    bot.isDeveloperMode = settings.developmentMode
    bot.token = settings.token
    bot.devToken = settings.devToken
}
```

This implementation follows best practices for data flow by:
1. Ensuring consistency between UI state and model data
2. Batching backend updates to reduce network operations
3. Refreshing UI when backend data changes
4. Handling asynchronous operations without blocking the UI

## Accessibility Implementation

The interface includes several accessibility enhancements:

```swift
.accessibilityIdentifier("serverIPField")
.accessibilityIdentifier("apiKeyField")
.accessibilityIdentifier("saveServerSettingsButton")
.accessibilityIdentifier("settingsView")
```

These identifiers support:
- UI testing automation
- VoiceOver navigation
- Voice control interaction
- Screen reader compatibility

## Conclusion

`SettingsView` demonstrates sophisticated SwiftUI implementation patterns that align with Apple's Human Interface Guidelines:

1. **Progressive Disclosure**: Shows detailed settings only when needed
2. **Contextual Relevance**: Adapts interface based on application state
3. **Clear Feedback**: Provides loading indicators and success/error messages
4. **Data Integrity**: Validates and persists settings across application layers
5. **Accessibility Support**: Implements proper identifiers and semantic elements

The view balances comprehensive functionality with a straightforward user experience, enabling efficient configuration of the Discord Bot application while preventing potential configuration errors or invalid states. 