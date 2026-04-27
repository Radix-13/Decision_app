import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DecisionApp(),
  ));
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
    int totalPros = pros.fold(0, (s, i) => s + i.weight);
    int totalCons = cons.fold(0, (s, i) => s + i.weight);

    if (totalPros + totalCons == 0) return 0;
    return (totalPros / (totalPros + totalCons)) * 100;
  }

  Color get scoreColor {
    if (score >= 70) return Colors.green;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }

  Color get bgColor {
    if (score >= 70) return Colors.green.shade50;
    if (score >= 40) return Colors.orange.shade50;
    return Colors.red.shade50;
  }

  void setTitle() {
    setState(() => decisionTitle = titleController.text);
  }

  void addPro() {
    if (proController.text.isEmpty) return;
    setState(() {
      pros.add(DecisionItem(text: proController.text, weight: 5));
      proController.clear();
    });
  }

  void addCon() {
    if (conController.text.isEmpty) return;
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
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text("Decision Maker"),
        centerTitle: true,
        backgroundColor: scoreColor,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),

          // TITLE INPUT
          Padding(
            padding: const EdgeInsets.all(12),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: "What is your decision?",
                        border: InputBorder.none,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: setTitle,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: scoreColor,
                        ),
                        child: Text("Set"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          if (decisionTitle.isNotEmpty)
            Text(
              decisionTitle,
              style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

          SizedBox(height: 10),

          // SCORE
          CircularPercentIndicator(
            radius: 100,
            lineWidth: 12,
            percent: score / 100,
            animation: true,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${score.toStringAsFixed(1)}%",
                  style:
                      TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                Text("Decision Score"),
              ],
            ),
            progressColor: scoreColor,
            backgroundColor: Colors.grey.shade300,
            circularStrokeCap: CircularStrokeCap.round,
          ),

          SizedBox(height: 10),

          // INPUTS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                _inputBox(proController, "Add Pro", Colors.green,
                    Icons.add, addPro),
                SizedBox(height: 10),
                _inputBox(conController, "Add Con", Colors.red,
                    Icons.remove, addCon),
              ],
            ),
          ),

          SizedBox(height: 10),

          // LISTS
          Expanded(
            child: Row(
              children: [
                _buildList("Pros", pros, Colors.green, removePro),
                _buildList("Cons", cons, Colors.red, removeCon),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputBox(TextEditingController controller, String hint,
      Color color, IconData icon, VoidCallback onTap) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(icon, color: color),
            onPressed: onTap,
          )
        ],
      ),
    );
  }

  Widget _buildList(String title, List<DecisionItem> items,
      Color color, Function(int) removeFn) {
    return Expanded(
      child: Column(
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color)),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  margin:
                      EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(items[index].text),
                        subtitle:
                            Text("Weight: ${items[index].weight}"),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => removeFn(index),
                        ),
                      ),
                      Slider(
                        min: 1,
                        max: 10,
                        divisions: 9,
                        value: items[index].weight.toDouble(),
                        onChanged: (value) {
                          setState(() {
                            items[index].weight = value.toInt();
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
    );
  }
}