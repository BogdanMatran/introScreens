import SwiftUI

struct PageIndicators: View {
    let count: Int
    let currentIndex: Int

    private let activeWidth: CGFloat = 24
    private let inactiveWidth: CGFloat = 8
    private let height: CGFloat = 4

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<count, id: \.self) { index in
                Capsule()
                    .fill(.primary.opacity(index == currentIndex ? 0.95 : 0.32))
                    .frame(width: index == currentIndex ? activeWidth : inactiveWidth, height: height)
            }
        }
        .animation(.spring(response: 0.45, dampingFraction: 0.85), value: currentIndex)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("Page \(currentIndex + 1) of \(count)"))
    }
}

#Preview {
    PageIndicators(count: 3, currentIndex: 0)
        .padding()
        .background(Color.black)
}
