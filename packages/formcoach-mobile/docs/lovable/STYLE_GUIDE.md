# FormCoach - Style Guide

## 🔄 Centralized Styling System

FormCoach uses a centralized styling system based on CSS variables, utility classes, and styled components. This approach allows for consistent styling across the application and makes it easy to update the design system in one place.

### CSS Variables

All colors, typography, spacing, and border radius values are defined as CSS variables in `src/styles/theme.css`. This makes it easy to update the design system in one place and have the changes propagate throughout the application.

```css
:root {
  /* Color tokens */
  --fc-color-bg-app: #020D0C;
  --fc-color-bg-card: #1C1C1E;
  --fc-color-bg-highlight: rgba(176, 232, 227, 0.12);
  --fc-color-bg-hover: #2D2D2F;

  --fc-color-text-primary: #A4B1B7;
  --fc-color-text-accent: #00C4B4;

  --fc-color-border-default: #2C2C2E;
  --fc-color-border-focus: #00C4B4;

  /* Status colors */
  --fc-color-status-success: #4ADE80;
  --fc-color-status-warning: #FACC15;
  --fc-color-status-alert: #FB923C;
  --fc-color-status-error: #F87171;

  /* Typography */
  --fc-font-size-heading: 32px;
  --fc-font-size-subheading: 20px;
  --fc-font-size-body: 16px;
  --fc-font-size-small: 14px;
  --fc-font-size-xs: 12px;

  /* ... other variables ... */
}
```

### Theme Support

FormCoach supports multiple themes through the `data-theme` attribute. The default theme is `dark`, but `light` and `high-contrast` themes are also available.

```jsx
// To switch themes
import { useTheme } from '@/contexts/ThemeContext';

const MyComponent = () => {
  const { theme, setTheme } = useTheme();

  return (
    <button onClick={() => setTheme('light')}>
      Switch to Light Mode
    </button>
  );
};
```

## 🎨 Color Palette

### Primary Colors
- **Background (Dark)**: `var(--fc-color-bg-app)` - Main app background
- **Primary Accent**: `var(--fc-color-text-accent)` - Main brand color for buttons, highlights, icons
- **Text Primary**: `var(--fc-color-text-primary)` - Main text color for headings and body text
- **Card Background**: `var(--fc-color-bg-card)` - Container backgrounds
- **Border Color**: `var(--fc-color-border-default)` - Border color for cards, inputs, and other elements
- **Hover State**: `var(--fc-color-bg-hover)` - Hover state for interactive elements

### Status Colors
- **Success**: `var(--fc-color-status-success)` - Positive indicators
- **Warning**: `var(--fc-color-status-warning)` - Cautionary indicators
- **Alert**: `var(--fc-color-status-alert)` - Attention indicators
- **Error**: `var(--fc-color-status-error)` - Error indicators

### Transparent Overlays
- **Card Overlay**: `var(--fc-color-bg-highlight)` with lower opacity - Subtle highlight for cards
- **Background Overlay**: `var(--fc-color-bg-highlight)` - For modal backgrounds and feature highlights

## 📝 Typography

### Font Families
- **Primary**: `var(--fc-font-family-sans)` - 'Inter', sans-serif

### Font Sizes
- **Heading**: `var(--fc-font-size-heading)` - 32px
- **Subheading**: `var(--fc-font-size-subheading)` - 20px
- **Body**: `var(--fc-font-size-body)` - 16px
- **Small**: `var(--fc-font-size-small)` - 14px
- **Extra Small**: `var(--fc-font-size-xs)` - 12px

### Font Weights
- **Regular**: `var(--fc-font-weight-regular)` - 400
- **Medium**: `var(--fc-font-weight-medium)` - 500
- **Semibold**: `var(--fc-font-weight-semibold)` - 600
- **Bold**: `var(--fc-font-weight-bold)` - 700

### Typography Utility Classes
- **Heading (H1)**: `fc-heading` - Main page headings
- **Subheading (H2)**: `fc-subheading` - Section headings
- **Body Text**: `fc-text` - Regular body text
- **Small Text**: `fc-text-small` - Labels, captions, etc.

