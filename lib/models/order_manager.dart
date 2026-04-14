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
    required this.vehicleImageUrl,
    required this.vehicleClass,
    required this.baseRate,
    required this.rentalUnit,
    required this.rentalLength,
    this.discountAmount = 0,
    this.discountCode,
  });

  final Set<int> selectedSegment;
  final TimeOfDay? selectedTime;
  final DateTime? selectedDate;
  final String name;
  final List<CartItem> items;
  final String vehicleName;
  final String vehicleImageUrl;
  final String vehicleClass;
  final double baseRate;
  final RentalUnit rentalUnit;
  final int rentalLength;
  final double discountAmount;
  final String? discountCode;

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

  double get subtotal => rentalCost + addOnTotal;

  double get totalCost => (subtotal - discountAmount).clamp(0, double.infinity);

  DateTime? get pickupDateTime {
    if (selectedDate == null || selectedTime == null) {
      return null;
    }

    return DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );
  }

  DateTime? get returnDateTime {
    final pickup = pickupDateTime;
    if (pickup == null) {
      return null;
    }

    return rentalUnit == RentalUnit.hours
        ? pickup.add(Duration(hours: rentalLength))
        : pickup.add(Duration(days: rentalLength));
  }

  String getFormattedReturnDate() {
    if (returnDateTime == null) return 'Unknown';
    return DateFormat('yyyy-MM-dd HH:mm').format(returnDateTime!);
  }

  String getFormattedOrderInfo() {
    return '$vehicleName - $vehicleClass\n'
        '${getFormattedName()}, Pickup: ${getFormattedDate()} at '
        '${getFormattedTime()}\n'
        'Return: ${getFormattedReturnDate()}\n'
        '$rentalLengthLabel, ${getFormattedSegment()}'
        '${discountCode == null ? '' : '\nPromo: $discountCode'}';
  }
}

class OrderManager {
  final List<Order> _orders = [];

  List<Order> get orders => _orders;

  void addOrder(Order order) {
    _orders.add(order);
  }

  void insertOrder(int index, Order order) {
    _orders.insert(index.clamp(0, _orders.length), order);
  }

  void removeOrder(Order order) {
    _orders.remove(order);
  }

  int get totalOrders => _orders.length;
}
