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
  });

  final CartManager cartManager;
  final Function() didUpdate;
  final Function(Order) onSubmit;
  final Restaurant vehicle;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  Set<int> selectedSegment = {0};
  TimeOfDay? selectedTime;
  DateTime? selectedDate;
  RentalUnit rentalUnit = RentalUnit.hours;
  int rentalLength = 1;
  final DateTime _firstDate = DateTime(DateTime.now().year - 2);
  final DateTime _lastDate = DateTime(DateTime.now().year + 1);
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _canSubmit => selectedDate != null && selectedTime != null;

  double get _baseRate {
    return rentalUnit == RentalUnit.hours
        ? widget.vehicle.hourlyRate
        : widget.vehicle.dailyRate;
  }

  double get _rentalCost => _baseRate * rentalLength;

  double get _totalCost => _rentalCost + widget.cartManager.totalCost;

  String formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'Pick Date';
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  String formatTimeOfDay(TimeOfDay? timeOfDay) {
    if (timeOfDay == null) return 'Pick Time';
    final hour = timeOfDay.hour.toString().padLeft(2, '0');
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
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
      decoration: const InputDecoration(labelText: 'Driver Name'),
    );
  }

  void _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: _firstDate,
      lastDate: _lastDate,
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _selectTime(BuildContext context) async {
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
      return Expanded(
        child: Center(
          child: Text(
            'No add-ons selected. You can still rent this car now.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: widget.cartManager.items.length,
        itemBuilder: (context, index) {
          final item = widget.cartManager.itemAt(index);
          return Dismissible(
            key: Key(item.id),
            direction: DismissDirection.endToStart,
            background: Container(),
            secondaryBackground: const SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [Icon(Icons.delete)],
              ),
            ),
            onDismissed: (direction) {
              setState(() {
                widget.cartManager.removeItem(item.id);
              });
              widget.didUpdate();
            },
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: colorTheme.primary, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: Text('x${item.quantity}'),
                ),
              ),
              title: Text(item.name),
              subtitle:
                  Text('Add-on total: \$${item.totalCost.toStringAsFixed(2)}'),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: !_canSubmit
          ? null
          : () {
              final order = Order(
                selectedSegment: selectedSegment,
                selectedTime: selectedTime,
                selectedDate: selectedDate,
                name: _nameController.text,
                items: widget.cartManager.items,
                vehicleName: widget.vehicle.name,
                vehicleClass: widget.vehicle.vehicleClass,
                baseRate: _baseRate,
                rentalUnit: rentalUnit,
                rentalLength: rentalLength,
              );

              widget.cartManager.resetCart();
              widget.onSubmit(order);
            },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Reserve Trip - \$${_totalCost.toStringAsFixed(2)}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Trip Details', style: textTheme.headlineSmall),
            const SizedBox(height: 16),
            _buildOrderSegmentedType(),
            const SizedBox(height: 16),
            _buildRentalUnitSelector(),
            const SizedBox(height: 16),
            _buildRentalLengthControl(),
            const SizedBox(height: 16),
            _buildTextField(),
            const SizedBox(height: 16),
            Row(
              children: [
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text(formatDate(selectedDate)),
                ),
                TextButton(
                  onPressed: () => _selectTime(context),
                  child: Text(formatTimeOfDay(selectedTime)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildPriceSummary(),
            const SizedBox(height: 16),
            const Text('Optional Add-ons'),
            _buildOrderSummary(context),
            _buildSubmitButton(),
          ],
        ),
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
        children: [
          Expanded(child: Text(label, style: style)),
          Text(value, style: style),
        ],
      ),
    );
  }
}
