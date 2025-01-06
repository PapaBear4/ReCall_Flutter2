part of 'contact_details_bloc.dart';

@freezed
class ContactDetailsState with _$ContactDetailsState {
  const factory ContactDetailsState.initial() = ContactDetailsIntial;
  const factory ContactDetailsState.loading() = ContactDetailsLoading;
  const factory ContactDetailsState.loaded(Contact contact) =
      ContactDetailsLoaded;
  const factory ContactDetailsState.error(String message) = ContactDetailsError;
}
