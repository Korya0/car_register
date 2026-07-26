// car_numbers_list.dart
import 'package:car_register_app/core/theme/app_colors.dart';
import 'package:car_register_app/core/widgets/common/text_app.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/car_number_card_widget.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/pin_verification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/car_register_cubit.dart';

class CarNumbersList extends StatefulWidget {
  final List<String> numbers;
  final CarRegisterLoaded state;

  const CarNumbersList({super.key, required this.numbers, required this.state});

  @override
  State<CarNumbersList> createState() => _CarNumbersListState();
}

class _CarNumbersListState extends State<CarNumbersList>
    with TickerProviderStateMixin {
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
    final number = widget.numbers[index];
    return GestureDetector(
      onLongPress: () => _toggleSelect(number),
      onTap: () {
        if (_selected.isNotEmpty) _toggleSelect(number);
      },
      child: Stack(
        key: ValueKey(number),
        children: [
          CarNumberCard(
            number: number,
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
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextApp(text: 'محدد'),
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
            label: TextApp(
              text: _selected.length == widget.numbers.length
                  ? 'إلغاء الكل'
                  : 'تحديد الكل',
              type: TextAppType.bodyMedium,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: _selected.isEmpty ? null : _confirmDeleteSelected,
            icon: const Icon(Icons.delete_forever, color: Colors.red, size: 18),
            label: const TextApp(
              text: 'حذف',
              style: TextStyle(color: Colors.red),
            ),
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
        _selected.addAll(widget.numbers);
      }
    });
  }

  void _deleteCarNumber(String number) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('تأكيد الحذف'),
          ],
        ),
        content: Text(
          'هل تريد حذف الرقم $number؟',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
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
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(String number) {
    setState(() => _deletingNumber = number);
    context
        .read<CarRegisterCubit>()
        .deleteCarNumber(number)
        .then((_) {
          if (mounted) setState(() => _deletingNumber = null);
        })
        .catchError((error) {
          if (mounted) setState(() => _deletingNumber = null);
          debugPrint('Error deleting item: $error');
        });
  }

  void _confirmDeleteSelected() async {
    if (_selected.isEmpty) return;
    final numbers = List<String>.from(_selected);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: TextApp(
          text: 'تأكيد الحذف',
          color: AppColors.textAndIconPrimary,
        ),
        content: TextApp(
          text: 'هل تريد حذف  العناصر محدد؟',
          color: AppColors.textAndIconPrimary,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const TextApp(
              text: 'إلغاء',
              color: AppColors.textAndIconPrimary,
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('متابعة'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final pinVerified = await PinVerificationDialog.show(context);
      if (pinVerified && mounted) {
        context.read<CarRegisterCubit>().deleteMultiple(numbers).then((_) {
          if (mounted) setState(() => _selected.clear());
        });
      }
    }
  }
}
