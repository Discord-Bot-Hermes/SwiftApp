# AttendanceCommandView Documentation

## Overview

`AttendanceCommandView` is a SwiftUI view component that manages Discord server attendance tracking functionality within the SwiftApp Discord Bot application. It provides a comprehensive interface for starting and stopping attendance sessions, viewing historical attendance records, and examining detailed attendance information for specific sessions.

## View Structure

The view consists of several key sections organized in a form-based layout:

1. **Attendance Setup Section**: Controls for configuring a new attendance session
   - Group selection picker
   - Admin member selection picker
   - Status indicators for configuration validity

2. **Attendance Status Section**: Controls for managing the attendance tracking state
   - Segmented control to toggle between Start/Stop modes
   - Current status indicator showing Active/Inactive state
   - Action button to execute the selected attendance command

3. **Feedback Section**: Dynamic notifications for operation outcomes
   - Success messages with green checkmark icon
   - Error messages with red warning icon

4. **Attendance Files Section**: List of historical attendance records
   - File cards displaying group name, date, and attendee count
   - Loading indicators for files being processed
   - Tappable areas to view detailed attendance information

5. **Attendance Details Sheet**: Modal presentation of attendance participants
   - List of attendee names
   - Empty state handling when no attendees are found
   - Group and date information in the navigation bar

## State Management

The view implements extensive state management using SwiftUI's `@State` and environment integration:

```swift
// Core state properties
@Bindable var bot: Bot
@Environment(\.modelContext) private var context
@State private var selectedGroupId: String?
@State private var attendanceStatus: Bool = false
@State private var showConfirmation: Bool = false
@State private var isLoading = false
@State private var isProcessing = false
@State private var errorMessage: String?
@State private var successMessage: String?
@State private var showFeedback = false
```

Key state categories include:

1. **Selection State**: Tracks user choices for configuration
   - Selected group and admin member
   - Desired attendance operation (start/stop)

2. **Loading State**: Manages visual feedback during async operations
   - General loading state for the entire view
   - Processing state for attendance command execution
   - File-specific loading states using a Set to track multiple concurrent operations
   - Detail data loading for attendance records

3. **Data State**: Holds retrieved information from the Discord bot API
   - Available Discord members and admin members
   - Attendance files with metadata
   - Attendee counts per file
   - Detailed attendee lists for selected files

4. **Feedback State**: Controls notification visibility and content
   - Success and error message content
   - Visibility toggle for feedback section

## User Interaction Flow

The view implements a multi-stage interaction flow:

1. **Setup Phase**:
   - User selects a Discord server group from available valid groups
   - User selects an admin member who will manage the attendance
   - System validates the configuration is complete

2. **Command Phase**:
   - User selects whether to start or stop attendance tracking
   - User initiates the command via the action button
   - System displays loading indication during processing
   - System displays success or error feedback after operation completes

3. **History Review Phase**:
   - User browses the list of historical attendance records
   - System displays attendee count for each record
   - User taps on a record to view detailed attendee information
   - System presents a modal sheet with the complete attendee list

## Data Retrieval and Processing

The view integrates with the Bot model's APIClient to retrieve and manipulate attendance data:

```swift
// Example of data retrieval flow
private func loadMembers() {
    isLoadingMembers = true
    adminMembers = []

    Task {
        let result = await bot.apiClient.fetchMembers()

        DispatchQueue.main.async {
            isLoadingMembers = false

            switch result {
            case .success(let fetchedMembers):
                self.members = fetchedMembers
                loadAdminMembers()
            case .failure(let message):
                errorMessage = "Failed to load members: \(message)"
                showFeedback = true
            }
        }
    }
}
```

Key data operations include:

1. **Member Management**:
   - Fetching Discord server members
   - Filtering members with Admin role for attendance management
   - Setting default selections for convenience

2. **Attendance Control**:
   - Starting attendance tracking for a selected group
   - Stopping active attendance sessions
   - Updating group model to reflect attendance state

