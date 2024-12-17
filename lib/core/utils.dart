import 'package:intl/intl.dart';
import 'package:spark_save/models/transaction.dart';

String formatDateToReadable(String date) {
  return DateFormat('MMMM d, yyyy').format(
    DateTime.parse(date),
  );
}

String formatCurrency(num amount) {
  return NumberFormat.currency(
    locale: 'en_US',
    symbol: '\₱',
    decimalDigits: 2,
  ).format(amount);
}

NetTotal getNetTotal(List<TransactionModel> transactions) {
  num expense = 0, income = 0;

  for (TransactionModel transaction in transactions) {
    if (transaction.type.toLowerCase() == "expense") {
      expense += transaction.transactionAmount;
    } else if (transaction.type.toLowerCase() == "income") {
      income += transaction.transactionAmount;
    }
  }

  return NetTotal(balance: income - expense, expense: expense, income: income);
}

Map<K, List<T>> groupItemsByDate<T, K>(
    List<T> items, K Function(T) keySelector) {
  Map<K, List<T>> groupedItems = {};

  for (var item in items) {
    K key = keySelector(item);

    if (groupedItems.containsKey(key)) {
      groupedItems[key]!.add(item);
    } else {
      groupedItems[key] = [item];
    }
  }

  return groupedItems;
}
