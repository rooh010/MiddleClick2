#!/usr/bin/env swift
import AppKit
import Foundation

let symbolName = "computermouse.fill"
let outputDir = "\(FileManager.default.currentDirectoryPath)/MiddleClick2Swift/Resources/Assets.xcassets/AppIcon.appiconset"

let targets: [(String, CGFloat)] = [
    ("icon_16x16.png", 16),
    ("icon_16x16@2x.png", 32),
    ("icon_32x32.png", 32),
    ("icon_32x32@2x.png", 64),
    ("icon_128x128.png", 128),
    ("icon_128x128@2x.png", 256),
    ("icon_256x256.png", 256),
    ("icon_256x256@2x.png", 512),
    ("icon_512x512.png", 512),
    ("icon_512x512@2x.png", 1024)
]

func renderSymbol(size: CGFloat) -> NSImage {
    let config = NSImage.SymbolConfiguration(pointSize: size * 0.8, weight: .regular)
    guard let base = NSImage(systemSymbolName: symbolName, accessibilityDescription: nil),
          let configured = base.withSymbolConfiguration(config) else {
        fatalError("Failed to load symbol \(symbolName)")
    }
    configured.isTemplate = true

    let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: Int(size),
        pixelsHigh: Int(size),
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: .deviceRGB,
        bytesPerRow: 0,
        bitsPerPixel: 0
    )!

    let image = NSImage(size: NSSize(width: size, height: size))
    image.addRepresentation(rep)

    NSGraphicsContext.saveGraphicsState()
    let ctx = NSGraphicsContext(bitmapImageRep: rep)
    NSGraphicsContext.current = ctx

    NSColor.clear.set()
    NSRect(x: 0, y: 0, width: size, height: size).fill()
    NSColor.black.set()
    configured.draw(in: NSRect(x: 0, y: 0, width: size, height: size),
                    from: NSRect.zero,
                    operation: NSCompositingOperation.sourceOver,
                    fraction: 1.0)

    NSGraphicsContext.restoreGraphicsState()
    return image
}

for (filename, size) in targets {
    let image = renderSymbol(size: size)
    guard let tiff = image.tiffRepresentation,
          let rep = NSBitmapImageRep(data: tiff),
          let png = rep.representation(using: .png, properties: [:]) else {
        fatalError("Failed to render \(filename)")
    }
    let url = URL(fileURLWithPath: outputDir).appendingPathComponent(filename)
    try png.write(to: url)
}

print("Generated AppIcon images in \(outputDir)")
