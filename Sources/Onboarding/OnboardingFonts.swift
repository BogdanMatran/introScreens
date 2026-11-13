import CoreText
import Foundation
import SwiftUI

enum OnboardingFonts {
    static let regular = "JetBrainsMono-Regular"
    static let medium = "JetBrainsMono-Medium"
    static let bold = "JetBrainsMono-Bold"

    static let registerOnce: Void = {
        for name in [regular, medium, bold] {
            guard let url = Bundle.module.url(forResource: name, withExtension: "ttf") else { continue }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }()

    static func ensureRegistered() {
        _ = registerOnce
    }
}

extension Font {
    static func jetBrainsMonoRegular(size: CGFloat, relativeTo style: Font.TextStyle = .body) -> Font {
        OnboardingFonts.ensureRegistered()
        return .custom(OnboardingFonts.regular, size: size, relativeTo: style)
    }

    static func jetBrainsMonoMedium(size: CGFloat, relativeTo style: Font.TextStyle = .body) -> Font {
        OnboardingFonts.ensureRegistered()
        return .custom(OnboardingFonts.medium, size: size, relativeTo: style)
    }

    static func jetBrainsMonoBold(size: CGFloat, relativeTo style: Font.TextStyle = .largeTitle) -> Font {
        OnboardingFonts.ensureRegistered()
        return .custom(OnboardingFonts.bold, size: size, relativeTo: style)
    }
}
