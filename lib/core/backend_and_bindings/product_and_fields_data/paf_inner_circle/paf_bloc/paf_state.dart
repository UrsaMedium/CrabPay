import 'package:flutter/material.dart' show immutable;

@immutable
abstract class PafState {
  const PafState();
}

class PafStateDataFetched implements PafState {
  const PafStateDataFetched();
}

class PafStateDataNotFetched implements PafState {
  const PafStateDataNotFetched();
}
