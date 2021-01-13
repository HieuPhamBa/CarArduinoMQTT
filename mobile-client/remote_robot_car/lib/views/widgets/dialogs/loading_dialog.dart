import 'package:remoterobotcar/configs/values/values.dart';
import 'package:remoterobotcar/views/widgets/widgets/indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:loading/loading.dart';

class LoadingDialog {
  static void show(BuildContext context, String mess) {
    showDialog(
        context: context,
        builder: (context) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Loading(
                    indicator: BallPulseIndicator(),
                    size: ScreenUtil().setWidth(50),
                    color: colorTextWhite),
                Visibility(
                  visible: mess != null,
                  child: Text(
                    mess.toString(),
                    style: Theme.of(context)
                        .primaryTextTheme
                        .caption
                        .copyWith(fontSize: ScreenUtil().setSp(fzCaption)),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(90)),
                  ),
                  color: colorIconWhite,
                  onPressed: () => hide(context),
                  child: Text(
                    'Hủy',
                    style: Theme.of(context).primaryTextTheme.button.copyWith(
                        color: colorTextSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: ScreenUtil().setSp(fzButton)),
                  ),
                ),
              ],
            ));
  }

  static void hide(BuildContext context) {
    Navigator.of(context).pop(LoadingDialog);
  }
}
