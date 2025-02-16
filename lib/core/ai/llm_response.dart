class LLMResponse {
  final String text;
  final Map<String, dynamic>? structuredData;
  final double? confidence;
  final String provider; // 'claude' or 'openai'
  final int tokensUsed;
  final Duration processingTime;

  LLMResponse({
    required this.text,
    this.structuredData,
    this.confidence,
    required this.provider,
    required this.tokensUsed,
    required this.processingTime,
  });
}
