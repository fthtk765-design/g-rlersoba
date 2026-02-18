import 'package:flutter_test/flutter_test.dart';

import 'package:shared/shared.dart';

void main() {
  test('sanitizePhoneDigits sadece rakam bırakır', () {
    expect(sanitizePhoneDigits('+90 (555) 123 45 67'), '905551234567');
  });
}
