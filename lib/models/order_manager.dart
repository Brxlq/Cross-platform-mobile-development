import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'cart_manager.dart';

enum RentalUnit { hours, days }

class Order {
  Order({
    required this.selectedSegment,
    required this.selectedTime,
    required this.selectedDate,
    required this.name,
    required this.items,
    required this.vehicleName,
    required this.vehicleClass,
    required this.baseRate,
    required this.rentalUnit,
    required this.rentalLength,
  });

  final Set<int> selectedSegment;
  final TimeOfDay? selectedTime;
  final DateTime? selectedDate;
  final String name;
  final List<CartItem> items;
  final String vehicleName;
  final String vehicleClass;
  final double baseRate;
  final RentalUnit rentalUnit;
  final int rentalLength;

  String getFormattedSegment() {
    if (selectedSegment.contains(0)) {
      return 'Round trip';
    } else if (selectedSegment.contains(1)) {
      return 'One-way';
    } else {
      return 'Flexible';
    }
  }

  String getFormattedTime() {
    if (selectedTime == null) return 'Unknown';
    final hour = selectedTime!.hour.toString().padLeft(2, '0');
    final minute = selectedTime!.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String getFormattedDate() {
    if (selectedDate == null) return 'Unknown';
    return DateFormat('yyyy-MM-dd').format(selectedDate!);
  }

  String getFormattedName() {
    if (name.isEmpty) return 'Guest driver';
    return name;
  }

  String get rentalLengthLabel {
    final unitLabel = rentalUnit == RentalUnit.hours ? 'hour' : 'day';
    final suffix = rentalLength == 1 ? '' : 's';
    return '$rentalLength $unitLabel$suffix';
  }

  double get addOnTotal {
    return items.fold<double>(0, (sum, item) => sum + item.totalCost);
  }

  double get rentalCost => baseRate * rentalLength;

  double get totalCost => rentalCost + addOnTotal;

  String getFormattedOrderInfo() {
    return '$vehicleName - $vehicleClass\n'
        '${getFormattedName()}, Pickup: ${getFormattedDate()} at '
        '${getFormattedTime()}\n'
        '$rentalLengthLabel, ${getFormattedSegment()}';
  }
}

class OrderManager {
  final List<Order> _orders = [];

  List<Order> get orders => _orders;

  void addOrder(Order order) {
    _orders.add(order);
  }

  void removeOrder(Order order) {
    _orders.remove(order);
  }

  int get totalOrders => _orders.length;
}
