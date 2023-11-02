import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() => runApp(const MoneyManagerApp());

class MoneyManagerApp extends StatelessWidget {
  const MoneyManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const MoneyManagerPage(),
    );
  }
}

class MoneyManagerPage extends StatelessWidget {
  const MoneyManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: const Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Money Manager',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  Icon(Icons.search, color: Colors.white),
                ],
              ),
              SizedBox(height: 20),
              MyTabBar(),
              Expanded(child: MyTabBarView()),
              SizedBox(height: 20),
              BalanceCard(),
              SizedBox(height: 20),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class MyTabBar extends StatelessWidget {
  const MyTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabBar(
      tabs: [
        Tab(text: 'DAILY'),
        Tab(text: 'MONTHLY'),
        Tab(text: 'YEARLY'),
      ],
      indicatorColor: Colors.blue,
      unselectedLabelColor: Colors.white38,
      labelColor: Colors.white,
    );
  }
}

class MyTabBarView extends StatelessWidget {
  const MyTabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabBarView(
      children: [
        Chart(), // Contenuto per "DAILY"
        Center(
            child: Text('Contenuto per MONTHLY',
                style: TextStyle(color: Colors.white))),
        Center(
            child: Text('Contenuto per YEARLY',
                style: TextStyle(color: Colors.white))),
      ],
    );
  }
}

class Chart extends StatelessWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 250),
      child: Column(
        children: [
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(
                  show: false,
                ),
                titlesData: const FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: getTitles,
                    ),
                  ),
                  leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 60,
                    interval: 500,
                    getTitlesWidget: getYTitles,
                  )),
                ),
                borderData: FlBorderData(
                  show: false,
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 3500,
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 1000),
                      const FlSpot(1, 2300),
                      const FlSpot(2, 1500),
                      const FlSpot(3, 2500),
                      const FlSpot(4, 3000),
                      const FlSpot(5, 3200),
                      const FlSpot(6, 2800),
                    ],
                    isCurved: true,
                    color: Colors.green,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.green.withOpacity(0.3),
                    ),
                  ),
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 800),
                      const FlSpot(1, 2100),
                      const FlSpot(2, 1300),
                      const FlSpot(3, 2200),
                      const FlSpot(4, 2700),
                      const FlSpot(5, 2900),
                      const FlSpot(6, 2500),
                    ],
                    isCurved: true,
                    color: Colors.red,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.red.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(20),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Balance:', style: TextStyle(color: Colors.white, fontSize: 16)),
          Row(
            children: [
              Text('₹14,700',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
            ],
          ),
        ],
      ),
    );
  }
}

Widget getTitles(double value, TitleMeta meta) {
  final daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  String day = (value >= 0 && value < daysOfWeek.length)
      ? daysOfWeek[value.toInt()]
      : '';

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: Text(
      day,
      style: const TextStyle(color: Colors.grey, fontSize: 16),
    ),
  );
}

Widget getYTitles(double value, TitleMeta meta) {
  final euroAmounts = [
    '€0',
    '€500',
    '€1000',
    '€1500',
    '€2000',
    '€2500',
    '€3000',
    '€3500'
  ];

  int index = (value / 500).toInt();

  String amount =
      (index >= 0 && index < euroAmounts.length) ? euroAmounts[index] : '';

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: Text(
      amount,
      style: const TextStyle(color: Colors.white, fontSize: 16),
    ),
  );
}
