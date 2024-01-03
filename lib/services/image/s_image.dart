import 'package:shared_alrayada/server/server.dart';

class ImageService {
  ImageService._();

  static String getImageByImageServerRef(String imageRef) =>
      ServerConfigurations.getImageUrl(imageRef);
}
