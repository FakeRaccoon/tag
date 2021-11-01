import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tag/Models/log-model.dart';
import 'package:tag/api-service.dart';

class LogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Log',
          style: GoogleFonts.sourceSansPro(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder(
        future: APIService().getLog(),
        builder: (BuildContext context, AsyncSnapshot<LogModel> snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data!.data!.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(snapshot.data!.data![index].log!),
              ),
              separatorBuilder: (BuildContext context, int index) => Divider(thickness: 1),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
