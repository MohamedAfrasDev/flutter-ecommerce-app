# Architecture Documentation

## Overview

ShopFlow follows a **feature-first** architecture with GetX for state management and Supabase as the Backend-as-a-Service. The app is structured around clear separation of concerns: UI (screens/widgets), business logic (controllers), and data (models/repositories).

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────┐
│                      Flutter App                         │
├─────────────────────────────────────────────────────────┤
│  Presentation Layer                                     │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐             │
│  │  Screens │  │  Widgets │  │  Layouts │             │
│  └────┬─────┘  └──────────┘  └──────────┘             │
│       │                                                 │
│  Business Logic Layer                                   │
│  ┌──────────────────────────────────────┐              │
│  │         GetX Controllers             │              │
│  │  (HomeControllers, CartController,   │              │
│  │   ProductController, OrderController)│              │
│  └────────────────┬─────────────────────┘              │
│                   │                                     │
│  Data Layer       │                                     │
│  ┌────────────────┼─────────────────────┐              │
│  │  ┌─────────┐   │   ┌──────────────┐  │              │
│  │  │  Models │   │   │ Repositories │  │              │
│  │  └─────────┘   │   └──────────────┘  │              │
│  └────────────────┼─────────────────────┘              │
│                   │                                     │
├───────────────────┼─────────────────────────────────────┤
│  External Services│                                     │
│  ┌────────────────▼──────┐  ┌─────────────────────┐    │
│  │       Supabase        │  │    PayHere SDK      │    │
│  │  (Auth + Database)    │  │  (Payment Gateway)  │    │
│  └───────────────────────┘  └─────────────────────┘    │
│  ┌───────────────────────┐  ┌─────────────────────┐    │
│  │     GetStorage        │  │  SharedPreferences  │    │
│  │  (App Config Cache)   │  │   (Cart Persist)    │    │
│  └───────────────────────┘  └─────────────────────┘    │
└─────────────────────────────────────────────────────────┘
```

---

## Layer Breakdown

### 1. Presentation Layer (`lib/common/`, `lib/features/*/screens/`)

Handles all UI rendering. Screens are feature-scoped and compose reusable widgets from `common/widgets/`.

**Key patterns:**
- Screens are `StatefulWidget` or `StatelessWidget` that observe GetX controllers via `Obx()`
- Reusable widgets are parameterized and theme-aware (dark/light mode)
- Navigation uses GetX routing (`Get.to()`, `Get.offAll()`)

### 2. Business Logic Layer (`lib/features/*/controllers/`)

GetX controllers manage app state and coordinate between UI and data sources.

| Controller | Responsibility |
|-----------|---------------|
| `HomeControllers` | User session, remote config (theme, reviews, currency, maintenance) |
| `ProductController` | Product data loading and caching |
| `CartController` | Cart state, persistence, price calculations |
| `StoreController` | Paginated product fetching for the store grid |
| `OrderController` | Order placement, stock updates |
| `CustomerController` | Customer profile and existence checks |
| `PayhereController` | Payment credential fetching from Supabase |
| `AddressAddController` | Address CRUD operations |

### 3. Data Layer (`lib/utils/helpers/models/`, `lib/utils/repository/`)

**Models:**
- `ProductModel` — Full product representation with variations, attributes, brand
- `OrderModel` — Order with addresses, products, pricing, status
- `CustomerModel` — User profile data
- `AddressModel` — Shipping/billing address
- `BannerModel` — Promotional banners
- `CategoryModel` — Product categories
- `ProductVariantionsModel` — Product size/color/style variations
- `ProductAttributeModel` — Product attributes (name-value pairs)

**Repositories:**
- `ProductRepository` — Product CRUD against Supabase
- `AuthenticationRepository` — Auth state management

---

## Data Flow

### Product Loading

```
StoreController.fetchProducts()
    → Supabase.from('products').select().range(start, end)
    → List<ProductModel>.fromJson()
    → products.obs (reactive list)
    → Obx(() => GridViewLayout(...)) rebuilds UI
```

### Cart & Checkout

```
User adds item → CartController.addToCart(CartItem)
    → Update reactive list
    → Persist to SharedPreferences (JSON)

Checkout → Config.startPayment(cartItems, address, total)
    → PayHere SDK processes payment
    → On success: OrderController.saveOrder(OrderModel)
    → Update stock quantities in Supabase
    → Navigate to OrderSuccessfulScreen
```

### Authentication

```
LoginScreen._signIn()
    → Supabase.auth.signInWithPassword(email, password)
    → Store UID in GetStorage
    → Navigate to NavigationMenu (home)

SplashScreen checks:
    → supabase.auth.currentUser != null? → Home
    → First time? → Onboarding
    → Otherwise → Login
