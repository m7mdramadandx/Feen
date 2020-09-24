class History {
  String id;
  String name;
  double lat;
  double lng;
  double rating;
  String type;
  String date;
  String time;
  String vicinity;

  History(
      {this.date,
      this.id,
      this.lat,
      this.lng,
      this.name,
      this.rating,
      this.time,
      this.type,
      this.vicinity});

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      date: json['date'],
      id: json['id'],
      lat: json['latitude'],
      lng: json['longitude'],
      name: json['name'],
      rating: json['rating'] ,
      time: json['time'],
      type: json['type'],
      vicinity: json['vicinity'],
    );
  }
}
