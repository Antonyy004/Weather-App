import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Result extends StatefulWidget {
  final String place;

  const Result({super.key, required this.place});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {

  Future<Map<String, dynamic>> getDataFromAPI() async {
    final response = await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=${widget.place}&appid=71ea194f07e2f6ce2db5d8579b2bbc4b&units=metric"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception("Error!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Cuaca Sekarang",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.black87,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black,
          ),
          child: FutureBuilder<Map<String, dynamic>>(
            future: getDataFromAPI(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                final data = snapshot.data!;
                final weather = data["weather"][0]["description"] ?? "Tidak ada deskripsi";
                final mainWeather = data["weather"][0]["main"] ?? "Tidak ada data";
                final temp = data["main"]["temp"] ?? 0.0;
                final humidity = data["main"]["humidity"] ?? 0;
                final windSpeed = data["wind"]["speed"] ?? 0.0;

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 8,
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        color: Colors.grey[850],  // Card dengan warna gelap
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                "Cuaca di ${widget.place}",
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Kondisi: $mainWeather",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Deskripsi: $weather",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white60,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.thermostat_outlined,
                                        color: Colors.orangeAccent,
                                        size: 30,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "${temp.toStringAsFixed(1)}°C",
                                        style: const TextStyle(fontSize: 22, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.water_drop,
                                        color: Colors.blueAccent,
                                        size: 30,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "$humidity%",
                                        style: const TextStyle(fontSize: 22, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.air,
                                        color: Colors.greenAccent,
                                        size: 30,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "${windSpeed.toStringAsFixed(1)} m/s",
                                        style: const TextStyle(fontSize: 22, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return const Center(child: Text("Terjadi kesalahan!", style: TextStyle(color: Colors.white)));
              } else {
                return const Center(child: Text("Tempat Tidak Diketahui", style: TextStyle(color: Colors.white)));
              }
            },
          ),
        ),
      ),
    );
  }
}
