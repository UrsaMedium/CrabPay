import 'package:flutter/material.dart' show immutable;

@immutable
abstract class PapState {
  const PapState();
}

class PapStateDataFetched implements PapState {
  const PapStateDataFetched();
}

class PapStateDataNotFetched implements PapState {
  const PapStateDataNotFetched();
}
