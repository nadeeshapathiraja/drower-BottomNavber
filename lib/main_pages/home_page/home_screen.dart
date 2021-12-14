import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController txtAmount = TextEditingController();
  TextEditingController txtNote = TextEditingController();

  bool isExpanded = false;
  final Stream<QuerySnapshot> _targetStreme =
      FirebaseFirestore.instance.collection("targets").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: _targetStreme,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Somthing went Error");
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
            return ExpansionPanelList(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                dynamic doc = document.data();

                return ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          doc["name"],
                          textScaleFactor: 1.5,
                        ),
                      );
                    },
                    body: Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Amount: " + doc['amount'].toString(),
                              ),
                              Text(
                                "Date: " +
                                    doc["date"]
                                        .toDate()
                                        .toString()
                                        .split(" ")[0],
                                // DateTime.parse(doc["date"].toDate().toString())
                              ),
                            ],
                          ),
                          Divider(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                doc['contribution_total'].toString() +
                                    " / " +
                                    doc['amount'].toString(),
                              ),
                              IconButton(
                                icon: Icon(Icons.attach_money),
                                splashColor: Colors.amber,
                                color: Colors.green,
                                onPressed: () {
                                  String tid = document.id;
                                  _showMyDialog(tid);
                                },
                              )
                            ],
                          ),
                          LinearProgressIndicator(
                            value: doc["contribution_total"] / doc['amount'],
                            color: Colors.red,
                          ),
                          SleekCircularSlider(
                            min: doc["contribution_total"] / doc['amount'],
                            max: 100,
                            initialValue:
                                (doc["contribution_total"] / doc['amount']) *
                                    100,
                            onChange: (double value) {
                              // callback providing a value while its being changed (with a pan gesture)
                            },
                            onChangeStart: (max) {
                              // callback providing a starting value (when a pan gesture starts)
                            },
                            onChangeEnd: (min) {
                              // ucallback providing an ending value (when a pan gesture ends)
                            },
                          ),
                        ],
                      ),
                    ),
                    isExpanded: true);
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showMyDialog(tid) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Contribution'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Enter Amount'),
                TextFormField(
                  controller: txtAmount,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 15),
                Text('Note'),
                TextFormField(
                  controller: txtNote,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                String amount = txtAmount.text;
                String note = txtNote.text;

                if (amount.isNotEmpty && note.isNotEmpty) {
                  FirebaseFirestore.instance.collection('contributions').add(
                    {
                      'amount': int.parse(amount),
                      'note': note,
                      'date': new DateTime.now(),
                      'target_id': tid,
                    },
                  );
                  FirebaseFirestore.instance
                      .collection('targets')
                      .doc(tid)
                      .update(
                    {
                      'contribution_total': FieldValue.increment(
                        int.parse(amount),
                      ),
                    },
                  );
                  txtAmount.text = '';
                  txtNote.text = '';

                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
