import 'package:care_sync/src/bloc/userBloc.dart';
import 'package:care_sync/src/models/enums/userRole.dart';
import 'package:care_sync/src/models/user/careGiverRequest.dart';
import 'package:care_sync/src/screens/careManagement/component/requestListCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../component/apiHandler/apiHandler.dart';
import '../../../component/errorBox/ErrorBox.dart';
import '../../../component/snakbar/customSnakbar.dart';
import '../../../component/text/bodyText.dart';
import '../../../service/api/httpService.dart';
import '../../../theme/customColors.dart';

class RequestList extends StatefulWidget {
  final UserRole role;
  const RequestList({super.key, required this.role});

  @override
  State<RequestList> createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  bool isLoading = true;
  bool hasError = false;
  String? errorMessage;
  String? errorTittle;

  List<CareGiverRequest> requests = dummyCareGiverRequests;
  late final HttpService httpService;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      httpService = HttpService(context.read<UserBloc>());
      _fetchRequestList();
      _isInitialized = true;
    }
  }

  Future<void> _fetchRequestList() async {
    setState(() {
      isLoading = true;
      hasError = false;
      errorMessage = null;
      errorTittle = null;
    });
    await ApiHandler.handleApiCall<List<CareGiverRequest>>(
      context: context,
      request: () => widget.role == UserRole.CAREGIVER
          ? httpService.careGiverRequestService.getSentRequests()
          : httpService.careGiverRequestService.getReceivedRequests(),
      onSuccess: (data, _) {
        setState(() {
          requests = data;
          hasError = false;
          errorMessage = null;
          errorTittle = null;
        });
      },
      onError: (title, message) {
        setState(() {
          hasError = true;
          errorMessage = message;
          errorTittle = title;
        });
      },
      onFinally: () {
        if (mounted) {
          setState(() => isLoading = false);
        }
      },
    );
  }

  Future<void> responseRequest(int id, bool accept) async {
    setState(() => isLoading = true);

    await ApiHandler.handleApiCall<void>(
      context: context,
      request: () => accept
          ? httpService.careGiverRequestService.acceptRequest(id)
          : httpService.careGiverRequestService.rejectRequest(id),
      onSuccess: (_, msg) {
        CustomSnackbar.showCustomSnackbar(
          context: context,
          message: msg,
          backgroundColor: Theme.of(context).extension<CustomColors>()!.success,
        );
        _fetchRequestList();
      },
      onFinally: () => setState(() => isLoading = false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Skeletonizer(
          enabled: isLoading,
          child: hasError
              ? ErrorBox(
                  message: errorMessage ?? 'Something went wrong.',
                  title: errorTittle ?? 'Something went wrong.',
                  onRetry: () {
                    _fetchRequestList();
                    setState(() {
                      hasError = false;
                      errorMessage = null;
                      errorTittle = null;
                    });
                  },
                )
              : (isLoading == false && requests.isEmpty)
                  ? const Center(
                      child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: BodyText(
                        text: 'No request found yet.',
                        textAlign: TextAlign.center,
                      ),
                    ))
                  : ListView.builder(
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final request = requests[index];
                        return RequestListCard(
                          request: request,
                          role: widget.role,
                          responseRequest: (accept) {
                            responseRequest(request.id, accept);
                          },
                        );
                      },
                    ),
        ));
  }
}
