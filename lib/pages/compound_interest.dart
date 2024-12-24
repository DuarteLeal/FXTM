import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Compound Interest Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: CompoundInterestCalculator(),
      ),
    );
  }
}

class CompoundInterestCalculator extends StatefulWidget {
  const CompoundInterestCalculator({super.key});

  @override
  _CompoundInterestCalculatorState createState() =>
      _CompoundInterestCalculatorState();
}

class _CompoundInterestCalculatorState
    extends State<CompoundInterestCalculator> {
  final TextEditingController initialInvestmentController =
      TextEditingController(text: '5000');
  final TextEditingController interestRateController =
      TextEditingController(text: '5');
  final TextEditingController additionalDepositController =
      TextEditingController(text: '300');
  final TextEditingController yearsController =
      TextEditingController(text: '1');
  final TextEditingController monthsController =
      TextEditingController(text: '0');

  String compoundFrequency = 'Monthly';
  String depositFrequency = 'Monthly';
  final List<String> frequencies = ['Daily', 'Weekly', 'Monthly', 'Annually'];

  double totalDeposited = 0.0;
  double totalInterestEarned = 0.0;
  double totalBalance = 0.0;
  List<Map<String, dynamic>> tableData = [];

  void calculate() {
    final double initialInvestment =
        double.tryParse(initialInvestmentController.text) ?? 0.0;
    final double annualInterestRate =
        double.tryParse(interestRateController.text) ?? 0.0;
    final double additionalDeposit =
        double.tryParse(additionalDepositController.text) ?? 0.0;
    final int years = int.tryParse(yearsController.text) ?? 0;
    final int months = int.tryParse(monthsController.text) ?? 0;

    // Determine the total number of periods in months
    final int totalMonths = (years * 12) + months;
    if (totalMonths == 0) return;

    double currentBalance = initialInvestment;
    totalDeposited = initialInvestment;
    totalInterestEarned = 0.0;

    tableData = [];

    for (int month = 1; month <= totalMonths; month++) {
      double monthlyInterestEarned = 0.0;

      // Apply interest based on compound frequency
      if (compoundFrequency == 'Daily') {
        for (int day = 1; day <= 30; day++) {
          double dailyInterest = currentBalance * (annualInterestRate / 100);
          monthlyInterestEarned += dailyInterest;
          currentBalance += dailyInterest;
        }
      } else if (compoundFrequency == 'Weekly') {
        for (int week = 1; week <= 4; week++) {
          double weeklyInterest = currentBalance * (annualInterestRate / 100);
          monthlyInterestEarned += weeklyInterest;
          currentBalance += weeklyInterest;
        }
      } else if (compoundFrequency == 'Monthly') {
        double monthlyInterest = currentBalance * (annualInterestRate / 100);
        monthlyInterestEarned += monthlyInterest;
        currentBalance += monthlyInterest;
      } else if (compoundFrequency == 'Annually' && month % 12 == 0) {
        double annualInterest = currentBalance * (annualInterestRate / 100);
        monthlyInterestEarned += annualInterest;
        currentBalance += annualInterest;
      }

      totalInterestEarned += monthlyInterestEarned;

      // Add deposits based on deposit frequency
      if (depositFrequency == 'Daily') {
        currentBalance += additionalDeposit * 30; // 30 days in a month
        totalDeposited += additionalDeposit * 30;
      } else if (depositFrequency == 'Weekly') {
        currentBalance += additionalDeposit * 4; // 4 weeks in a month
        totalDeposited += additionalDeposit * 4;
      } else if (depositFrequency == 'Monthly') {
        currentBalance += additionalDeposit;
        totalDeposited += additionalDeposit;
      } else if (depositFrequency == 'Annually' && month % 12 == 0) {
        currentBalance += additionalDeposit;
        totalDeposited += additionalDeposit;
      }

      // Add data to the table
      tableData.add({
        "Period": month,
        "Deposits": (depositFrequency == 'Daily')
            ? additionalDeposit * 30
            : (depositFrequency == 'Weekly')
                ? additionalDeposit * 4
                : (depositFrequency == 'Monthly')
                    ? additionalDeposit
                    : (depositFrequency == 'Annually' && month % 12 == 0)
                        ? additionalDeposit
                        : 0.0,
        "Interest": monthlyInterestEarned,
        "Total Deposits": totalDeposited,
        "Accrued Interest": totalInterestEarned,
        "Balance": currentBalance,
      });
    }

    totalBalance = currentBalance;

    // Update the state to reflect the changes
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.fromLTRB(48, 16, 48, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Formulário à esquerda
          SizedBox(
            width: size.width * 0.4, // 40% da largura da tela
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Initial investment:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: initialInvestmentController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Interest rate (%):',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: interestRateController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Compound frequency:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          DropdownButton<String>(
                            value: compoundFrequency,
                            onChanged: (String? newValue) {
                              setState(() {
                                compoundFrequency = newValue!;
                              });
                            },
                            items: frequencies
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            isExpanded: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Additional deposit:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: additionalDepositController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Deposit frequency:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          DropdownButton<String>(
                            value: depositFrequency,
                            onChanged: (String? newValue) {
                              setState(() {
                                depositFrequency = newValue!;
                              });
                            },
                            items: frequencies
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            isExpanded: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Years:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: yearsController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Months:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: monthsController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: calculate,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Calculate'),
                ),
                const SizedBox(height: 16),
                // Resumo
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey.shade200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Deposited: \$${totalDeposited.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Total Interest Earned: \$${totalInterestEarned.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Total Balance: \$${totalBalance.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Tabela com scroll separado à direita
          SizedBox(width: 24),
          Expanded(
            child: SizedBox(
              height: size.height, // Ocupa toda a altura disponível
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Month')),
                    DataColumn(label: Text('Deposits')),
                    DataColumn(label: Text('Interest')),
                    DataColumn(label: Text('Total Deposits')),
                    DataColumn(label: Text('Accrued Interest')),
                    DataColumn(label: Text('Balance')),
                  ],
                  rows: tableData
                      .map(
                        (row) => DataRow(cells: [
                          DataCell(Text(row['Period'].toString())),
                          DataCell(Text('\$${row['Deposits'].toStringAsFixed(2)}')),
                          DataCell(Text('\$${row['Interest'].toStringAsFixed(2)}')),
                          DataCell(Text(
                              '\$${row['Total Deposits'].toStringAsFixed(2)}')),
                          DataCell(Text(
                              '\$${row['Accrued Interest'].toStringAsFixed(2)}')),
                          DataCell(
                              Text('\$${row['Balance'].toStringAsFixed(2)}')),
                        ]),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
