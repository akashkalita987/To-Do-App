class BankAccount {
double _balance = 0; // private field — can't be accessed directly outside this file
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