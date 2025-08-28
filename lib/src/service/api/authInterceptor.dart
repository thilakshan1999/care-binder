import 'dart:async';

import 'package:care_sync/src/service/api/apiHelper.dart';
import 'package:flutter/material.dart';
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
    if (request.url.path.endsWith("/users/refresh-token")) {
      return request;
    }
    var accessToken = userBloc.state.accessToken;
    var refreshToken = userBloc.state.refreshToken;

    if (accessToken != null && refreshToken != null) {
      if (JwtDecoder.isExpired(accessToken)) {
        debugPrint('Access token expired');
        try {
          final refreshResponse =
              await httpService.userService.refreshToken(refreshToken);

          if (refreshResponse.success) {
            final newAccessToken = refreshResponse.data?.accessToken;
            final newRefreshToken = refreshResponse.data?.refreshToken;

            userBloc.setUserFromToken(newAccessToken!, newRefreshToken!);
            accessToken = newAccessToken;
          } else {
            throw AuthException("Refresh token failed");
          }
        } catch (e) {
          throw AuthException("Token refresh error: $e");
        }
      }

      // Always attach Authorization
      request.headers["Authorization"] = "Bearer $accessToken";
      debugPrint('Bearer $accessToken');
    }

    return request;
  }

  @override
  FutureOr<BaseResponse> interceptResponse(
      {required BaseResponse response}) async {
    if (response.statusCode == 401) {
      throw AuthException("Unauthorized (401)");
    }
    return response;
  }

  @override
  bool shouldInterceptRequest() => true;

  @override
  bool shouldInterceptResponse() => true;
}
