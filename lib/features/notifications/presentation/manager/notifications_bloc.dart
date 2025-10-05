// import 'dart:async';
// import 'package:bloc_concurrency/bloc_concurrency.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:injectable/injectable.dart';
// import 'package:wolfera/common/models/page_state/bloc_status.dart';

// import 'package:wolfera/features/notifications/presentation/manager/notifications_viewmodel.dart';
// import 'package:stream_transform/stream_transform.dart';
// import '../../../profile/presentation/manager/profile_cubit.dart';

// part 'notifications_event.dart';

// part 'notifications_state.dart';

// EventTransformer<E> _throttleDroppable<E>(
//     {Duration duration = const Duration(milliseconds: 500)}) {
//   return (events, mapper) {
//     return droppable<E>().call(events.throttle(duration), mapper);
//   };
// }

// @lazySingleton
// class NotificationsBloc
//     extends Bloc<NotificationsBlocEvent, NotificationsState> {
//   final ProfileBloc profileBloc;
//   final GetNotificationsUsecase _getNotificationsUsecase;
//   final ReadAllNotificationsUsecase _readAllNotificationsUsecase;
//   final ReadNotificationUsecase _readNotificationUsecase;
//   NotificationsBloc(
//     this.profileBloc,
//     this._getNotificationsUsecase,
//     this._readNotificationUsecase,
//     this._readAllNotificationsUsecase,
//   ) : super(NotificationsState()) {
//     on<ReadNotificationEvent>(_onReadNotificationEvent);
//     on<ReadAllNotificationsEvent>(_onReadAllNotificationsEvent);
//     on<GetNotificationsEvent>(_onGetNotifications);
//   }

//   final PagingController<int, NotificationViewModel> notificationController =
//       PagingController(firstPageKey: 1, invisibleItemsThreshold: 5);

//   FutureOr<void> _onGetNotifications(
//       GetNotificationsEvent event, Emitter<NotificationsState> emit) async {
//     final response =
//         await _getNotificationsUsecase(GetNotificationParams(page: event.page));

//     response.fold(
//       (exception, message) => notificationController.error = exception,
//       (value) {
//         if (value.hasReachedMax) {
//           notificationController.appendLastPage(value.data!
//               .map((e) => NotificationViewModel(notification: e))
//               .toList());
//         } else {
//           notificationController.appendPage(
//               value.data!
//                   .map((e) => NotificationViewModel(notification: e))
//                   .toList(),
//               event.page + 1);
//         }
//       },
//     );
//   }

//   FutureOr<void> _onReadNotificationEvent(
//       ReadNotificationEvent event, Emitter<NotificationsState> emit) async {
//     event.notificationViewModel.isRead.value = true;

//     final response = await _readNotificationUsecase(
//         event.notificationViewModel.notification.id);

//     response.fold(
//       (exception, message) {
//         EasyLoading.showError(
//           "Something went wrong!",
//           duration: const Duration(seconds: 2),
//           dismissOnTap: true,
//         );
//         return event.notificationViewModel.isRead.value = false;
//       },
//       (value) => null,
//     );
//   }

//   FutureOr<void> _onReadAllNotificationsEvent(
//       ReadAllNotificationsEvent event, Emitter<NotificationsState> emit) async {
//     try {
//       EasyLoading.show(
//         status: "Loading...",
//         dismissOnTap: false,
//       );

//       final response = await _readAllNotificationsUsecase();

//       response.fold(
//         (exception, message) {
//           EasyLoading.dismiss();
//           EasyLoading.showError(
//             "Something went wrong!",
//             duration: const Duration(seconds: 2),
//             dismissOnTap: true,
//           );
//         },
//         (value) {
//           EasyLoading.dismiss();
//           _readAllNotification();
//         },
//       );
//     } catch (e) {
//       EasyLoading.dismiss();
//     }
//   }

//   void _readAllNotification() {
//     notificationController.itemList?.forEach((element) {
//       element.isRead.value = true;
//     });
//   }
// }
