import 'package:care_sync/src/bloc/userBloc.dart';
import 'package:care_sync/src/component/appBar/appBar.dart';
import 'package:care_sync/src/component/errorBox/ErrorBox.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import '../../component/apiHandler/apiHandler.dart';
import '../../component/snakbar/customSnakbar.dart';
import '../../service/api/httpService.dart';
import '../../theme/customColors.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen>
    with WidgetsBindingObserver {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late final HttpService httpService;
  QRViewController? controller;
  bool isScanned = false;
  bool hasPermission = false;
  bool isLoading = true;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkCameraPermission();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      httpService = HttpService(context.read<UserBloc>());

      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (controller != null) {
      if (state == AppLifecycleState.inactive ||
          state == AppLifecycleState.paused) {
        controller!.pauseCamera();
      } else if (state == AppLifecycleState.resumed) {
        controller!.resumeCamera();
      }
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    // For hot reload on Android/iOS
    if (controller != null) {
      if (defaultTargetPlatform == TargetPlatform.android) {
        controller!.pauseCamera();
      } 
      debugPrint("Resuming camera after reassemble");
      controller!.resumeCamera();
    }
  }

 Future<void> _checkCameraPermission() async {
  final status = await Permission.camera.status;
  debugPrint('Current Camera Permission Status 1: $status');

  final newStatus = await Permission.camera.request();
  debugPrint('Requested Camera Permission Status: $newStatus');

  setState(() {
    hasPermission = newStatus.isGranted;
    isLoading = false;
  });
}


  void onQRViewCreated(QRViewController ctrl) {
    controller = ctrl;
    controller!.scannedDataStream.listen((scanData) {
      if (!isScanned && scanData.code != null) {
        setState(() => isScanned = true);
        controller!.pauseCamera();

        CustomSnackbar.showCustomSnackbar(
          context: context,
          message: "QR Scanned Successfully",
          backgroundColor: Theme.of(context).extension<CustomColors>()!.success,
        );

        linkViaQr(scanData.code!);
      }
    }, onError: (err) {
      debugPrint("QR Scan Error: $err");
      setState(() => isScanned = false);
      controller?.resumeCamera();
      CustomSnackbar.showCustomSnackbar(
        context: context,
        message: "Error scanning QR",
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    });
  }

  Future<void> linkViaQr(String qrToken) async {
    setState(() => isLoading = true);

    await ApiHandler.handleApiCall<void>(
      context: context,
      request: () => httpService.careGiverRequestService.linkViaQr(qrToken),
      onSuccess: (_, msg) {
        CustomSnackbar.showCustomSnackbar(
          context: context,
          message: msg,
          backgroundColor: Theme.of(context).extension<CustomColors>()!.success,
        );
        Navigator.of(context).pop(true);
      },
      onError: (errMsg, errTittle) {
        setState(() => isScanned = false);
        controller?.resumeCamera();
        CustomSnackbar.showCustomSnackbar(
          context: context,
          message: errMsg ?? "Failed to link via QR",
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      },
      onFinally: () => setState(() => isLoading = false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        tittle: "Scan QR",
        showProfile: false,
        showBackButton: !isLoading,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : !hasPermission
              ? const ErrorBox(
                  title: "Camera permission required",
                  message: "Camera permission is required to scan QR codes.")
              : Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      flex: 5,
                      child: QRView(
                        key: qrKey,
                        onQRViewCreated: onQRViewCreated,
                        overlay: QrScannerOverlayShape(
                          borderColor: Colors.blue,
                          borderRadius: 10,
                          borderLength: 30,
                          borderWidth: 8,
                          cutOutSize: 250,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.qr_code_scanner),
                          label: const Text("Rescan"),
                          onPressed: () async {
                            await controller?.resumeCamera();
                            setState(() => isScanned = false);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
