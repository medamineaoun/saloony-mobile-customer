import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ToastService {
  static final FToast _fToast = FToast();

  static void init(BuildContext context) {
    _fToast.init(context);
  }

  static void showSuccess(BuildContext context, String message) {
    _fToast.init(context);
    _fToast.showToast(
      child: _buildToastWidget(
        message: message,
        icon: Icons.check_circle,
        backgroundColor: const Color(0xFF4CAF50),
      ),
      gravity: ToastGravity.TOP,
      toastDuration: const Duration(seconds: 2),
    );
  }

  static void showError(BuildContext context, String message) {
    _fToast.init(context);
    _fToast.showToast(
      child: _buildToastWidget(
        message: message,
        icon: Icons.error_outline,
        backgroundColor: const Color(0xFFE53935),
      ),
      gravity: ToastGravity.TOP,
      toastDuration: const Duration(seconds: 3),
    );
  }

  /// ℹ️ Toast d'information
  static void showInfo(BuildContext context, String message) {
    _fToast.init(context);
    _fToast.showToast(
      child: _buildToastWidget(
        message: message,
        icon: Icons.info_outline,
        backgroundColor: const Color(0xFFF0CD97),
      ),
      gravity: ToastGravity.TOP,
      toastDuration: const Duration(seconds: 2),
    );
  }

  static void showWarning(BuildContext context, String message) {
    _fToast.init(context);
    _fToast.showToast(
      child: _buildToastWidget(
        message: message,
        icon: Icons.warning_amber_rounded,
        backgroundColor: const Color(0xFFFF9800),
      ),
      gravity: ToastGravity.TOP,
      toastDuration: const Duration(seconds: 2),
    );
  }

  static Widget _buildToastWidget({
    required String message,
    required IconData icon,
    required Color backgroundColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Annuler tous les toasts affichés
  static void cancelAll() {
    _fToast.removeCustomToast();
    _fToast.removeQueuedCustomToasts();
  }
}