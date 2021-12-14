import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final Stream<QuerySnapshot> _cotributionStream =
      FirebaseFirestore.instance.collection("targets").snapshots();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: StreamBuilder<QuerySnapshot>(
          stream: _cotributionStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something Went Error");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: CircularProgressIndicator(
                    semanticsLabel: 'Linear progress indicator',
                  ),
                ),
              );
            }
            ;

            return ListView(
              children: snapshot.data!.docs.map(
                (DocumentSnapshot doc2) {
                  return ListTile(
                    title: Text(doc2['note']),
                    subtitle: Row(
                      children: [
                        Text(
                          doc2['amount'].toString(),
                        ),
                        Text(
                          doc2['date'].toDate().toString(),
                        ),
                      ],
                    ),
                  );
                },
              ).toList(),
            );
          },
        ),
      ),
    );
  }
}
