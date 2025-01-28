class IceCream {
  final int? id;
  final String? name;
  final String? flavor;
  final double? price;
  final String? image;

  IceCream({this.id, this.name, this.flavor, this.price, this.image});

  factory IceCream.fromJson(Map<String, dynamic> json) {
    return IceCream(
      id: json['id'],
      name: json['name'],
      flavor: json['flavor'],
      price: json['price'].toDouble(), 
      image: json['image'],
    );
  }
}
