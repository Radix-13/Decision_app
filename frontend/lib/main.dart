import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

void main() {
  runApp(MaterialApp(home: DecisionApp()));
}

class DecisionItem {
  String text;
  int weight;

  DecisionItem({required this.text, required this.weight});
}

class DecisionApp extends StatefulWidget {
  @override
  State<DecisionApp> createState() => _DecisionAppState();
}

class _DecisionAppState extends State<DecisionApp> {
  String decisionTitle = "";

  List<DecisionItem> pros = [];
  List<DecisionItem> cons = [];

  final TextEditingController titleController = TextEditingController();
  final TextEditingController proController = TextEditingController();
  final TextEditingController conController = TextEditingController();

  double get score {
    int totalPros = pros.fold(0, (sum, item) => sum + item.weight);
    int totalCons = cons.fold(0, (sum, item) => sum + item.weight);

    if (totalPros + totalCons == 0) return 0;

    return (totalPros / (totalPros + totalCons)) * 100;
  }

  Color get scoreColor {
    if (score >= 70) return Colors.green;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }

  void setTitle() {
    setState(() {
      decisionTitle = titleController.text;
    });
  }

  void addPro() {
    if (proController.text.trim().isEmpty) return;

    setState(() {
      pros.add(DecisionItem(text: proController.text, weight: 5));
      proController.clear();
    });
  }

  void addCon() {
    if (conController.text.trim().isEmpty) return;

    setState(() {
      cons.add(DecisionItem(text: conController.text, weight: 5));
      conController.clear();
    });
  }

  void removePro(int index) {
    setState(() => pros.removeAt(index));
  }

  void removeCon(int index) {
    setState(() => cons.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Decision App"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),

          // 📝 DECISION TITLE INPUT
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: "Enter your decision (e.g. Change job?)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: setTitle,
                  child: Text("Set"),
                )
              ],
            ),
          ),

          // DISPLAY TITLE
          if (decisionTitle.isNotEmpty)
            Text(
              decisionTitle,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

          SizedBox(height: 10),

          // 🎯 CIRCLE SCORE
          CircularPercentIndicator(
            radius: 110,
            lineWidth: 12,
            percent: score / 100,
            animation: true,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${score.toStringAsFixed(1)}%",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                Text("Decision Score"),
              ],
            ),
            progressColor: scoreColor,
            backgroundColor: Colors.grey.shade300,
            circularStrokeCap: CircularStrokeCap.round,
          ),

          SizedBox(height: 10),

          // INPUT PRO/CON
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: proController,
                        decoration: InputDecoration(
                          hintText: "Add Pro",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: addPro,
                      child: Text("Add"),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: conController,
                        decoration: InputDecoration(
                          hintText: "Add Con",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: addCon,
                      child: Text("Add"),
                    )
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 10),

          // LISTS
          Expanded(
            child: Row(
              children: [
                // PROS
                Expanded(
                  child: Column(
                    children: [
                      Text("Pros",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green)),
                      Expanded(
                        child: ListView.builder(
                          itemCount: pros.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(pros[index].text),
                                    subtitle:
                                        Text("Weight: ${pros[index].weight}"),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () => removePro(index),
                                    ),
                                  ),
                                  Slider(
                                    min: 1,
                                    max: 10,
                                    divisions: 9,
                                    value: pros[index].weight.toDouble(),
                                    onChanged: (value) {
                                      setState(() {
                                        pros[index].weight = value.toInt();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // CONS
                Expanded(
                  child: Column(
                    children: [
                      Text("Cons",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red)),
                      Expanded(
                        child: ListView.builder(
                          itemCount: cons.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(cons[index].text),
                                    subtitle:
                                        Text("Weight: ${cons[index].weight}"),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () => removeCon(index),
                                    ),
                                  ),
                                  Slider(
                                    min: 1,
                                    max: 10,
                                    divisions: 9,
                                    value: cons[index].weight.toDouble(),
                                    onChanged: (value) {
                                      setState(() {
                                        cons[index].weight = value.toInt();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}