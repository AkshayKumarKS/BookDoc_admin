import 'package:adminproject/adding.dart';
import 'package:adminproject/all_bookings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
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
    "Oncologist"
  ];

  String department = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Row(
          children: [
            Spacer(),
            FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllBookings(),
                      ));
                },
                label: Text('Bookings')),
            Spacer(),
            FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => add(),
                      ));
                },
                label: Text('Add Doctor')),
            Spacer(),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: DropdownButtonFormField(
                  iconSize: 20,
                  dropdownColor: Colors.cyanAccent,
                  hint: Text("DEPARTMENTS"),
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
                      print(Specialvalue);
                    });
                  },
                ),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('data')
                    .where('specialvalue', isEqualTo: Specialvalue)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("ERROR ::: ${snapshot.error}");
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final document = snapshot.data!.docs[index];
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.6),
                                      offset: Offset(0.0, 5.0),
                                      blurRadius: 10.0,
                                      spreadRadius: -1.0)
                                ],
                              ),
                              height: 250,
                              width: 400,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  document['image']
                                                      .toString())),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "${document['name']}\n${document['specialvalue']}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, 'UPDATE',
                                                  arguments: {
                                                    'image': document['image']
                                                        .toString(),
                                                    'name': document['name'],
                                                    'spcl': document[
                                                        'specialvalue'],
                                                    'about': document['about'],
                                                    'fees': document['fee'],
                                                    'mail': document[
                                                        'doctor_email'],
                                                    'start':
                                                        document['start_time'],
                                                    'end': document['end_time'],
                                                    'id': document.id,
                                                  });
                                            },
                                            icon: Icon(Icons.edit)),
                                        IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  content: Text(
                                                      "Are you sure you want to delete ?"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("cancel")),
                                                    TextButton(
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                content: Text(
                                                                    "Are you sure?\n you want to delete this profile?"),
                                                                actions: [
                                                                  TextButton(
                                                                      onPressed: () =>
                                                                          Navigator.pop(
                                                                              context),
                                                                      child: Text(
                                                                          'cancel')),
                                                                  TextButton(
                                                                      onPressed: () => FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'data')
                                                                          .doc(document
                                                                              .id)
                                                                          .delete(),
                                                                      child: Text(
                                                                          'ok'))
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: Text("Ok"))
                                                  ],
                                                ),
                                              );
                                            },
                                            icon: Icon(Icons.delete))
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "About\n${document['about']}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "General Consultation : ₹ ${document['fee']}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ]),
                            ));
                      },
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
