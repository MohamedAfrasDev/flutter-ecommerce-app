import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:online_shop/utils/repository/product_model/variation_model.dart';
import 'package:collection/collection.dart';

class ProductVariationSelector extends StatefulWidget {
  final List<dynamic> productAttributes; // from Supabase
  final List<ProductVariantionsModel> variations;
  final Function(ProductVariantionsModel?)? onVariationSelected;

  const ProductVariationSelector({
    super.key,
    required this.productAttributes,
    required this.variations,
    this.onVariationSelected,
  });

  @override
  State<ProductVariationSelector> createState() =>
      _ProductVariationSelectorState();
}

class _ProductVariationSelectorState extends State<ProductVariationSelector> {
  Map<String, String> selectedAttributes = {};
  ProductVariantionsModel? selectedVariation;

  final storage = GetStorage();

  @override
  void initState() {
    super.initState();

    // Try to find the default variation
    final defaultVariation = widget.variations.firstWhereOrNull(
      (v) => v.isDefault == true,
    );

    if (defaultVariation != null) {
      // Set selectedAttributes to the default variation's attribute values
      selectedAttributes = Map<String, String>.from(
        defaultVariation.attributesValues,
      );
      selectedVariation = defaultVariation;
      widget.onVariationSelected?.call(defaultVariation);
    } else {
      // Fallback: select first value of each attribute
      for (var attribute in widget.productAttributes) {
        final attrName = attribute.name ?? '';
        final List<String> values = attribute.values ?? [];
        if (values.isNotEmpty) {
          selectedAttributes[attrName] = values[0];
        }
      }
      _matchVariation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...widget.productAttributes.map((attribute) {
          final attrName = attribute.name ?? '';
          final List<String> values = attribute.values ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(attrName, style: Theme.of(context).textTheme.titleMedium),
              Wrap(
                spacing: 8,
                children:
                    values.map((value) {
                      final isSelected = selectedAttributes[attrName] == value;
                      return ChoiceChip(
                        label: Text(value),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              selectedAttributes[attrName] = value;
                              _matchVariation();
                            });
                          }
                        },
                      );
                    }).toList(),
              ),
              const SizedBox(height: 12),
            ],
          );
        }).toList(),

        const Divider(height: 24),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Expanded for the text column so it can wrap
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (selectedVariation != null) ...[
                    if (selectedVariation!.salePrice == null ||
                        selectedVariation!.salePrice == 0)
                      Text(
                        'Price: ${storage.read('currency_symbol')} ${selectedVariation!.price}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    if (selectedVariation!.salePrice != null &&
                        selectedVariation!.salePrice! > 0)
                      Row(
                        children: [
                          Text(
                            'Price: ',
                            style: Theme.of(context).textTheme.titleMedium!
                                .apply(decoration: TextDecoration.none),
                          ),
                          Text(
                            '${storage.read('currency_symbol')} ${selectedVariation!.price}',
                            style: Theme.of(context).textTheme.titleMedium!
                                .apply(decoration: TextDecoration.lineThrough),
                          ),
                        ],
                      ),
                    if (selectedVariation!.salePrice != null &&
                        selectedVariation!.salePrice! > 0)
                      Text(
                        'Sale Price: ${storage.read('currency_symbol')} ${selectedVariation!.salePrice}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    Text(
                      selectedVariation!.stock != 0
                          ? '🟢 Stock: ${selectedVariation!.stock}'
                          : '🔴 Out of Stock',
                    ),
                    const SizedBox(height: 4),
                    Text('Description:'),
                    Text(
                      selectedVariation!.description ?? '',
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ] else if (selectedAttributes.length ==
                      widget.productAttributes.length)
                    const Text(
                      'No matching variation found',
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            /// Fixed-size image
            if (selectedVariation != null &&
                selectedVariation!.image.value.isNotEmpty)
              Image.network(
                selectedVariation!.image.value,
                height: 120,
                width: 120,
                fit: BoxFit.contain,
              ),
          ],
        ),
      ],
    );
  }

  void _matchVariation() {
    final match = widget.variations.firstWhereOrNull((variation) {
      return const MapEquality().equals(
        variation.attributesValues,
        selectedAttributes,
      );
    });

    setState(() {
      selectedVariation = match;
    });

    widget.onVariationSelected?.call(selectedVariation);
  }
}
