import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../services/background_service.dart';
import '../utils/constants.dart';
import '../utils/platform_utils.dart';
import '../widgets/preset_selector.dart';

/// Settings screen for customizing eye care preferences
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _hasOverlayPermission = false;
  final BackgroundService _backgroundService = BackgroundService();

  @override
  void initState() {
    super.initState();
    _checkOverlayPermission();
  }

  Future<void> _checkOverlayPermission() async {
    if (PlatformUtils.isAndroid) {
      final hasPermission = await _backgroundService.hasOverlayPermission();
      setState(() {
        _hasOverlayPermission = hasPermission;
      });
    }
  }

  Future<void> _requestOverlayPermission() async {
    await _backgroundService.requestOverlayPermission();
    // Check again after returning from settings
    await _checkOverlayPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          if (settingsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final settings = settingsProvider.settings;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Presets section
                PresetSelector(
                  selectedPreset: settings.activePreset,
                  onPresetChanged: (preset) {
                    settingsProvider.applyPreset(preset);
                  },
                ),
                const SizedBox(height: 24),

                // Custom Settings Header
                const _SectionHeader(title: 'Custom Settings'),
                const SizedBox(height: 12),

                // Background Mode Toggle
                _SettingsTile(
                  icon: Icons.play_circle_outline,
                  iconColor: AppColors.success,
                  title: 'Background Mode',
                  subtitle: 'Keep running when app is minimized',
                  trailing: Switch(
                    value: settings.backgroundModeEnabled,
                    onChanged: settingsProvider.setBackgroundMode,
                  ),
                ),

                // Overlay Permission (Android only)
                if (PlatformUtils.isAndroid) ...[
                  _SettingsTile(
                    icon: Icons.layers,
                    iconColor: _hasOverlayPermission ? AppColors.success : AppColors.warning,
                    title: 'Overlay Permission',
                    subtitle: _hasOverlayPermission
                        ? 'Enabled - shows on top of other apps'
                        : 'Required to show reminder over other apps',
                    trailing: _hasOverlayPermission
                        ? const Icon(Icons.check_circle, color: AppColors.success)
                        : ElevatedButton(
                            onPressed: _requestOverlayPermission,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                            ),
                            child: const Text('Enable', style: TextStyle(fontSize: 12)),
                          ),
                  ),
                ],

                // Blink Reminder Toggle
                _SettingsTile(
                  icon: Icons.visibility,
                  iconColor: AppColors.eyeIconColor,
                  title: 'Blink Reminder',
                  subtitle: 'Show visual reminder to blink',
                  trailing: Switch(
                    value: settings.blinkReminderEnabled,
                    onChanged: settingsProvider.setBlinkReminderEnabled,
                  ),
                ),

                // Blink Interval Slider
                if (settings.blinkReminderEnabled) ...[
                  const SizedBox(height: 8),
                  _SliderTile(
                    title: 'Blink Interval',
                    value: settings.blinkIntervalSeconds.toDouble(),
                    min: AppConstants.minBlinkInterval.toDouble(),
                    max: AppConstants.maxBlinkInterval.toDouble(),
                    divisions: AppConstants.maxBlinkInterval -
                        AppConstants.minBlinkInterval,
                    suffix: 'seconds',
                    onChanged: (value) {
                      settingsProvider.setBlinkInterval(value.round());
                    },
                  ),
                ],
                const SizedBox(height: 16),

                // Blank Screen Toggle
                _SettingsTile(
                  icon: Icons.visibility_off,
                  iconColor: AppColors.warning,
                  title: 'Blank Screen Mode',
                  subtitle: 'Periodic screen blanking for eye rest',
                  trailing: Switch(
                    value: settings.blankScreenEnabled,
                    onChanged: settingsProvider.setBlankScreenEnabled,
                  ),
                ),

                // Blank Screen Settings
                if (settings.blankScreenEnabled) ...[
                  const SizedBox(height: 8),
                  _SliderTile(
                    title: 'Blank Duration',
                    value: settings.blankScreenDurationSeconds.toDouble(),
                    min: AppConstants.minBlankDuration.toDouble(),
                    max: AppConstants.maxBlankDuration.toDouble(),
                    divisions: AppConstants.maxBlankDuration -
                        AppConstants.minBlankDuration,
                    suffix: 'seconds',
                    onChanged: (value) {
                      settingsProvider.setBlankScreenDuration(value.round());
                    },
                  ),
                  const SizedBox(height: 8),
                  _SliderTile(
                    title: 'Blank Interval',
                    value: settings.blankScreenIntervalMinutes.toDouble(),
                    min: AppConstants.minBlankInterval.toDouble(),
                    max: AppConstants.maxBlankInterval.toDouble(),
                    divisions: (AppConstants.maxBlankInterval -
                            AppConstants.minBlankInterval) ~/
                        5,
                    suffix: 'minutes',
                    onChanged: (value) {
                      settingsProvider.setBlankScreenInterval(value.round());
                    },
                  ),
                ],
                const SizedBox(height: 24),

                // Voice Settings
                const _SectionHeader(title: 'Voice Guide'),
                const SizedBox(height: 12),

                _SettingsTile(
                  icon: Icons.record_voice_over,
                  iconColor: AppColors.primary,
                  title: 'TTS Voice Guides',
                  subtitle: 'Audio guidance during exercises',
                  trailing: Switch(
                    value: settings.ttsEnabled,
                    onChanged: settingsProvider.setTtsEnabled,
                  ),
                ),
                const SizedBox(height: 32),

                // Reset Button
                Center(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showResetDialog(settingsProvider);
                    },
                    icon: const Icon(Icons.restore),
                    label: const Text('Reset to Defaults'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showResetDialog(SettingsProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: const Text('Reset Settings'),
        content: const Text(
          'Are you sure you want to reset all settings to their defaults?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.resetToDefaults();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

class _SliderTile extends StatelessWidget {
  final String title;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String suffix;
  final ValueChanged<double> onChanged;

  const _SliderTile({
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.suffix,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${value.round()} $suffix',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
