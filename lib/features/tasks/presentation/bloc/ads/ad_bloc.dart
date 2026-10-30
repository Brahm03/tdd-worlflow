import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:task_app/core/usecases/usecase.dart';
import 'package:task_app/features/tasks/domain/usecases/get_ads_usecase.dart';
import 'package:task_app/features/tasks/presentation/bloc/ads/ad_event.dart';
import 'package:task_app/features/tasks/presentation/bloc/ads/ad_state.dart';


@injectable
class AdBloc extends Bloc<AdEvent, AdState> {
  final GetAdsUsecase getAdsUsecase;

  AdBloc(this.getAdsUsecase) : super(AdState(status: AdStatus.loading)) {
    on<GetAdsEvent>((event, emit) async {
      // * logic here
      await Future.delayed(Duration(seconds: 3));
      emit(state.copyWith(status: AdStatus.loading));
      final result = await getAdsUsecase.call(NoParams());
      if (result.isRight) {
        emit(state.copyWith(status: AdStatus.success, data: result.right));
      } else {
        emit(state.copyWith(
            status: AdStatus.error, errorText: result.left.message));
      }
    });
    on<SwitchOffAdEvent>((event, emit) {
      
    });
  }
}
