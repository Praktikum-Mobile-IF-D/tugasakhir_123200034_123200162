import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class UserModel extends HiveObject {
  @HiveField(0)
  String password;

  @HiveField(1)
  List<int>? favorites;

  @HiveField(2)
  String? Name;

  @HiveField(3)
  String? image;

  @HiveField(4)
  bool? subs;



  UserModel({required this.password, this.favorites, this.Name, this.image , this.subs});
}

