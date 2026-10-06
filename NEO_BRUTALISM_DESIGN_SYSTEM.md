# Neo-Brutalism UI/UX & Design System Specification
**Project:** Remember Me (Adaptive Personal Day Planner)  
**Style:** Neo-brutalism (Digital Punk, Pop Art Saturation, Sticker Tactility, Controlled Chaos)  
**Themes:** 2 Themes Only (Neo-Brutalist Light & Neo-Brutalist Dark)  
**Font:** Space Grotesk (Google Fonts, heavy weights: 700 & 900)  
**Logo:** The "Band-Aid Alarm" (Vibrant Alarm Clock with a Bandaid Patch, symbolizing healing schedules & fixing time)

---

## 1. Design Philosophy: The Digital Punk Rebellion

Neo-brutalism is raw, vibrant, and unapologetically visible. It rejects smooth corporate gradients, blurry drop shadows, and delicate low-contrast grays in favor of:

1. **Unapologetic Visibility:** Every element has visual presence enforced with **thick 3px to 4px pure black borders** (`#000000`).
2. **Hard Layered Ink Shadows:** Zero-blur, solid offset shadows (`4px`, `8px`, `12px` offsets at 45°).
3. **Digital Tactility (The Sticker Effect):** Containers, badges, and cards feel like physical stickers or printed cardstock slapped onto a canvas with slight rotations (`-1°`, `+1.5°`, `-2°`).
4. **Mechanical Interactivity:** Buttons **push down mechanically** (`translate(3px, 3px)` to collapse their shadow on press). Inputs snap into high-visibility yellow backgrounds when active.
5. **The Pop Palette:** Cream newsprint canvas (`#FFFDF5`), Hot Red (`#FF6B6B`), Vivid Yellow (`#FFD93D`), Soft Violet (`#C4B5FD`), and Pure Pitch Black (`#000000`).

---

## 2. Dual-Theme Design Tokens (Light & Dark)

| Token Key | Neo-Brutalist Light (Default) | Neo-Brutalist Dark (Deep Ink) | Usage & Application |
| :--- | :--- | :--- | :--- |
| **`canvasBackground`** | `#FFFDF5` (Warm Cream / Newsprint) | `#121212` (Stark Pitch Black) | Root scaffold background |
| **`surface`** | `#FFFFFF` (Stark White) | `#1E1E1E` (Dark Cardstock) | Card interiors, containers |
| **`foreground` / `textPrimary`**| `#000000` (Pure Black) | `#FFFDF5` (Warm Cream White) | Headings, heavy labels, body |
| **`textSecondary`** | `#444444` | `#CCCCCC` | Timestamps, secondary subtitles |
| **`accentRed`** | `#FF6B6B` (Hot Neon Red) | `#FF5252` (High Voltage Red) | Primary CTAs, urgent tasks, focus finish |
| **`accentYellow`** | `#FFD93D` (Vivid Highlighter Yellow) | `#FEE140` (Electric Yellow) | Secondary buttons, active capacity, alarms |
| **`accentViolet`** | `#C4B5FD` (Soft Pop Violet) | `#A78BFA` (Vibrant Lilac) | Routines, background cards, category tags |
| **`border`** | `#000000` (Pure Solid Black) | `#FFFDF5` or `#000000` (Stark Border) | Universal 3px/4px element outlines |
| **`borderMuted`** | `#D9D6C7` | `#333333` | Sub-dividers |
| **`hardShadow`** | `#000000` (Solid Ink Black) | `#000000` / `#FFFDF5` (Solid Hard Shadow) | Crisp zero-blur offset shadow |

---

## 3. Typography: `Space Grotesk`

We standardize strictly on **Space Grotesk** (Google Fonts).

- **Headlines / Display:** `FontWeight.w900` (Black), uppercase, tight tracking (`-0.5`).
- **Subheadings / Titles:** `FontWeight.w800` (ExtraBold), uppercase.
- **Buttons / Badges:** `FontWeight.w700` (Bold), uppercase, wide tracking (`+1.0`).
- **Body Text:** `FontWeight.w700` (Bold) or `w500` (Medium) for high readability.

---

## 4. Component Design Language

### 1. Neo-Brutalist Button (`NeoButton`)
- Thick `3.5px` solid black border.
- Solid `4px` or `6px` zero-blur offset shadow.
- **Physical Push Effect:** Translates `(3, 3)px` on press, instantly collapsing shadow to zero.

### 2. Neo-Brutalist Card (`NeoCard`)
- Stark white or pop-colored background (`#FFFFFF`, `#FFD93D`, `#C4B5FD`).
- `3.5px` solid black border with sharp `0px` corners.
- `8px` hard offset ink shadow.
- Optional slight rotation (`-1.0°` to `+1.5°`) to give a physical sticker/flyer feel.

### 3. Neo-Brutalist Badge & Stickers (`NeoBadge` / `NeoSticker`)
- Slapped-on sticker look with 2px/3px borders, hard shadows, and slight rotation.
- Pill shape (`999px`) or sharp block shape (`0px`).

### 4. Top App Bar & Brand Identity (`NeoAppBar`)
- Features the **Band-Aid Alarm** logo (Alarm clock with a colorful bandage).
- Bold uppercase `REMEMBER ME` headline with `MENU` pill button.

---

## 5. Architectural Alignment: UX First $\rightarrow$ Adaptive Intelligence Next

The 3-Tab Architecture remains identical:
- **`TODAY`**: Immediate action command center (NOW, NEXT, DAY CAPACITY).
- **`PLAN`**: Day/Week/Month time-blocking + Routines engine.
- **`INSIGHTS`**: Actionable behavioral metrics and Planning Accuracy (no gamified XP/levels).
- **`MENU`**: Clean slide-up modal for 2-theme toggle (Neo-Light & Neo-Dark) and privacy settings.
