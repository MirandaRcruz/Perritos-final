import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

class CloudinaryService {
  static const String cloudName = 'dnp4wxja9';
  static const String uploadPreset = 'perritos_preset';

  static Future<String?> uploadImageWeb(
    Uint8List imageBytes,
  ) async {
    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );

    final request = http.MultipartRequest(
      'POST',
      url,
    );

    request.fields['upload_preset'] = uploadPreset;

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: 'perrito.jpg',
      ),
    );

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData =
          await response.stream.bytesToString();

      final data = jsonDecode(responseData);

      return data['secure_url'];
    }

    return null;
  }
}