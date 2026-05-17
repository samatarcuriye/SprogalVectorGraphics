import Foundation
import Sprogal





// MARK: - Declaration

/// A type that can draw a filled region of its path.
///
/// Conforming types must also conform to `Pathable` to
/// provide the path to fill.
public protocol Fillable: Pathable {
    
    
    
    
    
    /// The fill color track.
    var fillColor: Track<Color> { get set }
    
    
    
    
    
    /// The fill rule used to determine which areas are filled.
    ///
    /// Defaults to `.winding`.
    var fillRule: FillRule { get set }
    
    
    
    
    
}





// MARK: - Current Properties

/// Accessors for the current fill property values.
extension Fillable {
    
    
    
    
    
    /// The current fill color.
    public var currentFillColor: Color {
        return self.fillColor.current
    }
    
    
    
    
    
    /// The current fill rule.
    public var currentFillRule: FillRule {
        return self.fillRule
    }
    
    
    
    
    
}





// MARK: - Property Setters

/// Methods for replacing fill tracks with static values.
extension Fillable {
    
    
    
    
    
    /// Replaces the fill color track with a static value.
    /// - Parameter fillColor: The new fill color.
    /// - Returns: This object, for chaining.
    @discardableResult
    public func setFillColor(to fillColor: Color) -> Self {
        self.fillColor = Track(fillColor)
        return self
    }
    
    
    
    
    
    /// Replaces the fill rule with a new value.
    /// - Parameter fillRule: The new fill rule.
    /// - Returns: This object, for chaining.
    @discardableResult
    public func setFillRule(to fillRule: FillRule) -> Self {
        self.fillRule = fillRule
        return self
    }
    
    
    
    
    
}





// MARK: - Drawing

/// Default fill drawing implementation.
extension Fillable {
    
    
    
    
    
    /// Fills the path into the canvas using this type's fill
    /// color and fill rule.
    /// - Parameter canvas: The canvas to draw into.
    public func fillPath(in canvas: CoreGraphicsCanvas) {
        canvas.fillPath(
            self.currentPath,
            color: self.currentFillColor,
            fillRule: self.currentFillRule
        )
    }
    
    
    
    
    
}
