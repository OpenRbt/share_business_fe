import 'package:share_buisness_front_end/api_client/api.dart';

class Common {
  static OrganizationsApi? organizationApi;
  static ServerGroupsApi? serverGroupApi;
  static SessionsApi? sessionApi;
  static StandardApi? standardApi;
  static UsersApi? userApi;
  static WalletsApi? walletApi;
  static WashServersApi? washServerApi;

  static SetAuthToken(String idToken) {
    (Common.organizationApi!.apiClient.authentication as HttpBearerAuth).accessToken = idToken;
    (Common.serverGroupApi!.apiClient.authentication as HttpBearerAuth).accessToken = idToken;
    (Common.sessionApi!.apiClient.authentication as HttpBearerAuth).accessToken = idToken;
    (Common.standardApi!.apiClient.authentication as HttpBearerAuth).accessToken = idToken;
    (Common.userApi!.apiClient.authentication as HttpBearerAuth).accessToken = idToken;
    (Common.walletApi!.apiClient.authentication as HttpBearerAuth).accessToken = idToken;
    (Common.washServerApi!.apiClient.authentication as HttpBearerAuth).accessToken = idToken;
  }

  static void initializeApis (String url) {
    Common.organizationApi = OrganizationsApi(ApiClient(
        authentication: HttpBearerAuth(),
        basePath: url
    ));
    Common.serverGroupApi = ServerGroupsApi(ApiClient(
        authentication: HttpBearerAuth(),
        basePath: url
    ));
    Common.sessionApi = SessionsApi(ApiClient(
        authentication: HttpBearerAuth(),
        basePath: url
    ));
    Common.standardApi = StandardApi(ApiClient(
        authentication: HttpBearerAuth(),
        basePath: url
    ));
    Common.userApi = UsersApi(ApiClient(
        authentication: HttpBearerAuth(),
        basePath: url
    ));
    Common.walletApi = WalletsApi(ApiClient(
        authentication: HttpBearerAuth(),
        basePath: url
    ));
    Common.washServerApi = WashServersApi(ApiClient(
        authentication: HttpBearerAuth(),
        basePath: url
    ));
  }
}