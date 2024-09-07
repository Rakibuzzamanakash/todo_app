class Todo {
  final int id;
  final String title;
  final String description;
  final bool isDone;
  final String imageUrl;
  final DateTime? completionDate;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.isDone,
    required this.imageUrl,
    required this.completionDate
  });
}
