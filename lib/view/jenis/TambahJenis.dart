import 'package:flutter/material.dart';
import 'package:app_inventori/model/api.dart';
import 'package:app_inventori/model/jenisModel.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';
import 'dart:convert';

class TambahJenis extends StatefulWidget {
  final VoidCallback reload;
  TambahJenis(this.reload);
  @override
  State<TambahJenis> createState() => _TambahJenisState();
}

class _TambahJenisState extends State<TambahJenis> {
  FocusNode myFocusNode = new FocusNode();
  String? jenis;
  final _key = new GlobalKey<FormState>();
  check() {
    final form = _key.currentState;
    if (form != null && form.validate()) {
      form.save();
      simpanJenis();
    }
  }

  simpanJenis() async {
    try {
      final response = await http.post(
          Uri.parse(BaseUrl.urlTambahJenis.toString()),
          body: {"jenis": jenis});
      final data = jsonDecode(response.body);
      print(data);
      int code = data['success'];
      String pesan = data['message'];
      print(data);
      if (code == 1) {
        setState(() {
          Navigator.pop(context);
          widget.reload();
        });
      } else {
        print(pesan);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(244, 255, 255, 255),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 41, 141, 218),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  "Tambah Jenis Barang",
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              )
            ],
          ),
        ),
        body: Form(
          key: _key,
          child: ListView(
            padding: EdgeInsets.all(16.0),
            children: <Widget>[
              TextFormField(
                validator: (e) {
                  if ((e as dynamic).isEmpty) {
                    return "Silahkan isi Jenis";
                  }
                },
                onSaved: (e) => jenis = e,
                decoration: InputDecoration(
                  labelText: 'Jenis Barang',
                  labelStyle: TextStyle(
                      color: myFocusNode.hasFocus
                          ? Colors.blue
                          : Color.fromARGB(255, 0, 0, 0)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 0, 145, 255)),
                    )
                  )
                ),
              SizedBox(
                height: 25
              ),
              MaterialButton(
                color: Color.fromARGB(255, 41, 141, 218),
                onPressed: () {
                  check();
                },
                child: Text(
                  "Simpan",
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ],
          ),
        ));
  }
}