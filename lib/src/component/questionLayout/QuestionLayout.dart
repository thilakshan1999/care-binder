import 'package:care_sync/src/component/btn/primaryBtn/priamaryLoadingBtn.dart';
import 'package:care_sync/src/component/text/questionText.dart';
import 'package:flutter/material.dart';

/// Reusable Layout Widget
class QuestionLayout extends StatelessWidget {
  final String question;
  final Widget body;
  final bool isLoading;
  final String btnLabel;
  final Function() onClickBtn;
  final Function()? onClickBack;

  const QuestionLayout({
    super.key,
    required this.question,
    required this.body,
    required this.isLoading,
    required this.btnLabel,
    required this.onClickBtn,
    this.onClickBack,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
                width: double.infinity,
                color: primaryColor,
                child: Stack(
                  children: [
                    // Back Button (top-left)
                    SafeArea(
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios,
                            color: Theme.of(context).colorScheme.onPrimary),
                        onPressed: () {
                          if (onClickBack != null) {
                            onClickBack!(); // call the function
                          } else {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                    // Question Text (bottom-left)
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: QuestionText(
                            text: question,
                            textAlign: TextAlign.left,
                          )),
                    ),
                  ],
                )),
          ),

          // Body Section (custom widget injected)
          Expanded(
            flex: 7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                body,
                const Spacer(),

                // Next Button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: PrimaryLoadingBtn(
                      label: btnLabel,
                      loading: isLoading,
                      onPressed: onClickBtn),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
