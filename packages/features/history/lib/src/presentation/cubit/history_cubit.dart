import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:history/src/domain/load_history_use_case.dart';
import 'package:history/src/domain/models/short_url.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'history_state.dart';

@injectable
class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit(this._loadUseCase) : super(HistoryInitial());

  final LoadHistoryUseCase _loadUseCase;
  StreamSubscription<List<ShortUrl>>? _subscription;

  Future<void> load() async {
    emit(HistoryLoading());
    await Future.delayed(const Duration(seconds: 2)); // Simulate loading

    _subscription = _loadUseCase.call().listen((urls) {
      emit(HistoryLoaded(urls));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
