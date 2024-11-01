import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ikasoweb/Admin/view/dashboard/header.dart';

class DemandeHoteScreenWeb extends StatefulWidget {
  @override
  _DemandeHoteScreenWebState createState() => _DemandeHoteScreenWebState();
}

class _DemandeHoteScreenWebState extends State<DemandeHoteScreenWeb> {
  String selectedStatus = 'en_attente';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace:
            Header(), 
        toolbarHeight: 80.0, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTabButton(context, 'En attente', 'en_attente'),
                _buildTabButton(context, 'Approuvées', 'approuvé'),
                _buildTabButton(context, 'Rejetées', 'rejeté'),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('demandes_hote')
                    .where('status', isEqualTo: selectedStatus)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());

                  return ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(height: 16),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var doc = snapshot.data!.docs[index];
                      var userInfo = doc['userInfo'] as Map<String, dynamic>;
                      return Card(
                        elevation: 4,
                        shadowColor: Colors.grey.withOpacity(0.5),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                NetworkImage(userInfo['profileImageUrl'] ?? ''),
                          ),
                          title: Text(
                              '${userInfo['firstName']} ${userInfo['lastName']}'),
                          subtitle: Text(userInfo['email'] ?? ''),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.check, color: Colors.green),
                                onPressed: () => _approuverDemande(doc.id),
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.red),
                                onPressed: () => _rejeterDemande(doc.id),
                              ),
                              IconButton(
                                icon: Icon(Icons.info_outline,
                                    color: Color.fromARGB(255, 243, 198, 63)),
                                onPressed: () =>
                                    _showDemandeDetails(context, doc, userInfo),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(BuildContext context, String label, String status) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: selectedStatus == status ? Colors.white : Colors.black,
        backgroundColor: selectedStatus == status
            ? Color.fromARGB(255, 243, 198, 63)
            : Colors.grey[200],
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(label),
      onPressed: () {
        setState(() {
          selectedStatus = status;
        });
      },
    );
  }

  void _showDemandeDetails(BuildContext context, DocumentSnapshot doc,
      Map<String, dynamic> userInfo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Détails de la demande',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage:
                    NetworkImage(userInfo['profileImageUrl'] ?? ''),
              ),
              SizedBox(height: 10),
              Text('${userInfo['firstName']} ${userInfo['lastName']}',
                  style: TextStyle(fontSize: 18)),
              Divider(),
              ListTile(
                leading:
                    Icon(Icons.email, color: Color.fromARGB(255, 243, 198, 63)),
                title: Text(userInfo['email'] ?? 'Email indisponible'),
              ),
              ListTile(
                leading:
                    Icon(Icons.phone, color: Color.fromARGB(255, 243, 198, 63)),
                title:
                    Text(userInfo['phoneNumber'] ?? 'Téléphone indisponible'),
              ),
              ListTile(
                leading: Icon(Icons.location_city,
                    color: Color.fromARGB(255, 243, 198, 63)),
                title: Text('${userInfo['city']}, ${userInfo['country']}'),
              ),
              Divider(),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 243, 198, 63)),
            child: Text('Fermer'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _approuverDemande(String demandeId) async {
    await FirebaseFirestore.instance
        .collection('demandes_hote')
        .doc(demandeId)
        .update({'status': 'approuvé'});
  }

  void _rejeterDemande(String demandeId) async {
    await FirebaseFirestore.instance
        .collection('demandes_hote')
        .doc(demandeId)
        .update({'status': 'rejeté'});
  }
}
