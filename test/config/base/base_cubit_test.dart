import 'package:fitness_app/config/base/base_cubit.dart';
import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:flutter_test/flutter_test.dart';

class TestUiEvent extends BaseUiEvent {
  final String text;
  const TestUiEvent(this.text);
}

class TestCubit extends BaseCubit<int, TestUiEvent> {
  TestCubit() : super(0);

  void triggerEvent(String text) {
    emitEvent(TestUiEvent(text));
  }
}

void main() {
  group('BaseCubit', () {
    late TestCubit cubit;

    setUp(() {
      cubit = TestCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('emits events through uiEventStream', () async {
      final events = <TestUiEvent>[];
      final subscription = cubit.uiEventStream.listen(events.add);

      cubit.triggerEvent('First');
      cubit.triggerEvent('Second');

      await Future.delayed(Duration.zero);

      expect(events.length, equals(2));
      expect(events[0].text, equals('First'));
      expect(events[1].text, equals('Second'));

      await subscription.cancel();
    });

    test('emitEvent does not throw after close', () async {
      await cubit.close();
      expect(() => cubit.triggerEvent('Ignored'), returnsNormally);
    });
  });
}
