import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhismoappadmin/models/history_model.dart';
import 'package:dhismoappadmin/models/jumlo_history_model.dart';
import 'package:dhismoappadmin/models/product_model.dart';
import 'package:dhismoappadmin/models/project_names_or_ids.dart';
import 'package:dhismoappadmin/models/total_products_price_model.dart';
import 'package:dhismoappadmin/models/users_model.dart';

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
  addData(
      {double? groupPrice,
      String? productName,
      double? pricePerItemPurchased,
      double? pricePerItemToSell,
      int? quantity}) {
    projects.doc(projectID).collection("products").doc(productID).set({
      'groupPrice': groupPrice,
      'productID': productID,
      'productName': productName,
      'pricePerItemPurchased': pricePerItemPurchased,
      'pricePerItemToSell': pricePerItemToSell,
      'quantity': quantity
    }).then((_) {
      getTotal(pricePerItemPurchased!, pricePerItemToSell!, quantity!);
    });
  }

  deleteProduct(
      {required String prodID,
      required double pricePurchase,
      required double priceSold,
      required int quantityLeft}) {
    deleteAndUpdateTotal(pricePurchase, priceSold, quantityLeft).then((_) {
      products.doc(prodID).delete();
    });
  }

  Future deleteAndUpdateTotal(double pricePerItemPurchased,
      double pricePerItemToSell, int quantity) async {
    double totalPriceOfSingleProduct = pricePerItemPurchased * quantity;
    await products
        .doc('totalData')
        .collection('totalOfProducts')
        .doc('totalData')
        .get()
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

  getTotal(
      double pricePerItemPurchased, double pricePerItemToSell, int quantity) {
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
          priceGroupItems: doc['groupPrice'],
          productID: doc['productID'],
          productName: doc['productName'],
          pricePerItemPurchased: doc['pricePerItemPurchased'],
          pricePerItemToSell: doc['pricePerItemToSell'],
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
  addNewUser(String phoneNumber, bool isBlocked,String projectID) async {
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
    await users.doc(phoneNumber).update({"isBlocked": isBlocked}).then(
        (value) => print("user Status Updated"));
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

  Stream<List<HistoryModel>> getHistoryStream(String userID) {
    return users
        .doc(userID)
        .collection("History")
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
