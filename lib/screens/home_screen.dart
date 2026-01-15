import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/eye_care_provider.dart';
import '../services/background_service.dart';
import '../utils/constants.dart';
import '../utils/platform_utils.dart';
import '../widgets/blink_overlay.dart';
import '../widgets/blank_screen.dart';
import 'settings_screen.dart';
import 'training_screen.dart';

/// Main home screen of the Eye Care app
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BackgroundService _backgroundService = BackgroundService();
  SettingsProvider? _settingsProvider;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listen to settings changes and update EyeCareProvider
    final settingsProvider = context.read<SettingsProvider>();
    if (_settingsProvider != settingsProvider) {
      _settingsProvider?.removeListener(_onSettingsChanged);
      _settingsProvider = settingsProvider;
      _settingsProvider!.addListener(_onSettingsChanged);
    }
  }

  @override
  void dispose() {
    _settingsProvider?.removeListener(_onSettingsChanged);
    super.dispose();
  }

  /// Called when settings change - updates the running service with new settings
  void _onSettingsChanged() {
    final eyeCareProvider = context.read<EyeCareProvider>();
    final settings = _settingsProvider?.settings;
    if (settings != null && eyeCareProvider.isServiceRunning) {
      eyeCareProvider.updateSettings(settings);
    }
  }

  Future<void> _initializeService() async {
    final eyeCareProvider = context.read<EyeCareProvider>();
    final settingsProvider = context.read<SettingsProvider>();

    await eyeCareProvider.initialize();
    await eyeCareProvider.requestNotificationPermission();

    // Request overlay permission on Android at startup
    if (PlatformUtils.isAndroid) {
      await _requestOverlayPermissionIfNeeded();
    }

    // Start service with current settings if background mode is enabled
    if (!settingsProvider.isLoading) {
      final settings = settingsProvider.settings;
      if (settings.backgroundModeEnabled) {
        await eyeCareProvider.startService(settings);
      }
    }
  }

  /// Request overlay permission if not already granted
  Future<void> _requestOverlayPermissionIfNeeded() async {
    final hasPermission = await _backgroundService.hasOverlayPermission();
    if (!hasPermission && mounted) {
      // Show dialog explaining why we need the permission
      _showOverlayPermissionDialog();
    }
  }

  /// Show dialog to explain and request overlay permission
  void _showOverlayPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: const Row(
          children: [
            Icon(Icons.layers, color: AppColors.primary),
            SizedBox(width: 12),
            Text('Permission Required'),
          ],
        ),
        content: const Text(
          'Eye Care needs permission to display reminders over other apps.\n\n'
          'This allows the blink reminder to appear while you\'re using Instagram, YouTube, or any other app.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _backgroundService.requestOverlayPermission();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Enable Now'),
          ),
        ],
      ),
    );
  }

  /// Start protection with overlay permission check
  Future<void> _startProtection(EyeCareProvider eyeCareProvider, settings) async {
    // Check overlay permission first on Android
    if (PlatformUtils.isAndroid) {
      final hasPermission = await _backgroundService.hasOverlayPermission();
      if (!hasPermission) {
        // Ask for permission before starting
        final shouldContinue = await _showPermissionRequiredDialog();
        if (!shouldContinue) return;
      }
    }

    await eyeCareProvider.startService(settings);
  }

  /// Show dialog when starting protection without overlay permission
  Future<bool> _showPermissionRequiredDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: const Row(
          children: [
            Icon(Icons.warning_amber, color: AppColors.warning),
            SizedBox(width: 12),
            Text('Enable Overlay?'),
          ],
        ),
        content: const Text(
          'Without overlay permission, reminders will only show as notifications instead of full-screen overlays.\n\n'
          'Enable overlay to see reminders while using other apps.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Continue Anyway'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context, false);
              await _backgroundService.requestOverlayPermission();
              // Check again after returning
              final hasPermission = await _backgroundService.hasOverlayPermission();
              if (hasPermission && mounted) {
                Navigator.pop(context, true);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Enable Overlay'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<SettingsProvider, EyeCareProvider>(
      builder: (context, settingsProvider, eyeCareProvider, child) {
        final settings = settingsProvider.settings;

        return Stack(
          children: [
            // Main content
            Scaffold(
              appBar: AppBar(
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.visibility,
                      color: AppColors.eyeIconColor,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text('Eye Care'),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status card
                    _buildStatusCard(settingsProvider, eyeCareProvider),
                    const SizedBox(height: 20),

                    // Quick actions
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildQuickActions(context, settingsProvider, eyeCareProvider),
                    const SizedBox(height: 24),

                    // Eye Training section
                    const Text(
                      'Eye Training',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTrainingCard(context),
                    const SizedBox(height: 24),

                    // Current settings overview
                    const Text(
                      'Current Settings',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsOverview(settingsProvider),
                  ],
                ),
              ),
            ),

            // Blink reminder overlay (full black screen with countdown)
            BlinkOverlayContainer(
              visible: eyeCareProvider.showBlinkOverlay,
              countdown: settings.blankScreenDurationSeconds,
              onDismiss: eyeCareProvider.dismissBlinkOverlay,
            ),

            // Blank screen overlay (for longer rest periods)
            BlankScreenOverlay(
              visible: eyeCareProvider.showBlankScreen,
              countdown: eyeCareProvider.blankScreenCountdown,
              onSkip: eyeCareProvider.dismissBlankScreen,
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatusCard(
      SettingsProvider settingsProvider, EyeCareProvider eyeCareProvider) {
    final isActive = eyeCareProvider.isServiceRunning;
    final settings = settingsProvider.settings;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: (isActive ? AppColors.success : AppColors.textHint)
                        .withAlpha(38),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    isActive ? Icons.visibility : Icons.visibility_off,
                    color: isActive ? AppColors.success : AppColors.textHint,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isActive ? 'Protection Active' : 'Protection Inactive',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isActive
                            ? 'Your eyes are being protected'
                            : 'Tap to start eye protection',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Start/Stop button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (isActive) {
                    await eyeCareProvider.stopService();
                  } else {
                    await _startProtection(eyeCareProvider, settings);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isActive ? AppColors.error : AppColors.success,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  isActive ? 'Stop Protection' : 'Start Protection',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context,
      SettingsProvider settingsProvider, EyeCareProvider eyeCareProvider) {
    final settings = settingsProvider.settings;

    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            icon: Icons.visibility,
            label: 'Blink Now',
            color: AppColors.eyeIconColor,
            onTap: () {
              // Trigger blink reminder manually with full screen
              eyeCareProvider.triggerBlinkReminder(settings.blankScreenDurationSeconds);
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.dark_mode,
            label: 'Rest Now',
            color: AppColors.warning,
            onTap: () {
              eyeCareProvider.triggerBlankScreen(settings.blankScreenDurationSeconds);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrainingCard(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TrainingScreen()),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withAlpha(77),
                      AppColors.primaryLight.withAlpha(26),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.self_improvement,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Eye Training',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '3 exercises • 20-20-20, Focus Shifting, Figure 8',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textHint,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsOverview(SettingsProvider settingsProvider) {
    final settings = settingsProvider.settings;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _SettingRow(
              icon: Icons.visibility,
              label: 'Blink Reminder',
              value: settings.blinkReminderEnabled
                  ? 'Every ${settings.blinkIntervalSeconds}s (${settings.blankScreenDurationSeconds}s rest)'
                  : 'Off',
              isEnabled: settings.blinkReminderEnabled,
            ),
            const Divider(height: 24),
            _SettingRow(
              icon: Icons.dark_mode,
              label: 'Long Rest',
              value: settings.blankScreenEnabled
                  ? '${settings.blankScreenDurationSeconds}s every ${settings.blankScreenIntervalMinutes}min'
                  : 'Off',
              isEnabled: settings.blankScreenEnabled,
            ),
            const Divider(height: 24),
            _SettingRow(
              icon: Icons.record_voice_over,
              label: 'Voice Guide',
              value: settings.ttsEnabled ? 'Enabled' : 'Disabled',
              isEnabled: settings.ttsEnabled,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withAlpha(38),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isEnabled;

  const _SettingRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: (isEnabled ? AppColors.primary : AppColors.textHint)
                .withAlpha(38),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isEnabled ? AppColors.primary : AppColors.textHint,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isEnabled ? AppColors.primary : AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
