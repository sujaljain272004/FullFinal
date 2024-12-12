import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerService {
  final Function(String) onQRCodeScanned;
  MobileScannerController? _controller;
  bool _isScanning = false;

  QRScannerService({required this.onQRCodeScanned});

  Widget buildQRScanner() {
    _controller ??= MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
    );

    return MobileScanner(
      controller: _controller!,
      onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        if (barcodes.isNotEmpty && barcodes[0].rawValue != null) {
          onQRCodeScanned(barcodes[0].rawValue!);
        }
      },
    );
  }

  void toggleFlashlight(bool enabled) {
    _controller?.toggleTorch();
  }

  void startScanning() {
    if (!_isScanning && _controller != null) {
      _controller!.start();
      _isScanning = true;
    }
  }

  void stopScanning() {
    if (_isScanning && _controller != null) {
      _controller!.stop();
      _isScanning = false;
    }
  }

  void dispose() {
    stopScanning();
    _controller?.dispose();
    _controller = null;
  }
} 