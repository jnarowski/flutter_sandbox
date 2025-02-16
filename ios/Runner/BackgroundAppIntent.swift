import AppIntents
import intelligence

@available(iOS 16, *)
struct BackgroundAppIntent: AppIntent {
  static var title: LocalizedStringResource = "Quick Log Entry"
  static var openAppWhenRun: Bool = false  // Keep app in background
    
  @Parameter(title: "Entry", description: "What would you like to log?")
  var entry: String
  
  @MainActor
  func perform() async throws -> some IntentResult {
    // Process in background
    IntelligencePlugin.notifier.push(entry)
    
    // Provide immediate feedback
    return .result(
      value: "Entry logged",
      dialog: "Successfully logged: \(entry)"
    )
  }
  
  static var parameterSummary: some ParameterSummary {
    Summary("Quick log: \(\.$entry)")
  }
}

struct BackgroundShortcuts: AppShortcutsProvider {
  static var appShortcuts: [AppShortcut] {
    AppShortcut(
      intent: BackgroundAppIntent(),
      phrases: [
        "Quick log \(\.$entry)",
        "Quick note \(\.$entry)"
      ],
      systemImageName: "square.and.pencil.circle.fill"
    )
  }
}
