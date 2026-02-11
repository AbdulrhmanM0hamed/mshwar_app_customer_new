import 'package:equatable/equatable.dart';
import '../../../data/models/vehicle_category_model.dart';

abstract class VehicleState extends Equatable {
  const VehicleState();

  @override
  List<Object?> get props => [];
}

class VehicleInitial extends VehicleState {}

class VehicleLoading extends VehicleState {}

class VehicleLoaded extends VehicleState {
  final List<VehicleCategoryModel> categories;

  const VehicleLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class VehicleSelected extends VehicleState {
  final VehicleCategoryModel selectedVehicle;
  final List<VehicleCategoryModel> allCategories;

  const VehicleSelected({
    required this.selectedVehicle,
    required this.allCategories,
  });

  @override
  List<Object?> get props => [selectedVehicle, allCategories];
}

class VehicleError extends VehicleState {
  final String message;

  const VehicleError(this.message);

  @override
  List<Object?> get props => [message];
}
