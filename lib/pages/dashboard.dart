import 'package:flutter/material.dart';
import 'package:fx_analysis/custom_widgets/info_card.dart';

class Dashboard extends StatefulWidget {
  final String userDocument;

  const Dashboard({
    super.key,
    required this.userDocument,
  });

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          // First Row of Cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InfoCard(title:'Total accounts', value: '5', textColor: Colors.white),
              InfoCard(title:'Total Balance', value:'\$150k', textColor: Colors.white),
              InfoCard(title:'Liquid', value:'\$75,000', textColor: Colors.white),
              InfoCard(title:'Unrealised gain', value: '-50%', textColor: Colors.yellow),
              InfoCard(title:'Monthly return', value: '8.5%', textColor: Colors.green),
            ],
          ),
          SizedBox(height: 20),
          // Second Row of Cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InfoCard(title:'Total deposit', value: '\$100k', textColor: Colors.white),
              InfoCard(title:'Total profit', value: '\$50,000', textColor: Colors.white),
              InfoCard(title:'Performance fee', value: '25%', textColor: Colors.white),
              InfoCard(title:'Manager\'s profit', value: '\$12,500', textColor: Colors.white),
              InfoCard(title:'Total withdrawal', value:'\$5,000', textColor: Colors.white),
            ],
          ),
        ],
      ),
    );
  }
}
