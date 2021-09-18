import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../CustomerHome/presentation/pages/customer_home.dart';
import '../../../DriverHome/presentation/pages/driver_home.dart';

class WorkflowPicker extends StatelessWidget {
  const WorkflowPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(
            top: 80,
          ),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/imgs/swvl_logo.svg"),
              const SizedBox(
                height: 120,
              ),
              Text(
                "Select Workflow",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Theme.of(context).textTheme.headline5?.fontSize,
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildWorkflowOptionsBtn(context, "Driver", true),
                  _buildWorkflowOptionsBtn(context, "Rider", false)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkflowOptionsBtn(
      BuildContext context, String label, bool isDriver) {
    return Container(
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
        child: InkWell(
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => isDriver ? DriverHome() : CustomerHome(),
              ),
            )
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
