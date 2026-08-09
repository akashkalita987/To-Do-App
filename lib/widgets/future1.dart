Future<String> fetchGreeting() {
  return Future.delayed(const Duration(seconds: 2), () => "hwllo");
}

Future<void> main() async {
  print("start");
  final message = await fetchGreeting();
  print(message);
  print("End");
}
