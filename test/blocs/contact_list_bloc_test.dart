import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/blocs/contact_list/contact_list_bloc.dart';
import 'package:myapp/blocs/contact_list/contact_list_state.dart';

void main() {
  group('ContactListBloc', () {
    blocTest<ContactListBloc, ContactListState>(
      'emits initial state',
      build: () => ContactListBloc(),
      expect: () => [
         const ContactListState.initial()
      ],
    );
  });
}