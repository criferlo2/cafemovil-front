# CafeMovil Design System

Este archivo deja registrado el norte visual acordado para la aplicación móvil de venta de café colombiano.

## Concepto de marca

**Premium-artesanal colombiano**: una experiencia clara, cálida y elegante para vender café por libras y diferentes presentaciones. La referencia visual debe sentirse más cercana a Apple, Airbnb o Notion que a un dashboard técnico oscuro.

## Paleta de color

| Token | Uso | Hex |
| --- | --- | --- |
| `coffeeBrown` | Marca principal, textos fuertes, elementos premium | `#3B2416` |
| `caramel` | Botones principales, estados activos, highlights cálidos | `#C27A35` |
| `cream` | Fondo principal claro y cálido | `#FFF7EA` |
| `deepGreen` | Origen colombiano/café, badges, acentos naturales | `#245C3A` |
| `gold` | Acentos premium, detalles de calidad, ratings | `#D6A84F` |

## Tipografía

- Usar una sans serif moderna para interfaz: **DM Sans** o **Inter**.
- Reservar una serif elegante solo para títulos de marca o piezas muy destacadas.
- Priorizar legibilidad en móvil: jerarquías claras, buen contraste y textos cortos.

## Componentes clave

- **Product cards** grandes, con foto protagonista del café.
- **Presentation chips** para variantes: `250g`, `500g`, `1 libra`, `molido`, `grano`.
- **Origin badges** para procedencia: `Huila`, `Nariño`, `Sierra Nevada`, etc.
- **Coffee attributes** visibles: rating, aroma, intensidad y notas.
- **Primary CTA** cálido y directo: `Agregar al carrito`.
- **Clean checkout**: pocos pasos, claro, sin ruido visual.

## Iconografía

- Usar **Material Icons** (`Icons.*`) como fuente principal: vienen incluidos en Flutter, son gratuitos, genéricos, consistentes con Android y no agregan dependencias.
- Mantener íconos simples, reconocibles y funcionales para acciones comunes: navegación, carrito, búsqueda, perfil, favoritos, pagos y estados.
- Evitar mezclar muchos paquetes de íconos para conservar coherencia visual.
- Agregar un paquete externo solo si Material Icons no cubre bien una necesidad clave; opciones aceptables: **Font Awesome Free**, **Lucide Icons** o **Tabler Icons**, revisando licencia antes de incorporarlo.
- Si se agrega un paquete externo, documentar el motivo y centralizar su uso para no dispersar estilos por pantalla.

## Implementación Flutter esperada

Mantener el sistema centralizado y reutilizable:

```text
lib/
  core/
    theme/
      app_theme.dart
      app_colors.dart
      app_text_styles.dart
      app_spacing.dart
      app_radius.dart
```

Los componentes deben ser MVVM-friendly: widgets enfocados en presentación, lógica en ViewModels y datos vía repositories/models.

## Principios de UI

1. Base clara y cálida; evitar una estética oscura o demasiado técnica.
2. Fotos del producto como protagonista.
3. Consistencia de espaciados, radios y colores mediante tokens.
4. Checkout simple y confiable.
5. Componentes reutilizables antes que estilos duplicados por pantalla.
