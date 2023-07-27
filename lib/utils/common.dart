import 'package:share_buisness_front_end/api_client/api.dart';

class Common {
  static UsersApi? userApi;
  static SessionsApi? sessionApi;

  static SetAuthToken(String idToken) {
    (Common.userApi!.apiClient.authentication as HttpBearerAuth).accessToken = idToken;
    (Common.sessionApi!.apiClient.authentication as HttpBearerAuth).accessToken = idToken;
  }
}