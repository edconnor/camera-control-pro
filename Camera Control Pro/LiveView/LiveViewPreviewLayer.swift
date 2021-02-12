//
//  LiveViewOverlay.swift
//  Camera Control Pro
//
//  Created by Eduardo Connor on 1/11/21.
//

import AVFoundation
import SwiftUI

public class LiveViewPreviewLayer: AVCaptureVideoPreviewLayer {
    public var cornerLength: CGFloat = 30
    public var lineWidth: CGFloat = 2
    public var lineColor: NSColor = .yellow
    public var lineCap: CAShapeLayerLineCap = .round
    
    public var maskSize: CGSize = CGSize(width: 200, height: 200)
    
    public var rectOfInterest: CGRect {
           metadataOutputRectConverted(fromLayerRect: maskContainer)
       }

    public override var frame: CGRect {
           didSet {
               setNeedsDisplay()
           }
       }
    
    private var maskContainer: CGRect {
        CGRect(x: (bounds.width / 2) - (maskSize.width / 2),
        y: (bounds.height / 2) - (maskSize.height / 2),
        width: maskSize.width, height: maskSize.height)
    }
    
    public override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        
        for sublayer in self.sublayers ?? [] {
            sublayer.removeFromSuperlayer()
        }
        
        // MARK: - Background Mask
        let path = CGMutablePath()
        path.addRect(bounds)
        path.addRoundedRect(in: maskContainer, cornerWidth: cornerRadius, cornerHeight: cornerRadius)

        let maskLayer = CAShapeLayer()
        maskLayer.path = path
        maskLayer.fillColor = backgroundColor
        maskLayer.fillRule = .evenOdd

        addSublayer(maskLayer)
        
        // MARK: - Edged Corners
        if cornerRadius > cornerLength { cornerRadius = cornerLength }
        if cornerLength > maskContainer.width / 2 { cornerLength = maskContainer.width / 2 }

        let upperLeftPoint = CGPoint(x: maskContainer.minX, y: maskContainer.minY)
        let upperRightPoint = CGPoint(x: maskContainer.maxX, y: maskContainer.minY)
        let lowerRightPoint = CGPoint(x: maskContainer.maxX, y: maskContainer.maxY)
        let lowerLeftPoint = CGPoint(x: maskContainer.minX, y: maskContainer.maxY)

        let upperLeftCorner = NSBezierPath()
        upperLeftCorner.move(to: upperLeftPoint.offsetBy(dx: 0, dy: cornerLength))


        upperLeftCorner.appendArc(withCenter: upperLeftPoint.offsetBy(dx: cornerRadius, dy: cornerRadius),
                         radius: cornerRadius, startAngle: .pi, endAngle: 3 * .pi / 2, clockwise: true)
    
        upperLeftCorner.line(to: upperLeftPoint.offsetBy(dx: cornerLength, dy: 0))

        let upperRightCorner = NSBezierPath()
        upperRightCorner.move(to: upperRightPoint.offsetBy(dx: -cornerLength, dy: 0))
        upperRightCorner.appendArc(withCenter: upperRightPoint.offsetBy(dx: -cornerRadius, dy: cornerRadius),
                              radius: cornerRadius, startAngle: 3 * .pi / 2, endAngle: 0, clockwise: true)
        upperRightCorner.line(to: upperRightPoint.offsetBy(dx: 0, dy: cornerLength))

        let lowerRightCorner = NSBezierPath()
        lowerRightCorner.move(to: lowerRightPoint.offsetBy(dx: 0, dy: -cornerLength))
        lowerRightCorner.appendArc(withCenter: lowerRightPoint.offsetBy(dx: -cornerRadius, dy: -cornerRadius),
                                 radius: cornerRadius, startAngle: 0, endAngle: .pi / 2, clockwise: true)
        lowerRightCorner.line(to: lowerRightPoint.offsetBy(dx: -cornerLength, dy: 0))

        let bottomLeftCorner = NSBezierPath()
        bottomLeftCorner.move(to: lowerLeftPoint.offsetBy(dx: cornerLength, dy: 0))
        bottomLeftCorner.appendArc(withCenter: lowerLeftPoint.offsetBy(dx: cornerRadius, dy: -cornerRadius),
                                radius: cornerRadius, startAngle: .pi / 2, endAngle: .pi, clockwise: true)
        bottomLeftCorner.line(to: lowerLeftPoint.offsetBy(dx: 0, dy: -cornerLength))

        let combinedPath = CGMutablePath()
        combinedPath.addPath(upperLeftCorner.cgPath)
        combinedPath.addPath(upperRightCorner.cgPath)
        combinedPath.addPath(lowerRightCorner.cgPath)
        combinedPath.addPath(bottomLeftCorner.cgPath)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = combinedPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.fillColor = NSColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = lineCap

        addSublayer(shapeLayer)
    }
}

internal extension CGPoint {

    // MARK: - CGPoint+offsetBy
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        var point = self
        point.x += dx
        point.y += dy
        return point
    }
}

public extension NSBezierPath {

     var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)
        for i in 0 ..< self.elementCount {
            let type = self.element(at: i, associatedPoints: &points)
            switch type {
            case .moveTo: path.move(to: points[0])
            case .lineTo: path.addLine(to: points[0])
            case .curveTo: path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePath: path.closeSubpath()
            @unknown default: Swift.print("Unknown NSBezierPath path type.")
            }
        }
        return path
    }
}
