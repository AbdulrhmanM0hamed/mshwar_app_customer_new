// import '../../../ios/features/auth/data/models/refresh_token_request_model.dart';
// import '../../../ios/features/auth/data/repo/auth_repository.dart';
// import 'app_state_service.dart';

// /// Helper class to handle token refresh logic
// class TokenRefreshHelper {
//   final AuthRepository _authRepository;
//   final AppStateService _appStateService;

//   TokenRefreshHelper(this._authRepository, this._appStateService);

//   /// Check if access token is expired and refresh if needed
//   Future<bool> ensureValidToken() async {
//     // Check if access token is expired
//     if (!await _appStateService.isAccessTokenExpired()) {
//       return true; // Token is still valid
//     }

//     // Check if refresh token is expired
//     if (await _appStateService.isRefreshTokenExpired()) {
//       // Both tokens expired, user needs to login again
//       await _appStateService.clearTokens();
//       await _appStateService.setLoggedIn(false);
//       return false;
//     }

//     // Refresh the token
//     return await _refreshAccessToken();
//   }

//   /// Refresh the access token using refresh token
//   Future<bool> _refreshAccessToken() async {
//     final refreshToken = _appStateService.getRefreshToken();
//     final fcmToken = _appStateService.getFcmToken();

//     if (refreshToken == null) {
//       return false;
//     }

//     final request = RefreshTokenRequestModel(
//       refreshToken: refreshToken,
//       firebaseToken: fcmToken ?? 'default_token',
//       deviceType: 'android',
//     );

//     final result = await _authRepository.refreshToken(request: request);

//     return result.when(
//       success: (response) async {
//         // Save new tokens
//         final tokens = response.data.data.tokens;
//         await _appStateService.saveTokens(
//           accessToken: tokens.accessToken,
//           refreshToken: tokens.refreshToken,
//           accessTokenExpiresAt: tokens.accessTokenExpiresAt,
//           refreshTokenExpiresAt: tokens.refreshTokenExpiresAt,
//           tokenType: tokens.tokenType,
//         );
//         return true;
//       },
//       failure: (_) async {
//         // Refresh failed, clear tokens and logout
//         await _appStateService.clearTokens();
//         await _appStateService.setLoggedIn(false);
//         return false;
//       },
//     );
//   }
// }
