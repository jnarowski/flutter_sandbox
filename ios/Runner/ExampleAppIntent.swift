import AppIntents
import intelligence

@available(iOS 16, *)
struct ExampleAppIntent: AppIntent {
  static var title: LocalizedStringResource = "Log Entry"
  static var openAppWhenRun: Bool = true
    
  @Parameter(title: "Entry", description: "What would you like to log?")
  var entry: String
  
  @MainActor
  func perform() async throws -> some IntentResult {
    IntelligencePlugin.notifier.push(entry)
    return .result()
  }
  
  static var parameterSummary: some ParameterSummary {
    Summary("Log entry: \(\.$entry)")
  }
}


struct AppShortcuts: AppShortcutsProvider {
  static var appShortcuts: [AppShortcut] {
    AppShortcut(
      intent: ExampleAppIntent(),
      phrases: [
        "Log \(\.$entry)"
      ]
    )
  }
}
