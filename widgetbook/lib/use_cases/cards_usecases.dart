import 'package:demoapp/design_system/cards/info_card.dart';
import 'package:demoapp/design_system/cards/user_card.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import '../fixtures/user_fixtures.dart';

// InfoCard Use-Cases
@widgetbook.UseCase(name: 'Default', type: InfoCard, path: '[Cards]/InfoCard')
Widget buildInfoCardDefault(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: InfoCard(
      title: context.knobs.string(
        label: 'Title',
        initialValue: 'Información importante',
      ),
      description: context.knobs.string(
        label: 'Description',
        initialValue:
            'Esta es una descripción de ejemplo para la tarjeta de información.',
      ),
      icon: context.knobs.objectOrNull.dropdown<IconData>(
        label: 'Icon',
        options: [Icons.info, Icons.warning, Icons.check_circle, Icons.star],
        labelBuilder: (icon) => icon.toString().split('.').last,
      ),
      onTap: () => debugPrint('InfoCard tapped'),
    ),
  );
}

@widgetbook.UseCase(name: 'With Icon', type: InfoCard, path: '[Cards]/InfoCard')
Widget buildInfoCardWithIcon(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16),
    child: InfoCard(
      title: 'Nueva actualización disponible',
      description:
          'Hay una nueva versión de la aplicación lista para descargar.',
      icon: Icons.system_update,
    ),
  );
}

// UserCard Use-Cases
@widgetbook.UseCase(name: 'Default', type: UserCard, path: '[Cards]/UserCard')
Widget buildUserCardDefault(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: UserCard(
      name: context.knobs.string(label: 'Name', initialValue: 'Juan Pérez'),
      email: context.knobs.string(
        label: 'Email',
        initialValue: 'juan.perez@example.com',
      ),
      isVerified: context.knobs.boolean(label: 'Verified', initialValue: false),
      onTap: () => debugPrint('UserCard tapped'),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Verified User',
  type: UserCard,
  path: '[Cards]/UserCard/States',
)
Widget buildUserCardVerified(BuildContext context) {
  const user = UserFixtures.verified;
  return Padding(
    padding: const EdgeInsets.all(16),
    child: UserCard(
      name: user.name,
      email: user.email,
      avatarUrl: user.avatarUrl,
      isVerified: user.isVerified,
      onTap: () => debugPrint('Tapped: ${user.name}'),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Without Avatar',
  type: UserCard,
  path: '[Cards]/UserCard/States',
)
Widget buildUserCardNoAvatar(BuildContext context) {
  const user = UserFixtures.noAvatar;
  return Padding(
    padding: const EdgeInsets.all(16),
    child: UserCard(
      name: user.name,
      email: user.email,
      avatarUrl: user.avatarUrl,
      isVerified: user.isVerified,
      onTap: () => debugPrint('Tapped: ${user.name}'),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Long Name',
  type: UserCard,
  path: '[Cards]/UserCard/Edge Cases',
)
Widget buildUserCardLongName(BuildContext context) {
  const user = UserFixtures.longName;
  return Padding(
    padding: const EdgeInsets.all(16),
    child: UserCard(
      name: user.name,
      email: user.email,
      avatarUrl: user.avatarUrl,
      isVerified: user.isVerified,
      onTap: () => debugPrint('Tapped: ${user.name}'),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Long Email',
  type: UserCard,
  path: '[Cards]/UserCard/Edge Cases',
)
Widget buildUserCardLongEmail(BuildContext context) {
  const user = UserFixtures.longEmail;
  return Padding(
    padding: const EdgeInsets.all(16),
    child: UserCard(
      name: user.name,
      email: user.email,
      avatarUrl: user.avatarUrl,
      isVerified: user.isVerified,
      onTap: () => debugPrint('Tapped: ${user.name}'),
    ),
  );
}
