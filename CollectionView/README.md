# UICollectionView

Grids, carousels, and anything that isn't a single-column list. This section focuses on the most common real-world need: **a grid of images loaded from the network**.

## Files

| File | Use it when… |
|---|---|
| [`ImageCell.swift`](./ImageCell.swift) | A reusable cell that shows an async-loaded image. |
| [`ImageGridViewController.swift`](./ImageGridViewController.swift) | A responsive photo grid using compositional layout. |

> Image loading itself lives in [`../ImageLoading`](../ImageLoading) — the grid reuses that loader so cells don't re-download while scrolling.

## Step by step (image grid)

1. Build a **cell** (`ImageCell`) with a single `UIImageView` pinned to its edges.
2. Create a **compositional layout** describing item/group/section sizing (e.g. 3 across).
3. Register the cell and create the collection view with that layout.
4. Feed it with a data source (`cellForItemAt`) or, better, a **diffable data source**.
5. In each cell, start an async image load and **cancel it in `prepareForReuse`** so a fast scroll doesn't drop the wrong image into a recycled cell.

## Why compositional layout?

`UICollectionViewCompositionalLayout` (iOS 13+) replaces the fiddly `UICollectionViewFlowLayout` delegate math. You declare sizes with fractional dimensions and it adapts to any screen width:

```swift
let item = NSCollectionLayoutItem(
    layoutSize: .init(widthDimension: .fractionalWidth(1/3),
                      heightDimension: .fractionalHeight(1.0)))
```

`.fractionalWidth(1/3)` = "one third of the group's width" → a 3-column grid on every device.
