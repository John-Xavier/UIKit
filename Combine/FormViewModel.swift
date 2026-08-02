import Foundation
import Combine

// A view model whose state the UI can bind to. Publishes validation live.
final class FormViewModel {

    // Inputs — the VC writes these as the user types.
    @Published var email = ""
    @Published var password = ""

    // Outputs — the VC observes these to update the UI.
    @Published private(set) var isValid = false
    @Published private(set) var validationMessage = ""

    private var cancellables = Set<AnyCancellable>()

    init() {
        // Derive `isValid` from the latest email + password.
        Publishers.CombineLatest($email, $password)
            .map { email, password in
                email.contains("@") && password.count >= 6
            }
            .assign(to: &$isValid)   // assign(to:) on a @Published needs no store

        // Derive a human-readable message.
        Publishers.CombineLatest($email, $password)
            .map { email, password -> String in
                if !email.contains("@") { return "Enter a valid email." }
                if password.count < 6 { return "Password must be 6+ characters." }
                return ""
            }
            .assign(to: &$validationMessage)
    }
}
