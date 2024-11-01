import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ikasoweb/Admin/view/dashboard/header.dart';
import 'package:ikasoweb/models/user_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int totalHebergements = 0;
  int totalReservations = 0;
  int totalHotes = 0;
  int totalClients = 0;
  List<Transaction> transactions = [];
  List<UserModel> recentUsers = [];

  @override
  void initState() {
    super.initState();
    getStatistics();
    loadTransactions();
    loadRecentUsers();
  }

  Future<void> getStatistics() async {
    try {
      final hebergementsSnapshot =
          await FirebaseFirestore.instance.collection('hebergements').get();
      final reservationsSnapshot =
          await FirebaseFirestore.instance.collection('reservations').get();
      final usersSnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      setState(() {
        totalHebergements = hebergementsSnapshot.docs.length;
        totalReservations = reservationsSnapshot.docs.length;
        totalHotes = usersSnapshot.docs.where((user) {
          final data = user.data() as Map<String, dynamic>;
          return data['isHost'] == true;
        }).length;
        totalClients = usersSnapshot.docs.length - totalHotes;
      });
    } catch (e) {
      print('Error fetching statistics: $e');
    }
  }

  Future<void> loadTransactions() async {
    final transactionsSnapshot =
        await FirebaseFirestore.instance.collection('transactions').get();

    setState(() {
      transactions = transactionsSnapshot.docs.map((doc) {
        return Transaction.fromFirestore(doc);
      }).toList();
    });
  }

  Future<void> loadRecentUsers() async {
    final usersSnapshot =
        await FirebaseFirestore.instance.collection('users').limit(4).get();

    setState(() {
      recentUsers = usersSnapshot.docs.map((doc) {
        return UserModel.fromSnapshot(doc);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace:
            Header(), // Testez avec flexibleSpace au lieu de PreferredSize
        toolbarHeight: 80.0, // Ajustez la hauteur de la barre d'outils
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard('Total Hébergements', totalHebergements,
                      Icons.home, Colors.blue),
                  _buildStatCard('Total Reservations', totalReservations,
                      Icons.bookmark, Colors.purple),
                  _buildStatCard('Nombre Total d’Hôtes', totalHotes,
                      Icons.people, Colors.orange),
                  _buildStatCard('Total Clients', totalClients, Icons.person,
                      Colors.green),
                ],
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Sales Report'),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildSalesReportHeader(),
                      SizedBox(
                        height: 200,
                        child: _buildSalesLineChart(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildTransactionsSection()),
                  const SizedBox(width: 10),
                  Expanded(child: _buildRecentUsersSection()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, int count, IconData icon, Color color) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.2),
                child: Icon(icon, color: color, size: 28),
                radius: 24,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(count.toString(),
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSalesReportHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Sales Report',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Row(
          children: [
            TextButton(onPressed: () {}, child: const Text('12 Months')),
            TextButton(onPressed: () {}, child: const Text('6 Months')),
            TextButton(onPressed: () {}, child: const Text('30 Days')),
            TextButton(onPressed: () {}, child: const Text('7 Days')),
          ],
        ),
      ],
    );
  }

  Widget _buildSalesLineChart() {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      series: <ChartSeries>[
        LineSeries<SalesData, String>(
          dataSource: _createSalesData(),
          xValueMapper: (SalesData data, _) => data.month,
          yValueMapper: (SalesData data, _) => data.sales,
          color: Colors.blueAccent,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }

  List<SalesData> _createSalesData() {
    return [
      SalesData('Jan', 10000),
      SalesData('Feb', 15000),
      SalesData('Mar', 25000),
      SalesData('Apr', 20000),
      SalesData('May', 30000),
      SalesData('Jun', 45000),
      SalesData('Jul', 40000),
      SalesData('Aug', 35000),
      SalesData('Sep', 45000),
      SalesData('Oct', 50000),
      SalesData('Nov', 60000),
      SalesData('Dec', 70000),
    ];
  }

  Widget _buildTransactionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Transactions'),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: transactions.map((transaction) {
                return ListTile(
                  leading: const Icon(Icons.payment, color: Colors.green),
                  title: Text(transaction.method),
                  subtitle: Text('${transaction.date}'),
                  trailing: Text(
                      '${transaction.amount} ${transaction.currency}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentUsersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Utilisateurs Récents'),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: recentUsers.map((user) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent.withOpacity(0.2),
                    child: const Icon(Icons.person, color: Colors.blueAccent),
                  ),
                  title: Text('${user.firstName} ${user.lastName}'),
                  subtitle: Text(user.email ?? ''),
                  trailing: Text(user.city ?? '',
                      style: const TextStyle(color: Colors.grey)),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class Transaction {
  final String method;
  final String date;
  final double amount;
  final String currency;

  Transaction(
      {required this.method,
      required this.date,
      required this.amount,
      required this.currency});

  static Transaction fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Transaction(
      method: data['method'] ?? '',
      date: data['date'] ?? '',
      amount: (data['amount'] as num).toDouble(),
      currency: data['currency'] ?? '',
    );
  }
}

class SalesData {
  final String month;
  final double sales;

  SalesData(this.month, this.sales);
}
