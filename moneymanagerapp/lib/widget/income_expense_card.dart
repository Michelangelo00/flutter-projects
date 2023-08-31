import 'package:flutter/material.dart';
import 'package:moneymanagerapp/utils/constants.dart';

class ExpenseData {
  final String label;
  final String amount;
  final IconData icon;

  const ExpenseData(this.label, this.amount, this.icon);
}

class IncomeExpenseCard extends StatelessWidget {
  const IncomeExpenseCard({super.key, required this.expenseData});

  final ExpenseData expenseData;

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: const EdgeInsets.only(right: defaultSpacing),
      height: 80,
      padding: const EdgeInsets.all(defaultSpacing),
      decoration: BoxDecoration(
        color: expenseData.label == "Entrate" ? primaryDark : accent,
        borderRadius: const BorderRadius.all(Radius.circular(defaultRadius)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Colore dell'ombra
            spreadRadius: 1, // L'estensione dell'ombra
            blurRadius: 5, // La sfocatura dell'ombra
            offset: const Offset(0, 3), // La direzione dell'ombra
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expenseData.label,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: defaultSpacing / 3),
                  child: Text(
                    expenseData.amount,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          ),
          Icon(
            expenseData.icon,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
