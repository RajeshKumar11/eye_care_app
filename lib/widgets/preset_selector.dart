import 'package:flutter/material.dart';
import '../models/settings_model.dart';
import '../utils/constants.dart';

/// Widget for selecting eye care presets
class PresetSelector extends StatelessWidget {
  final EyeCarePreset selectedPreset;
  final ValueChanged<EyeCarePreset> onPresetChanged;

  const PresetSelector({
    super.key,
    required this.selectedPreset,
    required this.onPresetChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Quick Presets',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...EyeCarePreset.values.map((preset) {
          if (preset == EyeCarePreset.custom) {
            return const SizedBox.shrink();
          }
          return _PresetTile(
            preset: preset,
            isSelected: selectedPreset == preset,
            onTap: () => onPresetChanged(preset),
          );
        }),
      ],
    );
  }
}

class _PresetTile extends StatelessWidget {
  final EyeCarePreset preset;
  final bool isSelected;
  final VoidCallback onTap;

  const _PresetTile({
    required this.preset,
    required this.isSelected,
    required this.onTap,
  });

  IconData get _icon {
    switch (preset) {
      case EyeCarePreset.intenseFocus:
        return Icons.local_fire_department;
      case EyeCarePreset.normal:
        return Icons.balance;
      case EyeCarePreset.relaxed:
        return Icons.spa;
      case EyeCarePreset.custom:
        return Icons.tune;
    }
  }

  Color get _iconColor {
    switch (preset) {
      case EyeCarePreset.intenseFocus:
        return const Color(0xFFFF7043);
      case EyeCarePreset.normal:
        return const Color(0xFF64B5F6);
      case EyeCarePreset.relaxed:
        return const Color(0xFF81C784);
      case EyeCarePreset.custom:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isSelected ? AppColors.primary.withOpacity(0.15) : AppColors.cardDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _iconColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _icon,
                  color: _iconColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      preset.displayName,
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      preset.description,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
