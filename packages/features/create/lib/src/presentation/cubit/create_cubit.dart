import 'package:bloc/bloc.dart';
import 'package:create/src/domain/create_user_case.dart';
import 'package:create/src/domain/models/short_url.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'create_state.dart';

@injectable
class CreateCubit extends Cubit<CreateState> {
  CreateCubit(this._createUseCase) : super(CreateInitial());

  final CreateUseCase _createUseCase;

  Future<void> create(String url) async {
    emit(CreateLoading());
    try {
      final shortenedUrl = await _createUseCase.execute(url);
      emit(CreateSuccess(shortenedUrl));
    } catch (e) {
      emit(CreateError(e.toString()));
    }
  }
}
