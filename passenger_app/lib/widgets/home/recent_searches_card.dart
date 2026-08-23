import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/recent_search_provider.dart';
import '../../utils/app_colors.dart';

class RecentSearchesCard extends StatelessWidget {
  const RecentSearchesCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RecentSearchProvider>(
      builder: (context, recentSearchProvider, child) {
        if (recentSearchProvider.searches.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Recent Searches', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: recentSearchProvider.searches.map((search) {
                  return Chip(
                    label: Text(search.busId, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 32),
          ],
        );
      },
    );
  }
}

