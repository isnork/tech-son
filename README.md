# Am I Being Scammed?

A Rails 8 application for checking and analyzing potential scams and phishing attempts.

## Design Guidelines for AI Development

When making changes to this application, please follow these design guidelines:

### 🎨 Design System

**Framework**: Use Tailwind CSS for all styling
- All components should use Tailwind utility classes
- No custom CSS unless absolutely necessary
- Follow Tailwind's responsive design patterns

**Color Palette**: 
- Primary Color: `#3423A6` (Deep Purple)
- Use this color for:
  - Primary buttons and CTAs
  - Headers and important text
  - Borders and accents
  - Hover states

**Design Philosophy**:
- Keep it simple and clean
- Don't implement anything "crazy" or out of the box
- Focus on usability and accessibility
- Maintain consistency across all pages
- Use standard UI patterns that users expect

### 🛠 Technical Guidelines

**Styling Approach**:
- Use Tailwind's built-in color system with `#3423A6` as the primary color
- Leverage Tailwind's spacing, typography, and layout utilities
- Keep components responsive and mobile-first
- Use semantic HTML with appropriate Tailwind classes

**Component Examples**:
```html
<!-- Primary button with brand color -->
<button class="bg-[#3423A6] hover:bg-[#2a1c85] text-white px-4 py-2 rounded-lg transition-colors">
  Submit
</button>

<!-- Card with brand accent -->
<div class="border border-[#3423A6]/20 bg-white rounded-lg p-6 shadow-lg">
  <!-- Content -->
</div>
```

### 🚀 Getting Started

* Ruby version: 3.3.8 (for Heroku compatibility)
* Rails version: 8.0.2
* Database: SQLite (development), PostgreSQL (production)

### Setup

1. Clone the repository
2. Run `bundle install`
3. Run `bin/rails db:create db:migrate`
4. Run `bin/rails server`
5. Run `bin/rails tailwindcss:watch` (in another terminal)

### Deployment

The app is deployed on Heroku and automatically syncs with the main branch.
