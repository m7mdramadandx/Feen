import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:Feen/models/Error.dart';
import 'package:Feen/models/MenuList.dart';
import 'package:Feen/models/PlaceResult.dart';
import 'package:Feen/services/Database.dart';
import 'package:Feen/services/MapService.dart';
import 'package:Feen/ui/screens/Survey.dart';
import 'package:Feen/ui/widgets/colors.dart';
import 'package:Feen/ui/widgets/constants.dart';
import 'package:Feen/ui/widgets/defaultData.dart';
import 'package:Feen/ui/widgets/util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:spear_menu/spear_menu.dart';

class AtmFinder extends StatefulWidget {
  final Position position;

  const AtmFinder(this.position);

  State<AtmFinder> createState() {
    return _AtmFinder();
  }
}

//Sheben, 30.5720681  ---- 31.0085726
class _AtmFinder extends State<AtmFinder> {
  static GoogleMapController _controller;
  static Position _currentPosition;
  var rating = 0.0;
  String targetBank = "البنك الأهلي المصري", targetOperation = "سحب", imgUrl;
  static BitmapDescriptor offlinePin, withdrawPin, depositPin, pin;
  static String atmStatus2, atmType, distance;
  static PlaceResult _atm;
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
    try {
      initializing();
    } catch (e) {
      print(" **************");
    }
    _currentPosition = widget.position;
    _getCurrentLocation();
    controller = SheetController();
    MapService.setLocation(
        _currentPosition.latitude, _currentPosition.longitude);
    MapService.getNearbyAtm(targetBank, targetOperation);
    expandSheet();
  }

  checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
    } on SocketException catch (_) {
      noInternetConnection();
      MapService.atmKey = "notFound";
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

  Future<bool> waitNotification() async {
    return (await showDialog(
          context: context,
          builder: (context) => Directionality(
            textDirection: TextDirection.rtl,
            child: new AlertDialog(
              title: new Text(
                  'للاستفادة بخدمة اكثر تميزاً ما عليك سوى ملئ البيانات لتقيم الماكينة من خلال اشعار سيصلك بعد قليل ✨',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Cairo', color: primaryColor, fontSize: 16)),
              content: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 40,
                  child: Image.asset('lib/assets/icons/notification.png')),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('متابعة',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          color: primaryColor,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        )) ??
        false;
  }

  expandSheet() {
    distance = "0.0";
    polylines.clear();
    markers.clear();
    _atm = new PlaceResult();
    atmType = null;
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

  setPin(PlaceResult element) {
    if (element.rating.toString().startsWith("0")) {
      pin = offlinePin;
    } else if (element.rating.toString().startsWith("5")) {
      pin = depositPin;
    } else {
      pin = withdrawPin;
    }
    markers.add(Marker(
        markerId: MarkerId(element.placeId),
        icon: pin,
        position: LatLng(
            element.geometry.location.lat, element.geometry.location.long),
        infoWindow: InfoWindow(title: element.name, snippet: element.vicinity),
        onTap: () {
          moveCamera(LatLng(
              element.geometry.location.lat, element.geometry.location.long));
          setState(() {
            _atm = element;
            distance = element.distance;
            setAtmType(element.rating.toString());
          });
        }));
  }

  void _setStyle(GoogleMapController controller) async {
    String mapStyle = await DefaultAssetBundle.of(context)
        .loadString('lib/assets/light_map.json');
    controller.setMapStyle(mapStyle);
  }

  createMarker(context) {
    if (withdrawPin == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              configuration, 'lib/assets/icons/withdrawPin.png')
          .then((withdraw) {
        setState(() {
          withdrawPin = withdraw;
        });
      });
    } else if (offlinePin == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              configuration, 'lib/assets/icons/offlinePin.png')
          .then((offline) {
        setState(() {
          offlinePin = offline;
        });
      });
    } else if (depositPin == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              configuration, 'lib/assets/icons/depositPin.png')
          .then((deposit) {
        setState(() {
          depositPin = deposit;
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
      apiKey, // Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.transit,
    );
    polylineCoordinates.clear();
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    setState(() {
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
            child: Stack(children: <Widget>[
              buildMap(),
              Positioned(
                  top: 32,
                  left: 8,
                  child: FloatingActionButton(
                      mini: true,
                      onPressed: _getLocation,
                      backgroundColor: Colors.grey,
                      child: Icon(Ionicons.ios_locate, color: Colors.white))),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 32, 16, 0),
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
                        "أفضل ماكينة",
                        maxFontSize: 40,
                        minFontSize: 20.0,
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: grey),
                      ),
                      height: screenSize.height * .07,
                    ),
                  ],
                ),
              ),
              Positioned(
                  bottom: screenSize.height * 0.35,
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
              Positioned(
                  bottom: screenSize.height * 0.35,
                  left: 8,
                  child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: FloatingActionButton(
                        onPressed: () {
                          setOperation(btnKey);
                        },
                        key: btnKey,
                        mini: true,
                        heroTag: "operationType",
                        elevation: 8,
                        backgroundColor: Colors.white,
                        child: Icon(Ionicons.ios_cash, color: Colors.grey),
                      ))),
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

  void setOperation(GlobalKey btnKey) {
    if (operationType.isEmpty) {
      operationType.clear();
      operationType.add(MenuList('سحب', true));
      operationType.add(MenuList('إيداع', false));
    }
    List<MenuItemProvider> setData = new List<MenuItemProvider>();
    setData.clear();
    for (var io in operationType) {
      setData.add(MenuItem(title: io.name, isActive: io.isSelected));
    }

    SpearMenu menu = SpearMenu(
      lineColor: Colors.black54,
      highlightColor: primaryColor,
      items: setData,
      onClickMenu: onClickOperationMenu,
    );
    menu.show(widgetKey: btnKey);
  }

  void onClickBankMenu(MenuItemProvider item) {
    bankName.map((element) {
      if (item.menuTitle == element.name) {
        setState(() {
          element.isSelected = true;
          targetBank = element.name;
          MapService.getNearbyAtm(targetBank, targetOperation);
          expandSheet();
        });
      } else {
        element.isSelected = false;
      }
    }).toList();
  }

  void onClickOperationMenu(MenuItemProvider item) {
    operationType.map((element) {
      setState(() {
        if (item.menuTitle == element.name) {
          element.isSelected = true;
          targetOperation = element.name;
          MapService.getNearbyAtm(targetBank, targetOperation);
          expandSheet();
        } else {
          element.isSelected = false;
        }
      });
    }).toList();
  }

  Widget getAtm() {
    if (MapService.atmKey == "found") {
      _setImgUrl();
      final screenSize = MediaQuery.of(context).size;
      return Directionality(
          textDirection: TextDirection.rtl,
          child: new Container(
              width: screenSize.width * 0.95,
              height: screenSize.height * 0.22,
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: MapService.objectAtm.map((atm) {
                    setPin(atm);
                    LatLng _latLng = LatLng(
                        atm.geometry.location.lat, atm.geometry.location.long);
                    if (atm.distance.startsWith("0.") ||
                        atm.distance.startsWith("1.")) {
                      DatabaseService.discoveredATMs(_latLng);
                    }
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
                                    _atm = atm;
                                    distance = atm.distance;
                                    setAtmType(atm.rating.toString());
                                  });
                                  moveCamera(LatLng(atm.geometry.location.lat,
                                      atm.geometry.location.long));
                                },
                                child: new Row(children: <Widget>[
                                  Expanded(
                                      flex: 28,
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
                                              Text(atm.name,
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
                                              Text(atm.vicinity,
                                                  softWrap: true,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'Cairo',
                                                      fontSize: 10.5)),
                                              GFRating(
                                                  value: atm.rating,
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
                                                        atm.distance +
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
    } else if (MapService.atmKey == "notFound") {
      return noResult();
    } else if (MapService.atmKey == "overTries") {
      return noResult();
    } else {
      return loadResult();
    }
  }

  setAtmType(String rate) {
    if (rate.startsWith("0")) {
      atmType = "معطلة";
    } else if (rate.startsWith("5")) {
      atmType = "سحب وإيداع";
    } else {
      atmType = "سحب فقط";
    }
  }

  void _setImgUrl() {
    if (targetBank == "البنك الأهلي المصري")
      imgUrl = alahlyImgUrl;
    else if (targetBank == "بنك مصر")
      imgUrl = misrImgUrl;
    else if (targetBank == "بنك القاهرة") imgUrl = kaheraImgUrl;
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
      scrollSpec: ScrollSpec.bouncingScroll(),
      listener: (state) {
        this.state = state;
        setState(() {});
      },
      headerBuilder: buildHeader,
      footerBuilder: buildFooter,
      builder: buildChild,
    );
  }

  Widget buildHeader(BuildContext context, SheetState state) {
    final screenSize = MediaQuery.of(context).size;
    return CustomContainer(
        animate: true,
        height: screenSize.height * 0.25,
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
          getAtm()
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
                      DatabaseService.visitedATMs(_atm, atmType);
                      _createPolylines(
                          _currentPosition,
                          Position(
                              latitude: _atm.geometry.location.lat,
                              longitude: _atm.geometry.location.long));
                      controller.show();
                      controller.rebuild();
                    });
                    waitNotification();
                    notificationAfterSec();
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
                    controller.rebuild();
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
                      MapService.getNearbyAtm(targetBank, targetOperation);
                      controller.show();
                      controller.rebuild();
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
                          AtmStatus.crowdingStatus != null
                              ? AtmStatus.crowdingStatus
                              : "كثافة الماكينة",
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 16),
                        Text(
                          atmStatus2 != null ? atmStatus2 : "حالة الماكينة",
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 16),
                        Text(
                          atmType != null ? atmType : "نوع الماكينة",
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 16),
                        Text(
                          _atm.vicinity != null
                              ? _atm.vicinity
                              : "عنوان الماكينة",
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

// Notifications
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;

  void initializing() async {
    androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/appicon');
    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return SurveyScreen(atm: _atm, bankName: targetBank);
            },
          ),
        );
      }
    });
  }

  Future<void> notificationAfterSec() async {
    var timeDelayed = DateTime.now().add(Duration(seconds: 5));
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'second channel ID', 'second Channel title', 'second channel body',
            priority: Priority.High,
            importance: Importance.Max,
            ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
        NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.schedule(
        1,
        'تود افضل الخدمات لمكينات ال ATM 💳',
        'فبملء البيانات التالية سنضمن لك خدمة اكثر راحة اضغط هنا 👇🏻',
        timeDelayed,
        notificationDetails);
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return SurveyScreen(atm: _atm, bankName: targetBank);
        },
      ),
    );
  }
}
