# Chapel Hill/Durham Toddler Activities App - Style Guide

**Version:** 1.0
**Last Updated:** January 31, 2026
**Design Philosophy:** Whimsical yet clean and modern, inspired by 1960s Italian design

---

## Table of Contents

1. [Color System](#color-system)
2. [Typography](#typography)
3. [Spacing & Layout](#spacing--layout)
4. [Components](#components)
5. [Icons & Imagery](#icons--imagery)
6. [Interaction Patterns](#interaction-patterns)
7. [Accessibility](#accessibility)
8. [Design Principles](#design-principles)

---

## Color System

### Primary Colors

Our palette draws inspiration from bold 1960s Italian design - vibrant, saturated colors that evoke joy and playfulness while maintaining a modern, sophisticated feel.

#### Core Primary Colors

**Tomato Red** - `#E63946`
- RGB: 230, 57, 70
- Usage: High-energy activities, alerts, featured events
- Evokes: Excitement, energy, passion

**Sunshine Yellow** - `#FFB703`
- RGB: 255, 183, 3
- Usage: Creative activities, workshops, indoor play
- Evokes: Warmth, creativity, happiness

**Mediterranean Blue** - `#1D3557`
- RGB: 29, 53, 87
- Usage: Educational activities, libraries, quiet events
- Evokes: Trust, calm, intelligence

**Vibrant Cyan** - `#06AED5`
- RGB: 6, 174, 213
- Usage: Outdoor activities, water play, parks
- Evokes: Freshness, adventure, openness

**Lime Green** - `#80B918`
- RGB: 128, 185, 24
- Usage: Nature activities, gardens, eco-friendly events
- Evokes: Growth, nature, vitality

**Tangerine Orange** - `#F77F00`
- RGB: 247, 127, 0
- Usage: Food events, social gatherings, parties
- Evokes: Fun, sociability, enthusiasm

### Neutral Colors

**Charcoal** - `#2B2D42`
- RGB: 43, 45, 66
- Usage: Primary text, headings

**Slate Gray** - `#8D99AE`
- RGB: 141, 153, 174
- Usage: Secondary text, captions, disabled states

**Soft Gray** - `#EDF2F4`
- RGB: 237, 242, 244
- Usage: Backgrounds, dividers, subtle borders

**Pure White** - `#FFFFFF`
- RGB: 255, 255, 255
- Usage: Card backgrounds, primary background

**Off-White** - `#F8F9FA`
- RGB: 248, 249, 250
- Usage: Alternative background, subtle depth

### Accent & Interactive Colors

**Forest Green** - `#386641`
- RGB: 56, 102, 65
- Usage: Primary buttons, CTAs, active states
- This darker green provides excellent contrast against light backgrounds

**Deep Forest** - `#1B4332`
- RGB: 27, 67, 50
- Usage: Button hover states, pressed states

**Success Green** - `#52B788`
- RGB: 82, 183, 136
- Usage: Success messages, confirmations

**Warning Orange** - `#FB8500`
- RGB: 251, 133, 0
- Usage: Warnings, important notices

**Error Red** - `#D62828`
- RGB: 214, 40, 40
- Usage: Errors, destructive actions

### Color Usage Guidelines

**Section Headers:**
Rotate through primary colors (Tomato Red, Sunshine Yellow, Vibrant Cyan, Lime Green, Tangerine Orange) to create visual variety and help users mentally categorize different sections.

**Category Color Coding:**
- Arts & Crafts: Sunshine Yellow (#FFB703)
- Outdoor Activities: Vibrant Cyan (#06AED5)
- Educational: Mediterranean Blue (#1D3557)
- Physical Activities: Tomato Red (#E63946)
- Nature & Animals: Lime Green (#80B918)
- Food & Social: Tangerine Orange (#F77F00)

---

## Typography

### Font Families

**Headings: Merriweather** (Serif)
- Fallback: Georgia, "Times New Roman", serif
- Web: Google Fonts - `font-family: 'Merriweather', Georgia, serif;`
- Rationale: Warm, friendly serif that adds personality while remaining highly readable

**Body: Inter** (Sans-serif)
- Fallback: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif
- Web: Google Fonts - `font-family: 'Inter', -apple-system, sans-serif;`
- Rationale: Modern, clean, excellent readability at all sizes

### Type Scale

#### Headings

**H1 - Page Title**
- Font: Merriweather
- Size: 32px / 2rem
- Weight: 700 (Bold)
- Line Height: 1.2 (38px)
- Letter Spacing: -0.5px
- Usage: Main page headings, app title

**H2 - Section Title**
- Font: Merriweather
- Size: 24px / 1.5rem
- Weight: 700 (Bold)
- Line Height: 1.3 (31px)
- Letter Spacing: -0.25px
- Usage: Major section headers

**H3 - Subsection Title**
- Font: Merriweather
- Size: 20px / 1.25rem
- Weight: 700 (Bold)
- Line Height: 1.4 (28px)
- Letter Spacing: 0
- Usage: Card titles, subsections

**H4 - Component Title**
- Font: Inter
- Size: 16px / 1rem
- Weight: 600 (Semibold)
- Line Height: 1.5 (24px)
- Letter Spacing: 0
- Usage: Small component headers, list titles

#### Body Text

**Body Large**
- Font: Inter
- Size: 18px / 1.125rem
- Weight: 400 (Regular)
- Line Height: 1.6 (29px)
- Usage: Intro paragraphs, featured content

**Body Regular**
- Font: Inter
- Size: 16px / 1rem
- Weight: 400 (Regular)
- Line Height: 1.6 (26px)
- Usage: Standard body text, descriptions

**Body Small**
- Font: Inter
- Size: 14px / 0.875rem
- Weight: 400 (Regular)
- Line Height: 1.5 (21px)
- Usage: Secondary information, metadata

**Caption**
- Font: Inter
- Size: 12px / 0.75rem
- Weight: 400 (Regular)
- Line Height: 1.4 (17px)
- Usage: Timestamps, fine print, labels

**Label/Button Text**
- Font: Inter
- Size: 16px / 1rem
- Weight: 600 (Semibold)
- Line Height: 1.5 (24px)
- Letter Spacing: 0.5px
- Usage: Button labels, form labels

### Typography Best Practices

- **Maximum line length:** 65-75 characters for optimal readability
- **Paragraph spacing:** 16px (1rem) between paragraphs
- **Heading spacing:** 24px (1.5rem) above, 12px (0.75rem) below
- **Hierarchy:** Never skip heading levels (don't go from H1 to H3)
- **Emphasis:** Use weight variations within the same font family rather than mixing fonts

---

## Spacing & Layout

### Spacing Scale

Based on an 8px grid system for consistent, harmonious spacing:

```
4px  - xs  - Minimal spacing (icon padding, tight elements)
8px  - sm  - Small spacing (list item padding, compact layouts)
16px - md  - Medium spacing (card padding, standard gaps)
24px - lg  - Large spacing (section padding, generous whitespace)
32px - xl  - Extra large (major section spacing)
48px - 2xl - Section breaks
64px - 3xl - Page-level spacing
```

### Layout Grid

**Mobile (< 768px):**
- Container padding: 16px
- Card margin: 16px
- Content max-width: 100%

**Tablet (768px - 1024px):**
- Container padding: 24px
- Card margin: 24px
- Content max-width: 720px

**Desktop (> 1024px):**
- Container padding: 32px
- Card margin: 32px
- Content max-width: 1200px

### Component Spacing

**Cards:**
- Internal padding: 24px (lg)
- Border radius: 16px
- Gap between cards: 16px (md)
- Shadow: 0 2px 8px rgba(43, 45, 66, 0.08)

**Buttons:**
- Padding: 12px 24px (vertical: sm + 4px, horizontal: lg)
- Border radius: 24px (pill shape)
- Minimum width: 120px
- Gap between buttons: 12px

**Form Elements:**
- Input padding: 12px 16px
- Border radius: 12px
- Label margin-bottom: 8px (sm)
- Field margin-bottom: 16px (md)

**Lists:**
- List item padding: 16px (md)
- Gap between sections: 32px (xl)
- Divider margin: 16px (md) top and bottom

---

## Components

### Cards

Cards are the primary container for content throughout the app.

**Standard Card:**
```
Background: #FFFFFF (Pure White)
Border Radius: 16px
Padding: 24px
Shadow: 0 2px 8px rgba(43, 45, 66, 0.08)
Border: None
```

**Colored Section Card:**
```
Background: Primary color with reduced opacity (15-20%)
  Example: rgba(230, 57, 70, 0.15) for Tomato Red
Border Radius: 16px
Padding: 24px
Shadow: None
Border: None
```

**Interactive Card (Tappable):**
```
All Standard Card properties, plus:
Hover: Shadow increases to 0 4px 16px rgba(43, 45, 66, 0.12)
Active: Shadow decreases to 0 1px 4px rgba(43, 45, 66, 0.06)
Transition: all 0.2s ease-in-out
```

### Buttons

#### Primary Button (Action)
```
Background: #386641 (Forest Green)
Text Color: #FFFFFF (Pure White)
Font: Inter, 16px, 600 weight
Padding: 12px 24px
Border Radius: 24px
Border: None
Shadow: 0 2px 4px rgba(56, 102, 65, 0.2)

Hover:
  Background: #1B4332 (Deep Forest)
  Shadow: 0 4px 8px rgba(56, 102, 65, 0.3)

Active/Pressed:
  Background: #1B4332 (Deep Forest)
  Shadow: 0 1px 2px rgba(56, 102, 65, 0.2)
  Transform: scale(0.98)

Disabled:
  Background: #8D99AE (Slate Gray)
  Text Color: #FFFFFF
  Opacity: 0.5
  Cursor: not-allowed
```

#### Secondary Button (Outline)
```
Background: Transparent
Text Color: #386641 (Forest Green)
Font: Inter, 16px, 600 weight
Padding: 12px 24px
Border Radius: 24px
Border: 2px solid #386641

Hover:
  Background: rgba(56, 102, 65, 0.08)
  Border: 2px solid #1B4332

Active/Pressed:
  Background: rgba(56, 102, 65, 0.15)
  Transform: scale(0.98)
```

#### Circular Icon Button
```
Background: #386641 (Forest Green)
Size: 56px × 56px
Border Radius: 28px (50%)
Border: None
Shadow: 0 4px 12px rgba(56, 102, 65, 0.3)
Icon Size: 24px
Icon Color: #FFFFFF

Position: Fixed or absolute, typically bottom-right
Bottom: 24px
Right: 24px

Hover:
  Background: #1B4332
  Shadow: 0 6px 16px rgba(56, 102, 65, 0.4)
  Transform: scale(1.05)

Active:
  Transform: scale(0.95)
```

#### Text Button (Low Emphasis)
```
Background: Transparent
Text Color: #386641 (Forest Green)
Font: Inter, 16px, 600 weight
Padding: 8px 12px
Border: None

Hover:
  Background: rgba(56, 102, 65, 0.08)
  Border Radius: 8px

Active:
  Background: rgba(56, 102, 65, 0.15)
```

### Form Elements

#### Text Input
```
Background: #FFFFFF
Border: 2px solid #EDF2F4
Border Radius: 12px
Padding: 12px 16px
Font: Inter, 16px, 400 weight
Text Color: #2B2D42

Placeholder:
  Color: #8D99AE
  Font Style: normal

Focus:
  Border: 2px solid #386641
  Outline: None
  Shadow: 0 0 0 4px rgba(56, 102, 65, 0.1)

Error:
  Border: 2px solid #D62828
  Shadow: None

Disabled:
  Background: #F8F9FA
  Border: 2px solid #EDF2F4
  Color: #8D99AE
  Cursor: not-allowed
```

#### Labels
```
Font: Inter, 14px, 600 weight
Color: #2B2D42
Margin-bottom: 8px
Display: block
```

#### Helper Text
```
Font: Inter, 12px, 400 weight
Color: #8D99AE
Margin-top: 4px
```

#### Error Text
```
Font: Inter, 12px, 400 weight
Color: #D62828
Margin-top: 4px
```

### Chips/Tags

```
Background: Primary color with 20% opacity
Text Color: Darker shade of primary color
Font: Inter, 14px, 600 weight
Padding: 6px 12px
Border Radius: 16px
Border: None

Example (Outdoor Activity):
  Background: rgba(6, 174, 213, 0.2)
  Text: #06AED5
```

### Lists

#### List Item
```
Background: #FFFFFF
Padding: 16px
Border-bottom: 1px solid #EDF2F4

Hover (if interactive):
  Background: #F8F9FA
  Cursor: pointer

Active:
  Background: #EDF2F4
```

#### List with Icons
```
Icon Position: Left, centered vertically
Icon Size: 24px
Icon Margin-right: 16px
Content: Flex-grow to fill space
Arrow (if navigable): Right-aligned, 20px
```

---

## Icons & Imagery

### Icon Style

**Type:** Outlined/Stroke-based
- Stroke Width: 2px
- Corner Radius: Slightly rounded (2px)
- Style: Minimalist, geometric
- Recommended library: Lucide Icons, Feather Icons, or Heroicons (outline variant)

### Icon Sizes

```
Small:  16px × 16px - Inline with text
Medium: 24px × 24px - Standard UI icons
Large:  32px × 32px - Section icons, empty states
XLarge: 48px × 48px - Feature illustrations
```

### Icon Colors

- **Primary actions:** #386641 (Forest Green)
- **Secondary/neutral:** #2B2D42 (Charcoal)
- **Inactive/disabled:** #8D99AE (Slate Gray)
- **Decorative:** Match section primary color
- **On colored backgrounds:** #FFFFFF (Pure White)

### Icon Usage

- **Always center-align** icons with adjacent text
- **Maintain consistent sizing** within a component
- **Use spacing:** 8-12px gap between icon and text
- **Decorative icons:** Mark as aria-hidden for screen readers
- **Interactive icons:** Ensure 44×44px minimum touch target

### Imagery

**Photos:**
- Border Radius: 12px for thumbnails, 16px for large images
- Aspect Ratios: 16:9 for event photos, 1:1 for venue photos, 4:3 for activity images
- Treatment: Slight overlay (rgba(0,0,0,0.1)) on interactive images

**Illustrations:**
- Style: Playful, whimsical, but not overly childish
- Color Palette: Use primary colors from our palette
- Stroke: 2-3px, rounded caps
- Style Reference: Modern flat illustration with subtle textures

**Empty States:**
- Use XLarge icons (48px) or simple illustrations
- Muted colors (#8D99AE)
- Supportive, friendly copy

---

## Interaction Patterns

### Touch Targets

**Minimum Size:** 44px × 44px for all interactive elements
- Buttons, links, form inputs should meet this minimum
- If visual element is smaller, increase padding/margin to expand tap area

### Transitions & Animations

**Standard Transition:**
```css
transition: all 0.2s ease-in-out;
```

**Hover Effects:**
- Duration: 0.2s
- Property: background-color, box-shadow, transform
- Easing: ease-in-out

**Active/Pressed:**
- Scale: 0.95-0.98 for buttons
- Duration: 0.1s
- Immediate visual feedback

**Loading States:**
- Skeleton screens for content loading
- Color: #EDF2F4 with animated shimmer
- Duration: Subtle, continuous until loaded

**Page Transitions:**
- Slide: 300ms ease-in-out
- Fade: 200ms ease-in
- Avoid jarring or overly long animations

### Feedback

**Success:**
- Brief green checkmark animation
- Success message with #52B788 background
- Auto-dismiss after 3-4 seconds

**Error:**
- Red error icon
- Error message with #D62828 text
- Stays visible until user dismisses or corrects

**Loading:**
- Spinner or skeleton screen
- Color: #386641 for spinner
- Centered or inline depending on context

### Gestures (Mobile)

- **Swipe:** Common pattern for navigation between views
- **Pull to Refresh:** Standard pattern for content lists
- **Tap:** Primary interaction
- **Long Press:** Secondary actions, context menus

---

## Accessibility

### Color Contrast

All text must meet **WCAG AA standards** (minimum 4.5:1 for normal text, 3:1 for large text)

**Verified Combinations:**
- Charcoal (#2B2D42) on White (#FFFFFF): 12.4:1 ✓
- Charcoal (#2B2D42) on Off-White (#F8F9FA): 11.8:1 ✓
- Forest Green (#386641) on White (#FFFFFF): 5.1:1 ✓
- Slate Gray (#8D99AE) on White (#FFFFFF): 3.4:1 (Use only for large text or non-essential)

**For Primary Colors on White:**
- Test each combination when using colored text
- Add darker tints for text if needed
- Prefer colored backgrounds with dark text over colored text on white

### Text Sizing

- **Minimum body text:** 16px (1rem)
- **Allow text scaling:** Support up to 200% zoom
- **Relative units:** Use rem/em instead of fixed px when possible

### Focus States

**All interactive elements must have visible focus:**
```
outline: 2px solid #386641
outline-offset: 2px
border-radius: inherit
```

Never remove focus indicators - `outline: none` is prohibited unless replaced with custom visible alternative.

### Semantic HTML

- Use proper heading hierarchy (h1, h2, h3)
- Use `<button>` for buttons, not `<div>` with click handlers
- Use `<a>` for links, `<button>` for actions
- Use `<label>` for all form inputs
- Use ARIA labels when needed for screen readers

### Alternative Text

- All images must have descriptive alt text
- Decorative images: `alt=""` or `aria-hidden="true"`
- Icons conveying meaning: Include aria-label

### Keyboard Navigation

- **Tab order:** Logical flow through interactive elements
- **Enter/Space:** Activate buttons
- **Escape:** Close modals/overlays
- **Arrow keys:** Navigate lists when appropriate

---

## Design Principles

### 1. Whimsical Yet Purposeful

Every playful element should serve the user experience. Bright colors categorize content, rounded corners feel friendly, but the structure remains clean and navigable.

### 2. Bold but Not Overwhelming

Our 1960s Italian-inspired palette is vibrant, but we use it strategically. White space balances bold colors. Not every element needs color - restraint creates impact.

### 3. Mobile-First Clarity

Parents are often on-the-go. Large touch targets, readable text, clear hierarchy, and efficient navigation are non-negotiable.

### 4. Accessible to All

Design decisions must consider diverse abilities. Good contrast, scalable text, keyboard navigation, and semantic structure are requirements, not nice-to-haves.

### 5. Consistent Patterns

Once a user learns a pattern (e.g., circular green button = add action), we reinforce it throughout the app. Consistency reduces cognitive load.

### 6. Delight in Details

Small moments of personality - a friendly empty state message, a smooth animation, a perfectly paired color - accumulate into a memorable experience.

---

## Implementation Checklist

When implementing designs, verify:

- [ ] All text meets 4.5:1 contrast ratio
- [ ] Touch targets are minimum 44×44px
- [ ] Spacing follows 8px grid system
- [ ] Typography uses defined scale
- [ ] Interactive elements have hover/active/focus states
- [ ] Colors come from defined palette
- [ ] Border radius matches component specs
- [ ] Shadows match elevation system
- [ ] Icons are consistent size and style
- [ ] All images have alt text
- [ ] Forms have proper labels
- [ ] Keyboard navigation works
- [ ] Content is semantic HTML

---

## Quick Reference

### Most Common Patterns

**Primary Button:**
`bg: #386641, text: #FFFFFF, padding: 12px 24px, radius: 24px`

**Card:**
`bg: #FFFFFF, padding: 24px, radius: 16px, shadow: 0 2px 8px rgba(43,45,66,0.08)`

**Body Text:**
`font: Inter 16px, color: #2B2D42, line-height: 1.6`

**Heading:**
`font: Merriweather 24px Bold, color: #2B2D42, line-height: 1.3`

**Section Spacing:**
`32px between major sections`

**Card Spacing:**
`16px gap between cards`

---

**End of Style Guide**

*For questions or suggestions, please contact the design team.*
