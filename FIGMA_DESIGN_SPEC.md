# DramaVerse — Figma Design Specification
> Import this file into Figma as a reference. Use the token values to set up **Local Variables** and **Text Styles**.

---

## 1. HOW TO USE IN FIGMA

1. Create a new Figma file called **"DramaVerse Design System"**
2. Create **4 pages**: `🎨 Tokens`, `📐 Components`, `📱 Screens`, `📋 Specs`
3. Follow each section below to set up Local Variables, Text Styles, and frames

---

## 2. COLOR TOKENS — Local Variables

### Setup in Figma
> `Assets panel → Local Variables → + Collection → "DramaVerse/Colors"`

### 2.1 Core Colors

| Variable Name | Hex | Usage |
|---|---|---|
| `color/primary` | `#FF2D78` | Primary actions, neon pink |
| `color/primary-light` | `#FF6FA8` | Hover states |
| `color/primary-dark` | `#CC0055` | Pressed states |
| `color/accent` | `#BB3CFF` | Secondary accent, electric purple |
| `color/accent-light` | `#D580FF` | Light purple tints |
| `color/cyan` | `#00E5FF` | Tertiary highlight |
| `color/gold` | `#FFD600` | Coins, ratings |
| `color/gold-light` | `#FFEA00` | Gold highlights |

### 2.2 Background Colors

| Variable Name | Hex | Usage |
|---|---|---|
| `color/bg-deep` | `#0A0A0F` | Splash, darkest bg |
| `color/bg-dark` | `#0F0F1A` | Main scaffold bg |
| `color/bg-card` | `#161625` | Card surfaces |
| `color/bg-card-alt` | `#1E1E30` | Elevated cards |
| `color/bg-glass` | `#FFFFFF1A` | 10% white glass overlay |
| `color/bg-light` | `#F5F0FF` | Reader light mode |
| `color/bg-surface` | `#EDE9FF` | Reader light surface |
| `color/bg-sepia` | `#1A1410` | Reader sepia bg |

### 2.3 Text Colors

| Variable Name | Hex | Usage |
|---|---|---|
| `color/text-primary` | `#F0EEFF` | Main body text (dark mode) |
| `color/text-secondary` | `#AA9FC4` | Subtext, metadata |
| `color/text-hint` | `#6B618A` | Placeholders, disabled |
| `color/text-primary-light` | `#12101F` | Reader light mode text |
| `color/text-primary-sepia` | `#EAE0CC` | Reader sepia text |

### 2.4 Status Colors

| Variable Name | Hex | Usage |
|---|---|---|
| `color/success` | `#00E676` | Completed status |
| `color/warning` | `#FFAB00` | Hiatus status |
| `color/error` | `#FF1744` | Error, sign out |

---

## 3. GRADIENTS

Create these as **Styles → Gradient Fills** in Figma.

| Style Name | Type | Stop 1 | Stop 2 | Angle |
|---|---|---|---|---|
| `gradient/primary` | Linear | `#FF2D78` (0%) | `#BB3CFF` (100%) | 135° |
| `gradient/cyan` | Linear | `#00E5FF` (0%) | `#0066FF` (100%) | 135° |
| `gradient/gold` | Linear | `#FFD600` (0%) | `#FF9800` (100%) | 135° |
| `gradient/hero` | Linear | `#0A0A0F` (0%) | `#1A0A2E` (50%) | `#2D0F3D` (100%) | 180° |
| `gradient/dramatic` | Linear | `#1A0A2E` (0%) | `#3D0066` (50%) | `#660033` (100%) | 135° |
| `gradient/cover-overlay` | Linear | `transparent` (0%) | `#F5000000` (100%) | 180° |
| `gradient/card-glow` | Linear | `#FF2D7833` (0%) | `#BB3CFF33` (100%) | 135° |

### Neon Glow Effects
Create as **Styles → Effects**:

| Effect Name | Type | Color | Blur | Spread |
|---|---|---|---|---|
| `shadow/neon-pink` | Drop Shadow | `#FF2D7880` | 20 | 0 |
| `shadow/neon-purple` | Drop Shadow | `#BB3CFF73` | 20 | 0 |
| `shadow/neon-cyan` | Drop Shadow | `#00E5FF66` | 16 | 0 |
| `shadow/neon-pink-glow` | Drop Shadow | `#FF2D7880` | 18 | 1 |

