import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

void main() => runApp(MaterialApp(home: Scaffold(body: CompoundInterestCalculator())));

class CompoundInterestCalculator extends StatefulWidget {
  const CompoundInterestCalculator({super.key});

  @override
  _CompoundInterestCalculatorState createState() => _CompoundInterestCalculatorState();
}

class _CompoundInterestCalculatorState extends State<CompoundInterestCalculator> {
  double initialDeposit = 5000;
  double contributionAmount = 250;
  int investmentTimespan = 5;
  double estimatedReturn = 5;
  String compoundPeriod = "12"; // Monthly
  String contributionFrequency = "monthly"; // Default frequency
  String returnFrequency = "annually"; // Default return frequency

  List<BarChartGroupData> chartData = [];

  late double totalContributions;
  late double totalInterest;

  @override
  void initState() {
    super.initState();
    updateChartData();
  }

  void updateChartData() {
    double P = initialDeposit; // Principal
    double r = estimatedReturn / 100; // Return rate as a fraction
    double c = contributionAmount; // Contribution Amount
    int n = getFrequencyValue(returnFrequency); // Return frequency
    int t = investmentTimespan; // Investment Timespan

    int n2 = getFrequencyValue(contributionFrequency); // Contribution frequency

    double contributionsAccumulated = 0; // Tracks total contributions excluding initial deposit
    double interestAccumulated = 0;

    List<BarChartGroupData> updatedData = [];

    for (int i = 1; i <= t * n; i++) {
      // Apply periodic return directly based on selected frequency
      double interest = P * r;
      P += interest;
      interestAccumulated += interest;

      // Apply contributions
      if (i % (n ~/ n2) == 0) {
        P += c;
        contributionsAccumulated += c;
      }

      if (i % n == 0) {
        updatedData.add(BarChartGroupData(x: i ~/ n, barRods: [
          BarChartRodData(toY: P, color: Colors.blue),
        ]));
      }
    }

    setState(() {
      chartData = updatedData;
      totalContributions = contributionsAccumulated + initialDeposit; // Include initial deposit
      totalInterest = interestAccumulated;
    });
  }
  int getFrequencyValue(String frequency) {
    switch (frequency) {
      case "daily":
        return 365;
      case "weekly":
        return 52;
      case "monthly":
        return 12;
      case "semiannually":
        return 2;
      case "annually":
        return 1;
      default:
        return 12;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Em desenvolvimento", style: TextStyle(fontSize: 20),),
                SizedBox(height: 20),
                Row(
                  children: [
                    TextButton(onPressed: () { setState(() { initialDeposit = (initialDeposit - 100).clamp(0, double.infinity); updateChartData(); }); }, child: Text("-")),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Initial Deposit (\$)",
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        ),
                        keyboardType: TextInputType.number,
                        controller: TextEditingController(text: "\$${initialDeposit.toInt()}"),
                        readOnly: true,
                      ),
                    ),
                    TextButton(onPressed: () { setState(() { initialDeposit += 100; updateChartData(); }); }, child: Text("+")),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    TextButton(onPressed: () { setState(() { contributionAmount = (contributionAmount - 100).clamp(0, double.infinity); updateChartData(); }); }, child: Text("-")),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Contributions (\$)",
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        ),
                        keyboardType: TextInputType.number,
                        controller: TextEditingController(text: "\$${contributionAmount.toInt()}"),
                        onChanged: (value) {
                          setState(() {
                            contributionAmount = double.tryParse(value.replaceAll("\$", "")) ?? contributionAmount;
                            updateChartData();
                          });
                        },
                      ),
                    ),
                    TextButton(onPressed: () { setState(() { contributionAmount = (contributionAmount + 100).clamp(0, double.infinity); updateChartData(); }); }, child: Text("+")),
                    DropdownButton<String>(
                      value: contributionFrequency,
                      items: const [
                        DropdownMenuItem(value: "daily", child: Text("Daily")),
                        DropdownMenuItem(value: "weekly", child: Text("Weekly")),
                        DropdownMenuItem(value: "monthly", child: Text("Monthly")),
                        DropdownMenuItem(value: "semiannually", child: Text("Semiannually")),
                        DropdownMenuItem(value: "annually", child: Text("Annually")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          contributionFrequency = value!;
                          updateChartData();
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    TextButton(onPressed: () { setState(() { estimatedReturn = (estimatedReturn - 0.5).clamp(0, double.infinity); updateChartData(); }); }, child: Text("-")),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Estimated Rate of Return (%)",
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        ),
                        keyboardType: TextInputType.number,
                        controller: TextEditingController(text: "${estimatedReturn.toStringAsFixed(1)}%"),
                        readOnly: true,
                      ),
                    ),
                    TextButton(onPressed: () { setState(() { estimatedReturn += 0.5; updateChartData(); }); }, child: Text("+")),
                    DropdownButton<String>(
                      value: returnFrequency,
                      items: const [
                        DropdownMenuItem(value: "daily", child: Text("Daily")),
                        DropdownMenuItem(value: "weekly", child: Text("Weekly")),
                        DropdownMenuItem(value: "monthly", child: Text("Monthly")),
                        DropdownMenuItem(value: "semiannually", child: Text("Semiannually")),
                        DropdownMenuItem(value: "annually", child: Text("Annually")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          returnFrequency = value!;
                          updateChartData();
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    SizedBox(
                      width: 300,
                      child: Slider(
                        value: investmentTimespan.toDouble(),
                        min: 1,
                        max: 30,
                        divisions: 29,
                        label: "$investmentTimespan years",
                        onChanged: (value) {
                          setState(() {
                            investmentTimespan = value.toInt();
                            updateChartData();
                          });
                        },
                      ),
                    ),
                    Text("$investmentTimespan years"),
                  ],
                ),
                SizedBox(height: 16),
                Text("Compound Frequency:"),
                Row(
                  children: [
                    Radio<String>(
                      value: "365",
                      groupValue: compoundPeriod,
                      onChanged: (value) {
                        setState(() {
                          compoundPeriod = value!;
                          updateChartData();
                        });
                      },
                    ),
                    Text("Daily"),
                    Radio<String>(
                      value: "12",
                      groupValue: compoundPeriod,
                      onChanged: (value) {
                        setState(() {
                          compoundPeriod = value!;
                          updateChartData();
                        });
                      },
                    ),
                    Text("Monthly"),
                    Radio<String>(
                      value: "1",
                      groupValue: compoundPeriod,
                      onChanged: (value) {
                        setState(() {
                          compoundPeriod = value!;
                          updateChartData();
                        });
                      },
                    ),
                    Text("Annually"),
                  ],
                ),
                SizedBox(height: 16),
                Text("Future Balance: \$${chartData.isNotEmpty ? chartData.last.barRods.map((e) => e.toY).reduce((a, b) => a + b).toStringAsFixed(2) : "0"}"),
                Text("Total Contributions: \$${totalContributions.toStringAsFixed(2)}"),
                Text("Total Interest: \$${totalInterest.toStringAsFixed(2)}"),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  barGroups: chartData,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) => Text("\$${value.toInt()}", style: TextStyle(fontSize: 10)),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) => Text("Year ${(value).toInt()}", style: TextStyle(fontSize: 10)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
