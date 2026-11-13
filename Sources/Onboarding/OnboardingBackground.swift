import SwiftUI

struct OnboardingBackground: View {
    let accentColor: Color

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Group {
            if reduceMotion {
                StaticGlow(accentColor: accentColor, baseColor: baseColor)
            } else {
                LiquidShaderBackground(accentColor: accentColor, baseColor: baseColor)
            }
        }
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 0.6), value: accentColor)
    }

    private var baseColor: Color {
        colorScheme == .dark ? Color(white: 0.015) : Color(white: 0.96)
    }
}

private struct LiquidShaderBackground: View {
    let accentColor: Color
    let baseColor: Color

    @State private var startDate = Date()

    var body: some View {
        GeometryReader { geo in
            TimelineView(.animation) { context in
                let elapsed = context.date.timeIntervalSince(startDate)
                Rectangle()
                    .colorEffect(
                        ShaderLibrary.bundle(.module).liquidBackground(
                            .float2(geo.size),
                            .float(elapsed),
                            .color(accentColor),
                            .color(baseColor)
                        )
                    )
            }
        }
    }
}

private struct StaticGlow: View {
    let accentColor: Color
    let baseColor: Color

    var body: some View {
        ZStack {
            baseColor
            RadialGradient(
                colors: [accentColor.opacity(0.85), accentColor.opacity(0.0)],
                center: UnitPoint(x: 0.5, y: 0.18),
                startRadius: 20,
                endRadius: 460
            )
            .blur(radius: 24)
        }
    }
}
