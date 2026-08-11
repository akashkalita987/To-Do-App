
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

class student {
  String name;
  int roll;

  student(this.name, this.roll);

  
  void disData() {
    print(name);
    print(roll);
  }
}


void main() {
  vehical car1 = vehical("Alto800", 2007);
  car1.isValid();


  student st1 = student("akash", 5);
  st1.disData();
}
