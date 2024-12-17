import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spark_save/firebase_options.dart';
import 'package:spark_save/models/transaction.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  StreamSubscription<QuerySnapshot>? _transactionSubscription;
  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      DocumentReference docRef =
          await FirebaseFirestore.instance.collection('transactions').add({
        'name': transaction.name,
        'category': transaction.category,
        'transactionAmount': transaction.transactionAmount,
        'type': transaction.type,
        'date': transaction.date,
        'userId': _auth.currentUser?.uid
      });

      transaction.id = docRef.id;
    } catch (e) {
      print("Error adding transaction: $e");
      rethrow;
    }
  }

  Future<void> deleteTransaction(String id) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('Must be logged in');
    }

    await _firestore.collection('transactions').doc(id).delete();
  }

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    _auth.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        _transactionSubscription = _firestore
            .collection('transactions')
            .where('userId', isEqualTo: user.uid)
            .orderBy('date', descending: true)
            .snapshots()
            .listen((snapshot) {
          _transactions = [];
          for (final document in snapshot.docs) {
            _transactions.add(TransactionModel(
                id: document.id,
                name: document.data()['name'] as String,
                date: document.data()['date'] as Timestamp,
                type: document.data()['type'] as String,
                category: document.data()['category'] as String,
                transactionAmount:
                    document.data()['transactionAmount'] as num));
          }
          notifyListeners();
        });
      } else {
        _loggedIn = false;
        _transactions = [];
        _transactionSubscription?.cancel();
      }
      notifyListeners();
    });
  }
}
