import 'package:flutter/material.dart';
import 'package:stohp_driver_app/src/components/common/bloc/dialog_bloc.dart';
import 'package:stohp_driver_app/src/values/values.dart';

class StopDialog extends StatelessWidget {
  final DialogBloc _bloc;

  const StopDialog({Key key, DialogBloc bloc})
      : _bloc = bloc,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
          _bloc.add(HideDialog());
        },
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: new BoxDecoration(
            color: colorSecondary,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(4.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.info,
                color: Colors.white,
                size: 56.0,
              ),
              SizedBox(height: 16.0),
              Flexible(
                  flex: 1,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: Strings.stopDialogInstruction1,
                      style: contrastAppText.copyWith(
                          fontSize: 32.0, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: Strings.stopDialogInstruction2,
                          style: contrastAppText.copyWith(
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  )),
              SizedBox(height: 16.0),
              Text(
                Strings.stopDialogInstruction3,
                style: contrastAppText.copyWith(fontSize: 10.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
