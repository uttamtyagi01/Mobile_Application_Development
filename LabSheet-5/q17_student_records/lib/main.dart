import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class Student {
  final String name;
  final String rollNumber;
  final String course;

  Student({
    required this.name,
    required this.rollNumber,
    required this.course,
  });
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Student> students = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController rollController = TextEditingController();
  final TextEditingController courseController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  String searchText = "";

  void addStudent() {
    final name = nameController.text.trim();
    final roll = rollController.text.trim();
    final course = courseController.text.trim();

    if (name.isEmpty || roll.isEmpty || course.isEmpty) {
      return;
    }

    setState(() {
      students.add(
        Student(
          name: name,
          rollNumber: roll,
          course: course,
        ),
      );
    });

    nameController.clear();
    rollController.clear();
    courseController.clear();
  }

  void deleteStudent(Student student) {
    setState(() {
      students.remove(student);
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    rollController.dispose();
    courseController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredStudents = students.where((student) {
      return student.name
          .toLowerCase()
          .contains(searchText.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Student Records"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Student Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: rollController,
                  decoration: InputDecoration(
                    labelText: "Roll Number",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: courseController,
                  decoration: InputDecoration(
                    labelText: "Course",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: addStudent,
                    child: Text("Add Student"),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: "Search by name",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredStudents.isEmpty
                ? Center(
                    child: Text("No student records found"),
                  )
                : ListView.builder(
                    itemCount: filteredStudents.length,
                    itemBuilder: (context, index) {
                      final student = filteredStudents[index];

                      return Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        child: ListTile(
                          title: Text(student.name),
                          subtitle: Text(
                            "Roll: ${student.rollNumber}\n"
                            "Course: ${student.course}",
                          ),
                          isThreeLine: true,
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              deleteStudent(student);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
