import 'dart:io';
import 'package:http/io_client.dart';
import 'package:flutter/services.dart' show rootBundle;

class SslPinning {
  static Future<IOClient> createPinnedClient() async {
    final context = SecurityContext(withTrustedRoots: false);
    // Ganti path sertifikat sesuai lokasi file .cer kamu di assets
    final certBytes = await rootBundle.load(
      'assets/certificates/themoviedb.org.pem',
    );
    context.setTrustedCertificatesBytes(certBytes.buffer.asUint8List());
    final httpClient = HttpClient(context: context);
    return IOClient(httpClient);
  }
}
