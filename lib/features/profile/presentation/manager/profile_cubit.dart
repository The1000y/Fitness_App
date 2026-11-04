import 'package:injectable/injectable.dart';

import '../../../../config/base/base_cubit.dart';
import '../../../../config/base/base_ui_event.dart';
import 'profile_state.dart';

@injectable
class ProfileCubit extends BaseCubit<ProfileState, CommonUiEvent> {
  ProfileCubit(super.initialState);
 
}

