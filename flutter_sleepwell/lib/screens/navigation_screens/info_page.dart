import 'package:flutter/material.dart';
import 'package:flutter_login/JsonModels/sleeping_factor.dart';
import 'package:flutter_login/JsonModels/users_sleeping_factor.dart';
import 'package:flutter_login/SQLite/sqlite_sleep_facors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  late DatabaseHelperSleepFactors handler;
  late Future<List<SleepingFactor>> selectedFactorItems;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHelperSleepFactors();
    selectedFactorItems = Future.value([]); // Initialize with an empty future
    loadUserCheckedFactors();
  }

  Future<void> loadUserCheckedFactors() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? savedChosenID = prefs.getInt('chosenID');

    if (savedChosenID != null) {
      int chosenID = savedChosenID;

      // Load user's checked factors from the database
      final List<SleepingFactor> factors = await handler.readUserCheckedFactors(chosenID);
      setState(() {
        selectedFactorItems = Future.value(factors); // Update the future with the loaded data
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Expanded(
            child: FutureBuilder<List<SleepingFactor>>(
              future: selectedFactorItems,
              builder: (BuildContext context, AsyncSnapshot<List<SleepingFactor>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No Data"));
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  final items = snapshot.data ?? <SleepingFactor>[];
                  
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final solutions = items[index].solution.split('.').where((s) => s.trim().isNotEmpty).toList();
                      
                      return Padding(
                        padding: EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                          top: index == 0 ? 16.0 : 8.0, // Top margin for the first item
                          bottom: index == items.length - 1 ? 16.0 : 8.0, // Bottom margin for the last item
                        ),
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    items[index].name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0,
                                    )
                                  ),
                                  Icon(Icons.lightbulb),
                                ],
                              ),

                              SizedBox(height: 10),

                              Text('Causes:', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(items[index].causes, style: TextStyle(fontSize: 14.0)),

                              SizedBox(height: 10),

                              Text('Solution:', style: TextStyle(fontWeight: FontWeight.bold)),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: solutions.length,
                                itemBuilder: (context, solIndex) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('\u2022 ', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                                        Expanded(child: Text(solutions[solIndex].trim(), style: TextStyle(fontSize: 14.0))),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],

                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          loadUserCheckedFactors();
        },
        child: Icon(Icons.refresh),
        tooltip: 'Refresh',
        backgroundColor: Colors.blue[300],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
