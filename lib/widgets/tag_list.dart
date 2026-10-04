import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TagList extends HookWidget {
  final Set<String> initialTags;
  final ValueChanged<Set<String>> onChanged;

  const TagList({
    required this.onChanged,
    this.initialTags = const <String>{},
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<Set<String>> tags = useState<Set<String>>(
      Set<String>.from(initialTags),
    );
    final ValueNotifier<bool> isAdding = useState<bool>(false);

    final TextEditingController controller = useTextEditingController();
    final FocusNode focusNode = useFocusNode();
    final ScrollController scrollController = useScrollController();

    void submitTag() {
      final String value = controller.text.trim();
      if (value.isNotEmpty && !tags.value.contains(value)) {
        final Set<String> updated = Set<String>.from(tags.value)..add(value);
        tags.value = updated;
        onChanged(updated);
        controller.clear();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
            );
          }
        });
      }
      isAdding.value = false;
    }

    void removeTag(String value) {
      final Set<String> updated = Set<String>.from(tags.value)..remove(value);
      tags.value = updated;
      onChanged(updated);
    }

    return SingleChildScrollView(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ...tags.value.map(
            (String tag) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InputChip(
                label: Text(tag),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () => removeTag(tag),
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),

          if (isAdding.value)
            Container(
              width: 130,
              height: 36,
              margin: const EdgeInsets.only(right: 8),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                autofocus: true,
                style: Theme.of(context).textTheme.bodyMedium,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => submitTag(),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.check, size: 16),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: submitTag,
                  ),
                ),
              ),
            )
          else
            ActionChip(
              label: const Icon(Icons.add, size: 16),
              onPressed: () {
                isAdding.value = true;
              },
            ),
        ],
      ),
    );
  }
}
