import 'package:app_inventori/Loading.dart';
import 'package:app_inventori/view/jenis/EditJenis.dart';
import 'package:app_inventori/view/jenis/TambahJenis.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:app_inventori/model/jenisModel.dart';
import 'package:app_inventori/model/api.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

class DataJenis extends StatefulWidget {
  @override
  State<DataJenis> createState() => _DataJenisState();
}

class _DataJenisState extends State<DataJenis> {
  var loading = false;
  final list = [];
  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();

  getPref() async {
    _lihatData();
  }

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final respons = await http.get(Uri.parse(BaseUrl.urlDataJenis));
    if (respons.contentLength == 2) {
    } else {
      final data = jsonDecode(respons.body);
      data.forEach((api) {
        final ab = new JenisModel(api['id_jenis'], api['nama_jenis']);
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  ProsesHapus(String id) async {
    final response = await http
        .post(Uri.parse(BaseUrl.urlHapusJenis), body: {"id_jenis": id});
    final data = jsonDecode(response.body);
    int value = data['success'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        _lihatData();
      });
    } else {
      print(pesan);
      dialogHapus(pesan);
    }
  }
 
  dialogHapus(String pesan) {
    AwesomeDialog(
      context: context,
      dismissOnTouchOutside: false,
      dialogType: DialogType.error,
      animType: AnimType.topSlide,
      headerAnimationLoop: false,
      title: 'EROR!!!',
      desc: pesan,
      btnOkOnPress: () {},
      btnOkIcon: Icons.cancel,
      btnOkColor: Colors.blue,
    ).show();
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 0, 145, 255),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                "Data Jenis Barang",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Print("tambah Jenis");
          Navigator.push(context, 
          MaterialPageRoute(
            builder: ((context) => TambahJenis(_lihatData))));
        },
        child:  Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 0, 145, 255),
      ),
      body: RefreshIndicator(
        onRefresh: _lihatData,
        key: _refresh,
        child: loading
            ? Center( child: CircularProgressIndicator(),
            )
            : ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, i) {
                final x = list[i];
                return Container(
                  margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: Card(
                    color: Color.fromARGB(255, 255, 255, 255),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            x.nama_jenis.toString(),
                          ),
                          trailing: Wrap(
                            children: [
                              IconButton(
                                onPressed: (){
                                  // edit
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => EditJenis(x, _lihatData)));
                                }, 
                                icon: Icon(Icons.edit)),
                              IconButton(
                                onPressed: () {
                                 // delete
                                 ProsesHapus(x.id_jenis);
                                }, 
                                icon: Icon(Icons.delete)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )),
    );
  }
}