```

---

## Remote Configuration (Admin Panel)

The app reads configuration from a Supabase `app_config` table, allowing admin control without app updates:

| Config Key | Purpose |
|-----------|---------|
| `app_color` | Primary brand color (hex) |
| `app_theme` | Force dark/light/system theme |
| `currencySymbol` | Display currency (e.g., LKR, USD) |
| `maintenanceMode` | Toggle maintenance screen |
| `Enable Product Review` | Show/hide review section |
| `Allow Verified Review only` | Restrict reviews to verified purchases |
| `Processing Fee Structure` | Include/exclude processing fees |

Payment credentials are stored in a separate `payment_credentials` table:

| Field | Purpose |
|-------|---------|
| `PaymentProvider` | Provider name (PayHere) |
| `APIKey` | Merchant secret key |
| `MerchantID` | Merchant identifier |
| `isSandBox` | Toggle sandbox/production mode |

---

## Supabase Database Schema

```
┌──────────────────┐     ┌──────────────────┐
│    products      │     │    customers     │
├──────────────────┤     ├──────────────────┤
│ id (uuid, PK)   │     │ customerID (PK)  │
│ title            │     │ customerName     │
│ description      │     │ customerEmail    │
│ price            │     │ customerImage    │
│ sales_price      │     │ customerPhone    │
│ stock            │     │ address          │
│ thumbnail        │     └──────────────────┘
│ images[]         │
│ brand (jsonb)    │     ┌──────────────────┐
│ variation (jsonb)│     │     orders       │
│ product_type     │     ├──────────────────┤
│ product_attrs[]  │     │ orderID (PK)     │
│ offerValue       │     │ userID (FK)      │
│ rating           │     │ orderStatus      │
│ is_featured      │     │ paymentMethod    │
│ created_at       │     │ paymentStatus    │
└──────────────────┘     │ totalPrice       │
                         │ shippingCost     │
┌──────────────────┐     │ products (jsonb) │
│   app_config     │     │ shippingAddress  │
├──────────────────┤     │ orderDate        │
│ title            │     └──────────────────┘
│ value            │
│ description      │     ┌──────────────────┐
└──────────────────┘     │   tab_config     │
                         ├──────────────────┤
┌──────────────────┐     │ tab_location     │
│payment_credentials│    │ is_active        │
├──────────────────┤     │ order            │
│ PaymentProvider  │     └──────────────────┘
│ APIKey           │
│ MerchantID       │     ┌──────────────────┐
│ isSandBox        │     │    reviews       │
└──────────────────┘     ├──────────────────┤
                         │ productID (FK)   │
                         │ userID (FK)      │
                         │ rating           │
                         │ comment          │
                         │ isApproved       │
                         │ created_at       │
                         └──────────────────┘
```

---

## State Management Strategy

**GetX** is used throughout for:
- **Reactive state** — `.obs` variables with `Obx()` widget rebuilding
- **Dependency injection** — `Get.put()` / `Get.find()` for controller singletons
- **Navigation** — `Get.to()`, `Get.offAll()`, `Get.back()`
- **Snackbars/Dialogs** — `Get.snackbar()` for user feedback

**Local persistence** uses two strategies:
- `GetStorage` — Fast key-value store for user session data, credentials, config cache
- `SharedPreferences` — Cart items serialized as JSON for cross-session persistence

---

## Payment Flow

```
┌──────────┐     ┌───────────┐     ┌──────────────┐     ┌─────────┐
│  Cart    │────▶│  Address  │────▶│  PayHere SDK │────▶│ Success │
│  Review  │     │  Select   │     │  (Sandbox/   │     │ Screen  │
│          │     │           │     │   Production)│     │         │
└──────────┘     └───────────┘     └──────────────┘     └─────────┘
                                          │
                                          ▼
                                   ┌──────────────┐
                                   │   Supabase   │
                                   │ Save Order + │
                                   │ Update Stock │
                                   └──────────────┘
```

**Two checkout paths:**
1. **Standard Cart Checkout** — Multiple items from cart
2. **Fast Checkout** — Single product instant buy (bypasses cart)

---

## Theming

The app supports dynamic theming:
- Theme definitions in `lib/utils/theme/` (light + dark variants for all components)
- Theme mode is fetched from Supabase `app_config` on startup
- Primary color can be changed remotely without app update
- Custom font: Poppins (Regular, Bold, Italic)

---

## Security Considerations

- Supabase credentials are passed via `--dart-define` compile-time variables (not in source)
- Payment API keys are fetched from Supabase at runtime (not hardcoded)
- Supabase Row Level Security (RLS) should be configured on all tables
- User sessions managed by Supabase Auth with automatic token refresh

---

## Key Design Decisions

| Decision | Rationale |
|----------|-----------|
| Feature-first folder structure | Scales well as features grow independently |
| GetX over BLoC/Riverpod | Simpler boilerplate for rapid development, built-in DI + routing |
| Supabase over Firebase | PostgreSQL flexibility, built-in auth, real-time, self-hostable |
| JSON asset files for static data | Offline-first category/brand data, no network call needed |
| PayHere SDK | Native Sri Lankan payment gateway supporting LKR |
| SharedPreferences for cart | Survives app restarts, simple JSON serialization |
| Remote config via DB table | No app update needed for business changes |

---

## Build & Deployment

```bash
# Development
flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...

# Production APK
flutter build apk --release --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...

# Production iOS
flutter build ios --release --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
```
