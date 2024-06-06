/*
import 'package:flutter/material.dart';
import 'package:flutter_login/JsonModels/sleeping_factor.dart';
import 'package:flutter_login/SQLite/sqlite_sleep_facors.dart';

class UserFactorsPage extends StatelessWidget {
  final int userID;
  final DatabaseHelperSleepFactors dbHelper = DatabaseHelperSleepFactors.instance;

  UserFactorsPage({required this.userID});

  Future<List<SleepingFactor>> _getUserFactors() async {
    return await dbHelper.readUserCheckedFactors(userID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Factors'),
      ),
      body: FutureBuilder<List<SleepingFactor>>(
        future: _getUserFactors(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No factors found.'));
          } else {
            final factors = snapshot.data!;
            return ListView.builder(
              itemCount: factors.length,
              itemBuilder: (context, index) {
                final factor = factors[index];
                return ListTile(
                  title: Text(factor.name),
                  subtitle: Text('Causes: ${factor.causes}\nSolution: ${factor.solution}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
*/