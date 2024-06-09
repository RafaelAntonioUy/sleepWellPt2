import 'package:flutter/material.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    // late DatabaseHelper handler;
    // late Future<List<NoteModel>> notes;
    // final db = DatabaseHelper();

    // final title = TextEditingController();
    // final content = TextEditingController();


    // @override
    // void initState() {
    //   handler = DatabaseHelper();
    //   notes = handler.getNotes();

    //   // after database initialization, get the notes
    //   handler.initDB().whenComplete(() {
    //     notes = getAllNotes();
    //   });

    //   super.initState();
    // }


    // Future<List<NoteModel>> getAllNotes() {
    //   return handler.getNotes();
    // }


    // // executes to refresh the screen any modifiations to the notes
    // // hence, getting all the notes everytime _refresh is called
    // Future<void> _refresh() async { 
    //   setState(() {
    //     notes = getAllNotes();
    //   });
    // }

    return Scaffold(body: Center(child: Text("Statistics Page"),));
    //   body: FutureBuilder<List<NoteModel>> (
    //     // this will be the Future objects, which will be referenced to the snapshot
    //     // then, snapshot.data will hold the the notes value.
    //     future: notes,
    //     builder: (BuildContext context, AsyncSnapshot <List<NoteModel>> snapshot) {
          
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return Center(child: CircularProgressIndicator());

    //       } else if (snapshot.hasData && snapshot.data!.isEmpty){
    //         return Center(child: const Text("No Data"));

    //       } else if (snapshot.hasError) {
    //         return Center(child: Text(snapshot.error.toString()));

    //       } else {
    //         final items = snapshot.data ?? <NoteModel>[];
    //       }
    //     }
    //   )
    // );
  }
}