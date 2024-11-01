import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ikasoweb/Admin/view/dashboard/header.dart';
import 'package:provider/provider.dart';
import 'package:ikasoweb/models/approbation_model.dart';
import 'package:ikasoweb/view_models/hebergement_view_model.dart';

class ApprovalScreen extends StatefulWidget {
  @override
  _ApprovalScreenState createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen> {
  @override
  Widget build(BuildContext context) {
    final approvalViewModel = Provider.of<ApprovalViewModel>(context);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(),
          _buildStatisticsRow(),
          SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<List<Hebergement>>(
              stream: approvalViewModel.getHebergementsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Aucun hébergement à approuver'));
                }

                final hebergements = snapshot.data!;

                return GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 11.0,
                  ),
                  itemCount: hebergements.length,
                  itemBuilder: (context, index) {
                    final hebergement = hebergements[index];
                    return _buildHebergementCard(
                        hebergement, approvalViewModel);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsRow() {
    final approvalViewModel = Provider.of<ApprovalViewModel>(context);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: FutureBuilder(
        future: Future.wait([
          approvalViewModel.getTotalHebergements(),
          approvalViewModel.getApprovedHebergementsCount(),
          approvalViewModel.getPendingHebergementsCount(),
        ]),
        builder: (context, AsyncSnapshot<List<int>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            final totalHebergements = snapshot.data![0];
            final approvedHebergements = snapshot.data![1];
            final pendingHebergements = snapshot.data![2];

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatisticCard(
                    'Total Hébergement', '$totalHebergements', '+36%'),
                _buildStatisticCard(
                    'Nombre Approuvé', '$approvedHebergements', '+36%'),
                _buildStatisticCard(
                    'Nombre Non Approuvé', '$pendingHebergements', '+36%'),
              ],
            );
          }

          return Container(); 
        },
      ),
    );
  }

  Widget _buildStatisticCard(String title, String count, String growth) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(count,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(growth, style: TextStyle(color: Colors.green, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildHebergementCard(
      Hebergement hebergement, ApprovalViewModel approvalViewModel) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: hebergement.photos.isNotEmpty
                ? hebergement.photos[0]
                : 'images/notfound.png',
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
                Image.asset('images/notfound.png'),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hebergement.nom,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  hebergement.ville,
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  '${hebergement.prixParJour} XOF / jour',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  hebergement.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            approvalViewModel.cancelHebergement(hebergement.id),
                        child: Text('Annuler'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => approvalViewModel
                            .approveHebergement(hebergement.id),
                        child: Text('Approuver'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
