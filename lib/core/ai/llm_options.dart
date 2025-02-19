class LLMOptions {
  final String? systemMessage;
  final String? model;
  final int maxTokens;
  final double temperature;
  final Map<String, dynamic>? context;
  final bool jsonResponse;

  const LLMOptions({
    this.systemMessage,
    this.model,
    this.maxTokens = 1000,
    this.temperature = 0.7,
    this.context,
    this.jsonResponse = false,
  });

  Map<String, dynamic> toMap() => {
        'system_message': systemMessage,
        'model': model,
        'max_tokens': maxTokens,
        'temperature': temperature,
        'context': context,
        'json_response': jsonResponse,
      };
}
