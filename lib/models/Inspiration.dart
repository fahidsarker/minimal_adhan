class Inspiration {
  String source;
  String value;

  Inspiration(this.value, this.source);
  @override
  String toString() {
    return '$value\n- $source';
  }
}