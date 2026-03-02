# DramaVerse Design System Builder — Figma Plugin

This plugin builds the entire DramaVerse design system inside Figma in one click.

## What it creates

| Asset | Count |
|---|---|
| Color Styles | 18 (primary, accent, bg, text, status) |
| Effect Styles | 5 neon glow shadows |
| Text Styles | 12 (Oswald display + Inter UI) |
| Components | 8 (buttons, cards, nav, mini player, chips) |
| Screen Frames | 7 (Splash, Home, Novel Detail, Reader, Audio, Library, Locked) |
| Spec Tables | 6 (dimensions, spacing, radius, heights, animations, fonts) |

## How to install in Figma

### Option A — Load as Development Plugin (recommended)

1. Open Figma Desktop app
2. Go to **Plugins → Development → Import plugin from manifest...**
3. Navigate to this folder and select `manifest.json`
4. The plugin will appear under **Plugins → Development → DramaVerse Design System Builder**

### Option B — From the Figma Community (if published)

Search "DramaVerse Design System Builder" in the Figma Community.

## How to run

1. Open a **new blank Figma file**
2. Go to **Plugins → Development → DramaVerse Design System Builder**
3. Click **"BUILD DESIGN SYSTEM"**
4. Wait ~10–20 seconds for all assets to be generated
5. Navigate the pages:
   - 🚀 **Start Here** — Welcome screen
   - 🎨 **Tokens** — Color swatches + gradients
   - 📐 **Components** — All UI components
   - 📱 **Screens** — 7 key app screens
   - 📋 **Specs** — Design spec tables

## Prerequisites

- Figma Desktop app (plugin won't run in browser Figma)
- For best results, install these fonts on your system first:
  - [Oswald](https://fonts.google.com/specimen/Oswald)
  - [Inter](https://fonts.google.com/specimen/Inter)
  - If not installed, the plugin automatically falls back to Roboto

## Files

```
figma_plugin/
├── manifest.json   # Plugin metadata
├── code.js         # Plugin logic (creates all Figma nodes)
├── ui.html         # Plugin UI panel
└── README.md       # This file
```
