import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:todo_app_task/business_logic/cubit/auth_cubit/auth_cubit.dart';
import 'package:todo_app_task/constants/colors.dart';
import 'package:todo_app_task/constants/style.dart';
import 'package:todo_app_task/data/repository/auth_repo.dart';
import 'package:todo_app_task/presentation/widgets/app_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: MyColors.white,
      appBar: AppBar(
        title: Text(
          "Profile",
          style: myTasksLableText(context),
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthProfile) {
            return profileScreen(
                context: context,
                mediaQuery: mediaQuery,
                profileData: profileData);
          } else if (state is AuthLoading) {
            return ListView.builder(
              itemCount: 5, // Number of shimmer placeholders
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!, // Light grey background
                    highlightColor: Colors.grey[100]!, // Shimmer highlight
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60.0,
                          height: 60.0,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 16.0,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 8.0),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                height: 16.0,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is AuthError) {
            return Center(
              child: Text(
                state.errorMessage.toString(),
                style: largBlackText(context),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
