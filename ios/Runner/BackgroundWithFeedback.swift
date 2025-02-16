import AppIntents
import intelligence

@available(iOS 16, *)
struct BackgroundWithFeedbackAppIntent: AppIntent {
  static var title: LocalizedStringResource = "Quick Log Entry"
  static var openAppWhenRun: Bool = false  // Keep app in background
    
  @Parameter(title: "Entry", description: "What would you like to log?")
  var entry: String
  
  @MainActor
  func perform() async throws -> some IntentResult {
    // Process in background and wait for result
    let result = await IntelligencePlugin.notifier.pushAndProcess(entry)
    
    switch result {
      case .success(let processedLog):
        return .result(
          value: "Entry logged",
          dialog: """
            Successfully logged:
            Type: \(processedLog.type)
            Time: \(processedLog.timestamp)
            Details: \(processedLog.details)
            """
        )
      case .failure(let error):
        return .result(
          value: "Failed to log",
          dialog: "Error: \(error.localizedDescription)"
        )
    }
  }
  
  static var parameterSummary: some ParameterSummary {
    Summary("Quick log: \(\.$entry)")
  }
}

struct BackgroundShortcuts: AppShortcutsProvider {
  static var appShortcuts: [AppShortcut] {
    AppShortcut(
      intent: BackgroundWithFeedbackAppIntent(),
      phrases: [
        "Quick log \(\.$entry)",
        "Quick note \(\.$entry)"
      ],
      systemImageName: "square.and.pencil.circle.fill"
    )
  }
}