---

## 4. TYPOGRAPHY — Text Styles

> `Assets panel → Text Styles → + → set font, size, weight, line height`

### 4.1 Display (Oswald font)

| Style Name | Font | Weight | Size | Letter Spacing | Line Height |
|---|---|---|---|---|---|
| `type/display-large` | Oswald | Bold (700) | 40 | 1.5 | 100% |
| `type/display-medium` | Oswald | Bold (700) | 30 | 1.0 | 105% |
| `type/display-small` | Oswald | SemiBold (600) | 24 | 0.8 | 110% |
| `type/section-title` | Oswald | SemiBold (600) | 18 | 1.2 | 110% |

### 4.2 Titles (Inter font)

| Style Name | Font | Weight | Size | Letter Spacing | Line Height |
|---|---|---|---|---|---|
| `type/title-large` | Inter | ExtraBold (800) | 20 | -0.3 | 120% |
| `type/title-medium` | Inter | Bold (700) | 16 | -0.2 | 130% |
| `type/title-small` | Inter | Bold (700) | 13 | -0.1 | 130% |

### 4.3 Body & Labels (Inter font)

| Style Name | Font | Weight | Size | Line Height |
|---|---|---|---|---|
| `type/body-large` | Inter | Regular (400) | 16 | 160% |
| `type/body-medium` | Inter | Regular (400) | 14 | 155% |
| `type/body-small` | Inter | Regular (400) | 12 | 150% |
| `type/label-large` | Inter | Bold (700) | 14 | 140% |
| `type/label-small` | Inter | Bold (700) | 10 | 140% |

### 4.4 Reader (Crimson Text font)

| Style Name | Font | Weight | Size | Line Height |
|---|---|---|---|---|
| `type/reader-body` | Crimson Text | Regular (400) | 18 (default) | 190% |
| `type/reader-chapter-title` | Oswald | Bold (700) | 24 | 110% |

---

## 5. SPACING & RADIUS — Design Tokens

| Token | Value | Usage |
|---|---|---|
| `spacing/xs` | 4px | Micro gaps |
| `spacing/sm` | 8px | Small padding |
| `spacing/md` | 12px | Medium padding |
| `spacing/lg` | 16px | Standard padding |
| `spacing/xl` | 20px | Large sections |
| `spacing/2xl` | 24px | Screen padding |
| `spacing/3xl` | 32px | Large sections |
| `radius/sm` | 8px | Small chips, badges |
| `radius/md` | 12px | Cards, inputs |
| `radius/lg` | 16px | Large cards |
| `radius/xl` | 20px | Featured cards |
| `radius/2xl` | 24px | Hero cards |
| `radius/pill` | 30px | Buttons, chips |
| `radius/full` | 9999px | Circles |

---

## 6. COMPONENT SPECS

### 6.1 Primary Gradient Button
```
Width: fill-container | Height: 52px
Background: gradient/primary
Border Radius: 14px
Effect: shadow/neon-pink-glow
Label: type/label-large, color: #FFFFFF, UPPERCASE

States:
  Default: opacity 100%, scale 1.0
  Pressed: scale 0.96 (100ms ease)
```

### 6.2 Bottom Navigation Bar
```
Background: color/bg-card, opacity 95%
Border top: 1px, color/bg-glass (7% white)
Height: 60px + safe-area-bottom
Item width: 1/4 of screen width

Active item:
  Icon: 22px, color/primary
  Background pill: 48×32px, gradient/card-glow, radius 12px
  Label: type/label-small, color/primary

Inactive item:
  Icon: 22px, color/text-hint
  Label: type/label-small, color/text-hint

Icons: Home (home_rounded), Discover (explore_rounded),
       Library (collections_bookmark_rounded), Profile (person_rounded)
```

