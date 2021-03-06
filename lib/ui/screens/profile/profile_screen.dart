import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opolah/blocs/profile/profile_bloc.dart';
import 'package:opolah/blocs/profile/profile_state.dart';
import 'package:opolah/constant/constans.dart';
import 'package:opolah/models/transaction.dart';
import 'package:opolah/models/user.dart';
import 'package:opolah/repositories/transaction_repo.dart';
import 'package:opolah/ui/components/profile/history_list.dart';
import 'package:opolah/ui/components/profile/profile_header.dart';
import 'package:opolah/ui/screens/login/login_screen.dart';
import 'package:opolah/ui/screens/profile/edit_profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User user;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: BlocBuilder<UserBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation(colorPrimary),
                ),
              );
            } else if (state is ProfileSuccessLoad) {
              return Stack(
                children: [
                  Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          PorfileHeader(size: size, user: state.profileList),
                          SizedBox(height: 50),
                          HistoryList(
                            size: size,
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: CircularMenu(
                      toggleButtonColor: colorPrimary,
                      alignment: Alignment.bottomRight,
                      startingAngleInRadian: 3.35,
                      endingAngleInRadian: 4.35,
                      items: [
                        CircularMenuItem(
                          icon: Icons.logout,
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();
                            prefs.remove('userID');
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          color: colorSecondary,
                          iconColor: Colors.white,
                        ),
                        CircularMenuItem(
                          icon: Icons.settings,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfile(
                                        currentUser: state.profileList)));
                          },
                          color: colorPrimary,
                          iconColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return Container();
          },
        ));
  }
}
