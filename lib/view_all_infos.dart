import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Database/db_helper.dart';
import 'Model/info.dart';
import 'updatestudents.dart';

class ViewAllInfos extends StatefulWidget {
  const ViewAllInfos({super.key});

  @override
  State<ViewAllInfos> createState() => _ViewAllInfosState();
}

class _ViewAllInfosState extends State<ViewAllInfos> {
  late DatabaseHelper dbHelper;
  List<Info> infos = [];

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper.instance;
    loadAllStudents();
  }

  /// Fetch all students from the database
  Future<void> loadAllStudents() async {
    final data = await dbHelper.getAllData();
    setState(() {
      infos = List<Info>.from(
          data.map((e) => Info.fromMap(e as Map<String, dynamic>)));
    });
  }

  /// Function to make a phone call
  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Fluttertoast.showToast(msg: "Unable to make a call to $phoneNumber");
    }
  }

  /// Function to delete a student
  Future<void> deleteStudent(int id) async {
    final result = await dbHelper.deleteData(id);
    if (result > 0) {
      Fluttertoast.showToast(msg: "Student data has been deleted successfully");
      loadAllStudents();
    } else {
      Fluttertoast.showToast(msg: "Failed to delete student data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            List<Map<String, dynamic>> infosAsMaps =
            infos.map((info) => info.toMap()).toList();
            await FirebaseDatabase.instance.ref("Infos").set(infosAsMaps);
            Fluttertoast.showToast(msg: "Data saved to Firebase successfully!");
          } catch (e) {
            Fluttertoast.showToast(msg: "Failed to save data: $e");
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          CupertinoIcons.upload_circle,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: const Text(
          "All Students",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        backgroundColor: Colors.blue,
      ),
      body: infos.isEmpty
          ? const Center(child: Text("No student data available!"))
          : ListView.builder(
        itemCount: infos.length,
        itemBuilder: (context, index) {
          Info inf = infos[index];
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.blue, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateStudents(info: inf),
                  ),
                );
              },
              title: Text(
                inf.name!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(inf.email!),
              leading: const Icon(Icons.mail_outline, size: 40),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.question,
                        headerAnimationLoop: false,
                        animType: AnimType.bottomSlide,
                        title: 'Delete',
                        desc: 'Do you want to delete this student data?',
                        buttonsTextStyle:
                        const TextStyle(color: Colors.white),
                        showCloseIcon: true,
                        btnCancelOnPress: () {},
                        btnOkText: 'YES',
                        btnCancelText: 'NO',
                        btnOkOnPress: () {
                          deleteStudent(inf.id!);
                        },
                      ).show();
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.question,
                        headerAnimationLoop: false,
                        animType: AnimType.bottomSlide,
                        title: 'Call',
                        desc: 'Do you want to call ${inf.phone!}?',
                        buttonsTextStyle:
                        const TextStyle(color: Colors.white),
                        showCloseIcon: true,
                        btnCancelOnPress: () {},
                        btnOkText: 'YES',
                        btnCancelText: 'NO',
                        btnOkOnPress: () {
                          makePhoneCall(inf.phone!);
                        },
                      ).show();
                    },
                    icon: const Icon(
                      Icons.call,
                      color: Colors.green,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
