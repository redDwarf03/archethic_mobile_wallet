// @dart=2.9

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import 'package:uniris_mobile_wallet/app_icons.dart';
import 'package:uniris_mobile_wallet/appstate_container.dart';
import 'package:uniris_mobile_wallet/localization.dart';
import 'package:uniris_mobile_wallet/service_locator.dart';
import 'package:uniris_mobile_wallet/styles.dart';
import 'package:uniris_mobile_wallet/ui/widgets/app_text_field.dart';
import 'package:uniris_mobile_wallet/util/sharedprefsutil.dart';

class CustomUrl extends StatefulWidget {
  CustomUrl(this.tokensListController, this.tokensListOpen);

  final AnimationController tokensListController;
  bool tokensListOpen;

  @override
  _CustomUrlState createState() => _CustomUrlState();
}

class _CustomUrlState extends State<CustomUrl> {
  FocusNode _endpointFocusNode;
  TextEditingController _endpointController;
  bool useCustomEndpoint;

  String _endpointHint = '';
  String _endpointValidationText = '';

  Future<void> initControllerText() async {
    _endpointController.text = await sl.get<SharedPrefsUtil>().getEndpoint();
  }

  Future<void> updateEndpoint() async {
    await sl.get<SharedPrefsUtil>().setEndpoint(_endpointController.text);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    useCustomEndpoint = false;

    _endpointFocusNode = FocusNode();
    _endpointController = TextEditingController();

    initControllerText();

    _endpointFocusNode.addListener(() {
      if (_endpointFocusNode.hasFocus) {
        setState(() {
          _endpointHint = null;
        });
      } else {
        setState(() {
          _endpointHint = '';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      decoration: BoxDecoration(
        color: StateContainer.of(context).curTheme.backgroundDark,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: StateContainer.of(context).curTheme.overlay30,
              offset: const Offset(-5, 0),
              blurRadius: 20),
        ],
      ),
      child: SafeArea(
        minimum: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.035,
          top: 60,
        ),
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 10.0, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(children: <Widget>[
                    //Back button
                    Container(
                      height: 40,
                      width: 40,
                      margin: const EdgeInsets.only(right: 10, left: 10),
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              widget.tokensListOpen = false;
                            });
                            widget.tokensListController.reverse();
                          },
                          child: Icon(AppIcons.back,
                              color: StateContainer.of(context).curTheme.text,
                              size: 24)),
                    ),
                    // Header Text
                    Text(
                      AppLocalization.of(context).customUrlHeader,
                      style: AppStyles.textStyleSettingsHeader(context),
                    ),
                  ]),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(top: 30, bottom: bottom + 30),
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: getEndpointContainer(),
                              ),
                              Container(
                                alignment: const AlignmentDirectional(0, 0),
                                margin: const EdgeInsets.only(top: 3),
                                child: Text(_endpointValidationText,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: StateContainer.of(context)
                                          .curTheme
                                          .primary,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w600,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column getEndpointContainer() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalization.of(context).enterEndpoint,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w100,
                fontFamily: 'Montserrat',
                color: StateContainer.of(context).curTheme.text60,
              ),
            ),
          ],
        ),
        AppTextField(
          leftMargin: 10,
          rightMargin: 10,
          topMargin: 10,
          focusNode: _endpointFocusNode,
          controller: _endpointController,
          cursorColor: StateContainer.of(context).curTheme.primary,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16.0,
            color: StateContainer.of(context).curTheme.primary,
            fontFamily: 'Montserrat',
          ),
          inputFormatters: [LengthLimitingTextInputFormatter(150)],
          onChanged: (String text) {
            updateEndpoint();
            // Always reset the error message to be less annoying
            setState(() {
              _endpointValidationText = '';
            });
          },
          textInputAction: TextInputAction.next,
          maxLines: null,
          autocorrect: false,
          hintText: _endpointHint == null
              ? ''
              : AppLocalization.of(context).enterEndpoint,
          keyboardType: TextInputType.multiline,
          textAlign: TextAlign.left,
          onSubmitted: (String text) {
            FocusScope.of(context).unfocus();
          },
        ),
      ],
    );
  }
}
