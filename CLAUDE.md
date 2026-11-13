# Intro — Animated Onboarding (Swift Package)

A drop-in SwiftUI onboarding component: animated MeshGradient background that crossfades color per page, capsule paging indicators with animated active-width, rotating headline using `.contentTransition(.numericText())`, and a "Get Started" capsule button.

## Distribution

Swift Package Manager. Add to any iOS 18+ app via **Xcode → Add Package Dependencies → Local…** (point at this folder) or via remote URL once published. Then `import Onboarding`.

```swift
import Onboarding

OnboardingView(
    pages: OnboardingPage.samples,
    onGetStarted: { /* dismiss / persist */ },
    onLogIn: { /* optional — show login screen */ }
)
```

## Stack & Targets

- **Platform**: iOS 18.0+ (required for `MeshGradient` and `.contentTransition(.numericText())`)
- **Language**: Swift 6, strict concurrency
- **UI**: SwiftUI only

## Package Layout

```
intro/
├── Package.swift
├── CLAUDE.md
└── Sources/
    └── Onboarding/
        ├── OnboardingPage.swift              (public model + samples)
        ├── OnboardingView.swift              (public composition view)
        ├── PrimaryCapsuleButtonStyle.swift   (public ButtonStyle)
        ├── OnboardingState.swift             (internal @Observable state)
        ├── OnboardingBackground.swift        (internal animated gradient)
        └── PageIndicators.swift              (internal capsule indicators)
```

## Public API

- `OnboardingPage` — `Identifiable, Sendable`. `init(id:greeting:title:color:)`. `static var samples` for previews.
- `OnboardingView` — `init(pages:autoAdvanceInterval:onGetStarted:onLogIn:)`. `onLogIn` is optional; pass `nil` (default) to hide the footer.
- `PrimaryCapsuleButtonStyle` — exposed as `.primaryCapsule` extension on `ButtonStyle`. Useful if consumers want to match the CTA style elsewhere.

## Behavior

- **Auto-advance** every 2s (configurable). Driven by an `async` task scoped to the view's `.task` modifier — auto-cancels on disappear.
- **Background motion** — single `@State` phase animated via `repeatForever(autoreverses:)`. Drives MeshGradient control points. Color changes propagate through SwiftUI's normal animation transactions, so the per-page color crossfade interpolates rather than popping.
- **Reduce Motion** — disables the breath animation and skips the `easeInOut` on auto-advance. Indicators and text still update on schedule.
- **Dark/Light** — base gradient adapts; colored glow rides on top in both schemes. The package does **not** force `preferredColorScheme` — the host app decides.

## Open Questions Still Outstanding

These aren't blockers for the package as built, but the consumer should decide:

1. **End-of-deck behavior** — currently loops back to page 0 forever. If you want it to hold on the last page or auto-trigger Get Started, tell me.
2. **Swipe gestures** — not implemented. Add `TabView`-style paging if needed.
3. **Persistence** — the package emits `onGetStarted` / `onLogIn` callbacks; storing "completed" state is the host app's job.
4. **Localization** — strings are passed as `LocalizedStringResource`; consumers handle their own catalogs.

## Verification

`xcodebuild -scheme Intro -destination 'generic/platform=iOS Simulator' build` — currently green.

Note: `swift build` from the host targets macOS by default and will fail on iOS-only APIs. Always use the iOS destination, or build via Xcode.
