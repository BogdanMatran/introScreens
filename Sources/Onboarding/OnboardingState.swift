import SwiftUI

@Observable @MainActor
final class OnboardingState {
    let pages: [OnboardingPage]
    let autoAdvanceInterval: Duration
    var currentIndex: Int = 0

    init(pages: [OnboardingPage], autoAdvanceInterval: Duration = .seconds(2)) {
        precondition(!pages.isEmpty, "OnboardingState requires at least one page")
        self.pages = pages
        self.autoAdvanceInterval = autoAdvanceInterval
    }

    var currentPage: OnboardingPage { pages[currentIndex] }

    func advance() {
        guard pages.count > 1 else { return }
        currentIndex = (currentIndex + 1) % pages.count
    }

    func go(to index: Int) {
        guard pages.indices.contains(index) else { return }
        currentIndex = index
    }
}
