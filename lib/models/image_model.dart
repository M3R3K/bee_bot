import 'package:hive/hive.dart';

part 'image_model.g.dart';

@HiveType(typeId: 0)
class ImageModel extends HiveObject {
  @HiveField(0)
  String userId;

  @HiveField(1)
  String imagePath;

  @HiveField(2)
  String text;

  ImageModel({
    required this.userId,
    required this.imagePath,
    required this.text,
  });
}
