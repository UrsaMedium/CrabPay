import 'package:flutter/material.dart' show immutable;

@immutable
abstract class DatabaseState {
  const DatabaseState();
}

class DatabaseStateDataFetched implements DatabaseState {
  const DatabaseStateDataFetched();
}

class DatabaseStateDataNotFetched implements DatabaseState {
  const DatabaseStateDataNotFetched();
}
