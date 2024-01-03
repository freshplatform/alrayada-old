import 'package:flutter/foundation.dart' show immutable;

@immutable
class Pair<A, B> {

  const Pair(this.first, this.second);
  final A first;
  final B second;
}
