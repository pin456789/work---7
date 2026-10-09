/// ข้อมูลตู้คอนเทนเนอร์ / ล็อตยา
class Shipment {
  String containerId;
  String productType;
  String qaEmail;
  double maxTemp;
  int hoursLeft;
  String route;

  Shipment({
    required this.containerId,
    required this.productType,
    required this.qaEmail,
    required this.maxTemp,
    required this.hoursLeft,
    this.route = '',
  });
}