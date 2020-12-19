import 'package:flutter/material.dart';
import 'package:opolah/constant/constans.dart';
import 'package:opolah/ui/components/history_item.dart';
import 'package:opolah/ui/components/see_all.dart';
import 'package:opolah/ui/screens/profile/transaction_screen.dart';

class HistoryList extends StatelessWidget {
  const HistoryList({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SeeAll(
              title: 'History',
              openMore: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TransactionScreen(tabIndex: 2)));
              }),
          SizedBox(height: 10),
          HistoryItem(
              bgColor: Colors.white,
              textColor: colorPrimary,
              name: 'Space Milk T-Shirt',
              price: '99.500,00'),
          HistoryItem(
              bgColor: Colors.white,
              textColor: colorPrimary,
              name: 'Space Milk T-Shirt',
              price: '99.500,00'),
          HistoryItem(
              bgColor: Colors.white,
              textColor: colorPrimary,
              name: 'Space Milk T-Shirt',
              price: '99.500,00'),
        ],
      ),
    );
  }
}
