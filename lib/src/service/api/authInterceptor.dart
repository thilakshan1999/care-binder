

import 'dart:async';

import 'package:http/http.dart';
import 'package:http_interceptor/models/interceptor_contract.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../bloc/userBloc.dart';
import 'httpService.dart';

class AuthInterceptor implements InterceptorContract {
  final UserBloc userBloc;
  final HttpService httpService;

  AuthInterceptor(this.userBloc, this.httpService);

  @override
  FutureOr<BaseRequest> interceptRequest({required BaseRequest request}) async {
    var accessToken = userBloc.state.accessToken;
    var refreshToken = userBloc.state.refreshToken;

    if (accessToken != null && refreshToken != null) {
      if (JwtDecoder.isExpired(accessToken)) {
        try {
          final refreshResponse = await httpService.userService.refreshToken(refreshToken);

          if (refreshResponse.success) {
            final newAccessToken = refreshResponse.data?.accessToken;
            final newRefreshToken = refreshResponse.data?.refreshToken;

            userBloc.setUserFromToken(newAccessToken!, newRefreshToken!);
            accessToken = newAccessToken;
          } else {
            userBloc.clear();
          }
        } catch (e) {
          userBloc.clear();
        }
      }

      // Always attach Authorization
      if (accessToken != null) {
        request.headers["Authorization"] = "Bearer $accessToken";
      }
    }

    return request;
  }

  @override
  FutureOr<BaseResponse> interceptResponse({required BaseResponse response}) async {
    // Optional: Handle 401 → force logout if server rejects even after refresh
    if (response.statusCode == 401) {
      userBloc.clear();
    }
    return response;
  }

  @override
  bool shouldInterceptRequest() => true;

  @override
  bool shouldInterceptResponse() => true;
}
