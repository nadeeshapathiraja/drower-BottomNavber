import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateTargets extends StatefulWidget {
  const CreateTargets({Key? key}) : super(key: key);

  @override
  _CreateTargetsState createState() => _CreateTargetsState();
}

class _CreateTargetsState extends State<CreateTargets> {
  TextEditingController txtname = new TextEditingController();
  TextEditingController txtamount = new TextEditingController();

  DateTime? date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: SingleChildScrollView(
          child: Card(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Add New Targets",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Text("Target Name"),
                  TextFormField(
                    controller: txtname,
                  ),
                  const SizedBox(height: 20.0),
                  Text("Target Amount"),
                  TextFormField(
                    controller: txtamount,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20.0),
                  Text("Target Date"),
                  ElevatedButton(
                    onPressed: () async {
                      date = await showDatePicker(
                        context: context,
                        initialDate: date ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2500),
                      );
                    },
                    child: Text("Choose Date"),
                  ),
                  const SizedBox(height: 20.0),
                  ButtonBar(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            txtname.clear();
                            txtamount.clear();
                            date = null;
                          });
                        },
                        child: Text("Clear"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          String name = txtname.text;
                          String amount = txtamount.text;

                          FirebaseFirestore.instance.collection("targets").add(
                            {
                              "name": name,
                              "amount": amount,
                              "date": date,
                              "complete": 0,
                              "contribution_total": 0,
                            },
                          );
                          txtname.clear();
                          txtamount.clear();
                          date = null;
                        },
                        child: Text("Save"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
