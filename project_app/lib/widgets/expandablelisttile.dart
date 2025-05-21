import 'package:flutter/material.dart';

class ExpandableListTile extends StatefulWidget {
  final String packageType;
  final String address;
  final List<Widget> actions;

  const ExpandableListTile({
    Key? key,
    required this.packageType,
    required this.address,
    required this.actions,
  }) : super(key: key);

  @override
  State<ExpandableListTile> createState() => _ExpandableListTileState();
}

class _ExpandableListTileState extends State<ExpandableListTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: SizedBox(width: 50),
          title: Center(child: Text(widget.address + ' - ' + widget.packageType)),
          trailing: IconButton(
            icon: Icon(isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right),
            onPressed: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
          ),
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: widget.actions,
            ),
          ),
      ],
    );
  }
}