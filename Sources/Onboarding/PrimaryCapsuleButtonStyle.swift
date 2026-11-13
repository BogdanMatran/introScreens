import SwiftUI

public struct PrimaryCapsuleButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.jetBrainsMonoMedium(size: 17, relativeTo: .headline))
            .foregroundStyle(Color(.systemBackground))
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(Color.primary, in: .capsule)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

public extension ButtonStyle where Self == PrimaryCapsuleButtonStyle {
    static var primaryCapsule: PrimaryCapsuleButtonStyle { .init() }
}
