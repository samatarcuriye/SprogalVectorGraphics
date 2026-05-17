import Foundation
import Sprogal





// MARK: - Declaration

/// A type that can draw a stroked outline of its path.
///
/// Conforming types must also conform to `Pathable` to
/// provide the path to stroke.
public protocol Strokable: Pathable {
    
    
    
    
    
    /// The stroke color track.
    var strokeColor: Track<Color> { get set }
    
    
    
    
    
    /// The stroke width track.
    var strokeWidth: Track<Scalar> { get set }
    
    
    
    
    
    /// The stroke start fraction track, from `0` to `1`.
    var strokeStart: Track<Scalar> { get set }
    
    
    
    
    
    /// The stroke end fraction track, from `0` to `1`.
    var strokeEnd: Track<Scalar> { get set }
    
    
    
    
    
    /// The miter limit track.
    ///
    /// Controls when a miter join is replaced by a bevel join
    /// for sharp angles. Higher values allow sharper miters.
    /// Defaults to `100`.
    var miterLimit: Track<Scalar> { get set }
    
    
    
    
    
    /// The dash pattern for the stroke.
    ///
    /// Defaults to `.solid` (no dashing).
    var dashPattern: DashPattern { get set }
    
    
    
    
    
}





// MARK: - Current Properties

/// Accessors for the current stroke property values.
extension Strokable {
    
    
    
    
    
    /// The current stroke color.
    public var currentStrokeColor: Color {
        return self.strokeColor.current
    }
    
    
    
    
    
    /// The current stroke width.
    public var currentStrokeWidth: Scalar {
        return self.strokeWidth.current
    }
    
    
    
    
    
    /// The current stroke start fraction.
    public var currentStrokeStart: Scalar {
        return self.strokeStart.current
    }
    
    
    
    
    
    /// The current stroke end fraction.
    public var currentStrokeEnd: Scalar {
        return self.strokeEnd.current
    }
    
    
    
    
    
    /// The current miter limit.
    public var currentMiterLimit: Scalar {
        return self.miterLimit.current
    }
    
    
    
    
    
    /// The current dash pattern.
    public var currentDashPattern: DashPattern {
        return self.dashPattern
    }
    
    
    
    
    
}





// MARK: - Trimmed Path

/// Computes the visible portion of the path based on stroke trim fractions.
extension Strokable {
    
    
    
    
    
    /// The current visible portion of the path, trimmed by
    /// `strokeStart` and `strokeEnd`.
    public var currentTrimmedPath: BezierPath {
        let start = self.currentStrokeStart
        let end = self.currentStrokeEnd
        if start <= 0 && end >= 1 {
            return self.currentPath
        }
        return self.currentPath.computeTrimmedPath(from: start, to: end)
    }
    
    
    
    
    
}





// MARK: - Property Setters

/// Methods for replacing stroke tracks with static values.
extension Strokable {
    
    
    
    
    
    /// Replaces the stroke color track with a static value.
    /// - Parameter strokeColor: The new stroke color.
    /// - Returns: This node, for chaining.
    @discardableResult
    public func setStrokeColor(to strokeColor: Color) -> Self {
        self.strokeColor = Track(strokeColor)
        return self
    }
    
    
    
    
    
    /// Replaces the stroke width track with a static value.
    ///
    /// The stroke width must be zero or positive.
    /// A precondition failure occurs if the value is negative.
    /// - Parameter strokeWidth: The new stroke width.
    /// - Returns: This node, for chaining.
    @discardableResult
    public func setStrokeWidth(to strokeWidth: Scalar) -> Self {
        precondition(strokeWidth >= 0, "Stroke width must not be negative.")
        self.strokeWidth = Track(strokeWidth)
        return self
    }
    
    
    
    
    
    /// Replaces the stroke start track with a static value.
    ///
    /// The stroke start must be in the range `0` to `1`.
    /// A precondition failure occurs if the value falls outside that range.
    /// - Parameter strokeStart: The new stroke start fraction.
    /// - Returns: This node, for chaining.
    @discardableResult
    public func setStrokeStart(to strokeStart: Scalar) -> Self {
        precondition(strokeStart >= 0 && strokeStart <= 1, "Stroke start must be between 0 and 1.")
        self.strokeStart = Track(strokeStart)
        return self
    }
    
    
    
    
    
    /// Replaces the stroke end track with a static value.
    ///
    /// The stroke end must be in the range `0` to `1`.
    /// A precondition failure occurs if the value falls outside that range.
    /// - Parameter strokeEnd: The new stroke end fraction.
    /// - Returns: This node, for chaining.
    @discardableResult
    public func setStrokeEnd(to strokeEnd: Scalar) -> Self {
        precondition(strokeEnd >= 0 && strokeEnd <= 1, "Stroke end must be between 0 and 1.")
        self.strokeEnd = Track(strokeEnd)
        return self
    }
    
    
    
    
    
    /// Replaces the miter limit track with a static value.
    ///
    /// The miter limit must be positive.
    /// A precondition failure occurs if the value is zero or negative.
    /// - Parameter miterLimit: The new miter limit.
    /// - Returns: This node, for chaining.
    @discardableResult
    public func setMiterLimit(to miterLimit: Scalar) -> Self {
        precondition(miterLimit > 0, "Miter limit must be positive.")
        self.miterLimit = Track(miterLimit)
        return self
    }
    
    
    
    
    
    /// Replaces the dash pattern with a new value.
    /// - Parameter dashPattern: The new dash pattern.
    /// - Returns: This node, for chaining.
    @discardableResult
    public func setDashPattern(to dashPattern: DashPattern) -> Self {
        self.dashPattern = dashPattern
        return self
    }
    
    
    
    
    
}





// MARK: - Drawing

/// Default stroke drawing implementation.
extension Strokable {
    
    
    
    
    
    /// Strokes the path into the canvas using this type's
    /// stroke color, width, miter limit, and dash pattern,
    /// respecting stroke trim.
    /// - Parameter canvas: The canvas to draw into.
    public func strokePath(in canvas: CoreGraphicsCanvas) {
        canvas.setMiterLimit(self.currentMiterLimit)
        canvas.setDashPattern(self.currentDashPattern)
        canvas.strokePath(
            self.currentTrimmedPath,
            color: self.currentStrokeColor,
            lineWidth: self.currentStrokeWidth
        )
    }
    
    
    
    
    
}
