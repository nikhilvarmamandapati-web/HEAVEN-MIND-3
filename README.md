# HEAVEN MIND 3

A calming, beginner-friendly Flutter mental wellness and self-care app.

## Features
- Daily mood check-in
- Guided breathing pause
- Positive affirmations
- Private in-session journal (entries are not uploaded or synced)
- Practical wellness tips
- Support and help guidance

## Run locally
1. Install the Flutter SDK and enable web support.
2. Run `flutter pub get`.
3. Run `flutter run -d chrome` for web.
4. To create Android/iOS platform folders for local mobile builds, run `flutter create --platforms=android,ios .` from the project root.

## Build for web
`flutter build web --release --base-href "/HEAVEN-MIND-3/"`

## Deployment
The GitHub Actions workflow in `.github/workflows/deploy.yml` builds the Flutter web app and publishes it to GitHub Pages. In repository Settings > Pages, select **GitHub Actions** as the build and deployment source if it is not already selected.

## Important note
HEAVEN MIND 3 is a general wellbeing and self-care tool, not a medical or emergency service. It does not diagnose or treat mental health conditions. If you feel unsafe or need urgent help, contact a trusted adult, qualified professional, or local emergency service.
