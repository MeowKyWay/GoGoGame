import 'package:gogogame_frontend/core/interfaces/jsonable.dart';

class DiskTheme extends Jsonable {
  final String name;

  DiskTheme(this.name);

  String get blackPath => 'assets/images/disks/$name/black.png';
  String get whitePath => 'assets/images/disks/$name/white.png';

  @override
  Map<String, dynamic> toJson() {
    return {"name": name};
  }

  factory DiskTheme.fromJson(Map<String, dynamic> data) {
    return DiskTheme(data["name"]);
  }

  static List<DiskTheme> themes = [glossy, matte, solid, translucent];

  static DiskTheme get glossy => DiskTheme('glossy');
  static DiskTheme get matte => DiskTheme('matte');
  static DiskTheme get solid => DiskTheme('solid');
  static DiskTheme get translucent => DiskTheme('translucent');
}
