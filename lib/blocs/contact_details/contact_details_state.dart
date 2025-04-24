// lib/blocs/contact_details/contact_detals_state.dart
part of 'contact_details_bloc.dart';

@freezed
sealed class ContactDetailsState with _$ContactDetailsState {
  const factory ContactDetailsState.initial() = _Initial;
  const factory ContactDetailsState.loading() = _Loading;
  const factory ContactDetailsState.loaded(Contact contact) = _Loaded;
  const factory ContactDetailsState.cleared() = _Cleared; // State after deletion or explicit clear
  const factory ContactDetailsState.error(String message) = _Error;
}
