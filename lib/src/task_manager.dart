class TaskManager {
  void deleteTask(List<String> tasks, int index) {
    tasks.removeAt(index);
  }

  void editTask(List<String> tasks, int index, String editedTask) {
    tasks[index] = editedTask;
  }
}
