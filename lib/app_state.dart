import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spark_save/firebase_options.dart';
import 'package:spark_save/models/macro.dart';
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

  StreamSubscription<QuerySnapshot>? _poolingSubscription;
  List<Pooling> _poolings = [];
  List<Pooling> get poolings => _poolings;

  StreamSubscription<QuerySnapshot>? _macroSubscription;
  List<Macro> _macros = [];
  List<Macro> get macros => _macros;

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

  Future<TransactionModel?> retrieveTransactionById(String id) async {
    try {
      print("Retrieving transaction with ID: $id");
      DocumentSnapshot snapshot =
          await _firestore.collection('transactions').doc(id).get();
      print("Snapshot exists: ${snapshot.exists}");

      if (snapshot.exists) {
        print("Snapshot data: ${snapshot.data()}");
        final data = snapshot.data() as Map<String, dynamic>;

        return TransactionModel(
          id: snapshot.id,
          name: data['name'] ?? '',
          date: data['date'] as Timestamp,
          type: data['type'] ?? '',
          category: data['category'] ?? '',
          transactionAmount: data['transactionAmount'] ?? 0,
        );
      } else {
        print("Document with ID: $id not found.");
        return null;
      }
    } catch (e) {
      print("Error retrieving transaction by ID: $e");
      return null;
    }
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      if (transaction.id.isEmpty) {
        throw Exception("Transaction ID cannot be empty");
      }

      DocumentReference docRef =
          _firestore.collection('transactions').doc(transaction.id);

      await docRef.update({
        'name': transaction.name,
        'category': transaction.category,
        'transactionAmount': transaction.transactionAmount,
        'type': transaction.type,
        'date': transaction.date,
        'userId': _auth.currentUser?.uid,
      });
    } catch (e) {
      print("Error updating transaction: $e");
      rethrow;
    }
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
        'payer': pooling.payer,
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

  Future<Pooling?> retrievePoolingById(String id) async {
    try {
      print("Retrieving pooling with ID: $id");
      DocumentSnapshot snapshot =
          await _firestore.collection('poolings').doc(id).get();
      print("Snapshot exists: ${snapshot.exists}");

      if (snapshot.exists) {
        print("Snapshot data: ${snapshot.data()}");
        final data = snapshot.data() as Map<String, dynamic>;

        List<PoolingMember> members = (data['members'] as List)
            .map((memberData) => PoolingMember(
                  id: memberData['id'] != null
                      ? memberData['id'].toString()
                      : '',
                  name: memberData['member'] ?? 'Unknown',
                  isPaid: memberData['isPaid'] ?? false,
                  shareAmount: memberData['shareAmount'] ?? 0,
                ))
            .toList();

        return Pooling(
          id: snapshot.id,
          payer: data['payer'] ?? '',
          expenseAmount: data['expenseAmount'] ?? 0,
          expenseName: data['expenseName'] ?? '',
          date: data['date'] as Timestamp,
          category: data['category'] ?? '',
          status: data['status'] ?? '',
          members: members,
        );
      } else {
        print("Document with ID: $id not found.");
        return null;
      }
    } catch (e) {
      print("Error retrieving pooling by ID: $e");
      return null;
    }
  }

  Future<void> updatePooling(Pooling pooling) async {
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
          _firestore.collection('poolings').doc(pooling.id);

      await poolingDoc.update({
        'payer': pooling.payer,
        'expenseName': pooling.expenseName,
        'expenseAmount': pooling.expenseAmount,
        'date': pooling.date,
        'category': pooling.category,
        'status': pooling.status,
        'members': formattedMembers,
      });

      print('Pooling updated with ID: ${pooling.id}');
    } catch (e) {
      print("Error updating pooling: $e");
      rethrow;
    }
  }

  Future<void> addMacro(Macro macro) async {
    try {
      await _firestore.collection('macros').add({
        'userId': _auth.currentUser?.uid,
        'name': macro.name,
        'category': macro.category,
        'amount': macro.amount,
        'date': macro.date
      });
    } catch (e) {
      print("Error adding macro: $e");
    }
  }

  Future<void> updateMacro(Macro macro) async {
    try {
      if (macro.id.isNotEmpty) {
        await _firestore.collection('macros').doc(macro.id).update({
          'userId': _auth.currentUser?.uid,
          'name': macro.name,
          'category': macro.category,
          'amount': macro.amount,
          'date': macro.date,
        });
      }
    } catch (e) {
      print("Error updating macro: $e");
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

        _poolingSubscription = _firestore
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
              payer: document.data()['payer'] as String,
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

        _macroSubscription = _firestore
            .collection('macros')
            .where('userId', isEqualTo: user.uid)
            .snapshots()
            .listen((snapshot) {
          _macros = [];

          for (final document in snapshot.docs) {
            _macros.add(
              Macro(
                id: document.id,
                name: document.data()['name'] as String,
                category: document.data()['category'],
                amount: document.data()['amount'] as num,
                date: document.data()['date'] as Timestamp,
              ),
            );
          }
          notifyListeners();
        });
      } else {
        _loggedIn = false;
        _transactions = [];
        _poolings = [];
        _transactionSubscription?.cancel();
        _poolingSubscription?.cancel();
      }
      notifyListeners();
    });
  }
}
