import 'dart:math';

String numberWithProperUnit(num n) {
  String str = '';
  if (n >= pow(10, 6)) {
    str = '${(n / pow(10, 6).round()).toString()}百万';
  } else if (n >= pow(10, 4)) {
    str = '${(n / pow(10, 4).round()).toString()}万';
  } else {
    str = n.round().toString();
  }
  return str;
}
