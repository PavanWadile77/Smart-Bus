import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/tracking_provider.dart';
import '../../providers/timetable_provider.dart';
import '../tracking/bus_details_screen.dart';

// Extracted UI Widgets
import '../../widgets/search/search_result_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = "";
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', width: 40, height: 40),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _controller,
                autofocus: true,
                style: const TextStyle(color: Colors.white, fontSize: 18),
          decoration: InputDecoration(
            hintText: "Search Bus Number, Route, Stop...",
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white),
                    onPressed: () {
                      _controller.clear();
                      setState(() {
                        _searchQuery = "";
                      });
                    },
                  )
                : null,
          ),
          cursorColor: Colors.white,
          onChanged: (val) {
            setState(() {
              _searchQuery = val.toLowerCase();
            });
          },
        ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey.shade50,
      body: Consumer<TimetableProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final results = _searchQuery.isEmpty 
              ? provider.timetable
              : provider.timetable.where((bus) {
                  final busNumber = bus.busNumber.toLowerCase();
                  final route = bus.routeId.toLowerCase();
                  final source = bus.source.toLowerCase();
                  final destination = bus.destination.toLowerCase();
                  final hasStop = bus.stops.any((stop) => stop.toLowerCase().contains(_searchQuery));
                  
                  return busNumber.contains(_searchQuery) ||
                      route.contains(_searchQuery) ||
                      source.contains(_searchQuery) ||
                      destination.contains(_searchQuery) ||
                      hasStop;
                }).toList();



          if (results.isEmpty) {
            return const Center(
                child: Text("No buses or routes found.",
                    style: TextStyle(color: Colors.grey, fontSize: 16)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final bus = results[index];
              return SearchResultCard(
                bus: bus,
                onTap: () {
                  final trackingProvider = Provider.of<TrackingProvider>(context, listen: false);
                  trackingProvider.trackBus(bus.busId);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BusDetailsScreen()));
                },
              );
            },
          );
        },
      ),
    );
  }
}

