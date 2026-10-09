import 'package:krate_lab/core/api/api_payload.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('asList handles double-wrapped pagination', () {
    final wrapped = {
      'success': true,
      'data': {
        'count': 10,
        'next': null,
        'previous': null,
        'results': [
          {'id': 1, 'first_name': 'Ali', 'last_name': 'Alev'},
          {'id': 2, 'first_name': 'Aziz', 'last_name': 'Yusupov'},
        ],
      },
    };
    final list = ApiPayload.asList(wrapped);
    expect(list.length, 2);
    expect(list.first['firstName'], 'Ali'); // snake_case -> camelCase
    expect(list.first['id'], 1);
  });

  test('asList handles plain list', () {
    final plain = [
      {'id': 1, 'name': 'UJT'},
      {'id': 2, 'name': 'MJT'},
    ];
    expect(ApiPayload.asList(plain).length, 2);
  });
}
