import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import "package:latlong2/latlong.dart" as latLng;
import 'package:location/location.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:swvl_new_workflow/features/CustomerHome/data/models/booking_model.dart';
import 'package:swvl_new_workflow/features/CustomerHome/data/models/point_model.dart';
import '../../../../core/network/network_info.dart';
import '../../data/repositories/customer_home_repository.dart';
import '../bloc/customer_home/bloc/customer_home_bloc.dart';
import '../bloc/geofence_status/geofence_status_bloc.dart';
import '../widgets/trip_details_drawer.dart';
import '../../../../core/ui/no_glow_scroll_behavior.dart';

class CustomerHome extends StatefulWidget {
  const CustomerHome({Key? key}) : super(key: key);

  @override
  _CustomerHomeState createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  bool _isWithinGeofence = true;
  late bool _isExpanded;
  late NetworkInfo _networkInfo;
  late CustomerHomeRepository _customerHomeRepository;
  late CustomerHomeBloc _customerHomeBloc;
  late latLng.LatLng _currentLocation = latLng.LatLng(0, 0);

  late BookingModel currentBooking = BookingModel(
      start: PointModel(name: "", images: [], location: GeoPoint(0, 0)));
  late List<Polyline> paths = [];

  Location location = new Location();

  MapController _mapController = MapController();

  final List<Map<String, String>> _pointImages = [
    {
      "id": "1",
      "image":
          "https://lh5.googleusercontent.com/p/AF1QipMQeDuLiwOO624FpsK4mwJflFrxAR7w6t3TwHWE=w1080-k-no",
    },
    {
      "id": "2",
      "image":
          "https://lh5.googleusercontent.com/p/AF1QipMQeDuLiwOO624FpsK4mwJflFrxAR7w6t3TwHWE=w1080-k-no",
    }
  ];