3. **File Management**:
   - Retrieving attendance record files
   - Sorting files by creation date (newest first)
   - Fetching attendee counts for each file
   - Loading detailed attendee lists for selected files

4. **Data Transformation**:
   - Extracting group names from filenames
   - Parsing and formatting dates from filenames
   - Converting API data models to view-friendly formats

## SwiftUI Patterns and Techniques

The view leverages several advanced SwiftUI patterns:

### 1. Computed Properties

```swift
// Computed properties for derived data
private var validGroups: [GroupModel] {
    return bot.groups.filter { $0.isValid }
}

private var selectedGroup: GroupModel? {
    guard let selectedGroupId = selectedGroupId else { return nil }
    return validGroups.first { $0.name == selectedGroupId }
}

private var isAttendanceActive: Bool {
    return selectedGroup?.attendanceActive ?? false
}
```

These properties provide:
- Dynamic filtering of valid groups
- Reactive access to the currently selected group
- Attendance status derived from the current group state

### 2. Conditional Rendering

```swift
if isFilesLoading {
    HStack {
        Spacer()
        ProgressView()
            .padding()
        Spacer()
    }
} else if attendanceFiles.isEmpty {
    Text("No attendance files available")
        .foregroundColor(.gray)
        .font(.caption)
} else {
    // File list rendering
}
```

This pattern enables:
- Appropriate UI for different loading states
- Empty state handling with informative messages
- Progressive disclosure of information

### 3. Task-Based Concurrency

```swift
Task {
    let result = await bot.apiClient.manageAttendance(
        groupId: groupId,
        targetUserId: memberId,
        status: attendanceStatus
    )

    DispatchQueue.main.async {
        // Update UI with result
    }
}
```

This approach provides:
- Non-blocking API calls using Swift's structured concurrency
- Clean separation between background work and UI updates
- Error handling with descriptive user feedback

### 4. Environmental Integration

```swift
@Bindable var bot: Bot
@Environment(\.modelContext) private var context
@Environment(\.dismiss) private var dismiss
```

These integrations enable:
- Access to the application's data model
- SwiftData persistence operations
- Sheet dismissal through environment values

### 5. Custom View Components

The implementation includes a dedicated `AttendanceDetailsView` for displaying detailed attendance information, demonstrating:
- Component composition for reusability
- Clear separation of concerns
- Specialized UI for specific data visualization needs

## User Experience Considerations

The view incorporates several UX enhancements:

1. **Progressive Loading**: 
   - File counts load asynchronously without blocking the UI
   - Detail data loads only when requested

2. **Visual Feedback**:
   - Loading indicators at appropriate levels of granularity
   - Success and error states with distinctive icons
   - Color-coding for active/inactive states

3. **Intelligent Defaults**:
   - Auto-selection of the first valid group
   - Auto-selection of the first admin member
   - Preservation of selections between view appearances

4. **Validation Logic**:
   - Disabled controls when prerequisites aren't met
   - Clear error messages for missing requirements
   - Prevention of redundant operations (starting already-started attendance)

5. **Accessibility**:
   - Semantic grouping of related controls
   - Sufficient contrast in status indicators
   - Touch targets sized appropriately for interaction

## Data Persistence

The view uses SwiftData for persistence through the model context:

```swift
private func updateGroupAttendanceStatus(group: GroupModel, isActive: Bool) {
    group.attendanceActive = isActive
    try? context.save()
}
```

This enables:
- Persistent tracking of attendance status across app sessions
- Synchronization of model state with UI representation
- Immediate reflection of changes in other views

## Conclusion

`AttendanceCommandView` provides a comprehensive interface for Discord server attendance management, combining intuitive user controls with robust data handling. It demonstrates effective use of SwiftUI's reactive paradigm to create a responsive, state-driven interface that gracefully handles asynchronous operations while providing clear feedback to the user.

The view successfully bridges the gap between the Discord bot's backend capabilities and the user's need to track attendance, offering both command functionality and historical record review in a unified interface. Its implementation showcases modern SwiftUI development patterns including structured concurrency, environmental integration, and composable view architecture. 