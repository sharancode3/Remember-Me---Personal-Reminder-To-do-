import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/daily_trail_service.dart';
import '../providers/providers.dart';

class ReliabilityCheckScreen extends ConsumerStatefulWidget {
  const ReliabilityCheckScreen({super.key});

  @override
  ConsumerState<ReliabilityCheckScreen> createState() =>
      _ReliabilityCheckScreenState();
}

class _ReliabilityCheckScreenState extends ConsumerState<ReliabilityCheckScreen>
    with WidgetsBindingObserver {
  bool _loading = true;
  bool _notificationsGranted = false;
  bool _exactAlarmsGranted = false;
  bool _batteryOptimizationsIgnored = false;
  bool _testingAlarm = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkStatus();
    }
  }

  Future<void> _checkStatus() async {
    setState(() => _loading = true);
    final scheduler = ref.read(reminderSchedulerProvider);
    final status = await scheduler.getReliabilityStatus();
    if (mounted) {
      setState(() {
        _notificationsGranted = status['notificationsGranted'] == true;
        _exactAlarmsGranted = status['exactAlarmsGranted'] == true;
        _batteryOptimizationsIgnored =
            status['batteryOptimizationsIgnored'] == true;
        _loading = false;
      });
    }
  }

  Future<void> _sendTestReminder() async {
    setState(() => _testingAlarm = true);
    try {
      final scheduler = ref.read(reminderSchedulerProvider);
      await scheduler.testReminderIn10s();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Test reminder scheduled for 10 seconds from now. Lock your screen to verify sound & wake-up!',
            ),
            duration: Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _testingAlarm = false);
      }
    }
  }

  Future<void> _openDontKillMyApp() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await DailyTrailService.channel.invokeMethod<void>('openUrl', {
        'url': 'https://dontkillmyapp.com',
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final scheduler = ref.read(reminderSchedulerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder Reliability'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: _loading ? null : _checkStatus,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Android Background Diagnostics',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'To ensure reminders wake your phone with sound and action buttons even when the app is closed, verify the checks below.',
                  style: TextStyle(color: Color(0xFF68756E), fontSize: 14),
                ),
                const SizedBox(height: 20),

                // 1. Notifications
                _StatusCard(
                  icon: Icons.notifications_active_outlined,
                  title: 'Notification Permissions',
                  subtitle: _notificationsGranted
                      ? 'Granted - Reminders can post heads-up alerts'
                      : 'Denied - Reminders will fail silently',
                  isOk: _notificationsGranted,
                  actionLabel: _notificationsGranted
                      ? 'Configure Sound'
                      : 'Grant Permission',
                  onAction: () async {
                    await scheduler.openNotificationSettings();
                  },
                ),
                const SizedBox(height: 12),

                // 2. Exact Alarms
                _StatusCard(
                  icon: Icons.alarm_rounded,
                  title: 'Exact Alarm Scheduling',
                  subtitle: _exactAlarmsGranted
                      ? 'Allowed - Punctual to the exact second'
                      : 'Restricted - Alarms may be delayed up to 15+ minutes',
                  isOk: _exactAlarmsGranted,
                  actionLabel: _exactAlarmsGranted
                      ? 'Alarm Settings'
                      : 'Allow Exact Alarms',
                  onAction: () async {
                    await scheduler.openExactAlarmSettings();
                  },
                ),
                const SizedBox(height: 12),

                // 3. Battery Optimizations
                _StatusCard(
                  icon: Icons.battery_charging_full_rounded,
                  title: 'Battery Optimization',
                  subtitle: _batteryOptimizationsIgnored
                      ? 'Unrestricted - App survives background Doze mode'
                      : 'Optimized - OS may kill timers or suppress wakeups',
                  isOk: _batteryOptimizationsIgnored,
                  actionLabel: _batteryOptimizationsIgnored
                      ? 'Battery Settings'
                      : 'Ignore Optimizations',
                  onAction: () async {
                    await scheduler.openBatteryOptSettings();
                  },
                ),
                const SizedBox(height: 24),

                // Test Reminder Button
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _testingAlarm ? null : _sendTestReminder,
                  icon: _testingAlarm
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.timer_outlined),
                  label: const Text('Send Test Reminder (10 seconds)'),
                ),
                const SizedBox(height: 24),

                // OEM killer guide
                Card(
                  elevation: 0,
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.phonelink_setup_rounded, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Device-Specific Aggressive Killing',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Some manufacturers (Samsung, Xiaomi, OnePlus, Vivo) forcefully kill background schedulers. Check the community guide for your phone model:',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF68756E),
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: _openDontKillMyApp,
                          icon: const Icon(Icons.open_in_new, size: 16),
                          label: const Text('Visit DontKillMyApp.com'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isOk,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isOk;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isOk ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOk ? const Color(0xFFA5D6A7) : const Color(0xFFFFCC80),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: isOk ? const Color(0xFF2E7D32) : const Color(0xFFE65100),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: isOk
                        ? const Color(0xFF1B5E20)
                        : const Color(0xFFBF360C),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isOk
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFFE65100),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isOk ? 'OK' : 'ATTENTION',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 13, color: Color(0xFF37474F)),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: isOk
                    ? const Color(0xFF2E7D32)
                    : const Color(0xFFD84315),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(actionLabel),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_ios, size: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
