import 'package:Feen/ui/widgets/defaultData.dart';

import 'Geometry.dart';

class PlaceResult {
  Geometry geometry;
  String name;
  double rating;
  String placeId;
  String id;
  String vicinity;
  String distance;
  String crowd;
  String type;
  String enoughMoney;

  PlaceResult({
    this.id,
    this.geometry,
    this.name,
    this.placeId,
    this.vicinity,
    this.rating,
    this.distance,
    this.crowd,
    this.type,
    this.enoughMoney,
  });

  factory PlaceResult.fromJson(Map<String, dynamic> json) {
    return PlaceResult(
      geometry: Geometry.fromJson(json['geometry']),
      id: json['id'],
      name: json['name'],
      placeId: json['place_id'],
      rating: json['rating'] != null ? json['rating'].toDouble() : 0.0,
      vicinity: json['vicinity'],
      distance: "0.0",
      crowd: AtmStatus.crowdingStatus,
      type: " نوع الماكينة",
      enoughMoney: "تكفي",
    );
  }
}
