# Colour Scheme

### 🎨 Neubrutalist Color Scheme Framework
Here’s a structure for your UI’s visual identity:

#### 💡 Base Principles
- **High contrast** between foreground and background for legibility
- **Flat, vibrant colors** with minimal gradients or soft shadows
- **Thick borders**, gridlines, and typography with visual weight
- **Accessible by design**, hitting WCAG AA/AAA contrast standards

#### 🌓 Light & Dark Mode Palette
Here’s a suggested dual-mode palette to toggle between:

| Element              | Light Mode                     | Dark Mode                      | Accessibility Note                     |
|----------------------|--------------------------------|--------------------------------|----------------------------------------|
| Background           | #FFFDF9 (Warm white)           | #1A1A1A (Charcoal black)       | Good contrast for content zones        |
| Primary Accent       | #FF4B3E (Punchy red-orange)    | #FF4B3E                         | Stays consistent for brand identity    |
| Secondary Accent     | #F7B32B (Golden yellow)        | #F7B32B                         | Bright highlight, avoid large fields   |
| Stroke / Borders     | #1A1A1A                        | #F7F7F7                         | Reversed tone in each mode             |
| Text (Primary)       | #1A1A1A                        | #FFFFFF                        | WCAG AA/AAA compliant                  |
| Text (Muted)         | #6B6B6B                        | #AFAFAF                        | For sublabels and placeholders         |
| Success              | #00B894 (Emerald green)        | #00B894                        | Good for tracking completion           |
| Warning              | #FABE28                        | #FABE28                        | For alerts or overtime indicators      |

You can extend this with hover states using desaturated versions or slight brightness shifts.

### 🔄 Toggling Mode
Use a toggle switch with clear contrast—a brutalist “checkbox” style could look fantastic here. Make sure to:
- Store theme preference in `localStorage` or a user profile
- Use CSS variables for easy theme switching
- Animate transitions minimally (e.g., `opacity` or `filter`) if needed

### ⚡ Typography & Layout Suggestions
- Go bold: fonts like **Space Grotesk**, **Inter**, or even **IBM Plex Sans**
- Spacing: stick to a rigid grid—4px or 8px rhythm
- Hover & focus states: use thick outlines with accessible focus rings