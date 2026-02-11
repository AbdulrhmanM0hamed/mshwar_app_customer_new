import 'package:cabme/common/widget/custom_app_bar.dart';
import 'package:cabme/core/themes/constant_colors.dart';
import 'package:cabme/core/utils/dark_theme_provider.dart';
import 'package:cabme/features/settings_new/data/models/notification_model.dart';
import 'package:cabme/features/settings_new/presentation/cubit/notification/notification_cubit.dart';
import 'package:cabme/features/settings_new/presentation/cubit/notification/notification_state.dart';
import 'package:cabme/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<NotificationCubit>()..loadNotifications(),
      child: const NotificationView(),
    );
  }
}

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  String _selectedCategory = 'all'; // 'all', 'ride', 'broadcast'
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      context.read<NotificationCubit>().loadNotifications();
    }
  }

  List<NotificationModel> _getFilteredNotifications(
      List<NotificationModel> notifications) {
    if (_selectedCategory == 'all') return notifications;
    return notifications.where((n) => n.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final isDarkMode = themeChange.getThem();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
      appBar: CustomAppBar(
        title: l10n.notifications,
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
        actions: [
          IconButton(
            onPressed: () => context
                .read<NotificationCubit>()
                .loadNotifications(refresh: true),
            icon: const Icon(Iconsax.refresh, color: Colors.white, size: 22),
          ),
          IconButton(
            onPressed: () => context.read<NotificationCubit>().markAllAsRead(),
            icon:
                const Icon(Iconsax.tick_circle, color: Colors.white, size: 22),
            tooltip: l10n.markAllAsRead,
          ),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading && state is! NotificationLoaded) {
            return Center(
              child: CircularProgressIndicator(color: AppThemeData.primary200),
            );
          }

          if (state is NotificationError) {
            return _buildErrorState(state.message, isDarkMode, l10n);
          }

          if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return _buildEmptyState(isDarkMode, l10n);
            }

            final filtered = _getFilteredNotifications(state.notifications);

            return RefreshIndicator(
              onRefresh: () async {
                await context
                    .read<NotificationCubit>()
                    .loadNotifications(refresh: true);
              },
              color: AppThemeData.primary200,
              child: Column(
                children: [
                  _buildCategoryFilters(isDarkMode, l10n),
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Text(l10n.noNotificationsHere),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount:
                                filtered.length + (state.hasMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == filtered.length) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: CircularProgressIndicator(
                                      color: AppThemeData.primary200,
                                    ),
                                  ),
                                );
                              }
                              return _buildNotificationCard(
                                filtered[index],
                                isDarkMode,
                                context,
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildCategoryFilters(bool isDarkMode, AppLocalizations l10n) {
    final categories = ['all', 'ride', 'broadcast'];
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;

          // Simple color logic for filter chips
          Color categoryColor = AppThemeData.primary200;
          String label = '';
          if (category == 'all') {
            label = l10n.catAll;
          } else if (category == 'ride') {
            label = l10n.catRide;
          } else if (category == 'broadcast') {
            label = l10n.catBroadcast;
          }

          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              label: Text(label),
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              selectedColor: categoryColor.withValues(alpha: 0.2),
              checkmarkColor: categoryColor,
              labelStyle: TextStyle(
                color: isSelected
                    ? categoryColor
                    : (isDarkMode
                        ? AppThemeData.grey500Dark
                        : AppThemeData.grey500),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 12,
              ),
              side: BorderSide(
                color: isSelected
                    ? categoryColor
                    : (isDarkMode
                        ? AppThemeData.grey300Dark
                        : AppThemeData.grey300),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.notification,
              size: 48,
              color:
                  isDarkMode ? AppThemeData.grey500Dark : AppThemeData.grey500),
          const SizedBox(height: 16),
          Text(
            l10n.noNotificationsHere,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color:
                  isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
      String message, bool isDarkMode, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.warning_2, size: 48, color: AppThemeData.error200),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color:
                  isDarkMode ? AppThemeData.grey900Dark : AppThemeData.grey900,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context
                .read<NotificationCubit>()
                .loadNotifications(refresh: true),
            child: Text(l10n.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(
    NotificationModel notification,
    bool isDarkMode,
    BuildContext context,
  ) {
    return Dismissible(
      key: Key(notification.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        context.read<NotificationCubit>().deleteNotification(notification.id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDarkMode ? AppThemeData.grey800 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            // Mark as read
            context.read<NotificationCubit>().markAsRead(notification.id);

            // Show details or navigate
            _showNotificationDetail(notification, isDarkMode, context);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: notification.categoryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    notification.typeIcon,
                    color: notification.categoryColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: notification.isRead
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                                color: isDarkMode
                                    ? AppThemeData.grey900Dark
                                    : AppThemeData.grey900,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            notification.formattedDate,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkMode
                                  ? AppThemeData.grey500Dark
                                  : AppThemeData.grey500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification.message,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDarkMode
                              ? AppThemeData.grey500Dark
                              : AppThemeData.grey500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (!notification.isRead)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppThemeData.primary200,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showNotificationDetail(
    NotificationModel notification,
    bool isDarkMode,
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDarkMode ? AppThemeData.grey800 : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppThemeData.grey400Dark
                      : AppThemeData.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: notification.categoryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    notification.typeIcon,
                    color: notification.categoryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    notification.title,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode
                            ? AppThemeData.grey900Dark
                            : AppThemeData.grey900),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Divider(
              color:
                  isDarkMode ? AppThemeData.grey300Dark : AppThemeData.grey200,
            ),
            const SizedBox(height: 20),
            Text(
              // Check notification model for full body if different from message
              notification.message,
              style: TextStyle(
                fontSize: 15,
                color: isDarkMode
                    ? AppThemeData.grey500Dark
                    : AppThemeData.grey500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppThemeData.primary200,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(AppLocalizations.of(context)!.close),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
