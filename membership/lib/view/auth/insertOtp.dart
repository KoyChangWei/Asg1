import 'package:flutter/material.dart';
import 'package:email_otp/email_otp.dart';
import 'package:pinput/pinput.dart';
class OtpVerificationDialog extends StatefulWidget {
  final Function(String) onOtpVerified;
  final VoidCallback onBack;

  const OtpVerificationDialog({
    super.key,
    required this.onOtpVerified,
    required this.onBack,
  });

  @override
  State<OtpVerificationDialog> createState() => _OtpVerificationDialogState();
}

class _OtpVerificationDialogState extends State<OtpVerificationDialog> {
  final TextEditingController otpController = TextEditingController();
  String? errorMessage;

  void showMessage(String message, bool isError) {
    setState(() {
      errorMessage = isError ? message : null;
    });

    if (!isError) {
      // If verification successful, wait a moment before closing
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          widget.onOtpVerified(otpController.text);
        }
      });
    }
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Email Verification",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "We need to verify your email with OTP!",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Pinput(
                    length: 6,
                    controller: otpController,
                    showCursor: true,
                    onCompleted: (pin) {
                    
                      verifyOtp();
                    },
                    errorText: errorMessage,
                    errorTextStyle: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: verifyOtp,
                      child: const Text("Verify OTP"),
                    ),
                  ),
                ],
              ),
            ),
            // Back button
            Positioned(
              left: 10,
              top: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: widget.onBack,
                color: Colors.black54,
              ),
            ),
            // Success animation (optional)
            if (errorMessage == null)
              Positioned(
                top: -40,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.green.shade100,
                  child: Icon(
                    Icons.email_outlined,
                    size: 40,
                    color: Colors.green.shade700,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void verifyOtp() {
    final otpValue = otpController.text;
    
    if (otpValue.length != 6) {
      showMessage("Please enter a complete 6-digit OTP", true);
      return;
    }

    bool isValid = EmailOTP.verifyOTP(otp: otpValue);
    
    if (isValid) {
      showMessage("OTP Verified Successfully!", false);
    } else {
      showMessage("Invalid OTP. Please try again.", true);
    }
  }
}