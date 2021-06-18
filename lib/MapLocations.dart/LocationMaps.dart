import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:location_permissions/location_permissions.dart'as prefix;

import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:milyar/Utils/color.dart';

class LocationsMaps extends StatefulWidget {
  @override
  _LocationsMapsState createState() => _LocationsMapsState();
}

class _LocationsMapsState extends State<LocationsMaps> {
  BitmapDescriptor myIcon;

  GoogleMapController myController;
  double currentLat;
  double currentLong;
  dynamic currentAddress;
  String searchAddress = 'Search with Locations';
  Marker marker = Marker(
    markerId: MarkerId("1"),
  );

  Set<Marker> mark = Set();

  var location = Location();

  void initState() {
    super.initState();
    LocationPermissions().requestPermissions().then((prefix.PermissionStatus status) {
      if (status == prefix.PermissionStatus.granted) {
        location.getLocation().then((LocationData myLocation) {
          setState(() {
            Geolocator()
                .placemarkFromCoordinates(
                    myLocation.latitude, myLocation.longitude)
                .then((address) {
              setState(() {
                currentAddress = address[0].name + " " + address[0].country;
                print("================== $currentAddress");
              });
            });
            currentLat = myLocation.latitude;
            currentLong = myLocation.longitude;

            InfoWindow infoWindow = InfoWindow(title: "Location");
            Marker marker = Marker(
              draggable: true,
              markerId: MarkerId('markers.length.toString()'),
              infoWindow: infoWindow,
              position: LatLng(myLocation.latitude, myLocation.longitude),
              icon: myIcon,
            );
            setState(() {
              mark.add(marker);
            });
          });
        });
      } else {}
    });
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(
        size: Size(
          0,
          0,
        ),
        devicePixelRatio: .9,
      ),
      'assets/nnnn.png',
    ).then((onValue) {
      myIcon = onValue;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      myController = controller;
    });
  }

  Position updatedPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: currentLat == null && currentLong == null
            ? Center(
                child: CupertinoActivityIndicator(
                animating: true,
                radius: 15,
              ))
            : Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: <Widget>[
                    GoogleMap(
                      onCameraIdle: () {
                        print(updatedPosition);
                      },
                      onTap: (newLang) {
                        currentLat = updatedPosition.latitude;
                        currentLong = updatedPosition.longitude;
                        print('LAT    ' + currentLat.toString());
                        print('LONG    ' + currentLong.toString());
                      },
                      initialCameraPosition: CameraPosition(
                          target: LatLng(currentLat, currentLong), zoom: 15.0),
                      onMapCreated: _onMapCreated,
                      onCameraMove: ((_position) => _updatePosition(_position)),
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.location_on,
                          size: 40,
                          color: Color(getColorHexFromStr('#FC7D3C')),
                        )),
                    _buildSearch(),
                    Positioned(
                      top: MediaQuery.of(context).size.height - 50,
                      left: 30,
                      right: 30,
                      child: Padding(
                        padding: EdgeInsets.only(left: 0, right: 0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context, {
                              "lat": currentLat,
                              "long": currentLong,
                              "address": currentAddress
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            child: Center(
                              child: Text(
                                'تأكيد الموقع',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(getColorHexFromStr('#FC7D3C')),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  void _updatePosition(CameraPosition _position) {
    Position newMarkerPosition = Position(
        latitude: _position.target.latitude,
        longitude: _position.target.longitude);
    setState(() {
      updatedPosition = newMarkerPosition;
      marker = marker.copyWith(
          positionParam:
              LatLng(newMarkerPosition.latitude, newMarkerPosition.longitude));
      Geolocator()
          .placemarkFromCoordinates(
              updatedPosition.latitude, updatedPosition.longitude)
          .then((address) {
        setState(() {
          currentAddress = address[0].name + "  " + address[0].country;
          print("================== $currentAddress");
        });
      });
    });
  }

  Widget _buildSearch() {
    return Positioned(
      top: 50,
      right: 15,
      left: 15,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0), color: Colors.white),
        child: TextField(
          decoration: InputDecoration(
            hintText: searchAddress,
            hintStyle:
                TextStyle(color: Colors.black.withOpacity(0.2), fontSize: 14),
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
            prefixIcon: IconButton(
              icon: Icon(
                Icons.search,
                color: Theme.of(context).backgroundColor,
              ),
              onPressed: searchAndNavigate,
              iconSize: 30,
              color: Theme.of(context).primaryColor,
            ),
            suffixIcon: Padding(
              padding: EdgeInsets.only(left: 20, right: 15, top: 0),
              child: Container(
                width: 20,
                height: 20,
                child: Center(
                    child: Image.asset(
                  'assets/filter.png',
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                )),
              ),
            ),
          ),
          onChanged: (value) {
            setState(() {
              searchAddress = value;
            });
          },
        ),
      ),
    );
  }

  searchAndNavigate() {
    Geolocator().placemarkFromAddress(searchAddress).then((result) {
      myController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:
              LatLng(result[0].position.latitude, result[0].position.longitude),
          zoom: 10.0)));
    });
  }
}
