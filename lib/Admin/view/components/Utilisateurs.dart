import 'package:flutter/material.dart';
import 'package:ikasoweb/Admin/view/dashboard/header.dart';
import 'package:ikasoweb/view_models/user_view_model.dart';
import 'package:provider/provider.dart';

class ListesUtilisateursScreen extends StatefulWidget {
  @override
  _ListesUtilisateursScreenState createState() =>
      _ListesUtilisateursScreenState();
}

class _ListesUtilisateursScreenState extends State<ListesUtilisateursScreen> {
  String _searchQuery = '';
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserViewModel>(context, listen: false).fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 231, 231),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Header()],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<UserViewModel>(
        builder: (context, userViewModel, child) {
          if (userViewModel.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (userViewModel.error != null) {
            return Center(child: Text(userViewModel.error!));
          } else if (userViewModel.users.isEmpty) {
            return Center(child: Text('Aucun utilisateur trouvé'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildStats(userViewModel),
                  SizedBox(height: 20),
                  _buildSearchSortAndTable(userViewModel),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildSearchSortAndTable(UserViewModel userViewModel) {
    final filteredUsers = userViewModel.users
        .where((user) =>
            (user.firstName?.toLowerCase() ?? '')
                .contains(_searchQuery.toLowerCase()) ||
            (user.lastName?.toLowerCase() ?? '')
                .contains(_searchQuery.toLowerCase()))
        .toList();

    if (_isAscending) {
      filteredUsers.sort((a, b) => (a.firstName?.toLowerCase() ?? '')
          .compareTo(b.firstName?.toLowerCase() ?? ''));
    } else {
      filteredUsers.sort((a, b) => (b.firstName?.toLowerCase() ?? '')
          .compareTo(a.firstName?.toLowerCase() ?? ''));
    }

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color:
                    const Color.fromARGB(255, 174, 159, 159).withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3)),
          ],
        ),
        child: Column(
          children: [
            _buildSearchAndSortControls(),
            Expanded(
              child: SingleChildScrollView(
                child: Table(
                  columnWidths: {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(2),
                    4: FlexColumnWidth(1),
                    5: FlexColumnWidth(1),
                    6: FlexColumnWidth(1),
                    7: FlexColumnWidth(2),
                  },
                  children: [
                    _buildTableHeader(),
                    ...filteredUsers
                        .map((user) => _buildUserRow(user, userViewModel))
                        .toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndSortControls() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher par nom...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none),
              ),
              onChanged: (query) => setState(() => _searchQuery = query),
            ),
          ),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(_isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                color: Colors.green),
            onPressed: () => setState(() => _isAscending = !_isAscending),
          ),
        ],
      ),
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
      decoration: BoxDecoration(color: Colors.grey[200]),
      children: [
        _tableCellHeader('Nom'),
        _tableCellHeader('Profile'),
        _tableCellHeader('Email'),
        _tableCellHeader('Téléphone'),
        _tableCellHeader('Pays'),
        _tableCellHeader('Statut'),
        _tableCellHeader('Vérifié'),
        _tableCellHeader('Actions'),
      ],
    );
  }

  TableRow _buildUserRow(user, UserViewModel userViewModel) {
    return TableRow(
      children: [
        _tableCell("${user.firstName} ${user.lastName}"),
        _tableCell(user.isHost ? 'Hôte' : 'Client'),
        _tableCell(user.email ?? ''),
        _tableCell(user.phoneNumber ?? ''),
        _tableCell(user.country ?? ''),
        _tableCell(user.isCurrentlyHosting ? 'Actif' : 'Inactif'),
        _buildVerifiedIcon(user.isVerified),
        _buildActions(user, userViewModel),
      ],
    );
  }

  Widget _buildStats(UserViewModel userViewModel) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: const Color.fromARGB(255, 176, 160, 160).withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _statCard(
              icon: Icons.people,
              title: 'Total Utilisateurs',
              stat: userViewModel.getTotalUserCount().toString(),
              change: '${userViewModel.calculateUserGrowth()}% ce mois',
              isIncrease: true),
          _statCard(
              icon: Icons.person,
              title: 'Clients',
              stat: userViewModel.getClientCount().toString(),
              change: '${userViewModel.calculateClientGrowth()}% ce mois',
              isIncrease: true),
          _statCard(
              icon: Icons.computer,
              title: 'Hôtes',
              stat: userViewModel.getHostCount().toString(),
              change: '0% ce mois',
              isIncrease: false),
        ],
      ),
    );
  }

  Widget _buildVerifiedIcon(bool isVerified) {
    return TableCell(
      child: Icon(isVerified ? Icons.check_circle : Icons.cancel,
          color: isVerified ? Colors.green : Colors.red),
    );
  }

  Widget _buildActions(user, UserViewModel userViewModel) {
    return TableCell(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              icon: Icon(Icons.edit, color: Colors.blue, size: 20),
              onPressed: () => print("Éditer ${user.firstName}")),
          IconButton(
              icon: Icon(Icons.delete, color: Colors.red, size: 20),
              onPressed: () => print("Supprimer ${user.firstName}")),
          Flexible(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    user.isVerified ? Colors.red[100] : Colors.green[100],
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              onPressed: () =>
                  userViewModel.updateUserStatus(user.id!, !user.isVerified),
              child: Text(
                user.isVerified ? 'Suspendre' : 'Vérifier',
                style: TextStyle(
                    color: user.isVerified ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableCellHeader(String text) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _tableCell(String text) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text),
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String title,
    required String stat,
    required String change,
    required bool isIncrease,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: Colors.green[300]),
          SizedBox(height: 20),
          Text(title, style: TextStyle(fontSize: 18, color: Colors.grey[600])),
          Text(stat,
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          Text(change,
              style: TextStyle(color: isIncrease ? Colors.green : Colors.red)),
        ],
      ),
    );
  }
}
