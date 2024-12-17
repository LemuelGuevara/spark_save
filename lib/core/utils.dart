import 'package:intl/intl.dart';
import 'package:spark_save/models/transaction.dart';

String formatDateToReadable(String date) {
  return DateFormat('MMMM d, yyyy').format(
    DateTime.parse(date),
  );
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
