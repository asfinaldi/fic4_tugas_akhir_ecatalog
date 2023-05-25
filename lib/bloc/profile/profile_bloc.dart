import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:platzi_fake_store_app/data/datasources/auth_datasources.dart';
import 'package:platzi_fake_store_app/data/models/response/profile_response_model.dart';



part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthDatasource authDatasource;
  ProfileBloc(
    this.authDatasource,
  ) : super(ProfileInitial()) {
    on<GetProfileEvent>((event, emit) async {
      try {
        emit(ProfileLoading());
        final result = await authDatasource.getProfile();
        emit(ProfileLoaded(profile: result));
      } catch (e) {
        emit(ProfileError(message: 'network problem: ${e.toString()}'));
      }
    });
  }
}
