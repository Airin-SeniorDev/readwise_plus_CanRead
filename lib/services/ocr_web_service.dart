import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

class OCRWebService {
  // 🔑 ใส่ API Key ที่คุณได้มาแทน YOUR_API_KEY
  static const String _apiKey = 'K83611259588957'; // <-- แก้ตรงนี้

  static Future<String> scanImage(Uint8List imageBytes) async {
    final uri = Uri.parse('https://api.ocr.space/parse/image');

    final request =
        http.MultipartRequest('POST', uri)
          ..fields['apikey'] = _apiKey
          ..fields['language'] = 'eng'
          ..files.add(
            http.MultipartFile.fromBytes(
              'file',
              imageBytes,
              filename: 'upload.png',
            ),
          );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    final result = json.decode(response.body);

    if (result['IsErroredOnProcessing'] == false) {
      return result['ParsedResults'][0]['ParsedText'] ?? 'ไม่พบข้อความในภาพ';
    } else {
      return '❌ OCR Failed: ${result['ErrorMessage'] ?? 'Unknown error'}';
    }
  }
}
