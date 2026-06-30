import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello${authState.user?.name != null ? ', ${authState.user!.name}' : ''}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        AppConstants.appTagline,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 56,
                child: TextField(
                  readOnly: true,
                  onTap: () => context.push('/cars'),
                  decoration: InputDecoration(
                    hintText: 'Search cars...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Browse by Body Type',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _BodyTypeChip(
                      icon: Icons.directions_car,
                      label: 'Hatchback',
                      onTap: () => context.push('/cars', extra: {'body_type': 'Hatchback'}),
                    ),
                    _BodyTypeChip(
                      icon: Icons.time_to_leave,
                      label: 'Sedan',
                      onTap: () => context.push('/cars', extra: {'body_type': 'Sedan'}),
                    ),
                    _BodyTypeChip(
                      icon: Icons.explore,
                      label: 'SUV',
                      onTap: () => context.push('/cars', extra: {'body_type': 'SUV'}),
                    ),
                    _BodyTypeChip(
                      icon: Icons.local_shipping,
                      label: 'MUV',
                      onTap: () => context.push('/cars', extra: {'body_type': 'MUV'}),
                    ),
                    _BodyTypeChip(
                      icon: Icons.electric_car,
                      label: 'Electric',
                      onTap: () => context.push('/cars', extra: {'fuel_type': 'electric'}),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular Cars',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/cars'),
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const _PopularCarPlaceholder(),
            ],
          ),
        ),
      ),
    );
  }
}

class _BodyTypeChip extends StatelessWidget {
  const _BodyTypeChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 80,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: colorScheme.primary),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PopularCarPlaceholder extends StatelessWidget {
  const _PopularCarPlaceholder();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(4, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              width: 280,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text('Car Card Placeholder'),
              ),
            ),
          );
        }),
      ),
    );
  }
}
