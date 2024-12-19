import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spark_save/firebase_options.dart';
import 'package:spark_save/models/pooling.dart';
import 'package:spark_save/models/transaction.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  StreamSubscription<QuerySnapshot>? _transactionSubscription;
  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  StreamSubscription<QuerySnapshot>? _poolingSubscriptionb;
  List<Pooling> _poolings = [];
  List<Pooling> get poolings => _poolings;

  Future<void> deleteDocument(String id, String collection) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('Must be logged in');
    }

    await _firestore.collection(collection).doc(id).delete();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      DocumentReference docRef =
          await _firestore.collection('transactions').add({
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

  Future<void> addPooling(Pooling pooling) async {
    try {
      List<Map<String, dynamic>> formattedMembers =
          pooling.members.map((member) {
        return {
          'id': member.id,
          'member': member.name,
          'shareAmount': member.shareAmount,
        };
      }).toList();

      DocumentReference poolingDoc =
          await _firestore.collection('poolings').add({
        'userId': _auth.currentUser?.uid,
        'expenseName': pooling.expenseName,
        'expenseAmount': pooling.expenseAmount,
        'date': pooling.date,
        'category': pooling.category,
        'status': pooling.status,
        'members': formattedMembers,
      });

      print('Pooling added with ID: ${poolingDoc.id}');
    } catch (e) {
      print("Error adding pooling: $e");
      rethrow;
    }
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

        _poolingSubscriptionb = _firestore
            .collection('poolings')
            .where('userId', isEqualTo: user.uid)
            .snapshots()
            .listen((snapshot) {
          _poolings = [];
          for (final document in snapshot.docs) {
            List<PoolingMember> members = [];
            var memberData = document.data()['members'] as List<dynamic>;
            for (var member in memberData) {
              members.add(PoolingMember(
                isPaid:
                    member['isPaid'] != null ? member['isPaid'] as bool : false,
                id: member['id'] as String,
                name: member['member'] as String,
                shareAmount: member['shareAmount'] as num,
              ));
            }

            _poolings.add(Pooling(
              id: document.id,
              expenseName: document.data()['expenseName'] as String,
              expenseAmount: document.data()['expenseAmount'] as num,
              date: document.data()['date'] as Timestamp,
              category: document.data()['category'] as String,
              status: document.data()['status'] as String,
              members: members,
            ));
          }
          notifyListeners();
        });
      } else {
        _loggedIn = false;
        _transactions = [];
        _poolings = [];
        _transactionSubscription?.cancel();
        _poolingSubscriptionb?.cancel();
      }
      notifyListeners();
    });
  }
}
