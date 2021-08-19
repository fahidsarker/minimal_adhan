enum LocationMode{
  CACHED, LIVE
}
class LocationInfo{
  final double latitude;
  final double longitude;
  final String address;
  final LocationMode mode;

  LocationInfo(this.latitude, this.longitude, this.address, this.mode);

  LocationInfo copy(){
    return LocationInfo(latitude, longitude, address, mode);
  }
}