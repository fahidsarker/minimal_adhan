const _sepatator = "<!@#%^&!>";

class Tasbih {
  final int id;
  final String name;
  final int counted;
  final int? target;

  Tasbih._fromData(this.id, this.name, this.counted, this.target);

  factory Tasbih.create({required String name, int? target}) {
    if (name.contains(_sepatator)) {
      throw Exception("Tasbih name can not contain $_sepatator");
    }
    if (name == '') {
      throw Exception('Name can not be empty!');
    }
    if (target != null && target <= 0) {
      throw Exception("Invalid target!");
    }
    return Tasbih._fromData(
        DateTime.now().millisecondsSinceEpoch, name, 0, target);
  }

  factory Tasbih.fromString(String tsbh) {
    final data = tsbh.split(_sepatator);
    return Tasbih._fromData(int.parse(data[0]), data[1], int.parse(data[2]),
        data.length < 4 ? null : int.parse(data[3]));
  }

  double get ratio {
    final target = this.target;
    return target != null ? counted / target : 0;
  }

  @override
  String toString() {
    return "$id$_sepatator$name$_sepatator$counted${target == null ? '' : '$_sepatator$target'}";
  }
}
