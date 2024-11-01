import 'package:flutter/material.dart';
import 'package:ikasoweb/Admin/view/components/demande_hote.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 40, 40, 88),
      child: DemandeHoteScreenWeb(),
    );
  }
}
