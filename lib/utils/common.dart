import 'package:share_buisness_front_end/api_client/api.dart';

class Common {
  static UserApi? userApi;
  static SessionApi? sessionApi;

  static SetAuthToken(String idToken) {
    (Common.userApi!.apiClient.authentication as HttpBearerAuth).accessToken = idToken;
    (Common.sessionApi!.apiClient.authentication as HttpBearerAuth).accessToken = idToken;
  }
}