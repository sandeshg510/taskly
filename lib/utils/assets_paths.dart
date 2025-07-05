const String _images = "assets/images"; // * Path to the images folder

class ImagePaths {
  static ImagePaths instance =
      ImagePaths(); // * A singleton instance of the class to be used all over the project codebase

  final String brandLogo = "$_images/taskly.png";
}
