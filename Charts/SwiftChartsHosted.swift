import UIKit
import SwiftUI
import Charts   // Apple's Swift Charts — first-party, iOS 16+. (NOT the third-party DGCharts.)

// Embed a first-party Swift Charts view inside a UIKit view controller.
// Requires iOS 16+.

// 1. The data model.
struct Sale: Identifiable {
    let id = UUID()
    let day: String
    let amount: Double
}

// 2. The SwiftUI chart.
@available(iOS 16.0, *)
struct SalesChart: View {
    let sales: [Sale]

    var body: some View {
        Chart(sales) { sale in
            BarMark(
                x: .value("Day", sale.day),
                y: .value("Amount", sale.amount)
            )
            .foregroundStyle(.blue.gradient)
            .cornerRadius(4)
        }
        .padding()
    }
}

// 3. The UIKit host — add the SwiftUI view as a child view controller.
@available(iOS 16.0, *)
final class SalesChartViewController: UIViewController {

    private let sales = [
        Sale(day: "Mon", amount: 12), Sale(day: "Tue", amount: 30),
        Sale(day: "Wed", amount: 18), Sale(day: "Thu", amount: 25),
        Sale(day: "Fri", amount: 9)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sales"
        view.backgroundColor = .systemBackground

        let host = UIHostingController(rootView: SalesChart(sales: sales))
        addChild(host)                              // 1. establish the parent-child link
        host.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(host.view)                  // 2. add the SwiftUI view
        NSLayoutConstraint.activate([               // 3. lay it out
            host.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            host.view.heightAnchor.constraint(equalToConstant: 300)
        ])
        host.didMove(toParent: self)                // 4. notify the child
    }
}
