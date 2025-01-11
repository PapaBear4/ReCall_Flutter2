import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:recall/blocs/contact_details/contact_details_bloc.dart';
import 'package:recall/models/contact.dart';
import 'package:recall/screens/contact_details_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MockContactDetailsBloc extends Mock implements ContactDetailsBloc {}

void main() {
  late MockContactDetailsBloc mockContactDetailsBloc;

  setUp(() {
    mockContactDetailsBloc = MockContactDetailsBloc();
  });

  Widget makeTestableWidget({required Widget child}) {
    return MaterialApp(
      home: BlocProvider<ContactDetailsBloc>(
        create: (context) => mockContactDetailsBloc,
        child: child,
      ),
    );
  }

  group('ContactDetailsScreen', () {
    testWidgets('renders correctly when contactId is null',
        (WidgetTester tester) async {
      when(mockContactDetailsBloc.state)
          .thenReturn(ContactDetailsState.initial());

      await tester.pumpWidget(
          makeTestableWidget(child: ContactDetailsScreen(contactId: null)));

      expect(find.text('Contact Details'), findsOneWidget);
      expect(find.text('No Contact Selected'), findsOneWidget);
      verify(mockContactDetailsBloc
              .add(const ContactDetailsEvent.loadContact(contactId: null)))
          .called(1);
    });

    testWidgets('renders correctly when contactId is zero',
        (WidgetTester tester) async {
      when(mockContactDetailsBloc.state)
          .thenReturn(ContactDetailsState.initial());

      await tester.pumpWidget(
          makeTestableWidget(child: ContactDetailsScreen(contactId: 0)));

      expect(find.text('Contact Details'), findsOneWidget);
      expect(find.text('No Contact Selected'), findsOneWidget);
      verify(mockContactDetailsBloc
              .add(const ContactDetailsEvent.loadContact(0)))
          .called(1);
    });

    testWidgets('renders correctly when a valid contactId is passed',
        (WidgetTester tester) async {
      const contactId = 1;
      final contact = Contact(
          id: contactId,
          firstName: 'John',
          lastName: 'Doe',
          phoneNumber: '123-456-7890');
      when(mockContactDetailsBloc.state)
          .thenReturn(ContactDetailsState.loaded(contact: contact));

      await tester.pumpWidget(makeTestableWidget(
          child: ContactDetailsScreen(contactId: contactId)));

      expect(find.text('Contact Details'), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('123-456-7890'), findsOneWidget);

      verify(mockContactDetailsBloc
              .add(const ContactDetailsEvent.loadContact(contactId:null)))
          .called(1);
    });
  });
}
