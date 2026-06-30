import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/inquiry_provider.dart';

class InquiryPage extends ConsumerStatefulWidget {
  const InquiryPage({super.key});

  @override
  ConsumerState<InquiryPage> createState() => _InquiryPageState();
}

class _InquiryPageState extends ConsumerState<InquiryPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(inquiryListProvider.notifier).loadInquiries();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inquiriesAsync = ref.watch(inquiryListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Inquiries'),
      ),
      body: inquiriesAsync.when(
        data: (inquiries) {
          if (inquiries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No inquiries yet',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Browse cars and submit an inquiry',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => context.push('/cars'),
                    child: const Text('Browse Cars'),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(inquiryListProvider.notifier).loadInquiries(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: inquiries.length,
              itemBuilder: (context, index) {
                final inquiry = inquiries[index];
                return _InquiryCard(inquiry: inquiry);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 16),
              Text('Failed to load inquiries'),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () {
                  ref.read(inquiryListProvider.notifier).loadInquiries();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InquiryCard extends StatelessWidget {
  const _InquiryCard({required this.inquiry});

  final dynamic inquiry;

  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'contacted':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _statusColor(inquiry.status).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.directions_car,
                color: _statusColor(inquiry.status),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Inquiry #${inquiry.id}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _statusColor(inquiry.status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      inquiry.status.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: _statusColor(inquiry.status),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${DateTime.now().difference(inquiry.createdAt).inDays}d ago',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
