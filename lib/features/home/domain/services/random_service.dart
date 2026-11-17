
import 'dart:math';

import 'package:injectable/injectable.dart';

@singleton
class RandomService {
  final Random _random = Random();

  int nextInt(int max) => _random.nextInt(max);
}
