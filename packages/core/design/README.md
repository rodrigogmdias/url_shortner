# design

Design System mínimo para o monorepo: componentes reutilizáveis de UI (botão, texto, text field, list item e estados vazios) com estilos simples para prototipagem rápida.

## Objetivos

- Padronizar tipografia e espaçamentos básicos.
- Reutilização de widgets comuns evitando duplicação.
- Facilitar evolução incremental (tema mais elaborado, dark mode, etc.).

## Componentes Exportados

- `DesignButton` — Botão ícone + loading state.
- `DesignText` + `DesignTextType` — Tipografia (h1, h2, h3, body, caption).
- `DesignTextField` — Campo de texto com label (adaptado para uso de URL no create).
- `DesignListItem` — Item de lista com título, subtítulo e ação opcional.
- `DesignEmpty` — Placeholder para estados vazios.
- `DesignToast` — Toast/SnackBar flutuante com variantes de sucesso, alerta e erro.

## Uso rápido

```dart
import 'package:design/design.dart';

Widget build(BuildContext context) {
	return Column(
		crossAxisAlignment: CrossAxisAlignment.start,
		children: const [
			DesignText('Título', type: DesignTextType.h2),
			SizedBox(height: 16),
			DesignButton(icon: Icons.send, onPressed: null),
		],
	);
}
```

### Toasts

Exibir mensagens rápidas:

```dart
// Sucesso
DesignToast.success(context, 'URL encurtada com sucesso!');

// Alerta
DesignToast.warning(context, 'Verifique a URL informada.');

// Erro
DesignToast.error(context, 'Falha ao encurtar a URL.');

// Com ação
DesignToast.show(
  context,
  message: 'Link copiado',
  type: DesignToastType.success,
  actionLabel: 'Desfazer',
  onAction: () { /* ... */ },
);
```

## Tipografia

| Tipo | Tamanho | Peso |
|------|---------|------|
| h1 | 32 | bold |
| h2 | 24 | bold |
| h3 | 18 | bold |
| body | 14 | normal |
| caption | 12 | w400 |

## Extensões Futuras

- Suporte a theming dinâmico.
- Tokens (cores, radius, spacing) centralizados.
- Acessibilidade (larger fonts / contrast).

## Desenvolvimento

Formatar / fixes:
```
dart format .
dart fix --apply
```

## Licença

Uso interno no workspace.

