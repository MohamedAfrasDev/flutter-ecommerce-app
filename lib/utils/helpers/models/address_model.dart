class AddressModel {
  final String id;
  final String name;
  final String phone;
  final String street;
  final String postalCode;
  final String city;
  final String state;
  final String country;

  AddressModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.street,
    required this.postalCode,
    required this.city,
    required this.state,
    required this.country,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'street': street,
    'postalCode': postalCode,
    'city': city,
    'state': state,
    'country': country,
  };

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
    id: json['id'],
    name: json['name'],
    phone: json['phone'],
    street: json['street'],
    postalCode: json['postalCode'],
    city: json['city'],
    state: json['state'],
    country: json['country'],
  );
}
