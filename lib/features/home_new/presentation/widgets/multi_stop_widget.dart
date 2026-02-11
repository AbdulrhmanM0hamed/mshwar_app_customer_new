import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/themes/constant_colors.dart';
import '../../../../generated/app_localizations.dart';
import '../../../../common/widget/custom_text.dart';
import '../cubit/location/location_cubit.dart';
import '../cubit/location/location_state.dart';
import '../../data/models/location_model.dart';

class MultiStopWidget extends StatefulWidget {
  final bool isDarkMode;
  final List<LocationModel> stops;
  final Function(List<LocationModel>) onStopsChanged;

  const MultiStopWidget({
    Key? key,
    required this.isDarkMode,
    required this.stops,
    required this.onStopsChanged,
  }) : super(key: key);

  @override
  State<MultiStopWidget> createState() => _MultiStopWidgetState();
}

class _MultiStopWidgetState extends State<MultiStopWidget> {
  late List<LocationModel> _stops;
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _stops = List.from(widget.stops);
    _initializeControllers();
  }

  void _initializeControllers() {
    _controllers.clear();
    for (var stop in _stops) {
      _controllers.add(TextEditingController(text: stop.address));
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addStop() {
    setState(() {
      _stops.add(LocationModel(
        latitude: 0.0,
        longitude: 0.0,
        address: '',
      ));
      _controllers.add(TextEditingController());
    });
    widget.onStopsChanged(_stops);
  }

  void _removeStop(int index) {
    if (_stops.length > 0) {
      setState(() {
        _stops.removeAt(index);
        _controllers[index].dispose();
        _controllers.removeAt(index);
      });
      widget.onStopsChanged(_stops);
    }
  }

  void _reorderStops(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final stop = _stops.removeAt(oldIndex);
      final controller = _controllers.removeAt(oldIndex);
      _stops.insert(newIndex, stop);
      _controllers.insert(newIndex, controller);
    });
    widget.onStopsChanged(_stops);
  }

  Future<void> _selectStopLocation(int index) async {
    final locationCubit = context.read<LocationCubit>();
    
    // Show location search dialog
    final result = await showDialog<LocationModel>(
      context: context,
      builder: (context) => _LocationSearchDialog(
        isDarkMode: widget.isDarkMode,
        locationCubit: locationCubit,
      ),
    );

    if (result != null) {
      setState(() {
        _stops[index] = result;
        _controllers[index].text = result.address;
      });
      widget.onStopsChanged(_stops);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: l10n.stops,
              size: 16,
              weight: FontWeight.w600,
              color: widget.isDarkMode
                  ? AppThemeData.grey900Dark
                  : AppThemeData.grey900,
            ),
            TextButton.icon(
              onPressed: _addStop,
              icon: Icon(
                Iconsax.add_circle,
                size: 20,
                color: AppThemeData.primary200,
              ),
              label: CustomText(
                text: l10n.addStop,
                size: 14,
                weight: FontWeight.w500,
                color: AppThemeData.primary200,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Stops List
        if (_stops.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: CustomText(
                text: l10n.noStopsAdded,
                size: 14,
                color: widget.isDarkMode
                    ? AppThemeData.grey500Dark
                    : AppThemeData.grey500,
              ),
            ),
          )
        else
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _stops.length,
            onReorder: _reorderStops,
            itemBuilder: (context, index) {
              return _buildStopItem(index, l10n);
            },
          ),
      ],
    );
  }

  Widget _buildStopItem(int index, AppLocalizations l10n) {
    return Container(
      key: ValueKey(_stops[index]),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.isDarkMode
              ? AppThemeData.grey300Dark
              : AppThemeData.grey300,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppThemeData.primary200.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: CustomText(
              text: String.fromCharCode(65 + index), // A, B, C, etc.
              size: 14,
              weight: FontWeight.w600,
              color: AppThemeData.primary200,
            ),
          ),
        ),
        title: TextField(
          controller: _controllers[index],
          readOnly: true,
          onTap: () => _selectStopLocation(index),
          decoration: InputDecoration(
            hintText: '${l10n.stop} ${String.fromCharCode(65 + index)}',
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: widget.isDarkMode
                  ? AppThemeData.grey500Dark
                  : AppThemeData.grey500,
            ),
          ),
          style: TextStyle(
            color: widget.isDarkMode
                ? AppThemeData.grey900Dark
                : AppThemeData.grey900,
            fontSize: 14,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Reorder handle
            Icon(
              Iconsax.menu,
              color: widget.isDarkMode
                  ? AppThemeData.grey500Dark
                  : AppThemeData.grey500,
              size: 20,
            ),
            const SizedBox(width: 8),
            // Remove button
            IconButton(
              onPressed: () => _removeStop(index),
              icon: Icon(
                Iconsax.trash,
                color: AppThemeData.error200,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Location Search Dialog
class _LocationSearchDialog extends StatefulWidget {
  final bool isDarkMode;
  final LocationCubit locationCubit;

  const _LocationSearchDialog({
    required this.isDarkMode,
    required this.locationCubit,
  });

  @override
  State<_LocationSearchDialog> createState() => _LocationSearchDialogState();
}

class _LocationSearchDialogState extends State<_LocationSearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<LocationModel> _searchResults = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchLocation(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    widget.locationCubit.searchLocation(query);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: widget.isDarkMode
          ? AppThemeData.surface50Dark
          : AppThemeData.surface50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: l10n.searchLocation,
                  size: 18,
                  weight: FontWeight.w600,
                  color: widget.isDarkMode
                      ? AppThemeData.grey900Dark
                      : AppThemeData.grey900,
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Iconsax.close_circle,
                    color: widget.isDarkMode
                        ? AppThemeData.grey500Dark
                        : AppThemeData.grey500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search Field
            TextField(
              controller: _searchController,
              onChanged: _searchLocation,
              decoration: InputDecoration(
                hintText: l10n.enterLocation,
                prefixIcon: Icon(
                  Iconsax.search_normal,
                  color: widget.isDarkMode
                      ? AppThemeData.grey500Dark
                      : AppThemeData.grey500,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: widget.isDarkMode
                        ? AppThemeData.grey300Dark
                        : AppThemeData.grey300,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Search Results
            BlocBuilder<LocationCubit, LocationState>(
              bloc: widget.locationCubit,
              builder: (context, state) {
                if (state is LocationSearching) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is LocationSearchResults) {
                  // Get results from state
                  _searchResults = state.results;
                  
                  if (_searchResults.isEmpty) {
                    return Center(
                      child: CustomText(
                        text: l10n.noResultsFound,
                        size: 14,
                        color: widget.isDarkMode
                            ? AppThemeData.grey500Dark
                            : AppThemeData.grey500,
                      ),
                    );
                  }

                  return SizedBox(
                    height: 300,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final location = _searchResults[index];
                        return ListTile(
                          leading: Icon(
                            Iconsax.location,
                            color: AppThemeData.primary200,
                          ),
                          title: CustomText(
                            text: location.address,
                            size: 14,
                            weight: FontWeight.w500,
                            color: widget.isDarkMode
                                ? AppThemeData.grey900Dark
                                : AppThemeData.grey900,
                          ),
                          onTap: () {
                            Navigator.pop(context, location);
                          },
                        );
                      },
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
