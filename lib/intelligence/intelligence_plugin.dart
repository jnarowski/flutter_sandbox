class IntelligencePlugin {
  static Future<LogResult> pushAndProcess(String entry) async {
    try {
      // Process with LLM
      final llmResponse = await llmService.processMessage(
        message: entry,
        provider: LLMProvider.openAI,
      );

      // Parse into structured log
      final processedLog = LogParser.parseFromLLM(llmResponse);

      // Save to database
      await logService.create(processedLog);

      return LogResult.success(processedLog);
    } catch (e) {
      logger.e('Failed to process log: $e');
      return LogResult.failure(e);
    }
  }
}

class LogResult {
  final ProcessedLog? log;
  final dynamic error;

  LogResult.success(this.log) : error = null;
  LogResult.failure(this.error) : log = null;
}

class ProcessedLog {
  final String type;
  final DateTime timestamp;
  final String details;
  // ... other fields
}
