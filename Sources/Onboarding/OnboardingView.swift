import SwiftUI

public struct OnboardingView: View {
    @State private var state: OnboardingState
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let onGetStarted: () -> Void
    private let onLogIn: (() -> Void)?

    public init(
        pages: [OnboardingPage] = OnboardingPage.samples,
        autoAdvanceInterval: Duration = .seconds(2),
        onGetStarted: @escaping () -> Void = {},
        onLogIn: (() -> Void)? = nil
    ) {
        _state = State(wrappedValue: OnboardingState(
            pages: pages,
            autoAdvanceInterval: autoAdvanceInterval
        ))
        self.onGetStarted = onGetStarted
        self.onLogIn = onLogIn
    }

    public var body: some View {
        ZStack {
            OnboardingBackground(accentColor: state.currentPage.color)

            VStack(alignment: .leading, spacing: 14) {
                Spacer(minLength: 0)
                Header(greeting: state.currentPage.greeting, title: state.currentPage.title)
                PageIndicators(count: state.pages.count, currentIndex: state.currentIndex)
                    .padding(.top, 6)
                Button(action: onGetStarted) {
                    Text("Get Started")
                }
                .buttonStyle(.primaryCapsule)
                .padding(.top, 20)

                if let onLogIn {
                    LogInFooter(action: onLogIn)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .task { await runAutoAdvance() }
    }

    private func runAutoAdvance() async {
        while !Task.isCancelled {
            try? await Task.sleep(for: state.autoAdvanceInterval)
            guard !Task.isCancelled else { return }
            let animation: Animation? = reduceMotion ? nil : .easeInOut(duration: 0.6)
            withAnimation(animation) {
                state.advance()
            }
        }
    }
}

private struct Header: View {
    let greeting: LocalizedStringResource?
    let title: LocalizedStringResource

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let greeting {
                Text(greeting)
                    .font(.jetBrainsMonoRegular(size: 15, relativeTo: .subheadline))
                    .foregroundStyle(.secondary)
                    .contentTransition(.numericText())
            }
            Text(title)
                .font(.jetBrainsMonoBold(size: 32, relativeTo: .largeTitle))
                .foregroundStyle(.primary)
                .contentTransition(.numericText())
                .lineLimit(3)
                .multilineTextAlignment(.leading)
        }
    }
}

private struct LogInFooter: View {
    let action: () -> Void

    var body: some View {
        HStack(spacing: 4) {
            Text("Already have an account?")
                .font(.jetBrainsMonoRegular(size: 13, relativeTo: .footnote))
                .foregroundStyle(.secondary)
            Button("Log in", action: action)
                .font(.jetBrainsMonoMedium(size: 13, relativeTo: .footnote))
                .foregroundStyle(.primary)
                .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview("Default") {
    OnboardingView()
}

#Preview("Single page") {
    OnboardingView(pages: [
        OnboardingPage(
            greeting: "Welcome",
            title: "One-page intro",
            color: .mint
        )
    ])
}
