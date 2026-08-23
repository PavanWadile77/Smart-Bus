import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../screens/home/search_screen.dart';

class MapHeader extends StatelessWidget {
  final Map<String, dynamic>? busData;

  const MapHeader({Key? key, required this.busData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen()));
        },
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Image.asset('assets/images/logo.png', width: 40, height: 40),
              const SizedBox(width: 8),
              const Icon(Icons.search, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  busData != null
                      ? "Tracking ${(busData!['bus_id'] ?? busData!['id'])}"
                      : "Search Bus or Stop...",
                  style: TextStyle(
                    fontSize: 16,
                    color: busData != null ? AppColors.textPrimary : Colors.grey.shade600,
                    fontWeight: busData != null ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              if (busData != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text("LIVE", style: TextStyle(color: Colors.green.shade800, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
