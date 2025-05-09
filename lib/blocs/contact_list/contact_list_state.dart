// lib/blocs/contact_list/contact_list_state.dart
part of 'contact_list_bloc.dart';

abstract class ContactListState {
  const ContactListState();
}

class InitialContactListState extends ContactListState {
  const InitialContactListState();
}

class EmptyContactListState extends ContactListState {
  const EmptyContactListState();
}

class LoadingContactListState extends ContactListState {
  const LoadingContactListState();
}

class LoadedContactListState extends ContactListState {
  final List<Contact> originalContacts; // Full list from repository
  final List<Contact> displayedContacts; // Filtered/Searched list for UI
  final ContactListSortField sortField;
  final bool ascending;
  final String searchTerm; // Current search term
  final Set<ContactListFilterType> activeFilters; // Changed to Set of filters
  
  const LoadedContactListState({
    required this.originalContacts,
    required this.displayedContacts,
    this.sortField = ContactListSortField.nextContactDate,
    this.ascending = true,
    this.searchTerm = '',
    this.activeFilters = const {}, // Default to empty set
  });
  
  LoadedContactListState copyWith({
    List<Contact>? originalContacts,
    List<Contact>? displayedContacts,
    ContactListSortField? sortField,
    bool? ascending,
    String? searchTerm,
    Set<ContactListFilterType>? activeFilters,
  }) {
    return LoadedContactListState(
      originalContacts: originalContacts ?? this.originalContacts,
      displayedContacts: displayedContacts ?? this.displayedContacts,
      sortField: sortField ?? this.sortField,
      ascending: ascending ?? this.ascending,
      searchTerm: searchTerm ?? this.searchTerm,
      activeFilters: activeFilters ?? this.activeFilters,
    );
  }
}

class ErrorContactListState extends ContactListState {
  final String message;
  
  const ErrorContactListState(this.message);
}