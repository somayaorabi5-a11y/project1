import 'package:flutter/material.dart';
import 'shape.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int dim = 1;
  late List<Shape> currentList;
  late Shape selectedShape;

  bool showInputs = false;
  List<TextEditingController> controllers = [];

  String result = "";

  @override
  void initState() {
    super.initState();
    currentList = shape2D;
    selectedShape = currentList.first;
  }

  void updateDim(int newDim) {
    setState(() {
      dim = newDim;
      currentList = (dim == 1) ? shape2D : shape3D;
      selectedShape = currentList.first;
      showInputs = false;
      result = "";
    });
  }

  void updateType(Shape shape) {
    setState(() {
      selectedShape = shape;
      showInputs = false;
      result = "";
    });
  }

  // Create the needed input boxes
  void generateInputs() {
    controllers.clear();
    int count = inputCountForShape(selectedShape.type);

    for (int i = 0; i < count; i++) {
      controllers.add(TextEditingController()); //creates a new TextEditingController and adds it to the list
    }
  }

  int inputCountForShape(String type) {
    switch (type) {
      case "Triangle":
        return 3;
      case "Rectangle":
        return 2;
      case "Cylinder":
        return 2;
      case "Pyramid":
        return 2;
      default:
        return 1; // Circle, Square, Sphere, Cube
    }
  }

  void calculate() {
    double a = controllers.isNotEmpty ? double.tryParse(controllers[0].text) ?? 0 : 0; //true when the list has one or more controllers.
    double b = controllers.length ==2 ? double.tryParse(controllers[1].text) ?? 0 : 0;
    double c = controllers.length >2 ? double.tryParse(controllers[1].text) ?? 0 : 0;

    switch (selectedShape.type) {
      case "Circle":
        result = "Area = ${3.14 * a * a}\n"
            "Perimeter = ${2 * 3.14 * a}";
        break;

      case "Square":
        result = "Area = ${a * a}\n"
            "Perimeter = ${4 * a}";
        break;

      case "Rectangle":
        result = "Area = ${a * b}\n"
            "Perimeter = ${2 * (a + b)}";
        break;

      case "Triangle":
        result = "Area = ${0.5 * a * b}\n"
            "Perimeter = ${a + b+c}";
        break;

      case "Sphere":
        result = "Volume = ${(4 / 3) * 3.14 * a * a * a}\n"
            "Surface Area = ${4 * 3.14 * a * a}";
        break;

      case "Cube":
        result = "Volume = ${a * a * a}\n"
            "Surface Area = ${6 * a * a}";
        break;

      case "Cylinder":
        result = "Volume = ${3.14 * a * a * b}\n"
            "Surface Area = ${(2 * 3.14 * a * (a + b))}";
        break;

      case "Pyramid":
        result = "Volume = ${(1 / 3) * a * b}";
        break;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Geometry Calculator"),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            //  Shape Selection
            Card(
              elevation: 5,//shadow
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    const Text(
                      "Choose Shape",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 15),
                    DimensionSelector(updateDim: updateDim),

                    MyDropdownMenuWidget(
                      updateType: updateType,
                      shapeList: currentList,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // CONTINUE BUTTON
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () {
                generateInputs();
                setState(() => showInputs = true);
              },
              child: const Text(
                "Continue",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),

            const SizedBox(height: 25),

            // Input Section
            if (showInputs)
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [

                      const Text(
                        "Enter Values",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),

                      ...List.generate(
                        controllers.length,
                            (i) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: TextField(
                            controller: controllers[i],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Value ${i + 1}",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        onPressed: calculate,
                        child: const Text(
                          "Calculate",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 20),

            //  Result
            if (result.isNotEmpty)
              Card(
                color: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    result,
                    style: const TextStyle(fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
