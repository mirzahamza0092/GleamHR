import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class ViewEmplyeeLocation extends StatelessWidget {
  final String userId;
  const ViewEmplyeeLocation({Key? key, required this.userId}) : super(key: key);
  // List<LatLng> polylineCoordinates = [];
  // PolylinePoints polylinePoints = PolylinePoints();
  // Set<Polyline> _polylines = {};

  // @override
  // void initState() {
  //   super.initState();
  //   // _getPolyline();
  // }
  Stream<QuerySnapshot> fetchTodayUserDataStream(String userId) {
    DateTime now = DateTime.now();
    DateTime startOfDay =
        DateTime(now.year, now.month, now.day, 0, 0, 0); // Start of today
    DateTime endOfDay =
        DateTime(now.year, now.month, now.day, 23, 59, 59); // End of today

    return FirebaseFirestore.instance
        .collection("Users")
        .where("user_id", isEqualTo: userId)
        .where("time",
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where("time", isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .snapshots();
  }
  // void _getPolyline() async {
  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //     'AIzaSyAK4M5dY-0P9pDc12nBdHnsmyCkFJMENSQ', // Replace with your actual API key
  //     PointLatLng(33.662929, 73.006725), // origin latitude and longitude
  //     PointLatLng(33.710922, 73.027325), // destination latitude and longitude
  //     travelMode: TravelMode.driving,
  //   );

  //   if (result.points.isNotEmpty) {
  //     result.points.forEach((PointLatLng point) {
  //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //     });
  //   }

  //   setState(() {
  //     _polylines.add(Polyline(
  //       polylineId: PolylineId('polyline'),
  //       color: Colors.blue,
  //       points: polylineCoordinates,
  //       width: 5,
  //     ));
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Location'),
      ),
      body: StreamBuilder(
        stream: fetchTodayUserDataStream(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive()); // Placeholder for loading state
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Data is ready
            List<DocumentSnapshot> documents = snapshot.data!.docs;

            // Extract latitude and longitude for markers
            List<Marker> markers = documents.map((document) {
              double latitude = document['latitude'] as double;
              double longitude = document['longitude'] as double;
              return Marker(
                markerId: MarkerId(document.id),
                position: LatLng(latitude, longitude),
                // You can customize other properties of the marker as needed
                // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                // infoWindow: InfoWindow(title: 'Title', snippet: 'Snippet'),
              );
            }).toList();

            // Extract latitude and longitude for polylines
            List<LatLng> polylineCoordinates = documents.map((document) {
              double latitude = document['latitude'] as double;
              double longitude = document['longitude'] as double;
              return LatLng(latitude, longitude);
            }).toList();

            // // Create polyline points
            // Create polyline from polylineCoordinates
            // Polyline polyline = Polyline(
            //   polylineId:const PolylineId('route'),
            //   color: Colors.blue,
            //   width: 3,
            //   points: polylineCoordinates,
            // );

            // Create set of polylines
            // Set<Polyline> polylines = Set<Polyline>.of([polyline]);
            //
            LatLng target =const LatLng(0.0, 0.0);
            if (documents.isNotEmpty) {
            DocumentSnapshot lastDocument = documents.last;
            double lastLatitude = lastDocument['latitude'] as double;
            double lastLongitude = lastDocument['longitude'] as double;
            target = LatLng(lastLatitude, lastLongitude);
            }
            return GoogleMap(
              markers: Set<Marker>.of(markers),
              // polylines: polylines,
              initialCameraPosition: CameraPosition(
                target:target, // Initial location
                zoom:documents.isNotEmpty? 15.0:0.0,
              ),
            );
          }
        },
      ),
    );
  }
}
