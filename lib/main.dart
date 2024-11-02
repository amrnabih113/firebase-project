enum Weak {
  sat,
  sun,
  mon,
  tue,
  wed,
  tur,
  fri,
}

void main() {
  // num is the father of int and double
  print('<<<<<<<<<<< nums >>>>>>>>>>>>');
  num n1 = 5;
  print(n1);
  print(n1.isFinite);
  print(n1.hashCode);
  print(n1.isNegative);
  print(n1.sign); // -1 if neg and 1 if pos
  print(n1.compareTo(5));
  n1 /= 0;
  print(n1.isFinite);
  n1 = 5.456;
  print(n1);
  print(n1.ceil());
  print(n1.floor());
  int n2 = -8;
  print(n2.isEven);
  print(n2.abs());

  print('======================================================');
  // you cant change the type of the var variable
  var x = 5;
  print(x);
  // x= 'hello'; wrong
  var y = 'hello';
  print(y);
  print('======================================================');
  print('<<<<<<<<<<< dynamic variables >>>>>>>>>>>>');

  //dynamic
  dynamic D = 50;
  print(D);
  print(D is int);
  print(D is! int);

  D = 'hello';
  print(D);
  print(D is String);
  print(D is! String);

  D = 50.50;
  print(D);
  print('${D is double} ');
  print(D is! double);

  D = true;
  print(D);
  print(D is bool);
  print(D is! bool);

  print('======================================================');
  print('<<<<<<<<<<< casting >>>>>>>>>>>>');
  //type casting
  int age = 5;
  double age2 = age.toDouble();
  print(age + age2);
  print('======================================================');

  // type converting
  num temp = 5.5;
  num temp3 = temp as double;
  print('$temp  $temp3');
  print('======================================================');
  print('<<<<<<<<<<< strings >>>>>>>>>>>>');
  // strings
  String name = 'amr';
  String lastName = 'nabih';
  print(name.compareTo('amr')); //( 0 if = ) and (1 or -1 if !=)
  print(name.toLowerCase());
  print(name.toUpperCase());
  print(name.substring(2));
  print(name.isEmpty);
  print(name.isNotEmpty);
  print(name.length);
  print(name.runtimeType);
  print(name.replaceAll('amr', 'ahmed'));
  print(name.indexOf('r'));
  print('$name $lastName My age = 5+5');
  print('$name $lastName My age = ${5 + 5} ');
  print('======================================================');
  //multiline string
  String multi = '''hello
it's me ,
i was  wondring if after all this years you would like to be ''';
  print(multi);
  multi =
      'hello\nit\'s me\ni was  wondring if after all this years you would like to be';
  print(multi);
  print('======================================================');
  print('<<<<<<<<<<< switch >>>>>>>>>>>>');
  //switch in dart
  var xx = 10;
  switch (xx) {
    case >= 3 && <= 8:
      print("Correct");
      break;
    default:
      print("Inorrect");
      break;
  }
  print('======================================================');
  print('<<<<<<<<<<< operators >>>>>>>>>>>>');
  //operations
  var a = 6;
  a ??= 5;

  print(a);
  var b;
  b ??= 'c';
  print(b);
  var xy = 5;
  print(xy);
  xy++;
  print(xy);
  xy += 2;
  print(xy);
  bool yy = !(xy == xy) || !(xy == xy);
  print(yy);
  print('======================================================');
  print('<<<<<<<<<<< enums >>>>>>>>>>>>');
  // enums
  Weak weak1 = Weak.fri;
  print(weak1);
  print(weak1.index);
  print(weak1.runtimeType);
  print(weak1.name);
  print('======================================================');
  print('<<<<<<<<<<< lists >>>>>>>>>>>>');

// lists
  List list = [
    "Amr",
    [
      1,
      2,
      3,
      ['a', 'b', 'c']
    ],
    "nabih"
  ];
  print(list);
  list.add(5);
  list.addAll([3, 4, 5]);
  list.insert(2, "fuck");
  list.insertAll(5, [
    "hello",
    [2, 6, 66],
    '%',
    5.36
  ]);
  list.remove('fuck');
  list.removeAt(5);
  list.removeRange(4, 6);
  list.replaceRange(5, 7, ["replaced", 'replaced']);
  print(list);
  print(list[1]);
  print(list[1][3]);
  print(list[1][3][2]);

  print(list.first);
  print(list.isEmpty);
  print(list.last);
  print(list.contains(5));
  print(list.contains('vhv'));
  print(list.reversed.toList());
  print(list.indexed);
  print(list.runtimeType);
  print(list.firstOrNull);
  for (var i in list) {
    print(i);
  }
  list.forEach((element) {
    print(element);
  });
  list.clear();
  print(list.length);
  print(list.firstOrNull);
  print('======================================================');
  print('<<<<<<<<<<< maps >>>>>>>>>>>>');
  Map info = {"name": "Amr", "age": 25, "gender": "male"};
  List data = [];
  info.forEach((key, value) {
    data.add(value);
  });
  print(data);
  print(info);
  print(info["name"]);
  print(info.keys);
  print(info.length);
  print(info.values);
  print(info.remove("gender"));
  info.forEach((key, value) {
    print(value);
  });
  info.update("name", (value) => 'new', ifAbsent: () => "married");
  print(info);
  info.addAll({"id": 550, "home": "mansoura"});
  print(info);
  info.putIfAbsent(
    "salary",
    () => 5000,
  );
  print(info);
  print('======================================================');
  print('<<<<<<<<<<< functions >>>>>>>>>>>>');
}
