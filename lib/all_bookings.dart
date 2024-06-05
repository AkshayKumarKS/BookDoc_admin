
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'booking_provider.dart';

class AllBookings extends StatefulWidget {
  const AllBookings({super.key});

  @override
  State<AllBookings> createState() => _AllBookingsState();
}

class _AllBookingsState extends State<AllBookings> {
  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);

    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('book')
              .orderBy('booked_date', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Center(child: Text('An error occurred!'));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData) {
              final docs = snapshot.data!.docs;
              // Initialize the isSendList with the length of the snapshot data if not already initialized
              if (bookingProvider.isSendList.length != docs.length) {
                bookingProvider.initializeList(docs.length);
              }

              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final booked_data = docs[index];
                  return ListTile(
                    leading: Text(
                      booked_data['tokenNo'].toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                    title: Text(
                        "${booked_data['doctor']} - ${booked_data['department']}"),
                    subtitle: Text(
                        "Patient: ${booked_data['name']}\n${booked_data['booked_date']}"),
                    trailing: IconButton(
                      onPressed: () async {
                        try {
                          String phone = booked_data['phone'];
                          String message =
                              "Your consultation booking has been done! \nBooking Details:\n"
                              "Token No: ${booked_data['tokenNo']}\n"
                              "Doctor: ${booked_data['doctor']}\n"
                              "Department: ${booked_data['department']}\n"
                              "Name: ${booked_data['name']}\n"
                              "Time: ${booked_data['time']}\n"
                              "Booked Date: ${booked_data['booked_date']}\n For any queries, contact: 04772247000\n Sahrudaya Hospital, Alappuzha";
                          final url = Uri(
                            scheme: 'sms',
                            path: phone,
                            queryParameters: {'body': message},
                          );
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          }
                          bookingProvider.setSendStatus(index, true);
                        } catch (e) {
                          print(e);
                          bookingProvider.setSendStatus(index, false);
                        }
                      },
                      icon: bookingProvider.isSendList[index]
                          ? Icon(Icons.done_all)
                          : Icon(Icons.sms),
                    ),
                  );
                },
              );
            }

            return Center(child: Text('No data available'));
          },
        ),
      ),
    );
  }
}
