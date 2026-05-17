import Foundation
import CoreGraphics
import Sprogal





// MARK: - Stroke Settings

/// Extends `CoreGraphicsCanvas` with stroke configuration.
extension CoreGraphicsCanvas {
    
    
    
    
    
    /// Sets the miter limit for subsequent stroke operations.
    /// - Parameter limit: The miter limit value.
    public func setMiterLimit(_ limit: Scalar) {
        self.context.setMiterLimit(CGFloat(limit.value))
    }
    
    
    
    
    
    /// Sets the dash pattern for subsequent stroke operations.
    /// - Parameter pattern: The dash pattern to apply.
    public func setDashPattern(_ pattern: DashPattern) {
        let lengths = pattern.lengths.map { CGFloat($0.value) }
        self.context.setLineDash(
            phase: CGFloat(pattern.phase.value),
            lengths: lengths
        )
    }
    
    
    
    
    
}





// MARK: - Path Drawing

/// Extends `CoreGraphicsCanvas` with bezier path filling and stroking.
extension CoreGraphicsCanvas {
    
    
    
    
    
    /// Fills a bezier path with the given color and fill rule.
    /// - Parameters:
    ///   - path: The path to fill.
    ///   - color: The fill color.
    ///   - fillRule: The rule used to determine filled regions.
    public func fillPath(_ path: BezierPath, color: Color, fillRule: FillRule) {
        let cgPath = self.buildCGPath(from: path)
        self.context.addPath(cgPath)
        self.context.setFillColor(self.buildCGColor(from: color))
        
        switch fillRule {
        case .winding:
            self.context.fillPath()
        case .evenOdd:
            self.context.fillPath(using: .evenOdd)
        }
    }
    
    
    
    
    
    /// Strokes a bezier path with the given color and line width.
    /// - Parameters:
    ///   - path: The path to stroke.
    ///   - color: The stroke color.
    ///   - lineWidth: The width of the stroke.
    public func strokePath(_ path: BezierPath, color: Color, lineWidth: Scalar) {
        let cgPath = self.buildCGPath(from: path)
        self.context.addPath(cgPath)
        self.context.setStrokeColor(self.buildCGColor(from: color))
        self.context.setLineWidth(CGFloat(lineWidth.value))
        self.context.strokePath()
    }
    
    
    
    
    
}





// MARK: - Path Conversion

/// Helper for converting Sprogal paths to Core Graphics paths.
extension CoreGraphicsCanvas {
    
    
    
    
    
    /// Converts a `BezierPath` into a `CGPath`.
    /// - Parameter path: The bezier path to convert.
    /// - Returns: The equivalent Core Graphics path.
    public func buildCGPath(from path: BezierPath) -> CGPath {
        let cgPath = CGMutablePath()
        
        for subpath in path.subpaths {
            cgPath.move(to: CGPoint(
                x: CGFloat(subpath.startPoint.x.value),
                y: CGFloat(subpath.startPoint.y.value)
            ))
            
            for curve in subpath.curves {
                cgPath.addCurve(
                    to: CGPoint(
                        x: CGFloat(curve.endAnchorPoint.x.value),
                        y: CGFloat(curve.endAnchorPoint.y.value)
                    ),
                    control1: CGPoint(
                        x: CGFloat(curve.startControlPoint.x.value),
                        y: CGFloat(curve.startControlPoint.y.value)
                    ),
                    control2: CGPoint(
                        x: CGFloat(curve.endControlPoint.x.value),
                        y: CGFloat(curve.endControlPoint.y.value)
                    )
                )
            }
            
            if subpath.isClosed {
                cgPath.closeSubpath()
            }
        }
        
        return cgPath
    }
    
    
    
    
    
}
