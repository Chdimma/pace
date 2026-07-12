# Home Page Redesign — Dark Purple & Black Minimalist Layout

## 1. Color Palette

| Role | Hex | Usage |
|---|---|---|
| **Background (Primary)** | `#0D0D0D` | Full-screen base — near-black |
| **Surface / Cards** | `#1A1A2E` | Card containers — deep dark purple-black |
| **Surface Elevated** | `#232340` | Floating UI elements, elevated cards |
| **Accent Primary** | `#B388FF` | Icons, highlights, progress fill, active nav |
| **Accent Subtle** | `#7C4DFF` | Secondary highlights, borders |
| **Text Primary** | `#EDE7F6` | Headlines, bold labels |
| **Text Secondary** | `#B39DDB` | Body text, labels, metrics |
| **Text Muted** | `#6A5ACD` | Watermark, unobtrusive info |
| **Status Green** | `#00E676` | Connected / online indicator |
| **Status Red** | `#FF5252` | Disconnected / alert indicator |
| **Divider / Stroke** | `#2D2D44` | Thin separators, ring backgrounds |

## 2. Typography

- **Font:** System default (SF Pro on iOS, Roboto on Android) — Google Fonts Poppins removed for cleaner, more mature typography.
- **Weight usage:**
  - Greeting (username): `wght 300` (Light), 28px
  - Section headers: `wght 600` (Semibold), 11px, ALL CAPS, 1.8 letter-spacing
  - Primary metrics (score, streak): `wght 700` (Bold), 32px
  - Body / secondary text: `wght 400` (Regular), 14px
  - Micro labels: `wght 500` (Medium), 12px

## 3. Layout Structure (Vertical Scroll)

```
┌──────────────────────────────────────┐  ← SafeArea top: 8px
│                                        │
│  ┌──────────────────────────────────┐  │  Section 1: HEADER (no padding-left shift)
│  │  "Kim"                🔔•        │  │  Left: Light weight greeting
│  │  (12px above status)             │  │  Right: Notification bell + dot
│  └──────────────────────────────────┘  │
│                                        │
│  ┌── ● Online ──────────────────────┐  │  Section 2: STATUS PILL
│  │  Connection status: Online       │  │  Dark surface pill, thin border
│  └──────────────────────────────────┘  │  Small dot indicator (green/red)
│                                        │
│  ┌──────────────────────────────────┐  │  Section 3: POSTURE SCORE RING
│  │                                  │  │  Large centered ring (160px)
│  │          ╭───────╮              │  │  Thick stroke (14px)
│  │          │  85%  │              │  │  Value in center: bold white
│  │          ╰───────╯              │  │  Label below: "POSTURE SCORE"
│  │                                  │  │  11px caps, letter-spaced
│  │     POSTURE SCORE                │  │
│  └──────────────────────────────────┘  │
│                                        │
│  ┌────────────┬──────────────┐        │  Section 4: METRIC ROW (2 columns)
│  │  STREAK    │  NEXT        │        │
│  │  3 days    │  19min 20s   │        │  Each: dark elevated surface
│  │            │  STRETCH     │        │  Top label: 11px caps
│  └────────────┴──────────────┘        │  Metric value: 32px bold
│                                        │
│  ┌──────────────────────────────────┐  │  Section 5: INSIGHT CARD
│  │  TODAY'S INSIGHT                 │  │  Thin left accent border (#B388FF)
│  │  ┃ Remember the 20-20-20...     │  │  Text: secondary purple
│  │  ┃                              │  │  3px left bar in accent color
│  └──────────────────────────────────┘  │
│                                        │
│  ┌──────────────────────────────────┐  │  Section 6: ACTIVITY SPARKLINE
│  │  THIS WEEK                       │  │  Simple bar chart (drawn via CustomPaint)
│  │  ▁▃▂▅▄▇▆                        │  │  Bars: accent purple on transparent bg
│  │  Good Posture Minutes            │  │  Subtle, no gridlines
│  └──────────────────────────────────┘  │
│                                        │
│  ┌──────────────────────────────────┐  │  Section 7: BOTTOM NAV (overlay)
│  │  ○  ○  ○  ○  ○                  │  │  5 icons, flush with bottom edge
│  │  (Home active)                   │  │  Active icon: accent-purple filled
│  └──────────────────────────────────┘  │  Inactive: text-muted outlined
│                                        │
└──────────────────────────────────────┘  ← Bottom: 16px + nav height
```

## 4. Section-by-Section Specification

