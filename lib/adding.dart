import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class add extends StatefulWidget {
  const add({super.key});

  @override
  State<add> createState() => _addState();
}

class _addState extends State<add> {
  String? image;
  String? Specialvalue;

  List<String> Departments = [
    "Physician",
    "Surgeon",
    "Paediatricion",
    "Gynacologist",
    "Psychiatrist",
    "Cardiologist",
    "Neurologist",
    "Ophthalmologist",
    "Dermatologist",
    "Physiotherapist",
    "Orthopedist",
    "Urologist",
    "Otolaryngologist",
    "Gastroenterologist",
    "Oncologist",
  ];

  TextEditingController about = TextEditingController();
  TextEditingController fee = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController doctoremail = TextEditingController();
  TextEditingController token = TextEditingController();


  Done() async {
    await FirebaseFirestore.instance.collection('data').add({
      "image": image,
      "name": name.text,
      "specialvalue": Specialvalue,
      "about": about.text,
      "fee": fee.text,
      'start_time': start.format(context).toString(),
      'end_time': end.format(context).toString(),
      'doctor_email': doctoremail.text,
      'tokens':token.text
    });
  }

  TimeOfDay start = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay end = TimeOfDay(hour: 0, minute: 0);

  void showstart() {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((value) {
      setState(() {
        start = value!;
      });
    });
  }

  void showend() {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((value) {
      setState(() {
        end = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    name.text = "Dr. ";
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
                onTap: () async {
                  final pickedfile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (pickedfile == null) {
                    return;
                  } else {
                    File file = File(pickedfile.path);
                    setState(() async {
                      image = await uploadimage(file);
                    });
                  }
                },
                child: image == null
                    ? Container(
                        height: 400,
                        width: 400,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.lightBlueAccent)),
                        padding: EdgeInsets.all(20),
                      )
                    : Container(
                        height: 400,
                        width: 400,
                        child: Image.network(image!),
                      )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: name,
                decoration: InputDecoration(labelText: "Dr Name"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  iconSize: 20,
                  dropdownColor: Colors.cyanAccent,
                  hint: Text("Specialised in"),
                  value: Specialvalue,
                  items: Departments.map((String value) {
                    return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ));
                  }).toList(),
                  onChanged: (newvalue) {
                    setState(() {
                      Specialvalue = newvalue;
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: about,
                maxLines: 5,
                decoration: InputDecoration(labelText: "About"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: fee,
                decoration: InputDecoration(labelText: "Consultation fees"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: doctoremail,
                maxLines: 5,
                decoration: InputDecoration(labelText: "doctor email"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Row(
                children: [
                  MaterialButton(
                    onPressed: showstart,
                    child: Text("START TIME"),
                  ),
                  Text(
                    start.format(context).toString(),
                    style: TextStyle(fontWeight: FontWeight.w300),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Row(
                children: [
                  MaterialButton(
                    onPressed: showend,
                    child: Text("END TIME"),
                  ),
                  Text(
                    end.format(context).toString(),
                    style: TextStyle(fontWeight: FontWeight.w300),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: token,
                decoration: InputDecoration(
                  labelText: "Give Token",
                ),
                onChanged: (value) {
                  if (value.length == 4) {
                    FocusScope.of(context).nextFocus();
                  }
                },
                style: Theme.of(context).textTheme.headlineMedium,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(4),
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Done();
                  Navigator.pop(context);
                },
                child: Text("Done"))
          ],
        ),
      ),
    );
  }

  Future<String?> uploadimage(File file) async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    DateTime now = DateTime.now();
    String timestamp = now.millisecondsSinceEpoch.toString();
    firebase_storage.Reference ref = storage.ref().child("image/$timestamp");
    firebase_storage.UploadTask task = ref.putFile(file);
    await task;
    String downloadurl = await ref.getDownloadURL();
    setState(() {
      image = downloadurl;
    });
    return image;
  }
}
