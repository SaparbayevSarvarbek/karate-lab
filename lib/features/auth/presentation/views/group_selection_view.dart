import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/training_group_card.dart';

/// Karate mashg'ulot guruhini tanlash sahifasi (sportchi ro'yxatdan o'tishida).
///
/// Tanlangan guruh `context.pop(guruh)` orqali qaytariladi. Faqat `O'MG`
/// hozircha tanlanadi; qolgan guruhlar "Tez orada" toastini ko'rsatadi.
class GroupSelectionView extends StatefulWidget {
  final String? initialGroup;

  const GroupSelectionView({super.key, this.initialGroup});

  @override
  State<GroupSelectionView> createState() => _GroupSelectionViewState();
}

class _GroupSelectionViewState extends State<GroupSelectionView> {
  String? _selectedGroup;

  // (title, subtitle, selectable)
  static const List<(String, String, bool)> _groups = [
    ('SSG', 'sport-sog\'lomlashtirish guruhi', false),
    ('BTG', 'boshlang\'ich tayyorgarlik guruhi', false),
    ('O\'MG', 'o\'quv-mashg\'ulot guruhi', true),
    ('SKEG', 'sportda kamolotga erishish guruhi', false),
    ('OSMG', 'oliy sport mahorati guruhi', false),
  ];

  @override
  void initState() {
    super.initState();
    _selectedGroup = widget.initialGroup;
  }

  void _onSelect(String group, bool selectable) {
    if (!selectable) return;
    // Tanlangan guruh darhol qaytariladi — keyingi bosqichga o'tadi.
    context.pop(group);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mashg\'ulot guruhini tanlang'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Guruhni tanlang', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 4),
              const Text(
                'Sportchi qaysi guruhda mashg\'ulot o\'tkazishini belgilang',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 24),
              for (final (title, subtitle, selectable) in _groups) ...[
                TrainingGroupCard(
                  title: title,
                  subtitle: subtitle,
                  groupKey: title,
                  selectable: selectable,
                  isSelected: _selectedGroup == title,
                  onSelect: () => _onSelect(title, selectable),
                ),
                if (title != _groups.last.$1) const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
