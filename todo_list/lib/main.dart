import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Namer App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Task {
  int id;

  String task;

  Task({required this.id, required this.task});
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _taskController = TextEditingController();
  TextEditingController _searchController = TextEditingController();

  List<Task> tasksList = [];
  var currentTask = "";
  var isEditEnabled = false;
  var currentEditTaskId = -1;
  var searchTask = "";
  List<Task> filteredTasksList = [];

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do-List'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              width: 400,
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Text(
                'To-Do-List',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 10, // Adjust the height to your preference
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color:
                          Colors.white, // Change the color to match your design
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: TextFormField(
                      controller: _taskController,
                      decoration: InputDecoration(
                        hintText: 'Enter your task...',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) {
                        // Perform your desired action here with the updated input value
                        // print("Input changed: $value");
                        currentTask = value;
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: !isEditEnabled,
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    color: Colors.blue,
                    onPressed: () {
                      // Handle the button press here

                      if (currentTask.isNotEmpty) {
                        setState(() {
                          tasksList.add(Task(
                              id: tasksList.isEmpty
                                  ? 0
                                  : tasksList[tasksList.length - 1].id + 1,
                              task: currentTask));
                          filteredTasksList = tasksList;
                          _taskController.text = "";
                          currentTask = "";
                        });
                      }
                    },
                  ),
                ),
                Visibility(
                  visible: isEditEnabled,
                  child: IconButton(
                    icon: const Icon(Icons.done),
                    color: Colors.blue,
                    onPressed: () {
                      // Handle the button press here

                      if (currentTask.isNotEmpty) {
                        setState(() {
                          tasksList[currentEditTaskId].task = currentTask;
                          currentTask = "";
                          _taskController.text = "";
                          isEditEnabled = false;
                        });
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_forever),
                  color: Colors.blue,
                  onPressed: () {
                    // Handle the button press here
                    if (tasksList.isNotEmpty) {
                      setState(() {
                        tasksList.clear();
                        filteredTasksList.clear();
                        isEditEnabled = false;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.amber,
                          content: Padding(
                            padding: const EdgeInsets.all(8.0), // Add padding
                            child: Text(
                              'All tasks removed',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: const Color.fromARGB(
                                      255, 0, 0, 0)), // Set text color
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            SizedBox(
              height: 10, // Adjust the height to your preference
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white, // Change the color to match your design
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search a task...',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchTask = value;
                    if (searchTask != "") {
                      filteredTasksList = filteredTasksList
                          .where((currentTask) =>
                              currentTask.task.startsWith(searchTask))
                          .toList();
                    } else {
                      filteredTasksList = tasksList;
                    }
                  });
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(15.0), // Adjust the padding as needed
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black, // Specify the border color
                      width:
                          tasksList.isEmpty ? 0 : 1, // Specify the border width
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(10.0)), // Optional: Add border radius
                  ),
                  height: null,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap:
                        true, // This property makes the ListView only take up the necessary height
                    itemCount: filteredTasksList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: ListTile(
                          title: Text(filteredTasksList[index].task),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    filteredTasksList = filteredTasksList
                                        .where((task) =>
                                            task.id !=
                                            filteredTasksList[index].id)
                                        .toList();
                                  });
                                  if (filteredTasksList.length == 0) {
                                    setState(() {
                                      isEditEnabled = false;
                                    });
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  setState(() {
                                    isEditEnabled = !isEditEnabled;
                                  });
                                  if (isEditEnabled) {
                                    setState(() {
                                      _taskController.text =
                                          filteredTasksList[index].task;
                                      currentEditTaskId = index;
                                    });
                                  } else {
                                    setState(() {
                                      _taskController.text = "";
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
