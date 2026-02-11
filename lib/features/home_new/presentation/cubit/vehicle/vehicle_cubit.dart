import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/vehicle_repository.dart';
import '../../../data/models/vehicle_category_model.dart';
import 'vehicle_state.dart';

class VehicleCubit extends Cubit<VehicleState> {
  final VehicleRepository repository;
  List<VehicleCategoryModel> _categories = [];
  VehicleCategoryModel? _selectedVehicle;

  VehicleCubit({required this.repository}) : super(VehicleInitial());

  VehicleCategoryModel? get selectedVehicle => _selectedVehicle;
  List<VehicleCategoryModel> get categories => _categories;

  Future<void> loadVehicleCategories() async {
    try {
      emit(VehicleLoading());
      _categories = await repository.getVehicleCategories();

      if (_categories.isEmpty) {
        emit(const VehicleError('No vehicle categories available'));
        return;
      }

      // Auto-select first vehicle if none selected
      if (_selectedVehicle == null && _categories.isNotEmpty) {
        _selectedVehicle = _categories.first;
        emit(VehicleSelected(
          selectedVehicle: _selectedVehicle!,
          allCategories: _categories,
        ));
      } else {
        emit(VehicleLoaded(_categories));
      }
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }

  void selectVehicle(VehicleCategoryModel vehicle) {
    _selectedVehicle = vehicle;
    emit(VehicleSelected(
      selectedVehicle: vehicle,
      allCategories: _categories,
    ));
  }

  void selectVehicleById(String id) {
    final vehicle = _categories.firstWhere(
      (v) => v.id == id,
      orElse: () => _categories.first,
    );
    selectVehicle(vehicle);
  }

  void reset() {
    _selectedVehicle = null;
    emit(VehicleInitial());
  }
}
