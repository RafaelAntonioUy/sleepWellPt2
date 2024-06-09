import 'package:flutter/material.dart';
import 'package:flutter_login/JsonModels/sleeping_factor.dart';
import 'package:flutter_login/JsonModels/users_sleeping_factor.dart';
import 'package:flutter_login/SQLite/sqlite_sleep_facors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FactorsPage extends StatefulWidget {
  const FactorsPage({Key? key}) : super(key: key);

  @override
  State<FactorsPage> createState() => _FactorsPageState();
}

class _FactorsPageState extends State<FactorsPage> {
  late DatabaseHelperSleepFactors handler;
  late Future<List<SleepingFactor>> factorItems;
  late List<bool> checkedFactors = [];

  int chosenID = 0;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHelperSleepFactors();
    factorItems = handler.readFactors();
    // Load user's checked factors
    loadUserCheckedFactors();
  }

  

  Future<void> loadUserCheckedFactors() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? savedChosenID = prefs.getInt('chosenID');

    if (savedChosenID != null) {
      chosenID = savedChosenID;

      // Load user's checked factors from the database
      final List<UserSleepingFactor> userFactors = await handler.readUserFactors(chosenID);

      // Initialize the list of checked factors with false for each factor
      final factors = await factorItems;
      checkedFactors = List.filled(factors.length, false);

      // Mark factors as checked if they exist in userFactors
      for (var factor in userFactors) {
        if (factor.factorID > 0 && factor.factorID <= factors.length) {
          checkedFactors[factor.factorID - 1] = true; // -1 because factorID starts from 1 but list index starts from 0
        }
      }
      // Update UI with the loaded checked factors
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(),
      body: FutureBuilder<List<SleepingFactor>>(
        future: factorItems,
        builder: (BuildContext context, AsyncSnapshot<List<SleepingFactor>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No Data"));
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            final items = snapshot.data!;
            if (checkedFactors.isEmpty) {
              checkedFactors = List.filled(items.length, false);
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final factor = items[index];
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      gradient: LinearGradient(
                        colors: [Colors.blue[200]!, Colors.blue[400]!], // Define your gradient colors
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.2, 0.8], 
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.only(left: 30.0, right: 20.0),
                      leading: Checkbox(
                        value: checkedFactors[index],
                        activeColor: Colors.blue, // Set the active color to blue
                        onChanged: (bool? value) {
                          setState(() {
                            checkedFactors[index] = value!;
                            updateUserFactor(chosenID, factor.factorID!, value);
                          });
                        },
                      ),
                      title: Text(factor.name),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  AppBar buildAppbar() {
    return AppBar(
      title: Text(
        "Sleeping Factors",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.blue[300],
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.check),
        ),
      ],
    );
  }

  Future<void> updateUserFactor(int userID, int factorID, bool checked) async {
    if (checked) {
      // If the factor is checked, insert it into the database
      await handler.createUserFactor(UserSleepingFactor(userID: userID, factorID: factorID));
    } else {
      // If the factor is unchecked, delete it from the database
      await handler.deleteUserFactor(UserSleepingFactor(userID: userID, factorID: factorID));
    }
  }
}
