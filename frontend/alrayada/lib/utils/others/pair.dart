import 'package:flutter/foundation.dart' show immutable;

@immutable
class Pair<A, B> {
  final A first;
  final B second;

  const Pair(this.first, this.second);
}
