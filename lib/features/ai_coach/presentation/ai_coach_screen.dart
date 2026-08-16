import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/twin_badge.dart';
import '../providers/ai_coach_provider.dart';
import 'weekly_report_screen.dart';

class AiCoachScreen extends ConsumerStatefulWidget {
  const AiCoachScreen({super.key});

  @override
  ConsumerState<AiCoachScreen> createState() => _AiCoachScreenState();
}

class _AiCoachScreenState extends ConsumerState<AiCoachScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  final List<String> _quickPrompts = [
    'Bugün omzumda hafif hassasiyet var, rotayı uyarla.',
    'Platodayım, hipertrofiyi nasıl artırabilirim?',
    'Toparlanma durumumu ve CNS seviyemi açıkla.',
    'Haftalık sentetik ikiz raporumu göster.',
  ];

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage([String? prompt]) {
    final text = prompt ?? _textController.text;
    if (text.trim().isEmpty) return;

    if (prompt == 'Haftalık sentetik ikiz raporumu göster.') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const WeeklyReportScreen()),
      );
      return;
    }

    _textController.clear();
    ref.read(aiCoachProvider.notifier).sendMessage(text);

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiCoachProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: Row(
          children: [
            TwinBadge.ai(label: 'TWINFIT AI KOÇ'),
            const SizedBox(width: 8),
            const Text(
              'Biyolojik Danışman',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined, color: AppColors.secondary),
            tooltip: 'Haftalık İkiz Raporu',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const WeeklyReportScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Chat Messages List
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: state.messages.length,
                itemBuilder: (context, idx) {
                  final msg = state.messages[idx];
                  final isUser = msg.role == 'user';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isUser) ...[
                          Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.aiBadgeGradient,
                            ),
                            child: const Icon(Icons.auto_awesome, size: 16, color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                        ],
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? AppColors.primary.withValues(alpha: 0.15)
                                  : AppColors.darkSurface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isUser
                                    ? AppColors.primary.withValues(alpha: 0.4)
                                    : AppColors.darkBorder,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: [
                                if (!isUser) ...[
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TwinBadge.ai(label: 'AI BİYOLOJİK KOÇ'),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                ],
                                Text(
                                  msg.content,
                                  style: TextStyle(
                                    color: isUser ? AppColors.textPrimaryDark : AppColors.textPrimaryDark,
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            if (state.isLoading) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.secondary),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'TwinFit AI fizyolojik verileri işliyor...',
                      style: TextStyle(fontSize: 12, color: AppColors.secondary.withValues(alpha: 0.8), fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ],

            // Quick Prompt Suggestions
            SizedBox(
              height: 38,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _quickPrompts.length,
                itemBuilder: (context, idx) {
                  final prompt = _quickPrompts[idx];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: Text(prompt),
                      onPressed: () => _sendMessage(prompt),
                      backgroundColor: AppColors.darkSurfaceElevated,
                      labelStyle: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 11),
                      side: const BorderSide(color: AppColors.darkBorder),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            // Input Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                color: AppColors.darkSurface,
                border: Border(top: BorderSide(color: AppColors.darkBorder)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Koçunuza bir soru sorun veya durum bildirin...',
                        hintStyle: const TextStyle(color: AppColors.textTertiaryDark, fontSize: 13),
                        filled: true,
                        fillColor: AppColors.darkBackground,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: AppColors.darkBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: AppColors.darkBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: AppColors.primary),
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.primaryGradient,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Color(0xFF07090C), size: 18),
                      onPressed: () => _sendMessage(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
