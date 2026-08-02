# Async Image Loading

Download images off the main thread and cache them in memory so a scrolling grid or table doesn't re-download the same picture. Used by [`../CollectionView`](../CollectionView).

## Files

- [`ImageLoader.swift`](./ImageLoader.swift) — an `actor` that downloads and caches `UIImage`s.

## Step by step

1. Keep a single shared loader (`ImageLoader.shared`).
2. Back it with an `NSCache<NSURL, UIImage>` — automatically evicts under memory pressure.
3. Expose one `async` method: `image(for:) async throws -> UIImage`.
4. In a cell, wrap the call in a `Task` and **cancel that task in `prepareForReuse`**.

## Why an `actor`?

The cache is shared mutable state. Making `ImageLoader` an `actor` means the compiler guarantees no data races when many cells request images at once — no manual locks.

## Do I need a third-party library?

For most apps, no. Kingfisher / SDWebImage add disk caching, transitions, and downsampling — reach for them when you need those. This loader covers the 80% case in ~40 lines.
