import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SideMenu extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const SideMenu({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 189, 187, 187),
      child: SingleChildScrollView(
        child: Column(
          children: [
            DrawerHeader(child: SvgPicture.asset("icons/lo.svg")),
            DrawerListTitle(
              title: "Dashboard",
              svgSrc: "icons/dashboard.svg",
              isSelected: selectedIndex == 0,
              press: () => onItemSelected(0),
            ),
            DrawerListTitle(
              title: "Transactions",
              svgSrc: "icons/transactions.svg",
              isSelected: selectedIndex == 1,
              press: () => onItemSelected(1),
            ),
            DrawerListTitle(
              title: "Approbations",
              svgSrc: "icons/approbation.svg",
              isSelected: selectedIndex == 2,
              press: () => onItemSelected(2),
            ),
            DrawerListTitle(
              title: "Validation Hôte",
              svgSrc: "icons/client.svg",
              isSelected: selectedIndex == 3,
              press: () => onItemSelected(3),
            ),
            DrawerListTitle(
              title: "Utilisateurs",
              svgSrc: "icons/utilisateur.svg",
              isSelected: selectedIndex == 4,
              press: () => onItemSelected(4),
            ),
            DrawerListTitle(
              title: "Réservations",
              svgSrc: "icons/reservation.svg",
              isSelected: selectedIndex == 5,
              press: () => onItemSelected(5),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerListTitle extends StatelessWidget {
  final String title, svgSrc;
  final bool isSelected;
  final VoidCallback press;

  const DrawerListTitle({
    super.key,
    required this.title,
    required this.svgSrc,
    required this.isSelected,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: const Color.fromARGB(136, 0, 0, 0),
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected
              ? const Color.fromARGB(255, 243, 198, 63)
              : const Color.fromARGB(137, 0, 0, 0),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      tileColor: isSelected
          ? Colors.grey[300]
          : Colors.transparent, // Fond gris si sélectionné
    );
  }
}
