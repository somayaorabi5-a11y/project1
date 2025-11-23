import 'package:flutter/material.dart';

class Shape {
  String type;
  int dim;
  Shape(this.type, {this.dim = 1});

  @override
  String toString() => type;
}

List<Shape> shape2D = [
  Shape('Triangle', dim: 1),
  Shape('Circle', dim: 1),
  Shape('Square', dim: 1),
  Shape('Rectangle', dim: 1),
];

List<Shape> shape3D = [
  Shape('Sphere', dim: 2),
  Shape('Cube', dim: 2),
  Shape('Cylinder', dim: 2),
  Shape('Pyramid', dim: 2),
];

class DimensionSelector extends StatefulWidget {
  final Function(int) updateDim;

  const DimensionSelector({required this.updateDim, Key? key}) : super(key: key);

  @override
  State<DimensionSelector> createState() => _DimensionSelectorState();
}

class _DimensionSelectorState extends State<DimensionSelector> {
  int _dim = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Dimension:', style: TextStyle(fontSize: 18)),
        Radio<int>(
          value: 1,
          groupValue: _dim,
          onChanged: (val) {
            setState(() => _dim = val!);
            widget.updateDim(_dim);
          },
        ),
        const Text('2D'),
        Radio<int>(
          value: 2,
          groupValue: _dim,
          onChanged: (val) {
            setState(() => _dim = val!);
            widget.updateDim(_dim);
          },
        ),
        const Text('3D'),
      ],
    );
  }
}

class MyDropdownMenuWidget extends StatefulWidget {
  final Function(Shape) updateType;
  final List<Shape> shapeList;

  const MyDropdownMenuWidget({
    required this.updateType,
    required this.shapeList,
    super.key,
  });

  @override
  State<MyDropdownMenuWidget> createState() => _MyDropdownWidgetState();
}

class _MyDropdownWidgetState extends State<MyDropdownMenuWidget> {
  Shape? selectedShape;

  @override
  void initState() {
    super.initState();
    selectedShape = widget.shapeList.first;
  }

  @override
  void didUpdateWidget(MyDropdownMenuWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shapeList != oldWidget.shapeList) {
      setState(() {
        selectedShape = widget.shapeList.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<Shape>(
      width: 300,
      initialSelection: selectedShape,
      onSelected: (shape) {
        setState(() => selectedShape = shape);
        widget.updateType(shape!);
      },
      dropdownMenuEntries: widget.shapeList
          .map((Shape shape) =>
          DropdownMenuEntry(value: shape, label: shape.toString()))
          .toList(),
    );
  }
}
