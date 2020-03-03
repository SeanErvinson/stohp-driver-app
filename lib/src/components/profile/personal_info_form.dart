import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stohp_driver_app/src/components/profile/bloc/personal_info_bloc.dart';
import 'package:stohp_driver_app/src/models/user.dart';
import 'package:stohp_driver_app/src/values/values.dart';

class PersonalInfoForm extends StatefulWidget {
  final User _user;

  const PersonalInfoForm({Key key, User user})
      : this._user = user,
        super(key: key);

  @override
  _PersonalInfoFormState createState() => _PersonalInfoFormState(_user);
}

class _PersonalInfoFormState extends State<PersonalInfoForm> {
  User user;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final PersonalInfoBloc _bloc = PersonalInfoBloc();
  _PersonalInfoFormState(this.user);

  @override
  void initState() {
    _firstNameController.text = user.firstName != null ? user.firstName : "";
    _lastNameController.text = user.lastName != null ? user.lastName : "";
    _emailController.text = user.email != null ? user.email : "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PersonalInfoBloc, PersonalInfoState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is PersonalInfoSuccess) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Strings.updateSuccess,
                      style: TextStyle(fontSize: 14.0),
                    ),
                    Icon(Icons.error, size: 20.0)
                  ],
                ),
                backgroundColor: greenPrimary,
              ),
            );
        } else if (state is PersonalInfoFailed) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Strings.updateFailed,
                      style: TextStyle(fontSize: 14.0),
                    ),
                    Icon(Icons.error, size: 20.0)
                  ],
                ),
                backgroundColor: redPrimary,
              ),
            );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Form(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _firstNameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: Strings.firstName,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear, size: 14.0),
                      onPressed: () => _firstNameController.clear(),
                    ),
                  ),
                ),
                TextFormField(
                  controller: _lastNameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: Strings.lastName,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear, size: 14.0),
                      onPressed: () => _lastNameController.clear(),
                    ),
                  ),
                ),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: Strings.email,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear, size: 14.0),
                      onPressed: () => _lastNameController.clear(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: SizedBox()),
          Container(
            width: double.infinity,
            child: BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
              bloc: _bloc,
              builder: (context, state) {
                if (state is PersonalInfoSuccess) {
                  user = state.user;
                }
                return FlatButton(
                  child: Text(
                    Strings.save,
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                  color: colorSecondary,
                  onPressed: () {
                    User newUser = user;
                    newUser.firstName = _firstNameController.text.length != 0
                        ? _firstNameController.text
                        : user.firstName;
                    newUser.lastName = _lastNameController.text.length != 0
                        ? _lastNameController.text
                        : user.lastName;
                    newUser.email = _emailController.text.length != 0
                        ? _emailController.text
                        : user.email;
                    _bloc.add(SavePersonalInfo(newUser));
                  },
                );
              },
            ),
          ),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }
}
