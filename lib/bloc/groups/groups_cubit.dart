import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import '../../repository/user/groups_courses/groups_courses_repository.dart';
import '../../model/user/groups_courses/groups_courses_model.dart';
part 'groups_state.dart';

class GroupsCubit extends Cubit<GroupsState> {
  GroupsCubit(this.showProviderRepository) : super(GroupsInitial());
  static GroupsCubit get(BuildContext context) => BlocProvider.of(context);
  GroupModelRepository showProviderRepository;

  double? lat;
  double? lng;
  String? address;

  initAddress(int type, String? location) async {
    if (type == 1 && location != null && location.contains(',')) {
      try {
        List<String> locationDetails = location.split(',');
        lat = double.tryParse(locationDetails[0].trim());
        lng = double.tryParse(locationDetails[1].trim());
        if (lat != null && lng != null) {
          List<Placemark> placeMark = await placemarkFromCoordinates(lat!, lng!);
          Placemark place = placeMark[0];
          address = "${place.locality} , ${place.name} ";
          emit(InitAddressState());
        }
      } catch (e) {
        debugPrint('initAddress error: $e');
      }
    }
  }

  getCourseGroups(int id) {
    showProviderRepository.groupsCourses(id).then((value) {
      emit(GroupsLoaded(data: value.groupModel));
    });
  }
}