### 6.3 Novel Card (Vertical)
```
Width: 120px | Aspect ratio: cover ~0.68 (height ~175px)
Border radius: 14px
Cover: CachedNetworkImage, BoxFit.cover

Hot badge (top-left):
  Label: "🔥", gradient/primary, radius 6px, padding 6×3px
  Effect: shadow/neon-pink

New badge (top-left):
  Label: "✨", gradient/cyan, radius 6px, padding 6×3px

Audio badge (bottom-right):
  Circle 22px, gradient/primary, icon: headphones 12px white

Title: type/title-small, color/text-primary, 2 lines max
Author: type/body-small, color/text-hint, 1 line max
```

### 6.4 Novel Card Wide
```
Height: 110px | Width: fill-container
Background: color/bg-card
Border: 1px, white 6% opacity
Border radius: 16px

Cover: 76×110px, left-aligned, radius 16 0 0 16
Info area: padding 12px all sides

Genre tag: color/primary 15% bg, color/primary 30% border, radius 4px
Title: type/title-small, 2 lines
Rating: ⭐ type/body-small, color/gold
Chapter count: type/body-small, color/text-hint
Status dot: 5px circle (green=DONE, cyan=LIVE, amber=PAUSE)
```

### 6.5 Featured Card (Carousel)
```
Height: screen-width × 0.62, clamp(220, 340)
Border radius: 24px
Cover: fill, BoxFit.cover

Active shadow: color/primary 30% opacity, blur 24, spread 2, offset 0 8
Scale: 1.0 (active), 0.95 (inactive), 300ms ease

Bottom overlay: gradient/cover-overlay (35%→100%)

Genre pill (bottom-left):
  Padding 10×4px, white 15% bg, white 25% border, radius 20px
  Type: type/label-small, white

Top badge (top-left): 
  HOT: gradient/primary, type/label-small, radius 8px
  NEW: gradient/cyan, type/label-small, radius 8px

Title: type/title-large, white, 2 lines max
Rating row: ⭐ icon 14px gold + type/body-small gold | dot | view count white54
```

### 6.6 Mini Player
```
Height: 62px
Background: color/bg-card-alt
Top border: 1px, color/primary 30% opacity
Bottom border: 1px, white 5% opacity

Cover: 62×62px, left edge
Neon left stripe: 3px width, gradient/primary

Title: type/title-small, 1 line
Status dot: 6px circle (color/primary when playing, with neon glow)
Chapter: type/body-small, color/text-secondary

Controls: replay_10 icon + play/pause circle (36px, gradient/primary, neon glow) + forward_10 icon
```

### 6.7 Section Label
```
Row with:
  - 3×16px bar, gradient/primary, radius 2px
  - 8px gap
  - type/section-title, UPPERCASE, color/text-primary
```

### 6.8 Genre Chip
```
Active:
  Background: gradient/primary, radius 30px
  Effect: shadow/neon-pink
  Label: type/label-large, white

Inactive:
  Background: color/bg-card, radius 30px
  Border: 1px, white 8% opacity
  Label: type/label-large, color/text-secondary
```

---

## 7. SCREEN SPECS

### 7.1 Splash Screen (390×844)
```
Background: color/bg-deep
Glow orbs (positioned):
  - Top-right: 280px circle, color/accent 18% radial
  - Bottom-left: 300px circle, color/primary 20% radial
  - Center: 180px circle, color/cyan 12% radial

Center column (vertically centered):
  Logo mark: 100px circle, gradient/primary, play icon 52px white
    Shadow: neon-pink pulsing (20→50px blur)
  App name: 28px gap below, type/display-large, white, UPPERCASE, ShaderMask
  Divider row: 24px line + tagline (type/label-small, text-secondary) + 24px line
    72px gap
  Loading dots: 3 circles 6px, gradient/primary, staggered pulse animation
```

### 7.2 Onboarding Screen (390×844)
```
Background: color/bg-deep + animated glow orb (color changes per page)

Per content page (left-aligned, horizontal padding 28px):
  Emoji + tag row: emoji 36px + bordered tag container (label-small, primary border)
  Title: type/display-large, ShaderMask (primary→accent gradient), UPPERCASE, multiline
  Subtitle: type/body-large, color/text-secondary
  Neon line: 60×3px, gradient/primary→accent, blur glow

Genre picker page:
  Title: type/display-medium, white, UPPERCASE, multiline
  Subtitle: type/body-medium, text-secondary
  Genre chips: Wrap layout, animated stagger entry

Bottom controls:
  Dot indicators: active = 24px wide pill + gradient/primary, inactive = 6px circle 15% white
  CTA button: gradient/primary full width, 56px, type/label-large white UPPERCASE
```

