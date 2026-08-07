class vehical {
  String name;
  int modelYear;

  vehical(this.name, this.modelYear);
  void isValid() {
    if (modelYear > 2000) {
      print("valid car");
    } else {
      print("not valid");
    }
  }
}

class 

void main() {
  vehical car1 = vehical("Alto800", 2007);
  car1.isValid();
}
