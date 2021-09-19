import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../bloc/geofence_status/geofence_status_bloc.dart';

class TripDetailsDrawer extends StatefulWidget {
  final List<Map<String, String>> images;
  final void Function()? onImagesTapped;

  const TripDetailsDrawer(
      {Key? key, required this.images, required this.onImagesTapped})
      : super(key: key);

  @override
  _TripDetailsDrawerState createState() => _TripDetailsDrawerState();
}

class _TripDetailsDrawerState extends State<TripDetailsDrawer> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.2,
      minChildSize: 0.2,
      maxChildSize: 0.8,
      builder: (BuildContext context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, -3),
                color: Colors.black12,
                blurRadius: 4,
              )
            ],
          ),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            controller: scrollController,
            child: Column(
              children: [
                const SizedBox(height: 5),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.24,
                  child: AspectRatio(
                    aspectRatio: 13,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(216, 216, 216, 1),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      // height: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildYourArrivalDetails(),
                BlocBuilder<GeofenceStatusBloc, GeofenceStatusState>(
                  builder: (context, state) {
                    var direction = VerticalDirection.down;
                    if (state is WithinGeofence) {
                      direction = VerticalDirection.up;
                    }

                    return Column(
                      verticalDirection: direction,
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 20),
                            _buildDriverDetails(),
                            const SizedBox(height: 25),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildActionButton(
                                    icon: Icons.call,
                                    label: "Call",
                                    onPress: () {},
                                  ),
                                  _buildActionButton(
                                    icon: Icons.list,
                                    label: "Directions",
                                    onPress: () {},
                                    isCall: false,
                                  ),
                                  _buildActionButton(
                                    icon: Icons.close,
                                    label: "Cancel Trip?",
                                    onPress: () {},
                                    isCall: false,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        _buildImagesContainer(
                          images: widget.images,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 50),
                Image.asset("assets/imgs/trip_details.png"),
                const SizedBox(height: 50),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Image.asset("assets/imgs/trip_price.png"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildYourArrivalDetails() {
    return Column(
      children: [
        Text(
          "20 mins away",
          style: TextStyle(
            color: const Color.fromRGBO(252, 83, 83, 1),
            fontSize: Theme.of(context).textTheme.headline4?.fontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 15),
        Column(
          children: [
            Text(
              "10 km",
              style: TextStyle(
                color: const Color.fromRGBO(81, 81, 81, 1),
                fontSize: Theme.of(context).textTheme.headline5?.fontSize,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Away from Pickup Point",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildDriverDetails() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 10,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Stack(
              children: [
                Positioned(
                  top: 10,
                  right: -5,
                  bottom: -5,
                  child: Image.asset("assets/imgs/van.png"),
                ),
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("assets/imgs/driver.jpeg"),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
              children: const [
                Expanded(
                  child: Text(
                    "Abdullah Khurram",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.star_border_outlined,
                  size: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5, left: 5),
                  child: Text(
                    "4.72",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Column(
            children: [
              SvgPicture.asset("assets/imgs/bus.svg"),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "HYE-5647",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required dynamic onPress,
    bool isCall = true,
  }) {
    return SizedBox(
      width: 80,
      child: Column(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              border: Border.all(
                color: isCall
                    ? const Color.fromRGBO(240, 66, 73, 1)
                    : const Color.fromRGBO(225, 225, 225, 1),
              ),
              borderRadius: BorderRadius.circular(45),
            ),
            child: Material(
              color: isCall
                  ? const Color.fromRGBO(240, 66, 73, 1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(45),
              child: InkWell(
                onTap: onPress,
                borderRadius: BorderRadius.circular(45),
                child: Center(
                  child: Icon(
                    icon,
                    color: isCall
                        ? Colors.white
                        : const Color.fromRGBO(112, 112, 112, 1),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 7.5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagesContainer({required List<Map<String, String>> images}) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Famous Spots Near Your Pickup Point",
              style: TextStyle(
                color: Color.fromRGBO(81, 81, 81, 1),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(250, 250, 250, 1),
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: Color.fromRGBO(214, 214, 214, 1),
                  width: 0.5,
                ),
              ),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Row(
                    children: images
                        .asMap()
                        .entries
                        .map(
                          (entry) => Padding(
                            padding: EdgeInsets.only(
                              left: entry.key == 0 ? 15 : 7.5,
                              right: 7.5,
                            ),
                            child: GestureDetector(
                              onTap: widget.onImagesTapped,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.48,
                                child: AspectRatio(
                                  aspectRatio: 1.2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            entry.value['image'] ?? ""),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: images.isEmpty ? 15 : 7.5,
                      right: 15,
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.48,
                      child: AspectRatio(
                        aspectRatio: 1.2,
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.only(
                                top: 25,
                                left: 10,
                                right: 10,
                                bottom: 10,
                              ),
                              child: Center(
                                child: Image.asset(
                                    "assets/imgs/add_new_image.png"),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
