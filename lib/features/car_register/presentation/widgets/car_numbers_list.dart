import 'package:car_register_app/core/constants/app_strings.dart';
import 'package:car_register_app/core/utils/app_logger.dart';
import 'package:car_register_app/core/style/font/app_text_styles.dart';
import 'package:car_register_app/core/style/theme/app_colors.dart';
import 'package:car_register_app/features/car_register/presentation/controllers/car_register_cubit.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/car_number_card_widget.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/pin_verification_dialog.dart';
import 'package:car_register_app/features/car_register/data/models/car_number_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarNumbersList extends StatefulWidget {
  final List<CarNumberModel> numbers;

  const CarNumbersList({super.key, required this.numbers});

  @override
  State<CarNumbersList> createState() => _CarNumbersListState();
}

class _CarNumbersListState extends State<CarNumbersList> {
  final Set<String> _selected = <String>{};
  String? _deletingNumber;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_selected.isNotEmpty) _buildSelectionBar(),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.numbers.length,
          itemBuilder: _buildCarNumberItem,
        ),
      ],
    );
  }

  Widget _buildCarNumberItem(BuildContext context, int index) {
    final model = widget.numbers[index];
    final number = model.number;
    return GestureDetector(
      onLongPress: () => _toggleSelect(number),
      onTap: () {
        if (_selected.isNotEmpty) _toggleSelect(number);
      },
      child: Stack(
        key: ValueKey(number),
        children: [
          CarNumberCard(
            model: model,
            isDeleting: _deletingNumber == number,
            onDelete: () => _deleteCarNumber(number),
            index: index,
          ),
          if (_selected.contains(number))
            const Positioned(
              top: 12,
              left: 12,
              child: CircleAvatar(
                radius: 14,
                backgroundColor: Colors.blue,
                child: Icon(Icons.check, size: 18, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSelectionBar() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: AppColors.primary,
            child: Text(
              '${_selected.length}',
              style: AppTextStyles.selectedCount,
            ),
          ),
          const SizedBox(width: 8),
          const Text(AppStrings.selected),
          const Spacer(),
          TextButton.icon(
            onPressed: _toggleSelectAll,
            icon: Icon(
              _selected.length == widget.numbers.length
                  ? Icons.deselect
                  : Icons.select_all,
              size: 18,
              color: AppColors.primary,
            ),
            label: Text(
              _selected.length == widget.numbers.length ? AppStrings.deselectAll : AppStrings.selectAll,
              style: AppTextStyles.bodySmall,
            ),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: _selected.isEmpty ? null : _confirmDeleteSelected,
            icon: const Icon(Icons.delete_forever, color: Colors.red, size: 18),
            label: Text(AppStrings.delete, style: AppTextStyles.errorMessage),
          ),
        ],
      ),
    );
  }

  void _toggleSelect(String number) {
    setState(() {
      if (_selected.contains(number)) {
        _selected.remove(number);
      } else {
        _selected.add(number);
      }
    });
  }

  void _toggleSelectAll() {
    setState(() {
      if (_selected.length == widget.numbers.length) {
        _selected.clear();
      } else {
        _selected.addAll(widget.numbers.map((e) => e.number));
      }
    });
  }

  void _deleteCarNumber(String number) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text(AppStrings.confirmDelete),
          ],
        ),
        content: Text('${AppStrings.confirmDeleteSinglePrefix}$number${AppStrings.confirmDeleteSingleSuffix}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _confirmDelete(number);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(String number) {
    AppLogger.debug('UI: confirm delete number $number');
    setState(() => _deletingNumber = number);
    context.read<CarRegisterCubit>().deleteCarNumber(number).then((_) {
      if (mounted) setState(() => _deletingNumber = null);
    }).catchError((error) {
      AppLogger.warn('UI: unexpected error during delete', error: error);
      if (mounted) setState(() => _deletingNumber = null);
    });
  }

  void _confirmDeleteSelected() async {
    if (_selected.isEmpty) return;
    final numbers = List<String>.from(_selected);
    AppLogger.debug('UI: confirm delete ${numbers.length} selected numbers');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.confirmDelete),
        content: const Text(AppStrings.confirmDeleteSelected),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text(AppStrings.proceed),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final pinVerified = await PinVerificationDialog.show(context);
      if (pinVerified && mounted) {
        AppLogger.debug('UI: executing batch delete for ${numbers.length} numbers');
        context.read<CarRegisterCubit>().deleteMultiple(numbers).then((_) {
          if (mounted) setState(() => _selected.clear());
        });
      }
    }
  }
}
