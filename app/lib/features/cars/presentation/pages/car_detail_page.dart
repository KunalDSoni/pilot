import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/car_provider.dart';

class CarDetailPage extends ConsumerWidget {
  const CarDetailPage({super.key, required this.carId});

  final int carId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final carAsync = ref.watch(carDetailProvider(carId));

    return carAsync.when(
      data: (car) {
        return Scaffold(
          appBar: AppBar(
            title: Text('${car.brand.name} ${car.name}'),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 240,
                  color: colorScheme.surfaceContainerHighest,
                  child: Center(
                    child: Icon(
                      Icons.directions_car,
                      size: 120,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${car.brand.name} ${car.name}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _SpecBadge(label: car.bodyType, icon: Icons.explore),
                          const SizedBox(width: 8),
                          _SpecBadge(
                            label: car.fuelType.name,
                            icon: Icons.local_gas_station,
                          ),
                          const SizedBox(width: 8),
                          _SpecBadge(
                            label: car.transmissionType.name,
                            icon: Icons.settings,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (car.minPrice != null || car.maxPrice != null) ...[
                        Text(
                          '₹${(car.minPrice ?? 0 / 100000).toStringAsFixed(1)}L - ₹${(car.maxPrice ?? 0 / 100000).toStringAsFixed(1)}L',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                      Text(
                        'Specifications',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _SpecRow(label: 'Year', value: car.year.toString()),
                      if (car.engine != null)
                        _SpecRow(label: 'Engine', value: car.engine!),
                      if (car.mileage != null)
                        _SpecRow(
                            label: 'Mileage',
                            value: '${car.mileage} kmpl'),
                      if (car.seatingCapacity != null)
                        _SpecRow(
                            label: 'Seating',
                            value: '${car.seatingCapacity} Seats'),
                      if (car.variants != null && car.variants!.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Text(
                          'Variants',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...car.variants!.map((variant) {
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(variant.name),
                              subtitle: Text(
                                '₹${(variant.price / 100000).toStringAsFixed(1)}L | ${variant.fuelType.name} | ${variant.transmissionType.name}',
                              ),
                              trailing: FilledButton.tonal(
                                onPressed: () {
                                  context.push('/inquiries', extra: {
                                    'variant_id': variant.id,
                                    'car_name':
                                        '${car.brand.name} ${car.name} ${variant.name}',
                                  });
                                },
                                child: const Text('Inquire'),
                              ),
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Failed to load car details')),
      ),
    );
  }
}

class _SpecBadge extends StatelessWidget {
  const _SpecBadge({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
    );
  }
}

class _SpecRow extends StatelessWidget {
  const _SpecRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
