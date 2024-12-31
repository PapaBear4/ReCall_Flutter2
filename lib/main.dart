import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ReCall/blocs/contact_list/contact_list_bloc.dart';
import 'package:ReCall/repositories/contact_repository.dart';
import 'package:ReCall/screens/contact_list_screen.dart';

void main() {
  runApp(const ReCall());
}

class ReCall extends StatelessWidget {
  const ReCall({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ContactRepository(),
      child: BlocProvider(
        create: (context) => ContactListBloc(
          contactRepository: RepositoryProvider.of<ContactRepository>(context),
        )..add(LoadContacts()),
        child: MaterialApp(
          title: 'Contact App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const ContactListScreen(),
        ),
      ),
    );
  }
}
