import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhismoappadmin/models/daily_payments_model.dart';
import 'package:dhismoappadmin/models/history_model.dart';
import 'package:dhismoappadmin/models/jumlo_history_model.dart';
import 'package:dhismoappadmin/models/product_model.dart';
import 'package:dhismoappadmin/models/project_names_or_ids.dart';
import 'package:dhismoappadmin/models/total_products_price_model.dart';
import 'package:dhismoappadmin/models/users_model.dart';
import 'package:flutter/material.dart';

const String PROJECTS = "projects";
const String PRODUCTS = "products";
const String USERS = "users";
//const String projectID = "madiin project";

class Service {
  Service({this.projectID});

  String? projectID;
  CollectionReference projects =
      FirebaseFirestore.instance.collection(PROJECTS);
  CollectionReference products =
      FirebaseFirestore.instance.collection(PRODUCTS);
  CollectionReference users = FirebaseFirestore.instance.collection(USERS);
  double totalPricePurchased = 0;

  double totalPriceOfSell = 0;
  String productID = DateTime.now().toString();

// --------------------creating project name or id -----------------
  createProjectNameOrID(String projectNameOrID) {
    projects.doc(projectNameOrID).set({'projectNameOrID': projectNameOrID});
  }

  List<ProjectsNames> getCreatedProjectsIDs(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return ProjectsNames(projectName: doc['projectNameOrID']);
    }).toList();
  }

  deleteProjectName(String projectName) {
    projects.doc(projectName).delete();
  }

//-------------------------------------------------------------------------

  //---------------- Save and get Daily Payments Information---------------

  saveTodayPayment(String name, double amount) {
    var now = DateTime.now();
    String paymentID = now.toString();
    DateTime date = DateTime(now.year, now.month, now.day);
    projects.doc(projectID).collection("dailyPayments").doc(paymentID).set(
        {"paymentID": paymentID, "name": name, "amount": amount, "date": date});
  }

  deletePayment(String id) {
    projects.doc(projectID).collection("dailyPayments").doc(id).delete();
  }

  List<DailyPaymentsModel> getDaysOfPayment(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return DailyPaymentsModel(
          paymentID: doc['paymentID'],
          name: doc['name'],
          date: doc['date'],
          amount: doc['amount']);
    }).toList();
  }

  Stream<List<DailyPaymentsModel>> getDailyPaymentStream() {
    return projects
        .doc(projectID)
        .collection('dailyPayments')
        .orderBy("date", descending: true)
        .snapshots()
        .map(getDaysOfPayment);
  }

  //-------------------------------------------------------------------------
  addData({String? productName, double? pricePerItemPurchased, int? quantity}) {
    projects.doc(projectID).collection("products").doc(productID).set({
      'productID': productID,
      'productName': productName,
      'pricePerItemPurchased': pricePerItemPurchased,
      'quantity': quantity
    }).then((_) {
      getTotal(pricePerItemPurchased!, quantity!);
    });
  }

  deleteProduct(
      {required String prodID,
      required double pricePurchase,
      required int quantityLeft}) {
    deleteAndUpdateTotal(pricePurchase, quantityLeft).then((_) {
      projects.doc(projectID).collection('products').doc(prodID).delete();

    });
  }

  Future deleteAndUpdateTotal(
      double pricePerItemPurchased, int quantity) async {
    double totalPriceOfSingleProduct = pricePerItemPurchased * quantity;
    await projects.doc(projectID).collection('totalOfProducts').doc('totalData').get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        totalPricePurchased = snapshot.get('totalPricePurchased');
        double totalPurchased =
            totalPricePurchased -= totalPriceOfSingleProduct;
        updateTotalSold(totalPurchased);
      }
    });
  }




  //save the total
  saveTotal(double totalOfPurchased) {
    projects.doc(projectID).collection("totalOfProducts").doc('totalData').set({
      "totalPricePurchased": totalOfPurchased,
      "totalPriceToSell": 0.0
    }).then((value) {
      print("NEW DATA IS INSERTED");
    });
  }

  getTotal(double pricePerItemPurchased, int quantity) {
    double totalPriceOfSingleProduct = pricePerItemPurchased * quantity;
    projects
        .doc(projectID)
        .collection('totalOfProducts')
        .doc('totalData')
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        totalPricePurchased = snapshot.get('totalPricePurchased');
        double totalPurchased =
            totalPricePurchased += totalPriceOfSingleProduct;
        updateTotalSold(totalPurchased);
      } else {
        saveTotal(totalPriceOfSingleProduct);
      }
    });
  }

  //update the total
  updateTotalSold(double totalOfPurchased) {
    projects
        .doc(projectID)
        .collection("totalOfProducts")
        .doc('totalData')
        .update({
      "totalPricePurchased": totalOfPurchased,
    }).then((value) {
      print("DATA IS UPDATED");
    });
  }

  TotalProductsPriceModel getTotalSold(DocumentSnapshot snapshot) {
    return TotalProductsPriceModel(
        totalPurchased: snapshot.get('totalPricePurchased'),
        totalSold: snapshot.get('totalPriceToSell'));
  }

  List<ProductModel> getProductSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return ProductModel(
          productID: doc['productID'],
          productName: doc['productName'],
          pricePerItemPurchased: doc['pricePerItemPurchased'],
          quantity: doc['quantity']);
    }).toList();
  }

  deleteAllData() {
    products
        .doc('totalData')
        .collection("totalOfProducts")
        .doc('totalData')
        .delete();

    products.get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });

    //history collection deleting
    var historyIdList = [];

    users.get().then((querySnapshot) {
      for (DocumentSnapshot ds in querySnapshot.docs) {
        historyIdList.add(ds.id);
      }
      historyIdList.forEach((userId) {
        users.doc(userId).collection('History').get().then((snapshot) {
          for (DocumentSnapshot ds in snapshot.docs) {
            ds.reference.delete();
          }
        });
      });
    });

    users.get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });

    //jumlo collection deleting
    var jumloIdList = [];
    users.get().then((querySnapshot) {
      for (DocumentSnapshot ds in querySnapshot.docs) {
        jumloIdList.add(ds.id);
      }
      jumloIdList.forEach((userId) {
        users.doc(userId).collection('jumlo').get().then((snapshot) {
          for (DocumentSnapshot ds in snapshot.docs) {
            ds.reference.delete();
          }
        });
      });
    });

    users.get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }

