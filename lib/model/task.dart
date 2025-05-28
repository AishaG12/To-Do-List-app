class TaskModel{
  final String id;
  String title;
  final String date;
  bool isDone;
  TaskModel({
    required this.id,
    required this.title,
    required this.date,
    this.isDone=false,
  });
}