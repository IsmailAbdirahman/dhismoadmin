import 'package:dhismoappadmin/models/daily_payments_model.dart';
import 'package:dhismoappadmin/widgets/alert_dialog_daily_payments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'daily_payments_state.dart';

class DailyPayments extends StatefulWidget {
  const DailyPayments({Key? key}) : super(key: key);

  @override
  _DailyPaymentsState createState() => _DailyPaymentsState();
}

class _DailyPaymentsState extends State<DailyPayments> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer(
          builder: (BuildContext context, watch, child) {
            final dailyPaymentWatch = watch(dailyPaymentsProvider);
            return StreamBuilder<List<DailyPaymentsModel>>(
              stream: dailyPaymentWatch.getDailyPaymentStream(),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  var dailyData = snapshot.data;
                  return ListView.builder(
                      itemCount: dailyData!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onLongPress: () {
                            //               context.read(dailyPaymentsProvider).deletePayment(id);
                          },
                          child: DailyPaymentTile(
                            data: dailyData[index],
                          ),
                        );
                      });
                } else {
                  return CircularProgressIndicator();
                }
              },
            );
          },
        ),
        floatingActionButton: Align(
          alignment: Alignment.bottomCenter,
          child: FloatingActionButton(
            child: Icon(Icons.app_registration),
            onPressed: () {
              showDailyPaymentDialog(context);
            },
          ),
        ),
      ),
    );
  }
}

class DailyPaymentTile extends StatelessWidget {
  final DailyPaymentsModel? data;

  DailyPaymentTile({this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            height: 100,
            child: Card(
              color: Colors.deepOrange,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data!.name!,
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, top: 8.0, right: 8.0),
                        child: Text(
                          "\$${data!.amount!}",
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.white60,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      data!.date!,
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
