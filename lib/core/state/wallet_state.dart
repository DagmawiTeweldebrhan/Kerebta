import 'package:flutter/foundation.dart';

class WalletState {
  static final ValueNotifier<double> balance = ValueNotifier<double>(1250.0);

  static final ValueNotifier<List<Map<String, dynamic>>> ledger = ValueNotifier([
    {
      'title': 'Top-Up via Telebirr',
      'titleAmh': 'በቴሌብር የተሞላ',
      'time': 'Today, 1:45 PM',
      'timeAmh': 'ዛሬ, 1:45 ከሰዓት',
      'amount': 500.00,
      'isCredit': true,
    },
    {
      'title': 'Abeni Tour Tee Purchase',
      'titleAmh': 'የአቤኒ ቱር ቲሸርት ግዢ',
      'time': 'Yesterday, 8:12 PM',
      'timeAmh': 'ትላንት, 8:12 ምሽት',
      'amount': -1200.00,
      'isCredit': false,
    },
    {
      'title': 'Ad-Revenue Payout',
      'titleAmh': 'የማስታወቂያ ክፍያ ገቢ',
      'time': 'May 20, 10:30 AM',
      'timeAmh': 'ግንቦት 12, 10:30 ጠዋት',
      'amount': 2850.50,
      'isCredit': true,
    },
  ]);

  static void addTransaction(Map<String, dynamic> transaction) {
    ledger.value = [transaction, ...ledger.value];
    if (transaction['isCredit'] == true) {
      balance.value += transaction['amount'];
    } else {
      balance.value += transaction['amount']; // amount is negative
    }
  }
}
