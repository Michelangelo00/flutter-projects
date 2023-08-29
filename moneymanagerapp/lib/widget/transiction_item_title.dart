import 'package:flutter/material.dart';
import 'package:moneymanagerapp/data/userInfo.dart';
import 'package:moneymanagerapp/utils/constants.dart';

class TransictionItemTitle extends StatelessWidget {
  final Transaction transaction;

  const TransictionItemTitle({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius:
                    BorderRadius.all(Radius.circular(defaultRadius / 2))),
            child: transaction.categoryType == ItemCategoryType.fashion
                ? const Icon(Icons.supervised_user_circle_sharp)
                : const Icon(Icons.house)),
        title: Text(
          transaction.itemCategoryName,
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
              color: fontHeading,
              fontSize: fontSizeTitle,
              fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          transaction.itemName,
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                color: fontSubHeading,
                fontSize: fontSizeBody,
              ),
        ),
        trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction.amount,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color:
                        transaction.transactionType == TransactionType.outflow
                            ? Colors.red
                            : fontHeading,
                    fontSize: fontSizeTitle),
              ),
              Text(
                transaction.date,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: fontSubHeading,
                      fontSize: fontSizeBody,
                    ),
              )
            ]),
      ),
    );
  }
}
