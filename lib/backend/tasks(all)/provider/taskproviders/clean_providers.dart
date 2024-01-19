import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../taskmodels/task_model.dart';
import '../../widgets/category_widget_all/category.model.dart';
import 'selected_category_providers.dart';
import 'service_provider.dart';
import 'task_providers.dart';

class ProvidersClear {
  void clearEditTask(WidgetRef ref) {
    ref.read(taskUpdateStateProvider.notifier).update((state) => TaskModel(
        docID: '',
        taskTitle: '',
        description: '',
        isDone: false,
        status: '',
        categoryID: '',
        categoryName: '',
        categoryColorHex: '',
        dateTask: '',
        timeTask: '',
        repeatShown: '',
        repeatingDays: [],
        repeatingFrequency: '',
        stopDate: '',
        creationDate: ''));
    ref.read(selectedCategoryProvider.notifier).update((state) =>
        UserCreatedCategoryModel(
            categoryID: '', categoryName: "No Category", colorHex: '#4C7755'));
    ref.read(timeProvider.notifier).update((state) => 'hh:mm');
    ref.read(dateProvider.notifier).update((state) => 'mm/dd/yy');
    ref.read(repeatShownProvider.notifier).update((state) => 'No');
    ref.read(stopDateProvider.notifier).update((state) => 'Until?');
    ref.read(repeatingOptionDays.notifier).update((state) => []);
    ref.read(repeatingOptionFrequency.notifier).update((state) => 'No');
  }

  void clearNewTaskProvidersCancel(WidgetRef ref) {
    ref.read(selectedCategoryProvider.notifier).update((state) =>
        UserCreatedCategoryModel(
            categoryID: '', categoryName: "No Category", colorHex: '#4C7755'));
    ref.read(dateProvider.notifier).update((state) => 'mm/dd/yy');
    ref.read(timeProvider.notifier).update((state) => 'hh:mm');
    ref.read(repeatingOptionFrequency.notifier).update((state) => 'No');
    ref.read(repeatingOptionDays.notifier).update((state) => []);
    ref.read(stopDateProvider.notifier).update((state) => 'Until?');

    ref.read(repeatShownProvider.notifier).update((state) => 'No');
  }

  void newTaskProviderClearCreate(TextEditingController title,
      TextEditingController description, WidgetRef ref) {
    title.clear();
    description.clear();

    ref.read(selectedCategoryProvider.notifier).update((state) {
      return UserCreatedCategoryModel(
        categoryID: '',
        categoryName: "No Category",
        colorHex: '#4C7755',
      );
    });
    ref.read(dateProvider.notifier).update((state) => 'mm/dd/yy');
    ref.read(timeProvider.notifier).update((state) => 'hh:mm');

    ref.read(repeatShownProvider.notifier).update((state) => 'No');
  }
}
