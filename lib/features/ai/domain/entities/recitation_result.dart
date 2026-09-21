class RecitationResult {
  const RecitationResult({
    required this.recognizedText,
    required this.overallConfidence,
    this.matchedWords = const [],
    this.possibleMissedWords = const [],
    this.possiblePronunciationIssues = const [],
  });
  final String recognizedText;
  final double overallConfidence;
  final List<String> matchedWords,
      possibleMissedWords,
      possiblePronunciationIssues;
}
