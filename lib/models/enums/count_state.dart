enum CountState {
  completed,
  skipped,
  missed;

  static void ensureStableEnumValues() {
    assert(CountState.completed.index == 0);
    assert(CountState.skipped.index == 1);
    assert(CountState.missed.index == 2);
  }
}
