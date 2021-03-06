import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opolah/blocs/transaction/transaction_bloc.dart';
import 'package:opolah/blocs/transaction/transaction_state.dart';
import 'package:opolah/constant/constans.dart';
import 'package:opolah/ui/components/history_item.dart';
import 'package:opolah/ui/screens/payment/payment_screen.dart';

class PaymentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            if (state is TransactionLoading) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation(colorPrimary),
                ),
              );
            } else if (state is TransactionSuccessLoad) {
              final transactions = state.transctionList
                  .where((data) => data.getProof == "")
                  .toList();

              return Container(
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      return HistoryItem(
                        transactionItem: transactions[index],
                        tab: 'payment',
                        clickCallback: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaymentScreen(
                                      total: double.parse(
                                          transactions[index].getTotal),
                                      transactionID:
                                          transactions[index].getID)));
                        },
                      );
                    }),
              );
            }
            return Container();
          },
        ));
  }
}
