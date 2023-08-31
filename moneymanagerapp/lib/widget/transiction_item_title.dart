import 'dart:math';

import 'package:flutter/material.dart';
import 'package:moneymanagerapp/data/userInfo.dart';
import 'package:moneymanagerapp/utils/constants.dart';
import 'package:moneymanagerapp/utils/database_helper.dart';

class TransictionItemTitle extends StatefulWidget {
  final Transaction transaction;
  final VoidCallback onReload;
  final Function(double, TransactionType) onTransactionDeleted;

  const TransictionItemTitle({
    super.key,
    required this.transaction,
    required this.onReload,
    required this.onTransactionDeleted,
  });

  @override
  State<TransictionItemTitle> createState() => _TransictionItemTitleState();
}

class _TransictionItemTitleState extends State<TransictionItemTitle> {
  String getSign(TransactionType type) {
    switch (type) {
      case TransactionType.entrata:
        return "+";
      case TransactionType.uscita:
        return "-";
      case TransactionType.none:
        return "";
    }
  }

  Icon getIconForCategory(ItemCategoryType categoryType) {
    switch (categoryType) {
      case ItemCategoryType.cibo:
        return const Icon(Icons.fastfood);
      case ItemCategoryType.svago:
        return const Icon(Icons.music_video);
      case ItemCategoryType.vestiario:
        return const Icon(Icons.shopping_bag);
      case ItemCategoryType.sport:
        return const Icon(Icons.sports);
      case ItemCategoryType.macchina:
        return const Icon(Icons.directions_car);
      case ItemCategoryType.altro:
        return const Icon(Icons.more_horiz);
      case ItemCategoryType.none:
      default:
        return const Icon(Icons.not_interested);
    }
  }

  Color getRandomBgColor(ItemCategoryType categoryType) {
    switch (categoryType) {
      case ItemCategoryType.cibo:
        return Colors.amber;
      case ItemCategoryType.svago:
        return Colors.lightGreenAccent;
      case ItemCategoryType.vestiario:
        return Colors.lightBlueAccent;
      case ItemCategoryType.sport:
        return Colors.deepPurpleAccent;
      case ItemCategoryType.macchina:
        return const Color(0xFF8D6E63);
      case ItemCategoryType.altro:
        return Colors.deepOrangeAccent;
      case ItemCategoryType.none:
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: defaultSpacing / 2),
      decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset.zero,
                blurRadius: 10,
                spreadRadius: 4)
          ],
          color: background,
          borderRadius: BorderRadius.all(Radius.circular(defaultRadius))),
      child: ListTile(
        leading: Container(
            padding: const EdgeInsets.all(defaultSpacing / 2),
            decoration: BoxDecoration(
                color: getRandomBgColor(widget.transaction.categoryType),
                borderRadius:
                    const BorderRadius.all(Radius.circular(defaultRadius / 2))),
            child: getIconForCategory(widget.transaction.categoryType)),
        title: Text(
          widget.transaction.itemCategoryName,
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
              color: fontHeading,
              fontSize: fontSizeTitle,
              fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          widget.transaction.itemName,
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                color: fontSubHeading,
                fontSize: fontSizeBody,
              ),
        ),
        trailing: SizedBox(
          width: 150,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${getSign(widget.transaction.transactionType)}${widget.transaction.amount}",
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: widget.transaction.transactionType ==
                                    TransactionType.uscita
                                ? Colors.red
                                : fontHeading,
                            fontSize: 14,
                          ),
                    ),
                    Text(
                      widget.transaction.date,
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: fontSubHeading,
                            fontSize: 11,
                          ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                iconSize: 18,
                onPressed: () async {
                  bool? shouldDelete = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Conferma'),
                        content: const Text(
                            'Sei sicuro di voler eliminare questa transazione?'),
                        actions: [
                          TextButton(
                            child: const Text('Annulla'),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                          TextButton(
                            child: const Text('Conferma'),
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                        ],
                      );
                    },
                  );

                  if (shouldDelete == true) {
                    double amountAsDouble =
                        double.parse(widget.transaction.amount);
                    widget.onTransactionDeleted(
                        amountAsDouble, widget.transaction.transactionType);
                    await DatabaseHelper.instance
                        .deleteTransaction(widget.transaction.id!);
                    widget.onReload();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
