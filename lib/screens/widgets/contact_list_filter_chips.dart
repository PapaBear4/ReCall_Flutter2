import 'package:flutter/material.dart';
import 'package:recall/models/contact_enums.dart';

typedef FilterToggleCallback = void Function(ContactListFilter filter, bool enabled);
typedef FilterClearCallback = void Function(Set<ContactListFilter> filtersToKeep);
typedef SwitchViewCallback = void Function();

/// Helper class for filter options
class FilterOption {
  final ContactListFilter filter;
  final String label;
  final IconData icon;
  final Color color;

  FilterOption({
    required this.filter,
    required this.label,
    required this.icon,
    required this.color,
  });
}

class ContactListFilterChips extends StatelessWidget {
  final Set<ContactListFilter> appliedFilters;
  final FilterToggleCallback onFilterToggled;
  final FilterClearCallback onFiltersCleared;
  final SwitchViewCallback onSwitchView; // Callback to switch between active/archived

  const ContactListFilterChips({
    super.key,
    required this.appliedFilters,
    required this.onFilterToggled,
    required this.onFiltersCleared,
    required this.onSwitchView,
  });

  @override
  Widget build(BuildContext context) {
    final bool showingArchived = appliedFilters.contains(ContactListFilter.archived);

    // Define the functional filters
    final List<FilterOption> filterOptions = [
      FilterOption(
        filter: ContactListFilter.overdue,
        label: 'Overdue',
        icon: Icons.warning_amber_rounded,
        color: Colors.redAccent,
      ),
      FilterOption(
        filter: ContactListFilter.dueSoon,
        label: 'Due Soon',
        icon: Icons.upcoming,
        color: Colors.orangeAccent,
      ),
    ];

    // Check if any functional filters are active
    final bool hasFunctionalFilters = filterOptions.any((option) => appliedFilters.contains(option.filter));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Active/Archived switcher
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    showingArchived ? Icons.archive : Icons.people,
                    color: Theme.of(context).colorScheme.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    showingArchived ? 'Archived Contacts' : 'Active Contacts',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: onSwitchView, // Use the callback
                    child: Text(
                      showingArchived ? 'Show Active' : 'Show Archived',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Show filters header only if we have any active functional filters
          if (hasFunctionalFilters)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
              child: Row(
                children: [
                  Text(
                    'Filters:',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  // Clear filters button
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size(0, 24),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      // Keep active/archived status when clearing
                      Set<ContactListFilter> keep = {
                        showingArchived ? ContactListFilter.archived : ContactListFilter.active
                      };
                      onFiltersCleared(keep); // Use the callback
                    },
                    child: const Text('Clear Filters'),
                  ),
                ],
              ),
            ),

          // Filter chips row
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: filterOptions.map((option) {
              return FilterChip(
                avatar: Icon(
                  option.icon,
                  size: 18,
                  color: appliedFilters.contains(option.filter)
                      ? Colors.white
                      : option.color,
                ),
                label: Text(option.label),
                selected: appliedFilters.contains(option.filter),
                selectedColor: option.color,
                checkmarkColor: Colors.white,
                onSelected: (selected) {
                  onFilterToggled(option.filter, selected); // Use the callback
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
