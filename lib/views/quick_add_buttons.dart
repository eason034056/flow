import 'package:flutter/material.dart';
import '../models/user_model.dart';

class QuickAddButtons extends StatelessWidget {
  final void Function(int amount, String type) onAdd;
  final List<QuickAddOption> options;

  const QuickAddButtons({
    super.key,
    required this.onAdd,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: options.length,
        itemBuilder: (context, index) {
          return _QuickAddButton(
            amount: options[index].amount,
            type: options[index].type,
            onTap: () => onAdd(options[index].amount, options[index].type),
          );
        },
      ),
    );
  }
}

class _QuickAddButton extends StatelessWidget {
  final int amount;
  final String type;
  final VoidCallback onTap;

  const _QuickAddButton({
    required this.amount,
    required this.type,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              type == 'water'
                  ? Icons.water_drop
                  : type == 'coffee'
                      ? Icons.coffee
                      : type == 'tea'
                          ? Icons.emoji_food_beverage
                          : type == 'juice'
                              ? Icons.local_drink
                              : Icons.water_drop,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$amount',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                ),
                const SizedBox(width: 4),
                const Text('ml'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
