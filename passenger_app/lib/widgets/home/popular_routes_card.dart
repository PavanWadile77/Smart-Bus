import 'package:flutter/material.dart';
import '../../models/timetable_model.dart';
import '../../utils/app_colors.dart';

class PopularRoutesCard extends StatelessWidget {
  final List<TimetableModel> timetable;

  const PopularRoutesCard({Key? key, required this.timetable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (timetable.isEmpty) return const SizedBox.shrink();

    // Extract unique routes
    final Set<String> seen = {};
    final List<TimetableModel> popularRoutes = [];
    for (var bus in timetable) {
      String routeKey = "${bus.source}-${bus.destination}";
      if (!seen.contains(routeKey)) {
        seen.add(routeKey);
        popularRoutes.add(bus);
        if (popularRoutes.length >= 5) break;
      }
    }

    if (popularRoutes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('Popular Routes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 110,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: popularRoutes.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final bus = popularRoutes[index];
              return Container(
                width: 150,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(bus.source, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Icon(Icons.arrow_downward, size: 16, color: AppColors.primary),
                    ),
                    Text(bus.destination, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
