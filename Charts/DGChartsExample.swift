import UIKit

// DGCharts — the popular third-party charting library (successor to "Charts").
// Repo: https://github.com/danielgindi/Charts  •  SPM product: DGCharts
//
// NOTE: This file won't compile until you add the DGCharts package (see README).
// Uncomment the import and the body once the dependency is in the project.
//
// import DGCharts

final class DGChartsExampleViewController: UIViewController {

    // private let chartView = BarChartView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "DGCharts"
        view.backgroundColor = .systemBackground
        setupChart()
    }

    private func setupChart() {
        /*  // ── Uncomment after adding DGCharts ──────────────────────────────
        chartView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chartView)
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            chartView.heightAnchor.constraint(equalToConstant: 300)
        ])

        // Build entries: (x index, y value).
        let values: [Double] = [12, 30, 18, 25, 9]
        let entries = values.enumerated().map { BarChartDataEntry(x: Double($0.offset), y: $0.element) }

        let dataSet = BarChartDataSet(entries: entries, label: "Sales")
        dataSet.colors = [.systemBlue]
        dataSet.valueFont = .preferredFont(forTextStyle: .caption2)

        chartView.data = BarChartData(dataSet: dataSet)

        // Label the x-axis with weekdays.
        let days = ["Mon", "Tue", "Wed", "Thu", "Fri"]
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.granularity = 1
        chartView.rightAxis.enabled = false
        chartView.legend.enabled = true

        // Built-in animation + gestures (pinch-to-zoom, drag) come for free.
        chartView.animate(yAxisDuration: 0.8)
        */  // ────────────────────────────────────────────────────────────────
    }
}
