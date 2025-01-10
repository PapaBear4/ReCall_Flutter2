import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/blocs/contact_details/contact_details_bloc.dart';
import 'package:myapp/blocs/contact_details/contact_details_event.dart';
import 'package:myapp/blocs/contact_details/contact_details_state.dart';
import 'package:myapp/models/contact.dart';

void main() {
  group('ContactDetailsBloc', () {
    late ContactDetailsBloc contactDetailsBloc;

    setUp(() {
      contactDetailsBloc = ContactDetailsBloc();
    });

    tearDown(() {
      contactDetailsBloc.close();
    });

    test('initial state is ContactDetailsState.initial()', () {
      expect(contactDetailsBloc.state, ContactDetailsState.initial());
    });

    blocTest<ContactDetailsBloc, ContactDetailsState>(
      'emits [ContactDetailsState(contact: contact)] when ContactDetailsEvent.loadContact is added',
      build: () => contactDetailsBloc,
      act: (bloc) => bloc.add(ContactDetailsEvent.loadContact(contact: Contact(id:1, name:"test", phone:"123-456-7890"))),
      expect: () => [
        ContactDetailsState(contact: Contact(id:1, name:"test", phone:"123-456-7890")),
      ],
    );
  });
}