  @override
  void initState() {
    super.initState();

    _isWithinGeofence = true;
    _isExpanded = false;

    _networkInfo = NetworkInfo(connectivity: Connectivity());
    _customerHomeRepository = CustomerHomeRepository(networkInfo: _networkInfo);
    _customerHomeBloc =
        CustomerHomeBloc(customerHomeRepository: _customerHomeRepository);

    _customerHomeBloc
        .add(LoadBookingDetailsEvent(bookingId: "Wjrh2lf4HJ8ARlIgl7cK"));

    location.onLocationChanged.listen((LocationData currentLocation) async {
      latLng.LatLng tempCurrentLocation = _currentLocation.latitude == 0
          ? latLng.LatLng(33.641962, 72.993677)
          : _currentLocation;
      double _distanceInMeters = await Geolocator.distanceBetween(
        currentLocation.latitude!,
        currentLocation.longitude!,
        tempCurrentLocation.latitude,
        tempCurrentLocation.longitude,
      );

      latLng.LatLng newCurrentLocation =
          latLng.LatLng(currentLocation.latitude!, currentLocation.longitude!);
      latLng.LatLng bookingLocation = latLng.LatLng(
          currentBooking.start.location.latitude,
          currentBooking.start.location.longitude);
      if (_distanceInMeters > 1 && bookingLocation.latitude != 0) {
        setState(() {
          _currentLocation = newCurrentLocation;
        });

        if (_distanceInMeters < 3000) {
          _customerHomeBloc.add(CustomerHomeLoadNewPathEvent(
              point1: newCurrentLocation, point2: bookingLocation));
        }
      } else if (_currentLocation.latitude == 0 &&
          bookingLocation.latitude != 0) {
        if (_distanceInMeters < 3000) {
          _customerHomeBloc.add(CustomerHomeLoadNewPathEvent(
              point1: newCurrentLocation, point2: bookingLocation));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GeofenceStatusBloc>(
          create: (context) => GeofenceStatusBloc(),
        ),
        BlocProvider(
          create: (context) => _customerHomeBloc,
        ),
      ],
      child: BlocListener<CustomerHomeBloc, CustomerHomeState>(
        listener: (context, state) {
          if (state is CustomerHomeLoadedBooking) {
            setState(() {
              currentBooking = state.booking;
            });
          } else if (state is CustomerHomeLoadedPath) {
            print("AAAA");
            setState(() {
              paths = [
                new Polyline(
                  points: state.route.points,
                  strokeWidth: 2.0,
                  color: Colors.red,
                )
              ];
            });
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        _buildBusArrivalDetails(),
                        Expanded(
                          child: Stack(
                            children: [
                              Positioned(
                                child: FlutterMap(
                                  mapController: _mapController,
                                  options: MapOptions(
                                    center: _currentLocation.latitude == 0
                                        ? latLng.LatLng(33.641962, 72.993677)
                                        : _currentLocation,
                                    zoom: 15.0,
                                    onMapCreated: (_) async {
                                      await Future.delayed(
                                          Duration(seconds: 2));
                                      _mapController.move(
                                        _currentLocation.latitude == 0
                                            ? latLng.LatLng(
                                                33.641962, 72.993677)
                                            : _currentLocation,
                                        15.0,
                                      );

                                      bool serviceEnabled =
                                          await location.serviceEnabled();
                                      if (!serviceEnabled) {
                                        serviceEnabled =
                                            await location.requestService();
                                      }
                                    },
                                  ),
                                  layers: [
                                    TileLayerOptions(
                                      urlTemplate:
                                          "https://api.mapbox.com/styles/v1/shehriyar/cktpxtdhg2o3r18n60whr3we6/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoic2hlaHJpeWFyIiwiYSI6ImNrdHBkYjBrYTBsangyb3BubHhjMWZvYnoifQ.EOG7gOeDDCwp_xcGuyoanw",
                                      additionalOptions: {
                                        'accessToken':
                                            'pk.eyJ1Ijoic2hlaHJpeWFyIiwiYSI6ImNrdHBkYjBrYTBsangyb3BubHhjMWZvYnoifQ.EOG7gOeDDCwp_xcGuyoanw',
                                        'id': 'mapbox.mapbox-streets-v8'
                                      },
                                    ),
                                    MarkerLayerOptions(
                                      markers: [
                                        Marker(
                                          width: 20.0,
                                          height: 20.0,
                                          point: _currentLocation,
                                          builder: (ctx) => CircleAvatar(
                                            // radius: 15,
                                            backgroundColor:
                                                Colors.blue.shade300,
                                            child: Center(
                                              child: Container(
                                                height: 15,
                                                width: 15,
                                                decoration: BoxDecoration(
                                                  color: Colors.blue.shade600,
                                                  border: Border.all(
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                              ),
                                            ),
                                          ),
                                          rotate: true,
                                        ),
                                        Marker(
                                          width: 40.0,
                                          height: 40.0,
                                          point: currentBooking.start.location
                                                      .latitude ==
                                                  0
                                              ? latLng.LatLng(
                                                  33.649205,
                                                  72.999531,
                                                )
                                              : latLng.LatLng(
                                                  currentBooking
                                                      .start.location.latitude,
                                                  currentBooking.start.location
                                                      .longitude),
                                          builder: (ctx) => Container(
                                            child: Image.asset(
                                                "assets/imgs/pin.png"),
                                          ),
                                          rotate: true,
                                        ),
                                      ],
                                    ),
                                    CircleLayerOptions(
                                      circles: [
                                        CircleMarker(
                                          point: currentBooking.start.location
                                                      .latitude ==
                                                  0
                                              ? latLng.LatLng(
                                                  33.649205,
                                                  72.999531,
                                                )
                                              : latLng.LatLng(
                                                  currentBooking
                                                      .start.location.latitude,
                                                  currentBooking.start.location
                                                      .longitude),
                                          color: const Color.fromRGBO(
                                              246, 127, 127, 0.35),
                                          useRadiusInMeter: true,
                                          radius: 300,
                                        ),
                                      ],
                                    ),
                                    PolylineLayerOptions(
                                      polylines: paths,
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 42.5 + (_isWithinGeofence ? 40 : 0),
                                left: 10,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: const Offset(0, -2),
                                        color: Colors.black.withOpacity(0.16),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    child: InkWell(
                                      onTap: () {
                                        _mapController.move(
                                            _currentLocation, 15.0);
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 17.5,
                                          vertical: 12.5,
                                        ),
                                        child: Text(
                                          "Re-center",
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(81, 81, 81, 1),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              _isWithinGeofence
                                  ? Positioned(
                                      bottom: 30,
                                      left: 10,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              offset: const Offset(0, -2),
                                              color: Colors.black
                                                  .withOpacity(0.16),
                                              blurRadius: 6,
                                            ),
                                          ],
                                        ),
                                        child: Material(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                _isExpanded = true;
                                              });
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 17.5,
                                                vertical: 12.5,
                                              ),
                                              child: Text(
                                                "See Pictures Of Local",
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      81, 81, 81, 1),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              Positioned(
                                bottom: 30 + (_isWithinGeofence ? 50 : 0),
                                right: 10,
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(35),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: const Offset(0, 4),
                                        color: Colors.black.withOpacity(0.16),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(35),
                                    color: Colors.white,
                                    child: InkWell(
                                      onTap: () {},
                                      borderRadius: BorderRadius.circular(35),
                                      child: Stack(
                                        children: const [
                                          Positioned(
                                            top: -6,
                                            right: 0,
                                            bottom: 0,
                                            left: 0,
                                            child: Icon(
                                              Icons.close,
                                              color: Color.fromRGBO(
                                                  252, 83, 83, 1),
                                              size: 46,
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 5,
                                            left: 0,
                                            right: 0,
                                            child: Text(
                                              "Exit",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height:
                              (MediaQuery.of(context).size.height * 0.2) - 15,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: TripDetailsDrawer(
                        images: _pointImages,
                        onImagesTapped: () => {
                          setState(
                            () {
                              _isExpanded = true;
                            },
                          ),
                        },
                      ),
                    ),
                  ),
                  _isExpanded
                      ? Positioned(
                          top: 0,
                          right: 0,
                          bottom: 0,
                          left: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 40),
                            color: Colors.black45,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  width: 1,
                                  color: const Color.fromRGBO(112, 112, 112, 1),
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 15,
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _isExpanded = false;
                                          });
                                        },
                                        child: const Icon(
                                          Icons.cancel,
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ScrollConfiguration(
                                      behavior: NoGlowScrollBehavior(),
                                      child: PhotoViewGallery.builder(
                                        backgroundDecoration:
                                            const BoxDecoration(
                                          color: Colors.transparent,
                                        ),
                                        builder:
                                            (BuildContext context, int index) {
                                          return PhotoViewGalleryPageOptions(
                                            imageProvider: NetworkImage(
                                                _pointImages[index]["image"] ??
                                                    ""),
                                            initialScale: PhotoViewComputedScale
                                                    .contained *
                                                0.8,
                                            heroAttributes:
                                                PhotoViewHeroAttributes(
                                                    tag: _pointImages[index]
                                                            ['id'] ??
                                                        ""),
                                          );
                                        },
                                        itemCount: _pointImages.length,
                                        loadingBuilder: (context, event) =>
                                            const Center(
                                          child: SizedBox(
                                            width: 20.0,
                                            height: 20.0,
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBusArrivalDetails() {
    return Container(
      color: const Color.fromRGBO(96, 107, 127, 1),
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Arrival Time Of Bus:",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Time Remaining:",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 25,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "10:00 AM",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "34 mins",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
