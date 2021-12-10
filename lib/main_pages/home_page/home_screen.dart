import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Stream<QuerySnapshot> _targetStreme =
      FirebaseFirestore.instance.collection("targets").snapshots();
  bool isExpanded = false;
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
              return Text("Loading");
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
                                "Date: " + doc['date'],
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
                                onPressed: () {},
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
}