### 7.3 Home Screen (390×844)
```
Background: color/bg-dark
Scroll: CustomScrollView with SliverAppBar

AppBar (floating):
  Left: greeting body-small (secondary) + app name display-small ShaderMask
  Right: coin chip (bg-card, gold border) + VIP pill (gradient/primary, neon glow)

Featured section:
  Label: section-label component
  Carousel: PageView, viewportFraction 0.88, featured cards
  Dots: ExpandingDotsEffect, primary active, white 20% inactive

Shelf rows (horizontal scroll):
  Label row: section-label + "SEE ALL" label-small primary right
  Cards: NovelCard × N, height 200px, scroll horizontal

All Stories:
  Label: section-label
  List: NovelCardWide × N, padding 16px h
```

### 7.4 Novel Detail Screen (390×844)
```
Background: color/bg-dark
SliverAppBar expandedHeight: 220px, pinned

Hero cover:
  Full bleed image + gradient overlay (transparent→black 65%→bg-dark 100%)
  Genre pill: gradient/primary, bottom-left of hero
  Trending badge: gradient/primary + neon glow, top-right (conditional)
  Back button: 38px circle, black 50%, back arrow white (top-left)
  Bookmark button: 38px circle, black 50%, bookmark icon (top-right)

Pinned appbar: bg-dark, no elevation

Content (padding 20px h):
  Title: type/display-small, UPPERCASE
  Author: body-medium secondary
  Stats card (bg-card, radius 16, border white 6%):
    Row of 4: ⭐ Rating | 👁 Reads | 📖 Chapters | Status — separated by 1px dividers
    Each: emoji 16px + value title-small colored + label label-small hint

Action buttons row:
  READ button: gradient/primary, height 50, flex 2
  LISTEN button: bg-card, accent border, headphones icon (conditional)

Synopsis: section-label + animated expand/collapse text + gradient "READ MORE" link
Tags: Wrap of hashtag pills (bg-card, accent 30% border, accent-light text)

Chapter list:
  Section label + count badge
  Each tile: bg-card, radius 14, primary-tinted border (free) or subtle border (locked)
    Chapter number circle: 36px, gradient (free) or bg-card-alt (locked)
    Title: title-small | Duration: body-small hint
    Badge: FREE (gradient/cyan) or coin cost (bg-card-alt, gold border, 🪙 gold text)
```

### 7.5 Chapter Reader Screen (390×844)
```
Background: variable (bg-dark / bg-sepia / bg-light)

Fade-in Top Bar:
  Back button: 38×38px, white 8% bg, rounded 10
  Title + chapter progress: title-small + body-small hint
  Settings button: 38×38px, white 8% bg, tune icon

Reading content (padding: top=statusBar+80, h=24, bottom=safeArea+100):
  Chapter tag: gradient/primary, label-small white, radius 6px
  Chapter title: type/reader-chapter-title
  Neon divider: 60px line (primary) + ✦ ShaderMask + 60px line (accent)
  Body text: type/reader-body, variable color
  End ornament: ✦ ✦ ✦ ShaderMask centered
  Next chapter button: gradient/primary full width, radius 16, neon glow

Fade-in Bottom Bar:
  Progress bar: thin 3px, gradient/primary, neon glow
  Chapter x/total labels
  PREV / NEXT nav pills: gradient/primary, radius 20, label-small

Settings Sheet (bottom sheet, bg-card-alt):
  SIZE slider: SliderTheme primary
  SPACING pills: TIGHT / NORMAL / WIDE, active=gradient/primary
  THEME buttons: 🌙 DARK / 📜 SEPIA / ☀️ LIGHT, active=gradient/primary + neon glow
```

