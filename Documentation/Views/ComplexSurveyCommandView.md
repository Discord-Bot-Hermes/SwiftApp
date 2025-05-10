# ComplexSurveyCommandView Documentation

## Overview

`ComplexSurveyCommandView` is a sophisticated SwiftUI interface for creating, managing, and analyzing multi-question surveys within a Discord bot application. This view enables users to configure survey parameters, view historical survey data, and analyze response distributions through an intuitive interface that follows Apple's Human Interface Guidelines.

## View Structure and Composition

The view implements a hierarchical structure with several components:

1. **Main View (`ComplexSurveyCommandView`)**: The primary interface for survey creation and management
2. **Detail Views**:
   - `ComplexSurveyDetailsView`: Displays survey results organized by question
   - `SurveyResponseDetailsView`: Shows detailed analysis of responses to a specific question
   - `SurveyCategoryPeopleView`: Lists individuals who selected a specific response

This modular composition promotes reusability and separation of concerns, with each component handling a specific aspect of the survey workflow.

### Layout and Visual Design

The interface follows Apple's Human Interface Guidelines with:

- **Content Grouping**: Related controls are organized into logical Form sections
- **Progressive Disclosure**: Complex data is revealed through sheet presentations
- **Visual Hierarchy**: Important actions receive visual emphasis
- **Accessibility**: Components include identifiers and appropriate text sizing
- **Consistent Spacing**: Uniform padding and alignment throughout the interface
- **Responsive Feedback**: Loading states and confirmation messages

## State Management

The view leverages SwiftUI's state management capabilities extensively:

```swift
@Bindable var bot: Bot

// Primary state variables
@State private var message: String = ""
@State private var mainTopic: String = ""
@State private var selectedChannelId: String?
@State private var channels: [Channel] = []
@State private var questions: [Question] = [Question()]
@State private var numberOfQuestions = 1
@State private var surveyDuration: Double = 60

// UI state variables
@State private var isLoading = false
@State private var isCreating = false
@State private var showFeedback = false
@State private var errorMessage: String?
@State private var successMessage: String?

// Survey history states
@State private var surveyFiles: [SurveyFile] = []
@State private var isFilesLoading = false
@State private var surveyCounts: [String: Int] = [:]
@State private var loadingFiles: Set<String> = []

// Details view states
@State private var selectedFile: SurveyFile?
@State private var showDetails = false
@State private var isDetailDataLoading = false
@State private var loadedSurveys: [SurveyEntry] = []
```

This state architecture:
1. Isolates input fields from processing logic
2. Maintains UI responsiveness during network operations
3. Supports granular updates through property wrappers
4. Enables reactive updates across the component hierarchy

## User Interaction Flow

The view supports a complete survey management workflow:

1. **Survey Creation**:
   - Configure survey message and topic
   - Select target Discord channel
   - Define questions and response types (Score or Difficulty)
   - Set survey duration
   - Create and deploy survey

2. **Survey Analysis**:
   - View list of historical surveys
   - Select survey to analyze
   - Examine question-by-question results
   - View response distributions with interactive charts
   - Drill down into specific response categories

3. **Feedback Cycle**:
   - Receive clear success/error messages
   - Validate input before submission
   - Display loading indicators during operations

## Integration with API Client

The view communicates with the Discord bot backend through the `APIClient` instance associated with the `Bot` model:

```swift
private func createSurvey() {
    // Input validation
    
    Task {
        let result = await bot.apiClient.createComplexSurvey(
            message: message,
            mainTopic: mainTopic,
            channelId: channelId,
            questions: questionData,
            duration: Int(surveyDuration)
        )

        DispatchQueue.main.async {
            // UI updates based on result
        }
    }
}
```

Key aspects of the API integration:
1. **Asynchronous Operations**: All network calls use Swift's structured concurrency (`async/await`)
2. **Main Thread Updates**: UI updates occur on the main thread via `DispatchQueue.main.async`
3. **Error Handling**: Results are processed through typed result enums
4. **Optimistic UI**: Interface provides immediate feedback before server confirmation

## Data Visualization

The view implements sophisticated data visualization:

1. **Bar Charts**: Response distributions displayed using SwiftUI's Charts framework
2. **Color Coding**: Responses are color-coded based on semantic meaning
3. **Interactive Legend**: Tappable legends for drilling into specific categories
4. **Summary Statistics**: Count and percentage information for quick analysis

This visualization approach:
- Makes complex data immediately comprehensible
- Supports interactive exploration of results
- Provides visual patterns for quick insight detection

## Form Validation

The view includes robust validation:

```swift
private func validateQuestions() -> Bool {
    var incompleteQuestions: [String] = []
    
    // Check each question for completion
    
    if incompleteQuestions.isEmpty {
        return true
    } else {
        validationMessage = "Please complete the following:\n" 
            + incompleteQuestions.joined(separator: "\n")
        return false
    }
}
```

This validation ensures:
1. All required fields are completed before submission
2. Character limits are enforced on questions
3. Users receive clear feedback about validation issues

## Helper Components

The view defines several supporting structures:

1. **Question Model**:
```swift
struct Question {
    var text: String = ""
    var buttonType: String = ""
    var characterCount: Int { text.count }
    static let maxCharacters = 50
}
```

2. **Chart Data Model**:
```swift
struct ComplexChartData: Identifiable {
    let id = UUID()
    let category: String
    let count: Int
}
```

These models encapsulate domain concepts and provide helper properties for the view.

## Reusability and Composition

Several sub-views are extracted for reusability:

1. **KeyRow**: Renders individual question items
2. **ComplexSurveyDetailsView**: Shows survey results by question
3. **SurveyResponseDetailsView**: Displays detailed analysis of a single question
4. **SurveyCategoryPeopleView**: Lists individuals by response

This composition enhances:
- Code maintainability through focused components
- UI consistency across the application
- Testing capabilities through isolated components

## SwiftUI Features Utilized

The view showcases advanced SwiftUI capabilities:

1. **Lists and Forms**: Structured data presentation
2. **Sheets and Navigation**: Hierarchical information display
3. **Progress Indicators**: Visual feedback during operations
4. **Charts Framework**: Data visualization
5. **Pickers and Sliders**: Complex input controls
6. **Alerts**: Validation feedback
7. **Refreshable**: Pull-to-refresh functionality

## Conclusion

`ComplexSurveyCommandView` exemplifies sophisticated SwiftUI development practices through its:

1. **Hierarchical Structure**: Clear separation of concerns in nested views
2. **Comprehensive State Management**: Coordinated state variables for UI reactivity
3. **Asynchronous Operations**: Modern Swift concurrency for network operations
4. **Progressive Disclosure**: Information revealed through intuitive navigation
5. **Input Validation**: Robust error checking and user feedback
6. **Data Visualization**: Interactive charts for insightful analysis
7. **Accessibility**: Adherence to Human Interface Guidelines

This comprehensive implementation enables users to effectively create, manage, and analyze complex surveys through a Discord bot, with a focus on usability and information design principles. 