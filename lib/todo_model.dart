class TodoModel {
  String taskName;
  bool completed;
  Function(bool?)? onChnaged;

  TodoModel({required this.taskName, required this.completed, this.onChnaged});
}
