# design

Minimal Design System for the monorepo: reusable UI components (button, text, text field, list item, empty states, toasts) with simple styles for fast prototyping.

## Goals

- Standardize basic typography and spacing.
- Reuse common widgets to avoid duplication.
- Enable incremental evolution (richer theme, dark mode, etc.).

## Exported components

- `DesignButton` — Icon button with loading state.
- `DesignText` + `DesignTextType` — Typography (h1, h2, h3, body, caption).
- `DesignTextField` — Text field with label (tuned for URL input in create).
- `DesignListItem` — List item with title, subtitle, and optional action.
- `DesignEmpty` — Placeholder for empty states.
- `DesignToast` — Floating toast/snackbar with success, warning, and error variants.

## Quick usage

```dart
import 'package:design/design.dart';

Widget build(BuildContext context) {
	return Column(
		crossAxisAlignment: CrossAxisAlignment.start,
		children: const [
			DesignText('Title', type: DesignTextType.h2),
			SizedBox(height: 16),
			DesignButton(icon: Icons.send, onPressed: null),
		],
	);
}
```

### Toasts

Show quick messages:

```dart
// Success
DesignToast.success(context, 'URL shortened successfully!');

// Warning
DesignToast.warning(context, 'Please check the provided URL.');

// Error
DesignToast.error(context, 'Failed to shorten the URL.');

// With action
DesignToast.show(
	context,
	message: 'Link copied',
	type: DesignToastType.success,
	actionLabel: 'Undo',
	onAction: () { /* ... */ },
);
```

## Typography

| Type | Size | Weight |
|------|------|--------|
| h1 | 32 | bold |
| h2 | 24 | bold |
| h3 | 18 | bold |
| body | 14 | normal |
| caption | 12 | w400 |

## Future extensions

- Dynamic theming support.
- Centralized tokens (colors, radius, spacing).
- Accessibility (larger fonts / contrast).

## Development

Format / fixes:
```
dart format .
dart fix --apply
```

## License

Internal use within this workspace.

