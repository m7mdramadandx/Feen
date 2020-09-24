import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:Fen/data/model/Error.dart';
import 'package:Fen/data/model/MenuList.dart';
import 'package:Fen/data/model/PlaceResult.dart';
import 'package:Fen/ui/service/MapService.dart';
import 'package:Fen/util/colors.dart';
import 'package:Fen/util/constants.dart';
import 'package:Fen/util/loadResultWidget.dart';
import 'package:Fen/util/util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:spear_menu/spear_menu.dart';

class BankFinder extends StatefulWidget {
  final Position _position;

  const BankFinder(this._position);

  State<BankFinder> createState() {
    return _AtmFinder();
  }
}

class _AtmFinder extends State<BankFinder> {
  static GoogleMapController _controller;
  static Position _currentPosition;
  var rating = 0.0;
  String targetBank = "البنك الأهلي المصري", imgUrl, workTime, distance;
  static BitmapDescriptor pin;
  static PlaceResult _bank;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Marker> markers = <Marker>[];
  Error error;
  SheetState state;
  BuildContext context;
  SheetController controller;
  SpearMenu menu;
  GlobalKey btnKey = GlobalKey(), btnKey1 = GlobalKey();
  List<MenuList> bankName = new List<MenuList>(),
      operationType = new List<MenuList>();

  bool get isExpanded => state?.isExpanded ?? false;

  bool get isCollapsed => state?.isCollapsed ?? true;

  PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    checkInternet();
    _currentPosition = widget._position;
    _getCurrentLocation();
    _bank = new PlaceResult();
    distance = "0.0";
    controller = SheetController();
    MapService.setLocation(
        _currentPosition.latitude, _currentPosition.longitude);
    MapService.getNearbyBank(targetBank);
    expandSheet();
  }

  checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
    } on SocketException catch (_) {
      noInternetConnection();
      MapService.bankKey = "notFound";
    }
  }

  Future<bool> noInternetConnection() async {
    return (await showDialog(
          context: context,
          builder: (context) => Directionality(
            textDirection: TextDirection.rtl,
            child: new AlertDialog(
              title: new Text('عذرا ، لا يوجد اتصال بالإنترنت',
                  style: TextStyle(fontFamily: 'Cairo', color: primaryColor)),
              content: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 40,
                  child: Image.asset('lib/assets/icons/noInternet.png')),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
            ),
          ),
        )) ??
        false;
  }

  expandSheet() {
    distance = "0.0";
    polylines.clear();
    markers.clear();
    _bank = new PlaceResult();
    Future.delayed(Duration(milliseconds: 2500), () {
      controller.expand();
      controller.rebuild();
    });
  }

  void _getCurrentLocation() {
    Geolocator()
      ..getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      ).then((position) {
        if (mounted) {
          setState(() {
            _currentPosition = position;
          });
        }
      }).catchError((e) {
        print(e);
      });
  }

  _getLocation() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
      zoom: 17.0,
    )));
  }

  setPin() {
    MapService.objectBank.forEach((element) {
      markers.add(Marker(
          markerId: MarkerId(element.placeId),
          icon: pin,
          position: LatLng(
              element.geometry.location.lat, element.geometry.location.long),
          infoWindow:
              InfoWindow(title: element.name, snippet: element.vicinity),
          onTap: () {
            moveCamera(LatLng(
                element.geometry.location.lat, element.geometry.location.long));
            setState(() {
              _bank = element;
              print(_bank.name);
            });
          }));
    });
  }

  void _setStyle(GoogleMapController controller) async {
    String selectedValue = await DefaultAssetBundle.of(context)
        .loadString('lib/assets/light_map.json');
    controller.setMapStyle(selectedValue);
  }

  createMarker(context) {
    if (pin == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              configuration, 'lib/assets/icons/withdrawPin.png')
          .then((_pin) {
        setState(() {
          pin = _pin;
        });
      });
    }
  }

  moveCamera(LatLng latLng) {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 16.0, bearing: 45.0, tilt: 90.0)));
  }

  _createPolylines(Position start, Position destination) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      apiKey,
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.driving,
    );
    polylineCoordinates.clear();
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    setState(() {
      print(polylineCoordinates.length);
      PolylineId id = PolylineId("ID");
      Polyline polyline = Polyline(
        polylineId: id,
        color: primaryColor,
        onTap: moveCamera(LatLng(destination.latitude, destination.longitude)),
        points: polylineCoordinates,
        endCap: Cap.roundCap,
        startCap: Cap.roundCap,
      );
      polylines[id] = polyline;
    });
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
        zoom: 16,
        bearing: 45.0,
        tilt: 90.0)));
  }

  @override
  Widget build(BuildContext context) {
    createMarker(context);
    final screenSize = MediaQuery.of(context).size;
    SpearMenu.context = context;
    return Scaffold(body: Builder(builder: (context) {
      this.context = context;
      return Scaffold(
          key: this._scaffoldKey,
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Stack(alignment: Alignment.center, children: <Widget>[
              buildMap(),
              Positioned(
                  top: 32,
                  left: 8,
                  child: FloatingActionButton(
                      mini: true,
                      onPressed: _getLocation,
                      backgroundColor: Colors.grey,
                      child: Icon(Ionicons.ios_locate, color: Colors.white))),
              Positioned(
                top: 32,
                right: 8,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Ionicons.md_arrow_round_forward, color: grey),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(width: 2),
                    Container(
                      child: AutoSizeText(
                        "أفضل بنك",
                        maxFontSize: 40,
                        minFontSize: 20.0,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: grey,
                        ),
                      ),
                      height: screenSize.height * .07,
                    ),
                  ],
                ),
              ),
              Positioned(
                  bottom: screenSize.height * 0.37,
                  right: 8,
                  child: FloatingActionButton(
                    onPressed: () {
                      setBank(btnKey1);
                    },
                    heroTag: "bankName",
                    key: btnKey1,
                    mini: true,
                    elevation: 8,
                    backgroundColor: Colors.white,
                    child: Icon(FlutterIcons.bank_mco, color: Colors.grey),
                  )),
              buildSheet(),
            ]),
          ));
    }));
  }

  void setBank(GlobalKey btnKey) {
    if (bankName.isEmpty) {
      bankName.clear();
      bankName.add(MenuList('البنك الأهلي المصري', true));
      bankName.add(MenuList('بنك مصر', false));
      bankName.add(MenuList('بنك القاهرة', false));
    }
    List<MenuItemProvider> setData = new List<MenuItemProvider>();
    setData.clear();
    for (var io in bankName) {
      setData.add(MenuItem(title: io.name, isActive: io.isSelected));
    }

    SpearMenu menu = SpearMenu(
        lineColor: Colors.black54,
        highlightColor: primaryColor,
        items: setData,
        onClickMenu: onClickBankMenu);
    menu.show(widgetKey: btnKey);
  }

  void onClickBankMenu(MenuItemProvider item) {
    bankName.map((element) {
      if (item.menuTitle == element.name) {
        setState(() {
          element.isSelected = true;
          targetBank = element.name;
          _workTime(targetBank);
          MapService.getNearbyBank(targetBank);
          expandSheet();
        });
      } else {
        element.isSelected = false;
      }
    }).toList();
  }

  Widget getBank() {
    if (MapService.bankKey == "found") {
      _setImgUrl();
      setPin();
      final screenSize = MediaQuery.of(context).size;
      return Directionality(
          textDirection: TextDirection.rtl,
          child: new Container(
              width: screenSize.width * 0.95,
              height: screenSize.height * 0.24,
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: MapService.objectBank.map((bank) {
                    return Container(
                        margin: EdgeInsets.fromLTRB(4, 8, 0, 0),
                        width: screenSize.width * 0.85,
                        child: new Card(
                            color: silver,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black26),
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(25)),
                            ),
                            child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _bank = bank;
                                    distance = bank.distance;
                                    moveCamera(LatLng(
                                        bank.geometry.location.lat,
                                        bank.geometry.location.long));
                                  });
                                },
                                child: new Row(children: <Widget>[
                                  Expanded(
                                      flex: 35,
                                      child: CachedNetworkImage(
                                          imageUrl: imgUrl,
                                          imageBuilder: (context,
                                                  imageProvider) =>
                                              Container(
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: imageProvider,
                                                          fit:
                                                              BoxFit.cover))))),
                                  SizedBox(width: 4.0),
                                  Expanded(
                                      flex: 70,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                              Text(bank.name,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'Cairo',
                                                      fontSize: 11.0,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: primaryColor)),
                                              SizedBox(
                                                  width: 150.0,
                                                  child: Divider(
                                                      thickness: 2.0,
                                                      height: 3.0,
                                                      color: Colors.white)),
                                              Text(bank.vicinity,
                                                  softWrap: true,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'Cairo',
                                                      fontSize: 10.5)),
                                              GFRating(
                                                  value: bank.rating,
                                                  size: 15,
                                                  color: Colors.amber,
                                                  itemCount: 5,
                                                  allowHalfRating: true,
                                                  borderColor: Colors.black38,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      rating = value;
                                                    });
                                                  }),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                      FlutterIcons
                                                          .map_marker_distance_mco,
                                                      color: Colors.black38,
                                                      size: 16),
                                                  Text(
                                                    "  على بعد  " +
                                                        bank.distance +
                                                        "  كم",
                                                    style: TextStyle(
                                                        fontFamily: 'Cairo',
                                                        fontSize: 10.5),
                                                  ),
                                                ],
                                              ),
                                            ]),
                                      )),
                                ]))));
                  }).toList())));
    } else if (MapService.bankKey == "notFound") {
      return loadResultWidget.noResult();
    } else {
      return loadResultWidget.loadResult();
    }
  }

  void _setImgUrl() {
    if (targetBank == "البنك الأهلي المصري")
      imgUrl = alahlyImgUrlBank;
    else if (targetBank == "بنك مصر")
      imgUrl = misrImgUrlBank;
    else if (targetBank == "بنك القاهرة") imgUrl = kaheraImgUrlBank;
  }

  _workTime(String bankName) {
    if (bankName == "بنك مصر") {
      workTime = "مواعيد العمل من 8:30 حتى 16:00";
    } else if (bankName == "البنك الأهلي المصري") {
      workTime = "مواعيد العمل من 8:30 حتى 15:30";
    } else if (bankName == "بنك القاهرة")
      workTime = "مواعيد العمل من 8:30 حتى 15:00";
  }

  Widget buildMap() {
    return Column(children: <Widget>[
      Expanded(
          child: GoogleMap(
        myLocationButtonEnabled: false,
        mapToolbarEnabled: false,
        compassEnabled: false,
        myLocationEnabled: true,
        polylines: Set<Polyline>.of(polylines.values),
        markers: Set<Marker>.of(markers),
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            _controller = controller;
            _setStyle(controller);
          });
        },
        initialCameraPosition: CameraPosition(
            target: LatLng(
                _currentPosition.latitude != null
                    ? _currentPosition.latitude
                    : 30.5720681,
                _currentPosition.longitude != null
                    ? _currentPosition.longitude
                    : 31.0085726),
            zoom: 12.5),
      ))
    ]);
  }

  Widget buildSheet() {
    return SlidingSheet(
      controller: controller,
      color: Colors.white,
      elevation: 18,
      cornerRadius: 25,
      closeOnBackButtonPressed: true,
      border: Border.all(color: Colors.black45, width: 2),
      snapSpec: SnapSpec(
          snap: true,
          positioning: SnapPositioning.relativeToAvailableSpace,
          snappings: const [SnapSpec.headerFooterSnap, SnapSpec.expanded]),
      scrollSpec: ScrollSpec.overscroll(color: primaryColor),
      listener: (state) {
        this.state = state;
        setState(() {});
      },
      duration: Duration(milliseconds: 100),
      headerBuilder: buildHeader,
      builder: buildChild,
      footerBuilder: buildFooter,
    );
  }

  Widget buildHeader(BuildContext context, SheetState state) {
    final screenSize = MediaQuery.of(context).size;
    return CustomContainer(
        animate: true,
        height: screenSize.height * 0.27,
        color: Colors.white,
        child: Column(children: <Widget>[
          SizedBox(height: 8),
          Align(
              alignment: Alignment.topCenter,
              child: CustomContainer(
                  width: 46,
                  height: 4,
                  borderRadius: 2,
                  color: Colors.black12)),
          getBank()
        ]));
  }

  Widget buildFooter(BuildContext context, SheetState state) {
    final screenSize = MediaQuery.of(context).size;

    return CustomContainer(
        animate: true,
        height: screenSize.height * 0.08,
        elevation: !isCollapsed && !state.isAtBottom ? 8 : 0,
        shadowDirection: ShadowDirection.top,
        padding: const EdgeInsets.all(4),
        color: Colors.white,
        shadowColor: Colors.black12,
        child: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Expanded(
                child: GFButton(
                  onPressed: () async {
                    await controller.hide();
                    Future.delayed(const Duration(milliseconds: 2000), () {
                      _createPolylines(
                          _currentPosition,
                          Position(
                              latitude: _bank.geometry.location.lat,
                              longitude: _bank.geometry.location.long));
                      controller.show();
                      controller.rebuild();
                    });
                  },
                  color: primaryColor,
                  text: 'إذهب',
                  shape: GFButtonShape.pills,
                  textStyle: TextStyle(
                      fontFamily: 'Cairo',
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                  icon: Icon(Ionicons.ios_navigate),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: GFButton(
                  onPressed: () {
                    if (isExpanded == true) {
                      controller.collapse();
                    } else {
                      controller.expand();
                    }
                  },
                  type: GFButtonType.outline,
                  shape: GFButtonShape.pills,
                  color: primaryColor,
                  text: !isExpanded ? 'التفاصيل' : 'الخريطة',
                  textStyle: TextStyle(
                      fontFamily: 'Cairo',
                      color: Colors.black87,
                      fontWeight: FontWeight.w600),
                  icon: Icon(
                    !isExpanded
                        ? Ionicons.ios_list
                        : FlutterIcons.map_legend_mco,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: GFButton(
                  onPressed: () async {
                    markers.clear();
                    await controller.hide();
                    Future.delayed(const Duration(milliseconds: 1000), () {
                      _getCurrentLocation();
                      MapService.getNearbyBank(targetBank);
                      controller.show();
                    });
                  },
                  type: GFButtonType.outline,
                  shape: GFButtonShape.pills,
                  color: primaryColor,
                  text: 'إعادة بحث',
                  textStyle: TextStyle(
                      fontFamily: 'Cairo',
                      color: Colors.black87,
                      fontWeight: FontWeight.w600),
                  icon: Icon(Ionicons.ios_refresh),
                ),
              )
            ])));
  }

  Widget buildChild(BuildContext context, SheetState state) {
    final divider = Container(height: 1, color: Colors.black12);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              divider,
              SizedBox(height: 12),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text("التفاصيل",
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16))),
              Padding(
                  padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          workTime != null ? workTime : "مواعيد العمل",
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 16),
                        Text(
                          _bank.vicinity != null
                              ? _bank.vicinity
                              : "عنوان البنك",
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "على بعد  " + distance + "  كم",
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 16),
                        divider
                      ]))
            ]));
  }
}
