# Charts

Three ways to draw charts in a UIKit app, from zero-dependency to full-featured. Pick based on your deployment target and how much interactivity you need.

## Files

- [`NativeBarChartView.swift`](./NativeBarChartView.swift) — a simple bar chart drawn by hand with `CoreGraphics` (**no dependency, any iOS version**).
- [`SwiftChartsHosted.swift`](./SwiftChartsHosted.swift) — Apple's **Swift Charts** embedded in a UIKit view controller via `UIHostingController` (**iOS 16+, no third-party dependency**).
- [`DGChartsExample.swift`](./DGChartsExample.swift) — the popular **DGCharts** library (external dependency), for rich interactive charts.

## Which should I use?

| Option | Dependency | Min iOS | Best for |
|---|---|---|---|
| **Draw it yourself** (`NativeBarChartView`) | None | Any | One simple chart, full control, tiny binary |
| **Swift Charts** (`SwiftChartsHosted`) | None (Apple) | **16+** | Modern apps; clean declarative API; bar/line/area/point |
| **DGCharts** | External (SPM) | 12+ | Pre-iOS-16 support, gestures/zoom/pan, many chart types |

> **Recommendation:** if you're **iOS 16+**, use **Swift Charts** — it's free, first-party, and expressive. If you must support older iOS or need built-in pan/zoom and lots of chart types, use **DGCharts**. For a single static bar/line, drawing it yourself avoids any dependency.

## Swift Charts in a UIKit app

Swift Charts is a SwiftUI API, but you don't have to adopt SwiftUI everywhere — wrap the chart view in a `UIHostingController` and add it as a child view controller. That's the whole trick, and it's shown in `SwiftChartsHosted.swift`.

## DGCharts (the popular external library)

- **Repo:** `https://github.com/danielgindi/Charts` (Swift Package `DGCharts`). This is the successor to the widely-used "Charts" library (`import Charts` → now `import DGCharts`).
- **Add via SPM:** File → Add Packages → paste the URL → add product **`DGCharts`**.
- Gives you `BarChartView`, `LineChartView`, `PieChartView`, etc., with gestures, highlighting, animations, and axis formatting out of the box.

> `DGChartsExample.swift` won't compile until the package is added — the DGCharts calls are annotated so you can uncomment them once it's in the project.
