import Foundation





// MARK: - Declaration

/// The rule used to determine which areas of a path are filled.
///
/// ```swift
/// // Winding rule (default) — fills based on winding direction.
/// // Inner shapes wound in opposite direction create holes.
/// FillRule.winding
///
/// // Even-odd rule — fills based on crossing count.
/// // Any enclosed region alternates between filled and unfilled.
/// FillRule.evenOdd
/// ```
public enum FillRule {
    
    
    
    
    
    /// The non-zero winding rule.
    ///
    /// A point is inside the path if a ray from that point
    /// crosses path segments with a non-zero net winding number.
    /// Subpaths wound in opposite directions create holes.
    case winding
    
    
    
    
    
    /// The even-odd rule.
    ///
    /// A point is inside the path if a ray from that point
    /// crosses an odd number of path segments. Each nested
    /// boundary alternates between filled and unfilled.
    case evenOdd
    
    
    
    
    
}