### 4.1 Header
- **Height:** ~80px
- **Layout:** Row, cross-axis centered
- **Left:** Greeting text "Kim" — font size 28px, `wght 300`, text-primary (#EDE7F6)
  - No "Welcome back," prefix — too chatty. Just the name.
- **Right:** Notification icon (Icons.notifications_outlined) — color: text-secondary (#B39DDB), 24px
  - Unread dot: 8px circle, position top-right offset (3,3), color: status-red (#FF5252)
- **Bottom padding:** 20px spacer before next section

### 4.2 Connection Status Pill
- **Height:** 32px
- **Layout:** Center-aligned row, horizontal padding 14px
- **Background:** Surface (#1A1A2E) with 1px border (#2D2D44), radius: 100px (fully pill)
- **Dot:** 8px circle, gap 8px from start
  - Connected: #00E676
  - Disconnected: #FF5252
- **Text:** "Online" / "Offline" — 13px, `wght 500`, text-secondary
- **Horizontal margin:** None (full width minus side padding)
- **Bottom padding:** 28px

### 4.3 Posture Score Ring (Hero Card)
- **Height:** ~280px
- **Background:** Surface (#1A1A2E), radius: 20px
- **Inner padding:** 32px top/bottom, 24px sides
- **Layout:** Column, center-aligned
- **Ring:** SizedBox 160x160
  - CircularProgressIndicator (determinate)
  - strokeWidth: 14px
  - backgroundColor: #2D2D44
  - valueColor: #B388FF
  - value: postureScore / 100
- **Overlay on ring** (Stack, center):
  - Percentage text: 36px, `wght 700`, text-primary
- **Below ring (16px gap):**
  - Label: "POSTURE SCORE" — 11px, `wght 600`, letter-spacing 2.0, text-muted
- **Bottom padding:** 20px

### 4.4 Metric Row (Streak + Next Stretch)
- **Layout:** Row, 2 equal columns, 12px gap
- **Each card:**
  - Background: Surface Elevated (#232340), radius: 16px
  - Padding: 20px
  - Height: 110px
- **Left card (Streak):**
  - Top label: "STREAK" — 11px caps, text-muted
  - Value: "3 days" — 28px, `wght 700`, text-primary
- **Right card (Next Stretch):**
  - Top label: "NEXT STRETCH" — 11px caps, text-muted
  - Value: "19min 20s" — 28px, `wght 700`, text-primary
  - Color shifts to `#00E676` when timer reaches "Ready!" (positive green)
- **Bottom padding:** 20px

### 4.5 Insight Card
- **Height:** ~100px (dynamic based on text)
- **Background:** Surface (#1A1A2E), radius: 16px
- **Inner padding:** 16px
- **Layout:** Row
  - **Left accent bar:** Container 3px wide, height: 100%, radius: 2px, color: #B388FF
  - **Content (16px gap from bar):** Column, cross-axis start
    - Header: "TODAY'S INSIGHT" — 11px caps, `wght 600`, letter-spacing 1.5, text-muted
    - Body (8px gap): Text — 14px, `wght 400`, text-secondary, height 1.6
- **Bottom padding:** 20px

### 4.6 Activity Sparkline
- **Height:** ~130px
- **Background:** Surface (#1A1A2E), radius: 16px
- **Inner padding:** 16px 20px
- **Layout:** Column, cross-axis start
- **Header:** "THIS WEEK" — 11px caps, `wght 600`, letter-spacing 1.5, text-muted
- **Chart area (12px gap):** SizedBox height: 60px, width: fill
  - CustomPaint that draws simple vertical bars from `getGoodHistoryFor("Weekly")`
  - Bar width: 8px, spacing: auto-distributed
  - Bar color: #B388FF at 80% opacity
  - No axis labels, no grid — minimalist
- **Label below chart (8px gap):** "Good Posture Minutes" — 11px, text-muted, center-aligned
- **Bottom padding:** 16px

### 4.7 Bottom Navigation Bar
- **Height:** 72px (including bottom safe area padding)
- **Background:** #0D0D0D (matches page background — flush, not a floating bar)
- **Top border:** 0.5px divider line (#2D2D44) — subtle separation
- **Layout:** Row, space-evenly
- **5 icons** (24px size):
  - home, activity (star), schedule (access_time), exercise (directions_run), settings
- **Active state (home):** Icon filled (Icons.home), color: #B388FF
- **Inactive state:** Icon outlined, color: #4A4A6A
- **No labels beneath icons** — reduces visual noise
- **No background container** — just icons on the dark page canvas

## 5. Spacing Rhythm

- Page horizontal padding: 20px
- Between sections: 20px (consistent, creates rhythm)
- Card internal padding: 20–24px
- All radius values: 16px (cards), 100px (pills), 8px (small elements)

## 6. Micro-Interactions / Animations (Optional)

- Posture ring: Animates to new value on state change (1s ease-out)
- Streak/stretch numbers: fade-in on update (300ms)
- Bottom nav icon transition: scale 1.0 → 1.1 on tap

## 7. Code Architecture Recommendations

1. Extract card sections into separate StatelessWidget components:
   - `PostureScoreCard` — ring + percentage
   - `MetricTile` — reusable small card (streak, stretch)
   - `InsightCard` — accent bar + text
   - `ActivityChart` — sparkline with CustomPaint
   - `StatusPill` — connection indicator
   - `AppBottomNav` — clean navigation bar

2. Google Fonts Poppins should be removed entirely — use system fonts for a more mature, native feel.

3. The `bottomNavigationBar` should be replaced with a custom bottom bar that sits flush against the bottom, sharing the page background color rather than a white container.

## 8. Visual Mood Board Summary

```
Minimalist · Dark · High-end wellness app aesthetic

Texture:     Matte black surfaces, subtle depth from dark elevations
Lighting:    Accent purple glows on key metrics (score ring)
Tone:        Quiet, confident, clinical elegance
Comparable:  Oura Ring, Headspace (dark mode), Linear, Bear (dark)