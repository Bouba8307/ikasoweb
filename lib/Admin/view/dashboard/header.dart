import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ikasoweb/view_models/auth_view_model.dart';
import 'package:ikasoweb/view_models/hebergement_view_model.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    // Récupérer l'utilisateur actuel
    User? user = FirebaseAuth.instance.currentUser;

    return Padding(
      padding: const EdgeInsets.all(16.0), // Added padding for better spacing
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(child: SearchField()),

          // Espacement entre la recherche et les icônes
          const SizedBox(width: 16),

          // Icône de messages
          _buildIconButton("icons/message.svg", () {
            // Logic for messages
          }),

          // Icône de notification
          _buildIconButton("icons/notification.svg", () {
            // Logic for notifications
          }),

          // Carte du profil
          ProfileCard(userName: user?.displayName ?? "Utilisateur"),
        ],
      ),
    );
  }

  Widget _buildIconButton(String iconPath, VoidCallback onPressed) {
    return IconButton(
      icon: SvgPicture.asset(
        iconPath,
        height: 24,
        color: Colors.black87,
      ),
      onPressed: onPressed,
      tooltip: 'Icon Action', // Add a tooltip for accessibility
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String userName;

  const ProfileCard({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Row(
        children: [
          // Image de profil ronde
          CircleAvatar(
            backgroundImage: AssetImage("images/avatar.jpg"),
            radius: 16,
          ),
          const SizedBox(width: 8),
          Text(
            userName,
            style: const TextStyle(color: Colors.black87),
          ),
          const Icon(
            Icons.arrow_drop_down,
            color: Colors.black87,
          ),
        ],
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'logout',
          child: Text('Déconnexion'),
        ),
      ],
      onSelected: (value) {
        if (value == 'logout') {
          // Logique de déconnexion via le ViewModel
          final viewModel =
              Provider.of<DashboardViewModel>(context, listen: false);
          viewModel.signOut(context);
        }
      },
    );
  }
}

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final approvalViewModel = Provider.of<ApprovalViewModel>(context);

    return TextField(
      onChanged: (value) {
        setState(() {
          _searchQuery = value; // Met à jour la requête de recherche
        });
        // Vous pouvez appeler une méthode pour mettre à jour les résultats de recherche ici
        approvalViewModel.searchHebergements(
            _searchQuery); // Appelez une méthode de recherche
      },
      decoration: InputDecoration(
        hintText: "Tapez pour rechercher",
        fillColor: const Color.fromARGB(255, 245, 245, 245),
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: _buildSearchIcon(),
      ),
    );
  }

  Widget _buildSearchIcon() {
    return InkWell(
      onTap: () {
        // Logique pour lancer la recherche (si besoin)
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: SvgPicture.asset("icons/search.svg"),
      ),
    );
  }
}
