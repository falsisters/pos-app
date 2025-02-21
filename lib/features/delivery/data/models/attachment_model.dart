import 'package:image_picker/image_picker.dart';

class AttachmentModel {
  final String path;
  final String fileName;
  final XFile file;

  AttachmentModel({
    required this.path,
    required this.fileName,
    required this.file,
  });
}
