import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_firebase/database_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool personal = true, office = false, university = false;

  // bool completed = false;
  final todoController = TextEditingController();

  Stream? todoStream;

  getData() async {
    todoStream = await FirebaseService().fetchData(
      personal
          ? 'personal'
          : university
              ? 'university'
              : 'office',
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData(); // Call getData in initState to fetch data when the screen loads
  }

  Widget displayData() {
    return StreamBuilder(
        stream: todoStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Expanded(
                child: Center(
              child: Text('No Todo Found'),
            ));
          }
          return Expanded(
            child: ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot doc =
                      snapshot.data.docs[index]; // Use index here
                  return CheckboxListTile(
                      title: Text(doc['work'],style: const TextStyle(color: Colors.white),),
                      activeColor: Colors.red.shade400,
                      controlAffinity: ListTileControlAffinity.leading,
                      value: doc['isCompleted'],
                      onChanged: (value) {
                        setState(() {
                          FirebaseService().tickMethod(
                            doc['id'],
                            personal
                                ? 'personal'
                                : university
                                    ? 'university'
                                    : 'office',
                          );
                          setState(() {
                            Future.delayed(const Duration(seconds: 4), () {
                              FirebaseService().deleteMethod(
                                doc['id'],
                                personal
                                    ? 'personal'
                                    : university
                                        ? 'university'
                                        : 'office',
                              );
                            });
                          });
                        });
                      });
                }),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Center(
          child: Text(
            'Todo App',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(left: 10, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            welcomeText(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                personal
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white
                        ),
                        child: const Text(
                          'Personal',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      )
                    : InkWell(
                        onTap: () async {
                          personal = true;
                          office = false;
                          university = false;
                          await getData(); // Fetch data when changing the category
                        },
                        child: const Text(
                          'Personal',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                university
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white
                        ),
                        child: const Text(
                          'University',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      )
                    : InkWell(
                        onTap: () async {
                          personal = false;
                          office = false;
                          university = true;
                          await getData(); // Fetch data when changing the category
                        },
                        child: const Text(
                          'University',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                office
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white
                        ),
                        child: const Text(
                          'Office',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      )
                    : InkWell(
                        onTap: () async {
                          personal = false;
                          office = true;
                          university = false;
                          await getData(); // Fetch data when changing the category
                        },
                        child: const Text(
                          'Office',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
              ],
            ),
            const SizedBox(height: 30),
            displayData(), // Display data here
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: openDialog,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }

  openDialog() {
    return showDialog(
      barrierColor: Colors.white,
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.cancel,
                            size: 30,
                          )),
                      const Text(
                        'Add todo Task...',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(8),
                    // decoration: BoxDecoration(border: Border.all(),),
                    child: TextFormField(
                      controller: todoController,
                      decoration: const InputDecoration(
                          hintText: 'Enter todo Text',
                          suffixIcon: Icon(Icons.task)),
                    ),
                  ),
                  const SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      if (todoController.text.trim().isEmpty) {
                        // Show a message or alert that the task cannot be empty.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Task cannot be empty')),
                        );
                        return;
                      }

                      String id = DateTime.now().millisecondsSinceEpoch.toString();
                      Map<String, dynamic> userTodo = {
                        'id': id,
                        'work': todoController.text.trim(),
                        'isCompleted': false,
                      };
                      personal
                          ? FirebaseService().addPersonalTask(userTodo, id)
                          : university
                          ? FirebaseService().addUniversityTask(userTodo, id)
                          : FirebaseService().addOfficeTask(userTodo, id);
                      todoController.clear();
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(width: 2, color: Colors.black)),
                        child: const Text(
                          'Add',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget welcomeText() {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: const Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
          Text('Nain',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22)),
          Text('Let\'s begin work..',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20))
        ],
      ),
    );
  }
}
