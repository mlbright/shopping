# Shopping Lists - Multi-tenant Rails Application

A Google Keep-inspired shopping list application built with Ruby on Rails 8.1.1, featuring real-time collaboration, household-based multi-tenancy, and a responsive Tailwind CSS interface.

## Features

- **Multi-tenant Architecture**: Association-based scoping with households and memberships
- **Real-time Collaboration**: Action Cable with Solid Cable for live updates when multiple users edit the same list
- **Google Keep-style UI**: Responsive card-based layout with hover actions and bottom expandable input
- **Item States**: Active, completed (with strikethrough), and deferred (with visual indicator)
- **List Operations**: Clone lists (all items or deferred only), merge lists (keeping duplicates)
- **Drag-and-drop**: Reorder items with explicit position column (last-write-wins)
- **Authentication**: Custom has_secure_password implementation without Devise
- **Auto-created Households**: Each user gets a "Personal" household on signup

## Technology Stack

- **Ruby**: 3.4.7
- **Rails**: 8.1.1
- **Database**: SQLite3 with multi-database production setup (primary, cache, queue, cable)
- **Frontend**: Hotwire (Turbo + Stimulus), Tailwind CSS
- **Background Jobs**: Solid Queue
- **Caching**: Solid Cache  
- **WebSocket**: Solid Cable (Action Cable)
- **Deployment**: Kamal, Docker

## Setup

### Prerequisites

- Ruby 3.4.7
- Node.js (for asset compilation)
- SQLite3

### Installation

```bash
# Clone the repository
cd /home/mbright/shopping

# Install dependencies
bundle install

# Setup database
bin/rails db:create db:migrate

# Optional: Seed with sample data
bin/rails db:seed

# Start the development server (includes Tailwind CSS compilation)
bin/dev
```

The application will be available at `http://localhost:3000`

## Usage

### Getting Started

1. **Sign up**: Create an account at `/signup`
2. **Personal Household**: A "Personal" household is automatically created for you
3. **Create Lists**: Click "New List" on the dashboard
4. **Add Items**: Use the bottom expandable input (Google Keep style) to add items
5. **Complete/Defer**: Check the checkbox to complete items, or click "Defer" to mark for later
6. **Drag to Reorder**: Use the drag handle on the right to reorder items
7. **Share Lists**: Invite others to your household to collaborate on shared lists
8. **Real-time Updates**: Changes appear instantly for all users viewing the same list

### List Operations

- **Clone**: Create a copy with all items or only deferred items
- **Merge**: Combine two lists (keeps all items including duplicates)
- **Share**: Add/remove household members to control list access

## Architecture

### Models

- **User**: Authentication with has_secure_password, auto-creates personal household
- **Household**: Container for users and lists, association-based multi-tenancy
- **HouseholdMembership**: Join table (user/household) with roles (owner/member)
- **ShoppingList**: Belongs to household and creator, has many items
- **ShoppingItem**: Name, state enum (active/completed/deferred), position integer

### Controllers

- **ApplicationController**: Authentication helpers (current_user, require_login)
- **SessionsController**: Login/logout
- **UsersController**: Registration
- **ShoppingListsController**: CRUD + clone/merge with association-based scoping
- **ShoppingItemsController**: CRUD + toggle_completed/defer/update_position
- **HouseholdsController**: CRUD + add_member/remove_member

### Real-time Updates

- **ShoppingListChannel**: Subscribes to `shopping_list:#{id}`
- **Broadcasts**: Model callbacks trigger Turbo Stream updates via Action Cable
- **Solid Cable**: SQLite-backed WebSocket adapter for development/production

### Frontend

- **Stimulus Controllers**:
  - `expandable_input_controller.js`: Google Keep-style bottom input
  - `draggable_controller.js`: Drag-and-drop item reordering
- **Tailwind CSS**: Responsive grid (1/2/3+ cols), completed/deferred styling
- **Turbo Frames**: Inline editing and real-time updates

## Testing

```bash
# Run all tests
bin/rails test

# Run system tests
bin/rails test:system

# Run specific test file
bin/rails test test/models/shopping_list_test.rb
```

## Deployment

The application includes Kamal configuration for Docker-based deployment:

```bash
# Setup deployment
bin/kamal setup

# Deploy
bin/kamal deploy

# View logs
bin/kamal app logs
```

### Production Databases

SQLite3 with separate databases for scalability:
- `storage/production.sqlite3` - Primary application data
- `storage/production_cache.sqlite3` - Solid Cache
- `storage/production_queue.sqlite3` - Solid Queue  
- `storage/production_cable.sqlite3` - Solid Cable

## Development

### Key Design Decisions

1. **Association-based Multi-tenancy**: Simple pattern using `current_user.households` scoping instead of gems like acts_as_tenant
2. **Minimal Item Attributes**: Name, state, position for MVP (can add categories/quantities later)
3. **Solid Cable**: SQLite-backed WebSocket for real-time (easy to swap for Redis if needed)
4. **Explicit Position**: Manual position column instead of acts_as_list gem
5. **Last-write-wins**: Position conflicts resolved by accepting last update
6. **Keep Duplicates**: Merge operations preserve all items (no deduplication)
7. **Auto-create Personal Household**: Users start with private workspace

### Future Enhancements

- Item categories and quantities
- Recurring items and list templates
- Smart deduplication in merge
- Item images via Active Storage
- Mobile PWA installation
- Redis adapter for high-concurrency WebSocket
- Request logging and analytics

## License

This project is available as open source under the terms of the MIT License.
