Future<String> fetchGreeting() {
  return Future.delayed(const Duration(seconds: 2), () {
    return 'hello from future';
  });
}