//---------------- adding new user ----------------------
  addNewUser(String phoneNumber, bool isBlocked, String projectID) async {
    await projects
        .doc(projectID)
        .collection('users')
        .doc(phoneNumber)
        .set({"phoneNumber": phoneNumber, "isBlocked": isBlocked}).then(
            (value) => print("Added new user"));
    await addDocument(phoneNumber);
  }

  Future addDocument(String phoneNumber) async {
    return users.doc(phoneNumber);
  }

  List<UserInfo> getPhoneNumberSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserInfo(
          phoneNumber: doc['phoneNumber'], isBlocked: doc['isBlocked']);
    }).toList();
  }

  blockUnblockUser(String phoneNumber, bool isBlocked) async {
    await projects.doc(projectID).collection('users').doc(phoneNumber).update(
        {"isBlocked": isBlocked}).then((value) => print("user Status Updated"));
  }

  //Get specific User History
  List<HistoryModel> getHistorySnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return HistoryModel(
          dateSold: doc['dateSold'],
          historyID: doc['historyID'],
          productName: doc['productName'],
          pricePerItemToSell: doc['pricePerItemToSell'],
          totalPrice: doc['totalPrice'],
          quantity: doc['quantity']);
    }).toList();
  }

  Stream<List<HistoryModel>> getHistoryStream(String userID, String projectID) {
    print(":::::::::::::::::: userID:   $userID");
    print(":::::::::::::::::: projectID:   $projectID");
    return projects
        .doc(projectID)
        .collection("users")
        .doc(userID)
        .collection('History')
        .snapshots()
        .map(getHistorySnapshot);
  }

  List<JumloHistoryModel> getJumloSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return JumloHistoryModel(
          historyID: doc['historyID'],
          productName: doc['productName'],
          priceGroupItems: doc['priceGroupItems'],
          totalPrice: doc['totalPrice'],
          dateTold: doc['dateSold'],
          quantity: doc['quantity'],
          isLoan: doc['isLoan'],
          nameOfPerson: doc['nameOfPerson']);
    }).toList();
  }

//------------------------------------Other User---------------------

}
