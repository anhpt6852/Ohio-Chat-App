import 'package:dartz/dartz.dart';
import 'package:ohio_chat_app/core/results/failures.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void processUsecaseResult(
    {required Either<Failure, dynamic> result,
    Function(dynamic)? onSuccess,
    bool Function(Failure)? shouldShowFailure,
    RefreshController? refreshController,
    bool isRefreshing = true}) {
  result.fold((failure) {
    bool shoudShow = true;
    if (shouldShowFailure != null) {
      shoudShow = shouldShowFailure(failure);
    }
    if (shoudShow) {
      // Show snack bar or dialog error
    }

    if (refreshController != null) {
      isRefreshing
          ? refreshController.refreshFailed()
          : refreshController.loadFailed();
    }
  }, (data) {
    if (onSuccess != null) {
      onSuccess(data);
    }
    if (refreshController != null) {
      if (isRefreshing) {
        refreshController.refreshCompleted(resetFooterState: true);
      } else {
        if (data is List && data.isEmpty) {
          refreshController.loadNoData();
        } else {
          refreshController.loadComplete();
        }
      }
    }
  });
}
