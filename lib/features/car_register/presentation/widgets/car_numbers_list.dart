import 'package:car_register_app/features/car_register/presentation/widgets/car_number_card_widget.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/car_number_delete_dialog.dart';
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
  final Map<String, AnimationController> _slideOutControllers = {};
  final Map<String, Animation<Offset>> _slideOutAnimations = {};
  String? _deletingNumber;
  final Set<String> _selected = {};

  @override
  void dispose() {
    for (final controller in _slideOutControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

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

  /// بناء عنصر رقم السيارة
  Widget _buildCarNumberItem(BuildContext context, int index) {
    final number = widget.numbers[index];
    _initializeSlideOutAnimation(number);

    return SlideTransition(
      position: _slideOutAnimations[number]!,
      child: GestureDetector(
        onLongPress: () => _toggleSelect(number),
        onTap: () {
          if (_selected.isNotEmpty) {
            _toggleSelect(number);
          }
        },
        child: Stack(
          key: ValueKey(number),
          children: [
            CarNumberCard(
              number: number,
              index: index,
              isDeleting: _deletingNumber == number,
              onDelete: () => _deleteCarNumber(number),
            ),
            if (_selected.contains(number)) ...[
              const Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Color(0x22007AFF)),
                  ),
                ),
              ),
              const Positioned(
                top: 12,
                left: 12,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Color(0xFF007AFF),
                  child: Icon(Icons.check, size: 16, color: Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// تهيئة أنيميشن الإنزلاق
  void _initializeSlideOutAnimation(String number) {
    if (!_slideOutControllers.containsKey(number)) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
      );
      final animation = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-1.5, 0),
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInBack));

      _slideOutControllers[number] = controller;
      _slideOutAnimations[number] = animation;
    }
  }

  /// حذف رقم السيارة
  void _deleteCarNumber(String number) {
    CarNumberDeleteDialog.show(
      context: context,
      number: number,
      onConfirm: () => _confirmDelete(number),
    );
  }

  Widget _buildSelectionBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text('المحدد: ${_selected.length}'),
          const Spacer(),
          TextButton(
            onPressed: _toggleSelectAll,
            child: Text(
              _selected.length == widget.numbers.length
                  ? 'إلغاء الكل'
                  : 'تحديد الكل',
            ),
          ),
          TextButton.icon(
            onPressed: _confirmDeleteSelected,
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            label: const Text('حذف المحدد'),
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

  void _confirmDeleteSelected() {
    if (_selected.isEmpty) return;
    final numbers = _selected.toList();
    final parentContext = context;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل تريد حذف ${numbers.length} عنصر؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              parentContext
                  .read<CarRegisterCubit>()
                  .deleteMultiple(numbers)
                  .then((_) {
                    if (mounted) {
                      setState(() {
                        _selected.clear();
                      });
                    }
                  });
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _toggleSelectAll() {
    setState(() {
      if (_selected.length == widget.numbers.length) {
        _selected.clear();
      } else {
        _selected
          ..clear()
          ..addAll(widget.numbers);
      }
    });
  }

  /// تأكيد الحذف
  void _confirmDelete(String number) {
    setState(() => _deletingNumber = number);

    context.read<CarRegisterCubit>().deleteCarNumber(number).then((_) {
      if (mounted) {
        setState(() => _deletingNumber = null);
      }
    });
  }
}
