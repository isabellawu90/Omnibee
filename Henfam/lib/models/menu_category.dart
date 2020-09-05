import 'models.dart';
import 'package:equatable/equatable.dart';

class MenuCategory extends Equatable {
  final String categoryName;
  final List<MenuItem> menuItems;

  MenuCategory(this.categoryName, this.menuItems);

  @override
  List<Object> get props => [
        categoryName,
        menuItems,
      ];
}
