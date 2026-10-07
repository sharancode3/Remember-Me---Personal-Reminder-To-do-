import 'package:flutter_test/flutter_test.dart';
import 'package:remember_me/src/core/utils/natural_language_parser.dart';

void main() {
  final refDate = DateTime(2026, 8, 29, 10, 0);

  test('Parses title with time range "Study physics 7 to 9"', () {
    final result = NaturalLanguageTaskParser.parse(
      'Study physics 7 to 9',
      referenceTime: refDate,
    );
    expect(result.title, 'Study physics');
    expect(result.startAt.hour, 7);
    expect(result.endAt.hour, 9);
    expect(result.durationMinutes, 120);
  });

  test('Parses tomorrow with duration "Read book tomorrow 45m"', () {
    final result = NaturalLanguageTaskParser.parse(
      'Read book tomorrow 45m',
      referenceTime: refDate,
    );
    expect(result.title, 'Read book');
    expect(result.startAt.day, 30);
    expect(result.durationMinutes, 45);
  });

  test('Parses high priority and tag "Gym #fitness !high 1h at 6pm"', () {
    final result = NaturalLanguageTaskParser.parse(
      'Gym #fitness !high 1h at 6pm',
      referenceTime: refDate,
    );
    expect(result.title, 'Gym');
    expect(result.tag, 'fitness');
    expect(result.priority, 2);
    expect(result.startAt.hour, 18);
    expect(result.durationMinutes, 60);
  });
}
