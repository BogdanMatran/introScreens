import SwiftUI

public struct OnboardingPage: Identifiable, Sendable {
    public let id: UUID
    public let greeting: LocalizedStringResource?
    public let title: LocalizedStringResource
    public let color: Color

    public init(
        id: UUID = UUID(),
        greeting: LocalizedStringResource? = nil,
        title: LocalizedStringResource,
        color: Color
    ) {
        self.id = id
        self.greeting = greeting
        self.title = title
        self.color = color
    }
}

public extension OnboardingPage {
    static let samples: [OnboardingPage] = [
        OnboardingPage(
            greeting: "Hello, Bogdan",
            title: "Your Personal AI Assistant",
            color: Color(red: 0.16, green: 0.78, blue: 1.00)
        ),
        OnboardingPage(
            greeting: "Hello, Bogdan",
            title: "Discover What Inspires You",
            color: Color(red: 0.74, green: 0.55, blue: 1.00)
        ),
        OnboardingPage(
            greeting: "Hello, Bogdan",
            title: "Move Faster, Think Bigger",
            color: Color(red: 1.00, green: 0.45, blue: 0.45)
        )
    ]
}
