import 'package:flutter/material.dart';

void main() {
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Movie Booking App',
            theme: ThemeData(
                primarySwatch: Colors.blue,
            ),
            home: MovieSelectionScreen(),
        );
    }
}

class MovieSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Movie'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (int index = 0; index < 4; index++)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TheaterSelectionScreen(movieIndex: index)),
                  );
                },
                child: Column(
                  children: [
                    Image.network(
                      [
                        'https://image.tmdb.org/t/p/w500/r7MDZVAUA30Pl2Z0dLVL7GnzIvU.jpg', // Hancock
                        'https://image.tmdb.org/t/p/w500/gh4cZbhZxyTbgxQPxD0dOudNPTn.jpg', // Spider-Man
                        'https://image.tmdb.org/t/p/w500/udDclJoHjfjb8Ekgsd4FDteOkCU.jpg', // Batman
                        'https://image.tmdb.org/t/p/w500/2DyEk84XnbJEdPlGF43crxfdtHH.jpg'  // Fast and Furious
                      ][index],
                    ),
                    Text(
                      [
                        'Hancock',
                        'Spider-Man',
                        'Batman',
                        'Fast and Furious'
                      ][index],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class Cinema {
  final String name;

  Cinema({required this.name});
}

List<Cinema> cinemas = [
  Cinema(name: 'Multiplex'),
  Cinema(name: 'Summer'),
  Cinema(name: 'Boomer'),
  Cinema(name: 'Oskar'),
];

class TheaterSelectionScreen extends StatelessWidget {
  final int movieIndex;

  TheaterSelectionScreen({required this.movieIndex});

  @override
  Widget build(BuildContext context) {
    List<Cinema> availableTheaters;
    if (movieIndex == 0 || movieIndex == 2) {
      availableTheaters = [cinemas[0], cinemas[2]]; // Hancock and Batman
    } else {
      availableTheaters = [cinemas[1], cinemas[3]]; // Spider-Man and Fast and Furious
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Theater'),
      ),
      body: ListView.builder(
        itemCount: availableTheaters.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(availableTheaters[index].name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowSelectionScreen(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ShowSelectionScreen extends StatefulWidget {
    @override
    _ShowSelectionScreenState createState() => _ShowSelectionScreenState();
}

class _ShowSelectionScreenState extends State<ShowSelectionScreen> {
  String? selectedFormat = '2D';
  List<String> showTimes = [];

  void updateShowTimes() {
    if (selectedFormat == '2D') {
      showTimes = ['9:00', '10:00', '11:00', '12:00'];
    } else if (selectedFormat == '3D') {
      showTimes = ['13:00', '14:00', '15:00', '16:00'];
    } else if (selectedFormat == 'IMAX') {
      showTimes = ['17:00', '18:00', '19:00', '20:00'];
    }
  }

  @override
  void initState() {
    super.initState();
    updateShowTimes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Show'),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: selectedFormat,
            items: <String>['2D', '3D', 'IMAX'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedFormat = newValue;
                updateShowTimes();
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: showTimes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(showTimes[index]),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SeatSelectionScreen()),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SeatSelectionScreen extends StatefulWidget {
    @override
    _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  List<bool> seats = List.generate(100, (index) => false);
  final double ticketPrice = 10.0;

  double getTotalCost() {
    int selectedSeatsCount = seats.where((seat) => seat).length;
    return selectedSeatsCount * ticketPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Seats'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 10,
              ),
              itemCount: seats.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      seats[index] = !seats[index];
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.all(4.0),
                    color: seats[index] ? Colors.green : Colors.grey,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total: \$${getTotalCost().toStringAsFixed(2)}'),
                ElevatedButton(
                  onPressed: seats.contains(true)
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FoodSelectionScreen(totalCost: getTotalCost())),
                          );
                        }
                      : null,
                  child: Text('Pay'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FoodSelectionScreen extends StatefulWidget {
  final double totalCost;

  FoodSelectionScreen({required this.totalCost});

  @override
  _FoodSelectionScreenState createState() => _FoodSelectionScreenState();
}

class _FoodSelectionScreenState extends State<FoodSelectionScreen> {
  String selectedDrink = 'Water';
  final Map<String, double> drinkPrices = {
    'Water': 0.0,
    'Cola': 5.0,
    'Fanta': 4.0,
    'Sprite': 3.0,
  };

  double getTotalCost() {
    return widget.totalCost + drinkPrices[selectedDrink]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Food'),
      ),
      body: Column(
        children: [
          RadioListTile<String>(
            secondary: Image.network('https://icons.veryicon.com/png/o/miscellaneous/quick/bottle-25.png', width: 40),
            title: Text('Water'),
            value: 'Water',
            groupValue: selectedDrink,
            onChanged: (value) {
              setState(() {
                selectedDrink = value!;
              });
            },
          ),
          RadioListTile<String>(
            secondary: Image.network('https://icons.veryicon.com/png/o/food--drinks/fast-food-color-icon/cola-1.png', width: 40),
            title: Text('Cola'),
            value: 'Cola',
            groupValue: selectedDrink,
            onChanged: (value) {
              setState(() {
                selectedDrink = value!;
              });
            },
          ),
          RadioListTile<String>(
            secondary: Image.network('https://icons.veryicon.com/png/o/food--drinks/fast-food-color-icon/fanta-merinda.png', width: 40),
            title: Text('Fanta'),
            value: 'Fanta',
            groupValue: selectedDrink,
            onChanged: (value) {
              setState(() {
                selectedDrink = value!;
              });
            },
          ),
          RadioListTile<String>(
            secondary: Image.network('https://icons.veryicon.com/png/o/food--drinks/summer-grocery-store/sprite-1.png', width: 40),
            title: Text('Sprite'),
            value: 'Sprite',
            groupValue: selectedDrink,
            onChanged: (value) {
              setState(() {
                selectedDrink = value!;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total: \$${getTotalCost().toStringAsFixed(2)}'),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MovieSelectionScreen()),
                      (route) => false,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Tickets successfully purchased! Ticket number: 12345'),
                      ),
                    );
                  },
                  child: Text('Pay'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}