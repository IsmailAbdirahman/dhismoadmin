import 'dart:ui';
import 'package:dhismoappadmin/daily_payments/daily_payments_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

showDailyPaymentDialog(
  BuildContext context,
) {
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            //this right here
            child: Container(
              height: MediaQuery.of(context).size.height * 0.50,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.clear))),
                    Text("Daily Payment"),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(hintText: "Name:"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: amountController,
                        decoration: InputDecoration(hintText: "amount:"),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                                primary: Colors.deepOrange),
                            child: Text(
                              "Add",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              if (nameController.text != '' &&
                                  amountController.text != '') {
                                context
                                    .read(dailyPaymentsProvider)
                                    .saveTodayPayment(nameController.text,
                                        double.parse(amountController.text));
                                Navigator.pop(context);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Meel banaan ayaa jirta",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
}
