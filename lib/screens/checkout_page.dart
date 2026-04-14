import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/models.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({
    super.key,
    required this.cartManager,
    required this.didUpdate,
    required this.onSubmit,
    required this.vehicle,
    this.scrollController,
    this.showAppBar = true,
  });

  final CartManager cartManager;
  final Function() didUpdate;
  final Function(Order) onSubmit;
  final Restaurant vehicle;
  final ScrollController? scrollController;
  final bool showAppBar;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  static const Map<String, double> _promoCodes = {
    'ASTANA10': 0.10,
    'ECHELON15': 0.15,
    'PLUS20': 0.20,
  };

  Set<int> selectedSegment = {0};
  TimeOfDay? selectedTime;
  DateTime? selectedDate;
  RentalUnit rentalUnit = RentalUnit.hours;
  int rentalLength = 1;
  late final DateTime _firstDate;
  late final DateTime _lastDate;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _promoController = TextEditingController();
  String? _promoCode;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _firstDate = DateTime(today.year, today.month, today.day);
    _lastDate = DateTime(today.year + 1, today.month, today.day);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  bool get _canSubmit => selectedDate != null && selectedTime != null;

  double get _baseRate {
    return rentalUnit == RentalUnit.hours
        ? widget.vehicle.hourlyRate
        : widget.vehicle.dailyRate;
  }

  double get _rentalCost => _baseRate * rentalLength;

  DateTime? get _pickupDateTime {
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

  DateTime? get _returnDateTime {
    final pickup = _pickupDateTime;
    if (pickup == null) {
      return null;
    }

    return rentalUnit == RentalUnit.hours
        ? pickup.add(Duration(hours: rentalLength))
        : pickup.add(Duration(days: rentalLength));
  }

  double get _subtotal => _rentalCost + widget.cartManager.totalCost;

  double get _discountAmount {
    final ratio = _promoCode == null ? 0.0 : _promoCodes[_promoCode!] ?? 0.0;
    return _subtotal * ratio;
  }

  double get _totalCost =>
      (_subtotal - _discountAmount).clamp(0, double.infinity).toDouble();

  String formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'Select pickup date';
    return DateFormat('EEE, MMM d').format(dateTime);
  }

  String formatTimeOfDay(TimeOfDay? timeOfDay) {
    if (timeOfDay == null) return 'Select pickup time';
    final hour = timeOfDay.hour.toString().padLeft(2, '0');
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Choose pickup to calculate';
    return DateFormat('EEE, MMM d • HH:mm').format(dateTime);
  }

  String get _rentalLengthLabel {
    final unitLabel = rentalUnit == RentalUnit.hours ? 'hour' : 'day';
    final suffix = rentalLength == 1 ? '' : 's';
    return '$rentalLength $unitLabel$suffix';
  }

  void onSegmentSelected(Set<int> segmentIndex) {
    setState(() {
      selectedSegment = segmentIndex;
    });
  }

  void _showInfo(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _applyPromoCode() {
    final code = _promoController.text.trim().toUpperCase();
    if (code.isEmpty) {
      setState(() {
        _promoCode = null;
      });
      _showInfo('Promo code cleared.');
      return;
    }

    if (!_promoCodes.containsKey(code)) {
      _showInfo('Promo code not recognized. Try ASTANA10 or ECHELON15.');
      return;
    }

    setState(() {
      _promoCode = code;
      _promoController.text = code;
    });
    _showInfo('$code applied to this reservation.');
  }

  Widget _buildOrderSegmentedType() {
    return SegmentedButton(
      showSelectedIcon: false,
      segments: const [
        ButtonSegment(
          value: 0,
          label: Text('Round Trip'),
          icon: Icon(Icons.sync_alt),
        ),
        ButtonSegment(
          value: 1,
          label: Text('One Way'),
          icon: Icon(Icons.trending_flat),
        ),
      ],
      selected: selectedSegment,
      onSelectionChanged: onSegmentSelected,
    );
  }

  Widget _buildRentalUnitSelector() {
    return SegmentedButton<RentalUnit>(
      showSelectedIcon: false,
      segments: const [
        ButtonSegment(
          value: RentalUnit.hours,
          label: Text('Hours'),
          icon: Icon(Icons.schedule),
        ),
        ButtonSegment(
          value: RentalUnit.days,
          label: Text('Days'),
          icon: Icon(Icons.calendar_today),
        ),
      ],
      selected: {rentalUnit},
      onSelectionChanged: (values) {
        setState(() {
          rentalUnit = values.first;
          rentalLength = 1;
        });
      },
    );
  }

  Widget _buildRentalLengthControl() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surfaceContainer,
      ),
      child: Row(
        children: [
          Text(
            'Rental length',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Spacer(),
          IconButton(
            onPressed: rentalLength > 1
                ? () {
                    setState(() {
                      rentalLength--;
                    });
                  }
                : null,
            icon: const Icon(Icons.remove_circle_outline),
          ),
          Text(
            _rentalLengthLabel,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          IconButton(
            onPressed: () {
              setState(() {
                rentalLength++;
              });
            },
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _nameController,
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(
        labelText: 'Driver Name',
        hintText: 'Enter the main driver name',
      ),
    );
  }

  Widget _buildPromoCodeField() {
    return TextField(
      controller: _promoController,
      textCapitalization: TextCapitalization.characters,
      decoration: InputDecoration(
        labelText: 'Promo code',
        hintText: 'ASTANA10',
        suffixIcon: TextButton(
          onPressed: _applyPromoCode,
          child: const Text('Apply'),
        ),
      ),
      onSubmitted: (_) => _applyPromoCode(),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? _firstDate,
      firstDate: _firstDate,
      lastDate: _lastDate,
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Widget _buildScheduleRow() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _selectDate(context),
            icon: const Icon(Icons.calendar_today_outlined),
            label: Text(formatDate(selectedDate)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _selectTime(context),
            icon: const Icon(Icons.schedule_outlined),
            label: Text(formatTimeOfDay(selectedTime)),
          ),
        ),
      ],
    );
  }

  Widget _buildTripPreview() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colorScheme.primaryContainer.withValues(alpha: 0.45),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trip timeline',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 10),
          _SummaryRow(
            label: 'Pickup',
            value: formatDateTime(_pickupDateTime),
          ),
          _SummaryRow(
            label: 'Return',
            value: formatDateTime(_returnDateTime),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSummary() {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.vehicle.name, style: textTheme.titleLarge),
          const SizedBox(height: 12),
          _SummaryRow(
            label: 'Base rate '
                '(${rentalUnit == RentalUnit.hours ? 'hourly' : 'daily'})',
            value: '\$${_baseRate.toStringAsFixed(0)}',
          ),
          _SummaryRow(
            label: 'Duration',
            value: _rentalLengthLabel,
          ),
          _SummaryRow(
            label: 'Rental price',
            value: '\$${_rentalCost.toStringAsFixed(2)}',
          ),
          _SummaryRow(
            label: 'Add-ons',
            value: '\$${widget.cartManager.totalCost.toStringAsFixed(2)}',
          ),
          if (_promoCode != null)
            _SummaryRow(
              label: 'Promo $_promoCode',
              value: '-\$${_discountAmount.toStringAsFixed(2)}',
            ),
          const Divider(),
          _SummaryRow(
            label: 'Total',
            value: '\$${_totalCost.toStringAsFixed(2)}',
            emphasize: true,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;

    if (widget.cartManager.items.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Theme.of(context).colorScheme.surfaceContainerLow,
        ),
        child: Text(
          'No add-ons selected. You can still reserve this car now.',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      itemCount: widget.cartManager.items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = widget.cartManager.itemAt(index);
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Dismissible(
            key: Key(item.id),
            direction: DismissDirection.endToStart,
            background: Container(),
            secondaryBackground: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            onDismissed: (direction) {
              setState(() {
                widget.cartManager.removeItem(item.id);
              });
              widget.didUpdate();
            },
            child: ListTile(
              tileColor: Theme.of(context).colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: colorTheme.primary, width: 2),
                ),
                child: Text('x${item.quantity}'),
              ),
              title: Text(item.name),
              subtitle: Text(
                'Add-on total: \$${item.totalCost.toStringAsFixed(2)}',
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: !_canSubmit
          ? () {
              _showInfo('Choose both pickup date and pickup time first.');
            }
          : () {
              final order = Order(
                selectedSegment: selectedSegment,
                selectedTime: selectedTime,
                selectedDate: selectedDate,
                name: _nameController.text,
                items: widget.cartManager.items,
                vehicleName: widget.vehicle.name,
                vehicleImageUrl: widget.vehicle.imageUrl,
                vehicleClass: widget.vehicle.vehicleClass,
                baseRate: _baseRate,
                rentalUnit: rentalUnit,
                rentalLength: rentalLength,
                discountAmount: _discountAmount,
                discountCode: _promoCode,
              );

              widget.cartManager.resetCart();
              widget.onSubmit(order);
            },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
      ),
      child: Text('Reserve Trip - \$${_totalCost.toStringAsFixed(2)}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            )
          : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            controller: widget.scrollController,
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!widget.showAppBar) ...[
                    Center(
                      child: Container(
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  Text('Trip Details', style: textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(
                    'Set your pickup time, trip length, '
                    'and any optional extras.',
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  _buildOrderSegmentedType(),
                  const SizedBox(height: 16),
                  _buildRentalUnitSelector(),
                  const SizedBox(height: 16),
                  _buildRentalLengthControl(),
                  const SizedBox(height: 16),
                  _buildTextField(),
                  const SizedBox(height: 16),
                  _buildPromoCodeField(),
                  const SizedBox(height: 16),
                  _buildScheduleRow(),
                  const SizedBox(height: 16),
                  _buildTripPreview(),
                  const SizedBox(height: 16),
                  _buildPriceSummary(),
                  const SizedBox(height: 16),
                  Text(
                    'Optional Add-ons',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildOrderSummary(context),
                  const SizedBox(height: 20),
                  _buildSubmitButton(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final style = emphasize
        ? Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            )
        : Theme.of(context).textTheme.bodyLarge;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: style)),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              style: style,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