### 7.6 Audio Player Screen (390×844)
```
Background: color/bg-deep + blurred cover (opacity 15%) + bg-deep 85% overlay
Neon glow orbs: primary top-right, accent bottom-left

Top bar:
  Down chevron button: 40px circle, white 10% bg
  "NOW PLAYING" label-small centered, text-secondary
  More vert button: 40px circle, white 10% bg

Album art (center):
  ClipRRect radius 20px
  Playing: 260×260px | Paused: 240×240px (animated)
  Glow ring (playing): shadow/neon-pink 40px blur, shadow/neon-purple 60px

Track info:
  Title: type/title-large, UPPERCASE, centered
  Chapter: type/body-medium, text-secondary, centered

Progress bar:
  Track: 3px height, primary (active) / white 12% (inactive)
  Thumb: 6px circle, white
  Time labels: body-small, text-hint, both ends

Speed selector:
  "SPEED" label-small + 1.0x / 1.25x / 1.5x / 2.0x pills
  Active: gradient/primary, neon glow

Controls row:
  skip_previous (28px, text-secondary)
  replay_10 (32px, text-primary)
  Play/Pause button: 72×72px circle, gradient/primary, shadow/neon-pink-glow blur 24 spread 2
  forward_30 (32px, text-primary)
  skip_next (28px, text-secondary)
```

### 7.7 Library Screen (390×844)
```
Background: color/bg-dark

Header: "MY LIBRARY" display-small, padding 20px h

Tab bar:
  Container: bg-card, radius 22, border white 6%, height 44
  Active tab: gradient/primary, radius 22, neon glow, white text
  Inactive tab: text-hint
  Badges: white 25% bg circle, label-small white

Reading card (per item):
  bg-card, radius 16, border white 6%, height 115
  Cover: 80×115 left side
  Title: title-small | Chapter progress: body-small secondary
  Progress bar: 4px, gradient/primary + neon glow
  "X% read" body-small primary left | CONTINUE pill gradient/primary right

Bookmark grid:
  3 columns, 14px gap, aspect ratio 0.54
  Cover: ClipRRect radius 12, full height
  Title: body-small text-primary, 2 lines

Empty state:
  Large emoji + display-small + body-medium hint + gradient/primary pill button
```

### 7.8 Profile Screen (390×844)
```
Background: color/bg-dark

SliverAppBar expandedHeight: 200px:
  Background: gradient/dramatic + neon orb top-right
  Avatar: 76×76 circle, gradient/primary, display-small initial, neon glow
  VIP badge: 22px circle, gradient/gold, premium icon
  Name: title-large white | Email: body-small white 60%

Stats card (bg-card, radius 18, border white 6%):
  3 columns: 📖 Chapters | ⏱ Read Time | 🔖 Saved
  Each: icon 20px primary + title-large value + label-small hint
  Dividers: 1×40px, white 8%

VIP banner (gradient/primary or gold):
  Premium icon circle (white 20% bg) + title/subtitle + "GET VIP" pill (white 20%)

Menu sections (each in bg-card container, border white 6%, radius 16):
  Section label: 3px gradient bar + label-small hint uppercase
  Menu item: icon circle (36px, iconColor 12% bg) + body-large title + trailing + chevron
  Dividers: Padding-left 66, white 6% Divider
```

### 7.9 Locked Chapter Screen (390×844)
```
Background: cover image (15% opacity) + bg-dark 85% overlay

Back button: top-left, 40×40px, white 8% bg, rounded 10

Centered content:
  Lock icon: 80×80 circle, bg-card, primary border 1.5px, neon glow, lock icon primary 36px
  "CHAPTER X LOCKED": display-small centered
  Description: body-medium text-secondary, centered, h-padding 40px
  Coin balance: 🪙 emoji + title-small (gold if can afford, error if can't)

CTA buttons (v-stack, h-padding 32px):
  Unlock: gradient/primary, neon glow, label-large white
  OR Get Coins: gradient/gold, gold glow
  VIP option: bg-card, accent border, title in accent-light
```

---

## 8. SCREEN FLOW MAP

