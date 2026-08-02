import UIKit

// Reusable alert helpers. Call them on any UIViewController.
extension UIViewController {

    // Simple informational alert with an OK button.
    func showAlert(title: String, message: String? = nil, buttonTitle: String = "OK",
                   completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default) { _ in completion?() })
        present(alert, animated: true)
    }

    // Show a caught error to the user.
    func showError(_ error: Error) {
        showAlert(title: "Something went wrong", message: error.localizedDescription)
    }

    // Confirm / cancel, with optional destructive styling.
    func confirm(title: String, message: String? = nil,
                 confirmTitle: String = "OK", cancelTitle: String = "Cancel",
                 destructive: Bool = false, onConfirm: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel))
        alert.addAction(UIAlertAction(title: confirmTitle,
                                      style: destructive ? .destructive : .default) { _ in
            onConfirm()
        })
        present(alert, animated: true)
    }

    // Prompt the user for a single line of text.
    func promptForText(title: String, message: String? = nil, placeholder: String? = nil,
                       initialText: String? = nil, onSubmit: @escaping (String) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { tf in
            tf.placeholder = placeholder
            tf.text = initialText
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Done", style: .default) { _ in
            onSubmit(alert.textFields?.first?.text ?? "")
        })
        present(alert, animated: true)
    }

    // Bottom action sheet. Pass sourceView for iPad popover safety.
    func showActionSheet(title: String? = nil, message: String? = nil,
                         actions: [UIAlertAction], sourceView: UIView? = nil) {
        let sheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        actions.forEach { sheet.addAction($0) }
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        if let sourceView {
            sheet.popoverPresentationController?.sourceView = sourceView
            sheet.popoverPresentationController?.sourceRect = sourceView.bounds
        }
        present(sheet, animated: true)
    }
}
