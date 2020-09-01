import 'package:equatable/equatable.dart';

import 'menu_item.dart';

class Restaurant extends Equatable {
  final String name;
  final List<double> location;
  final String imagePath;
  final List<MenuItem> menu;

  Restaurant({this.name, this.location, this.imagePath, this.menu});

  @override
  List<Object> get props => [name, location, imagePath];
}
