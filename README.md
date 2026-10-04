# ClickMe

A polished Flutter demo shop for thoughtful home and lifestyle finds. The app
uses local mock product data and in-memory shopping state; it does not connect
to a backend or process real payments.

## Run

```sh
flutter pub get
flutter run
```

## Demo flow

The splash screen opens sign-in. Use any valid-looking email and a password of
at least six characters, create an account with the same basic validation, or
continue as a guest. Browse categories and products, save favourites, add items
to the bag, and complete checkout with demo delivery details and either payment
option. Completed orders appear under **My orders** for the current app session.

The forgot-password screen is illustrative only: no reset email is sent.
Product photos load from Unsplash and use a colour placeholder if unavailable.

## Project structure

- `lib/core/` — app-wide theme
- `lib/data/` — mock categories and product catalogue
- `lib/models/` — product, cart, and order models
- `lib/screens/` — authentication, browsing, shopping, checkout, and profile UI
- `lib/state/` — shared in-memory cart, favourites, and order state
- `lib/widgets/` — reusable product cards, images, logo, and common UI

Run `flutter analyze` and `flutter test` to validate the project.
