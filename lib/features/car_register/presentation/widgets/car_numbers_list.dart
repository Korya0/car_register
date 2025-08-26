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
  final Set<String> _selected = <String>{};

  @override
  void dispose() {
    // Properly dispose all animation controllers
    for (final controller in _slideOutControllers.values) {
      controller.dispose();
    }
    _slideOutControllers.clear();
    _slideOutAnimations.clear();
    super.dispose();
  }

  @override
  void didUpdateWidget(CarNumbersList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Clean up animations for removed numbers
    final currentNumbers = widget.numbers.toSet();
    final oldControllers = Map<String, AnimationController>.from(
      _slideOutControllers,
    );

    for (final entry in oldControllers.entries) {
      if (!currentNumbers.contains(entry.key)) {
        entry.value.dispose();
        _slideOutControllers.remove(entry.key);
        _slideOutAnimations.remove(entry.key);
      }
    }

    // Remove selected items that no longer exist
    _selected.removeWhere((item) => !currentNumbers.contains(item));
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
    if (index >= widget.numbers.length) {
      return const SizedBox.shrink();
    }

    final number = widget.numbers[index];
    _initializeSlideOutAnimation(number);

    return SlideTransition(
      position:
          _slideOutAnimations[number] ??
          const AlwaysStoppedAnimation(Offset.zero),
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
    if (!_slideOutControllers.containsKey(number) && mounted) {
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
    if (!mounted) return;

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
            onPressed: _selected.isEmpty ? null : _confirmDeleteSelected,
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            label: const Text('حذف المحدد'),
          ),
        ],
      ),
    );
  }

  void _toggleSelect(String number) {
    if (!mounted) return;

    setState(() {
      if (_selected.contains(number)) {
        _selected.remove(number);
      } else {
        _selected.add(number);
      }
    });
  }

  void _confirmDeleteSelected() {
    if (_selected.isEmpty || !mounted) return;

    final numbers = List<String>.from(_selected);
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
              if (mounted) {
                parentContext
                    .read<CarRegisterCubit>()
                    .deleteMultiple(numbers)
                    .then((_) {
                      if (mounted) {
                        setState(() {
                          _selected.clear();
                        });
                      }
                    })
                    .catchError((error) {
                      // Handle error if needed
                      debugPrint('Error deleting multiple items: $error');
                    });
              }
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _toggleSelectAll() {
    if (!mounted) return;

    setState(() {
      if (_selected.length == widget.numbers.length) {
        _selected.clear();
      } else {
        _selected.clear();
        _selected.addAll(widget.numbers);
      }
    });
  }

  /// تأكيد الحذف
  void _confirmDelete(String number) {
    if (!mounted) return;

    setState(() => _deletingNumber = number);

    context
        .read<CarRegisterCubit>()
        .deleteCarNumber(number)
        .then((_) {
          if (mounted) {
            setState(() => _deletingNumber = null);
          }
        })
        .catchError((error) {
          if (mounted) {
            setState(() => _deletingNumber = null);
          }
          debugPrint('Error deleting item: $error');
        });
  }
}
