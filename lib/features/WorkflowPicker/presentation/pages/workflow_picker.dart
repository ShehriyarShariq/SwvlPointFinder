import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/util/internet_cubit/internet_cubit.dart';
import '../../../CustomerHome/presentation/pages/customer_home.dart';

class WorkflowPicker extends StatelessWidget {
  const WorkflowPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<InternetCubit, InternetState>(
      listener: (context, state) {
        if (state is InternetDisconnected) {}
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(
              top: 80,
            ),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/imgs/swvl_logo.svg"),
                      const SizedBox(
                        height: 120,
                      ),
                      Text(
                        "Come Travel With Us",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize:
                              Theme.of(context).textTheme.headline5?.fontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildWorkflowOptionsBtn(context, "Let's Go"),
                        ],
                      )
                    ],
                  ),
                ),
                BlocBuilder<InternetCubit, InternetState>(
                  builder: (context, state) {
                    if (state is InternetDisconnected) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 7.5),
                        color: Colors.black54,
                        child: Text(
                          "Not Connected",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13,
                          ),
                        ),
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWorkflowOptionsBtn(BuildContext context, String label) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.width * 0.7 * 0.24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            color: Colors.black.withOpacity(0.16),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        child: InkWell(
          onTap: () async {
            if (await Permission.location.isPermanentlyDenied) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Permission Required!"),
                    content: const Text(
                        "Location permission is required for this app to function properly. Please allow location from your settings."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          openAppSettings();
                        },
                        child: const Text("Open Settings"),
                      )
                    ],
                  );
                },
              );
            } else {
              PermissionStatus permissionRequestStatus =
                  await Permission.location.request();

              if (permissionRequestStatus == PermissionStatus.granted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CustomerHome(),
                  ),
                );
              }
            }
          },
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.36,
            child: AspectRatio(
              aspectRatio: 2.18,
              child: Center(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color.fromRGBO(81, 81, 81, 1),
                    fontSize: Theme.of(context).textTheme.headline6?.fontSize,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
