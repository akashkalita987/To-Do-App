Future<String> fetchGreeting() {
  return Future.delayed(const Duration(seconds: 10), () {
    return 'hello from future';
  });
}

void main() {
  print("Start");
  fetchGreeting().then((message) {
    print(message);
  });
  print("end");
}