## 🧩 Components

FormCoach provides a set of styled components that use the centralized styling system. These components are available in `src/components/ui/styled/`.

### Importing Styled Components

```jsx
import { Heading, Text, Button, Card, FormField, IconWrapper } from '@/components/ui/styled';
```

### Utility Classes vs. Styled Components

You can use either utility classes or styled components depending on your needs:

1. **Utility Classes**: Use when you need more flexibility or for one-off styling
2. **Styled Components**: Use for consistent, reusable UI elements

### Buttons

#### Using the Button Component
```jsx
// Primary Button (default)
<Button>Primary Button</Button>

// Secondary Button
<Button variant="secondary">Secondary Button</Button>

// Text Button
<Button variant="text">Text Button</Button>

// Loading State
<Button isLoading={true}>Loading Button</Button>

// Disabled State
<Button disabled>Disabled Button</Button>
```

#### Using Utility Classes
```jsx
<button className="fc-button-primary">
  Primary Button
</button>

<button className="fc-button-secondary">
  Secondary Button
</button>
```

### Typography

#### Using Typography Components
```jsx
// Main Heading (H1)
<Heading>Main Heading</Heading>

// Subheading (H2)
<Heading level={2}>Subheading</Heading>

// Body Text
<Text>This is regular body text.</Text>

// Small Text
<Text size="small">This is smaller text for labels or captions.</Text>

// Text as different element
<Text as="span">This renders as a span element.</Text>
```

#### Using Utility Classes
```jsx
<h1 className="fc-heading">Main Heading</h1>
<h2 className="fc-subheading">Subheading</h2>
<p className="fc-text">Body text</p>
<span className="fc-text-small">Small text</span>
```

### Cards

#### Using the Card Component
```jsx
// Standard Card
<Card>
  <Heading level={2}>Card Title</Heading>
  <Text>Card content goes here.</Text>
</Card>

// Highlighted Card
<Card highlight>
  <Heading level={2}>Highlighted Card</Heading>
  <Text>This card has a highlight background.</Text>
</Card>

// Card with Hover Effect
<Card hover>
  <Text>This card has a hover effect.</Text>
</Card>
```

#### Using Utility Classes
```jsx
<div className="fc-card">
  <h2 className="fc-subheading">Card Title</h2>
  <p className="fc-text">Card content</p>
</div>

<div className="fc-highlight-card">
  <h2 className="fc-subheading">Highlighted Card</h2>
  <p className="fc-text">Highlighted content</p>
</div>
```

### Form Elements

#### Using the FormField Component
```jsx
<FormField label="Username" error={errors.username}>
  <input className="fc-input" />
</FormField>
```

#### Using Utility Classes
```jsx
<div className="space-y-1">
  <label className="fc-input-label">Username</label>
  <input className="fc-input" />
  {error && (
    <div className="fc-form-error">
      <AlertCircle size={14} />
      <span>{error}</span>
    </div>
  )}
</div>
```

### Icons

#### Using the IconWrapper Component
```jsx
<IconWrapper icon={CalendarIcon} size={24} />
```

#### Using Utility Classes
```jsx
<CalendarIcon size={24} className="fc-icon" />
```

## 🎭 UI Patterns

### Information Display
```jsx
<div className="flex items-center">
  <Scale size={20} className="text-[#00C4B4] mr-3" />
  <span className="text-[#A4B1B7]">Weight:</span>
  <span className="ml-2 text-[#A4B1B7]">180 lbs</span>
</div>
```

### Navigation
- Bottom tabs for mobile-first navigation
- Back buttons in top left for nested screens
- Progress indicators for multi-step flows

### Animations
- Fade In: `animate-fade-in` - Smooth entrance animations
- Accordion: `animate-accordion-down` - For expanding content
- Transitions: 0.2s-0.5s ease-out for most UI transitions

## 📱 Common Screen Patterns

