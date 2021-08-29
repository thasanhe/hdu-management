import 'package:flutter/cupertino.dart';
import 'package:hdu_management/widgets/expanded_tile.dart';

class ManagementTile extends ExpandedTile {
  final String title;
  final List<String> expandedItemsList;

  ManagementTile({
    required this.title,
    required this.expandedItemsList,
  }) : super(
          title: title,
          expandedItemsList: expandedItemsList,
        );
}
