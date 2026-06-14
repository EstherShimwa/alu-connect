import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_alu_connect/services/rsvp_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('RSVP Service initial state', () async {
    final service = RsvpService.instance;
    await service.init();
    expect(service.isRegistered('1'), false);
    expect(service.registrations.isEmpty, true);
  });

  test('RSVP Service registration and cancellation flow', () async {
    final service = RsvpService.instance;
    await service.init();

    final registrationData = {
      'name': 'Jane Doe',
      'email': 'j.doe@alustudent.com',
      'cohort': 'Software Engineering',
      'tshirtSize': 'M',
      'needsTransport': true,
      'motivation': 'Excited to attend the hackathon!',
    };

    // Register
    await service.register('1', registrationData);
    expect(service.isRegistered('1'), true);
    expect(service.getRegistrationDetails('1')?['name'], 'Jane Doe');
    expect(service.getRegistrationDetails('1')?['needsTransport'], true);

    // Cancel
    await service.cancelRsvp('1');
    expect(service.isRegistered('1'), false);
    expect(service.getRegistrationDetails('1'), null);
  });
}
