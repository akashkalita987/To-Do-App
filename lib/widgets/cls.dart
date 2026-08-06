class BankAccount {
  double _balance =
      0; // private field — can't be accessed directly outside this file
  double get balance => _balance; // controlled read access (getter)
  void deposit(double amount) {
    if (amount > 0) {
      _balance += amount;
    }
  }

  void withdraw(double amount) {
    if (amount <= _balance) {
      _balance -= amount;
    } else {
      print('Insufficient funds');
    }
  }
}

void main() {
  final account = BankAccount();
  account.deposit(100);
  account.withdraw(30);
  print(account.balance); // 70 — read through the getter, not the raw field
  // account._balance = 1000000; // Error: _balance is private, can't be set directly
}
