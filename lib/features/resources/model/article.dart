class Article {
  final String id;
  final String title;
  final String description; // A short summary for the card
  final String imageUrl;
  final String content;

  Article({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.content,
  });
}