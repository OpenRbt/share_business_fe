import 'package:share_buisness_front_end/api_client/api.dart';

class Common {
  static SessionsApi? sessionApi;
  static StandardApi? standardApi;
  static WalletsApi? walletApi;

  static SetAuthToken(String idToken) {
    (Common.sessionApi!.apiClient.authentication as HttpBearerAuth).accessToken = idToken;
    (Common.standardApi!.apiClient.authentication as HttpBearerAuth).accessToken = idToken;
    (Common.walletApi!.apiClient.authentication as HttpBearerAuth).accessToken = idToken;
  }

  static void initializeApis (String url) {
    Common.sessionApi = SessionsApi(ApiClient(
        authentication: HttpBearerAuth(),
        basePath: url
    ));
    Common.standardApi = StandardApi(ApiClient(
        authentication: HttpBearerAuth(),
        basePath: url
    ));
    Common.walletApi = WalletsApi(ApiClient(
        authentication: HttpBearerAuth(),
        basePath: url
    ));
  }
}