sealed class ProfileEvent {
  const ProfileEvent();
}

final class LoadProfile extends ProfileEvent {
  const LoadProfile();
}

final class LogoutRequested extends ProfileEvent {
  const LogoutRequested();
}
