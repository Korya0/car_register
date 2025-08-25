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

  @override
  void dispose() {
    for (final controller in _slideOutControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.numbers.length,
      itemBuilder: _buildCarNumberItem,
    );
  }

  /// بناء عنصر رقم السيارة
  Widget _buildCarNumberItem(BuildContext context, int index) {
    final number = widget.numbers[index];
    _initializeSlideOutAnimation(number);

    return SlideTransition(
      position: _slideOutAnimations[number]!,
      child: CarNumberCard(
        number: number,
        index: index,
        isDeleting: _deletingNumber == number,
        onDelete: () => _deleteCarNumber(number),
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
