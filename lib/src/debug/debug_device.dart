import 'dart:io' as io;

String getPlatform() {
  if (io.Platform.isIOS) return 'iOS';
  if (io.Platform.isAndroid) return 'Android';
  return 'Other';
}
