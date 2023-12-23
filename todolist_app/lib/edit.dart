// ignore_for_file: unused_field, prefer_const_constructors, avoid_print, use_key_in_widget_constructors, must_be_immutable, unused_element, unused_local_variable, avoid_unnecessary_containers

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uas_pbm/home.dart';

class Edit extends StatefulWidget {
  Edit({required this.id});

  String id;

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  final _formKey = GlobalKey<FormState>();

  //inisialize field
  var title = TextEditingController();
  var content = TextEditingController();

  @override
  void initState() {
    super.initState();
    //in first time, this method will be executed
    _getData();
  }

  //Http to get detail data
  Future _getData() async {
    try {
      final response = await http.get(Uri.parse(
          //you have to take the ip address of your computer.
          //because using localhost will cause an error
          //get detail data with id
          "http://192.168.0.12/mobile/uas_pbm/detail.php?id='${widget.id}'"));

      // if response successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          title = TextEditingController(text: data['title']);
          content = TextEditingController(text: data['content']);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future _onUpdate(context) async {
    try {
      return await http.post(
        Uri.parse("http://192.168.0.12/mobile/uas_pbm/update.php"),
        body: {
          "id": widget.id,
          "title": title.text,
          "content": content.text,
        },
      ).then((value) {
        //print message after insert to database
        //you can improve this message with alert dialog
        var data = jsonDecode(value.body);
        print(data["message"]);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ),
        );
      });
    } catch (e) {
      print(e);
    }
  }

  Future _onDelete(context) async {
    try {
      return await http.post(
        Uri.parse("http://192.168.0.12/mobile/uas_pbm/delete.php"),
        body: {
          "id": widget.id,
        },
      ).then((value) {
        //print message after insert to database
        //you can improve this message with alert dialog
        var data = jsonDecode(value.body);
        print(data["message"]);

        // Remove all existing routes until the home.dart, then rebuild Home.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ),
        );
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 55, 99, 56),
      appBar: AppBar(
        titleTextStyle: TextStyle(
            color: Colors.black, fontSize: 21, fontWeight: FontWeight.bold),
        backgroundColor: Colors.lightGreen,
        title: Text("Edit To Do List"),
        // ignore: prefer_const_literals_to_create_immutables
        actions: [
          Container(
            padding: EdgeInsets.only(right: 20),
            child: IconButton(
                color: Colors.black,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      //show dialog to confirm delete data
                      return AlertDialog(
                        content: Text('Apakah Anda Yakin Ingin Menghapus?'),
                        actions: <Widget>[
                          ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.red),
                            child: Icon(Icons.cancel_outlined),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.green),
                            child: Icon(Icons.check_circle_outline_rounded),
                            onPressed: () => _onDelete(context),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(
                  Icons.delete_outline_rounded,
                  size: 28,
                )),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'To Do',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: title,
                decoration: InputDecoration(
                    hintText: "Add To Do",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    fillColor: Colors.white,
                    filled: true),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'To Do Title is Required!';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text(
                'Description',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: content,
                keyboardType: TextInputType.multiline,
                minLines: 5,
                maxLines: null,
                decoration: InputDecoration(
                    hintText: 'Add Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    fillColor: Colors.white,
                    filled: true),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Description is Required!';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.greenAccent.shade700,
                  ),
                  child: Text(
                    "Edit",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    // validate
                    if (_formKey.currentState!.validate()) {
                      // send data to the database with this method
                      _onUpdate(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
