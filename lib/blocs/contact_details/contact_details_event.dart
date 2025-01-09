part of 'contact_details_bloc.dart';

@freezed
class ContactDetailsEvent with _$ContactDetailsEvent {
  const factory ContactDetailsEvent.loadContact(int contactId) = LoadContact;
  const factory ContactDetailsEvent.saveContactDetails(Contact updatedContact) =
      SaveContactDetails;
  const factory ContactDetailsEvent.updateContactDetails(
      Contact updatedContact) = UpdateContactDetails;
  const factory ContactDetailsEvent.updateBirthday(
      {required DateTime? birthday, required int contactId}) = UpdateBirthday;
  const factory ContactDetailsEvent.startNewContact() = StartNewContact;
  const factory ContactDetailsEvent.addNewContact(Contact newContact) =
      AddNewContact;
}
