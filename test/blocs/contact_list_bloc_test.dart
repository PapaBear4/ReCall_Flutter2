import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recall/blocs/contact_list/contact_list_bloc.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/models/contact_frequency.dart';
import 'package:recall/repositories/contact_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'contact_list_bloc_test.mocks.dart';

@GenerateMocks([ContactRepository])
void main() {
  group('ContactListBloc', () {
    blocTest<ContactListBloc, ContactListState>(
      'emits initial state',
      build: () {
        final mockContactRepository = MockContactRepository();
        return ContactListBloc(contactRepository: mockContactRepository);
      },
      expect: () => [const ContactListState.initial()],
    );

    blocTest<ContactListBloc, ContactListState>(
      'calls getAllContacts when ContactListEvent.loadContacts is added',
      build: () {
        final contactRepository = MockContactRepository();
        when(contactRepository.getAll()).thenAnswer((_) async => []);
        return ContactListBloc(contactRepository: contactRepository);
      },
      act: (bloc) => bloc.add(const ContactListEvent.loadContacts()),
      expect: () => [
        ContactListState.loading(),
        ContactListState.empty(),
      ],
    );

    blocTest<ContactListBloc, ContactListState>(
      'emits loaded state with contacts when repository returns contacts',
      build: () {
        final mockContactRepository = MockContactRepository();
        final mockContacts = [
          Contact(
            id: 1,
            firstName: 'John',
            lastName: 'Doe',
            frequency: ContactFrequency.daily.value,
            birthday: DateTime(1990, 1, 1),
            lastContacted: DateTime.now(),
          ),
          Contact(
            id: 2,
            firstName: 'Jane',
            lastName: 'Doe',
            frequency: ContactFrequency.weekly.value,
            birthday: DateTime(1992, 5, 10),
            lastContacted: DateTime.now().subtract(const Duration(days: 7)),
          ),
        ];
        when(mockContactRepository.getAll())
            .thenAnswer((_) async => mockContacts);
        return ContactListBloc(contactRepository: mockContactRepository);
      },
      act: (bloc) => bloc.add(const ContactListEvent.loadContacts()),
      expect: () => [
        ContactListState.loading(),
        ContactListState.loaded(contacts: mockContacts),
      ],
    );

    blocTest<ContactListBloc, ContactListState>(
      'emits error state when repository throws an error',
      build: () {
        final contactRepository = MockContactRepository();
        when(contactRepository.getAll())
            .thenThrow(Exception('Failed to load contacts'));
        return ContactListBloc(contactRepository: contactRepository);
      },
      act: (bloc) => bloc.add(const ContactListEvent.loadContacts()),
      expect: () => [
        ContactListState.loading(),
        ContactListState.error('failed to load contact'),
      ],
    );
  });
}