### Welcome Screen
- Use large heading with `text-[32px] font-bold text-[#A4B1B7]`
- Include descriptive text with `text-[16px] font-normal text-[#A4B1B7]`
- Use highlighted card with `rgba(176,232,227,0.12)` background for feature lists
- Feature list items should use bullet points with teal color `text-[#00C4B4]`
- Primary action button at the bottom

Example:
```jsx
<div className="flex flex-col items-center justify-center min-h-[80vh] font-inter">
  <div className="mb-10">
    <h1 className="font-bold text-[32px] text-center text-[#A4B1B7]">
      Welcome to FormCoach
    </h1>
    <p className="font-normal text-[16px] text-[#A4B1B7] text-center mt-4 mb-8">
      Your personalized AI fitness coach for better form, 
      safer workouts, and meaningful progress
    </p>

    <div className="rounded-lg p-6 mb-8" style={{ backgroundColor: "rgba(176, 232, 227, 0.12)" }}>
      <h2 className="font-semibold text-[20px] text-[#A4B1B7] mb-4">
        FormCoach helps you:
      </h2>

      <ul className="space-y-3">
        <li className="flex items-start">
          <span className="text-[#00C4B4] mr-2">•</span>
          <span className="font-normal text-[14px] text-[#A4B1B7]">
            Feature description
          </span>
        </li>
        <!-- More list items -->
      </ul>
    </div>
  </div>

  <div className="w-full">
    <PrimaryButton onClick={() => navigate('/next-page')}>
      Let's Get Started
    </PrimaryButton>
  </div>
</div>
```

### Form Input Screens (e.g., Birthdate Selection)
- Use icon + heading pattern with teal icon and text heading
- Center align content
- Use appropriate form components with consistent styling
- Error messages should use `text-red-400`

Example:
```jsx
<div className="space-y-6 animate-fade-in">
  <div className="flex items-center justify-center mb-2">
    <Icon size={28} className="text-[#00C4B4] mr-3"/>
    <h1 className="font-bold text-[32px] text-center text-[#A4B1B7]">
      Form Input Heading
    </h1>
  </div>

  <div className="flex flex-col items-center justify-center mt-8 mb-4">
    <!-- Form components with consistent styling -->

    {error && <p className="text-red-400 text-sm mt-2">{error}</p>}
  </div>
</div>
```

## 🚀 Best Practices

### General Guidelines

- **Use Styled Components**: Prefer styled components over direct CSS classes for consistent UI
- **CSS Variables**: Always use CSS variables instead of hardcoded values
- **Theme Support**: Ensure your components work with all themes by using CSS variables
- **Responsive Design**: Use responsive values and test on multiple screen sizes

### Component Usage

- **Typography**: Use `<Heading>` and `<Text>` components for text elements
- **Buttons**: Use the `<Button>` component with appropriate variants
- **Cards**: Use the `<Card>` component for content containers
- **Forms**: Use `<FormField>` for form elements with labels and error handling
- **Icons**: Use `<IconWrapper>` for consistent icon styling

### CSS Class Usage

- **Utility Classes**: Use the `fc-*` utility classes for consistent styling
- **Text Color**: Use `text-[var(--fc-color-text-primary)]` or the `fc-text` class
- **Background Colors**: Use `bg-[var(--fc-color-bg-app)]` for page backgrounds and `bg-[var(--fc-color-bg-card)]` for cards
- **Borders**: Use `border-[var(--fc-color-border-default)]` for all borders
- **Icons**: Use `text-[var(--fc-color-text-accent)]` or the `fc-icon` class for icons
- **Spacing**: Use CSS variables for spacing (`var(--fc-spacing-md)`) or Tailwind's spacing utilities

### Migration Guide

When updating existing components:

1. Replace hardcoded color values with CSS variables
2. Replace direct styling with utility classes where possible
3. Consider refactoring to use styled components for complex UI elements
4. Test in all supported themes (dark, light, high-contrast)

Last updated: May 20, 2025