```
Splash (2.8s)
  └→ Onboarding (3 pages + genre picker)
       └→ Home
            ├→ Discover (search + genre filter)
            │    └→ Novel Detail
            ├→ Featured/Shelf card tap → Novel Detail
            │    ├→ Chapter Reader (free chapter)
            │    │    ├→ Locked Chapter Screen (if paid)
            │    │    │    ├→ Unlock (coin spend) → Chapter Reader
            │    │    │    ├→ → Wallet
            │    │    │    └→ → Subscription
            │    │    └→ Audio Player (listen button)
            │    └→ Audio Player (Listen button)
            │         └→ Mini Player (persistent)
            ├→ Library (reading history + bookmarks)
            ├→ Profile
            │    ├→ Wallet (coin balance + packages)
            │    └→ Subscription (VIP plans)
            └→ Auth (sign in / sign up)
```

---

## 9. ICONOGRAPHY

All icons use **Material Symbols Rounded** style.

| Screen | Icon | Usage |
|---|---|---|
| Home | `home_rounded` | Bottom nav |
| Discover | `explore_rounded` | Bottom nav |
| Library | `collections_bookmark_rounded` | Bottom nav |
| Profile | `person_rounded` | Bottom nav |
| Reader | `menu_book_rounded` | Read CTA |
| Audio | `headphones_rounded` | Listen CTA, mini player |
| Back | `arrow_back_ios_new_rounded` | Navigation |
| Bookmark | `bookmark_rounded` / `bookmark_outline_rounded` | Toggle |
| Settings | `tune_rounded` | Reader settings |
| Play | `play_arrow_rounded` | Audio player |
| Pause | `pause_rounded` | Audio player |
| Lock | `lock_rounded` | Paywall |
| Coin | `monetization_on_rounded` | Wallet |
| VIP | `workspace_premium` | Subscription |
| Star | `star_rounded` | Rating |
| Search | `search_rounded` | Search bar |

---

## 10. ANIMATION SPECS

| Animation | Type | Duration | Easing |
|---|---|---|---|
| Screen entry fadeIn | Fade | 300–500ms | easeOut |
| Button press | Scale 0.96 | 100ms | linear |
| Featured card scale | Scale 0.95→1.0 | 300ms | easeOut |
| Genre chip select | Background animate | 200ms | easeInOut |
| Logo pulse (splash) | BoxShadow blur | 1500ms | repeat(reverse) |
| Loading dots | Scale pulse | 600ms | easeInOut, stagger 150ms |
| Shelf item entry | FadeIn + SlideX | 300ms | delay i×60ms |
| UI show/hide (reader) | FadeTransition | 250ms | easeInOut |
| Album art glow (playing) | BoxShadow blur | 1800ms | repeat(reverse) |
| Album art size | AnimatedContainer | 400ms | easeOut |
| Onboarding glow orb | AnimatedContainer | 600ms | easeInOut |
| Chapter tile entry | FadeIn + SlideX | 250ms | delay i×30ms |

---

## 11. FIGMA FILE SETUP INSTRUCTIONS

### Step 1: Create the file
1. Open Figma → New File → Rename to `DramaVerse — Design System`

### Step 2: Install fonts
- Download from Google Fonts: **Oswald**, **Inter**, **Crimson Text**
- Install on your system before opening Figma

### Step 3: Set up Local Variables
1. `Cmd+L` → Variables → + Collection → Name it `Colors`
2. Add all tokens from Section 2 with Type: **Color**

### Step 4: Create Text Styles
1. For each entry in Section 4, create a frame with a text box
2. Set the font properties → right-click → `Create style`
3. Name with the path format: e.g., `Display/Large`

### Step 5: Create Effect Styles
1. Add a rectangle → add Drop Shadow with neon values from Section 3
2. Right-click the shadow → `Create style`

### Step 6: Build Components
For each component in Section 6:
1. Create a new frame with the exact dimensions
2. Use your Local Variables for all colors
3. Select the frame → `Cmd+Alt+K` to create a Component
4. Name using the path format: e.g., `Button/Primary Gradient`

### Step 7: Build Screen Frames
1. Create frames at **390×844** (iPhone 14 Pro size)
2. Use **Auto Layout** for all content areas
3. Apply `clip content` on all screen frames

### Step 8: Prototype
1. Switch to Prototype tab
2. Connect screens per the flow in Section 8
3. Set transitions: Smart Animate, 300ms, ease out

---

*Generated from DramaVerse Flutter source — v1.0.0*
