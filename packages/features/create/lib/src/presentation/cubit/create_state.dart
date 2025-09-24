part of 'create_cubit.dart';

@immutable
sealed class CreateState {}

final class CreateInitial extends CreateState {}

final class CreateLoading extends CreateState {}

final class CreateSuccess extends CreateState {
  final ShortUrl shortenedUrl;

  CreateSuccess(this.shortenedUrl);
}

final class CreateError extends CreateState {
  final String message;

  CreateError(this.message);
}
