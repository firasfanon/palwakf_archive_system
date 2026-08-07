import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/state/local_operational_store.dart';
import '../../shared/widgets.dart';
import '../evidence/evidence_detail_screen.dart';

class SearchDiscoveryScreen extends ConsumerStatefulWidget {
  const SearchDiscoveryScreen({super.key});

  @override
  ConsumerState<SearchDiscoveryScreen> createState() =>
      _SearchDiscoveryScreenState();
}

class _SearchDiscoveryScreenState extends ConsumerState<SearchDiscoveryScreen> {
  final _query = TextEditingController();
  EvidenceDomain? _domain;
  EvidenceReviewStatus? _status;
  AccessLevel? _accessLevel;
  SpatialStatus? _spatialStatus;
  bool _onlyWithWaqfAsset = false;

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(localOperationalProvider);
    var results =
        ref.read(localOperationalProvider.notifier).searchEvidence(_query.text);
    if (_domain != null) {
      results = results
          .where((item) => item.domain == _domain)
          .toList(growable: false);
    }
    if (_status != null) {
      results = results
          .where((item) => item.status == _status)
          .toList(growable: false);
    }
    if (_accessLevel != null) {
      results = results
          .where((item) => item.accessLevel == _accessLevel)
          .toList(growable: false);
    }
    if (_spatialStatus != null) {
      results = results
          .where((item) => item.spatialStatus == _spatialStatus)
          .toList(growable: false);
    }
    if (_onlyWithWaqfAsset) {
      results = results
          .where((item) => item.linkedWaqfAssetId != null)
          .toList(growable: false);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('الفهرس والبحث', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const LocalOnlyBanner(),
        const SizedBox(height: 12),
        SectionCard(
          icon: Icons.manage_search_outlined,
          title: 'بحث ذكي محلي',
          subtitle:
              'SMART_SEARCH_ADVANCED_FILTERS: فلاتر يومية حسب المجال والحالة والإتاحة والمكان وروابط waqf_asset_id.',
          children: [
            TextField(
              controller: _query,
              decoration: const InputDecoration(
                labelText: 'بحث محلي في العنوان، المرجع، المصدر، waqf_asset_id',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _domainFilter(),
                _statusFilter(),
                _accessFilter(),
                _spatialFilter(),
                FilterChip(
                  selected: _onlyWithWaqfAsset,
                  label: const Text('مرتبط بأصل وقفي'),
                  avatar: const Icon(Icons.link_outlined),
                  onSelected: (value) =>
                      setState(() => _onlyWithWaqfAsset = value),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text('النتائج: ${results.length} من ${state.evidence.length}'),
        const SizedBox(height: 12),
        if (results.isEmpty)
          const EmptyState(message: 'لا توجد نتائج مطابقة.')
        else
          for (final item in results) ...[
            Card(
              child: ListTile(
                leading: const Icon(Icons.description_outlined),
                title: Text(item.title),
                subtitle: Text('${item.reference}\n${item.sourceAuthority}'),
                isThreeLine: true,
                trailing: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    StatusPill(label: item.domain.label),
                    StatusPill(label: item.status.label),
                    IconButton.outlined(
                      tooltip: 'فتح التفاصيل',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                EvidenceDetailScreen(itemId: item.id),
                          ),
                        );
                      },
                      icon: const Icon(Icons.open_in_new_outlined),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
      ],
    );
  }

  Widget _domainFilter() {
    return SizedBox(
      width: 240,
      child: DropdownButtonFormField<EvidenceDomain?>(
        initialValue: _domain,
        decoration: const InputDecoration(labelText: 'المجال'),
        items: [
          const DropdownMenuItem<EvidenceDomain?>(
              value: null, child: Text('كل المجالات')),
          for (final domain in EvidenceDomain.values)
            DropdownMenuItem<EvidenceDomain?>(
                value: domain, child: Text(domain.label)),
        ],
        onChanged: (value) => setState(() => _domain = value),
      ),
    );
  }

  Widget _statusFilter() {
    return SizedBox(
      width: 240,
      child: DropdownButtonFormField<EvidenceReviewStatus?>(
        initialValue: _status,
        decoration: const InputDecoration(labelText: 'حالة المراجعة'),
        items: [
          const DropdownMenuItem<EvidenceReviewStatus?>(
              value: null, child: Text('كل الحالات')),
          for (final status in EvidenceReviewStatus.values)
            DropdownMenuItem<EvidenceReviewStatus?>(
                value: status, child: Text(status.label)),
        ],
        onChanged: (value) => setState(() => _status = value),
      ),
    );
  }

  Widget _accessFilter() {
    return SizedBox(
      width: 240,
      child: DropdownButtonFormField<AccessLevel?>(
        initialValue: _accessLevel,
        decoration: const InputDecoration(labelText: 'الإتاحة'),
        items: [
          const DropdownMenuItem<AccessLevel?>(
              value: null, child: Text('كل الإتاحات')),
          for (final access in AccessLevel.values)
            DropdownMenuItem<AccessLevel?>(
                value: access, child: Text(access.label)),
        ],
        onChanged: (value) => setState(() => _accessLevel = value),
      ),
    );
  }

  Widget _spatialFilter() {
    return SizedBox(
      width: 240,
      child: DropdownButtonFormField<SpatialStatus?>(
        initialValue: _spatialStatus,
        decoration: const InputDecoration(labelText: 'الحالة المكانية'),
        items: [
          const DropdownMenuItem<SpatialStatus?>(
              value: null, child: Text('كل الحالات المكانية')),
          for (final status in SpatialStatus.values)
            DropdownMenuItem<SpatialStatus?>(
                value: status, child: Text(status.label)),
        ],
        onChanged: (value) => setState(() => _spatialStatus = value),
      ),
    );
  }
}
