//importation du package Flutter pour l'interface utilisateur
import 'package:flutter/material.dart';

void main() {
  runApp(TodoApp());
}
// Définition de l'application principale comme un widget sans état (stateless)
class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoListScreen(),
    );
  }
}
// Écran principal de la liste de tâches, défini comme un widget avec état (stateful)
class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}
// État associé à l'écran de la liste de tâches
class _TodoListScreenState extends State<TodoListScreen> {
  List<Task> tasks = [];
  List<Task> filteredTasks = [];
  Map<String, bool> filters = {
    'Todo': true,
    'In progress': false,
    'Done': false,
    'Bug': false,
  };

  @override
  void initState() {
    super.initState();
    tasks = [
      Task('Task 1', '', 'Todo'),
      Task('Task 2', '', 'In progress'),
      Task('Task 3', '', 'Done'),
      Task('Task 4', '', 'Bug'),
    ];
    // Initialisation de la liste filtrée
    filteredTasks = tasks;
  }
  //Ajout d'une nouvelle tache 
  void _addTask(String title, String description, String status) {
    setState(() {
      tasks.add(Task(title, description, status));
      _filterTasks(); // Appliquer les filtres après ajout
    });
  }
    // Modification d'une tâche existante
  void _editTask(int index, String title, String description, String status) {
    setState(() {
      tasks[index] = Task(title, description, status);
      _filterTasks();  // Modification d'une tâche existante
    });
  }

  void _filterTasks() {
    setState(() {
      filteredTasks = tasks.where((task) => filters[task.status]!).toList();
    });
  }

  
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter par'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: filters.keys.map((String key) {
              return CheckboxListTile(
                title: Text(key),
                value: filters[key],
                onChanged: (bool? value) {
                  setState(() {
                    filters[key] = value!;
                  });
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _filterTasks();
                Navigator.of(context).pop();
              },
              child: Text('Appliquer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todo App',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 71, 66, 66),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            color: Colors.white,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredTasks.length,
        itemBuilder: (context, index) {
          final task = filteredTasks[index];
          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: _getStatusColor(task.status),
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(task.title),
              leading: CircleAvatar(
                backgroundColor: _getStatusColor(task.status),
              ),
              onTap: () {
                _showEditTaskDialog(index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 71, 66, 66),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Todo':
        return Colors.grey;
      case 'In progress':
        return Colors.blue;
      case 'Done':
        return Colors.green;
      case 'Bug':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showAddTaskDialog() {
    String title = '';
    String description = '';
    String status = 'Todo';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Todo App'),
            foregroundColor: const Color.fromARGB(255, 255, 254, 254),
            backgroundColor: const Color.fromARGB(255, 71, 66, 66),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Ajouter',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 2, 12, 20),
                      ),
                    ),
                    Spacer(),
                    Container(
                      constraints: BoxConstraints(maxWidth: 150),
                      child: DropdownButtonFormField<String>(
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 2, 12, 20),
                        ),
                        value: status,
                        decoration: InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'Todo',
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 5.0,
                                ),
                                SizedBox(width: 8.0),
                                Text('Todo'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'In progress',
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  radius: 5.0,
                                ),
                                SizedBox(width: 8.0),
                                Text('In progress'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'Done',
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.green,
                                  radius: 5.0,
                                ),
                                SizedBox(width: 8.0),
                                Text('Done'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'Bug',
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.red,
                                  radius: 5.0,
                                ),
                                SizedBox(width: 8.0),
                                Text('Bug'),
                              ],
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            status = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Nouvelle tâche',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: (value) {
                    title = value;
                  },
                ),
                SizedBox(height: 16.0),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  maxLines: 5,
                  onChanged: (value) {
                    description = value;
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    _addTask(title, description, status);
                    Navigator.pop(context);
                  },
                  child: Text('Ajouter'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 248, 245, 245),
                    backgroundColor: const Color.fromARGB(255, 71, 66, 66),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
        onPressed:_showFilterDialog,
        child: Icon(Icons.close, color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 71, 66, 66),
      ),
        ),
      ),
    );
  }

  void _showEditTaskDialog(int index) {
    String title = tasks[index].title;
    String description = tasks[index].description;
    String status = tasks[index].status;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Todo App'),
            backgroundColor: const Color.fromARGB(255, 61, 57, 57),
            foregroundColor: const Color.fromARGB(255, 255, 255, 255),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                              Row(
                  children: [
                    Text(
                      'Modifier',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 2, 12, 20),
                      ),
                    ),
                    Spacer(),
                    Container(
                      constraints: BoxConstraints(maxWidth: 150),
               child: DropdownButtonFormField<String>(
                  value: status,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'Todo',
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 5.0,
                          ),
                          SizedBox(width: 8.0),
                          Text('Todo'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'In progress',
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blue,
                            radius: 5.0,
                          ),
                          SizedBox(width: 8.0),
                          Text('In progress'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Done',
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: 5.0,
                          ),
                          SizedBox(width: 8.0),
                          Text('Done'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Bug',
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 5.0,
                          ),
                          SizedBox(width: 8.0),
                          Text('Bug'),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      status = value!;
                     });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Titre de la tâche',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  controller: TextEditingController(text: title),
                  onChanged: (value) {
                    title = value;
                  },
                ),
                SizedBox(height: 16.0),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  maxLines: 5,
                  controller: TextEditingController(text: description),
                  onChanged: (value) {
                    description = value;
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    _editTask(index, title, description, status);
                    Navigator.pop(context);
                  },
                  child: Text('Modifier'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 248, 245, 245),
                    backgroundColor: const Color.fromARGB(255, 71, 66, 66),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
           floatingActionButton: FloatingActionButton(
        onPressed:main,
        child: Icon(Icons.close, color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 71, 66, 66),
      ),
        ),
      ),
    );
  }
}

class Task {
  String title;
  String description;
  String status;

  Task(this.title, this.description, this.status);
}
