import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/HomePageModel.dart';

class HomePageWidget extends StatelessWidget {
  const HomePageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomePageModel(),
      child: Consumer<HomePageModel>(
        builder: (context, vm, child) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Header (profil, notification, recherche)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              'https://images.unsplash.com/photo-1566492031773-4f4e44671857?w=500',
                              width: 40,
                              height: 40,
                            ),
                          ),
                          Row(
                            children: const [
                              Icon(Icons.notifications_none),
                              SizedBox(width: 16),
                              Icon(Icons.search_rounded),
                            ],
                          )
                        ],
                      ),
                    ),

                    // Services
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        height: 100,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: vm.services.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            final service = vm.services[index];
                            return Container(
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (service.image != null)
                                    Image.network(service.image!, width: 60, height: 60),
                                  Text(service.label),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Salons
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Nearest Salon', style: TextStyle(fontSize: 18)),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 180,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: vm.salons.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 16),
                              itemBuilder: (context, index) {
                                final salon = vm.salons[index];
                                return Container(
                                  width: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    image: DecorationImage(
                                      image: NetworkImage(salon.image),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius: const BorderRadius.vertical(
                                            bottom: Radius.circular(16),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              salon.name,
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                            Text(
                                              '${salon.away} • ${salon.rating} ⭐',
                                              style: const TextStyle(color: Colors.white70),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
