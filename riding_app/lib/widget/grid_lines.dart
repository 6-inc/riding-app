import 'package:flutter/material.dart';
import 'package:responsive_toolkit/responsive_toolkit.dart';

class GridLines extends StatelessWidget {
  final List<Widget> children;

  const GridLines({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Stack(
        children: [
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) => ResponsiveRow(
                columns: List.generate(
                  12,
                  (i) => ResponsiveColumn.span(
                    span: 1,
                    child: Container(
                      height: constraints.maxHeight,
                      decoration: BoxDecoration(
                        border: BorderDirectional(
                          end: BorderSide(color: Colors.blue.shade200),
                          start: i == 0
                              ? BorderSide(color: Colors.blue.shade200)
                              : BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children
                .map(
                  (c) => Padding(
                    padding: EdgeInsets.only(
                        bottom: c == children.last ? 0.0 : 16.0),
                    child: c,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
