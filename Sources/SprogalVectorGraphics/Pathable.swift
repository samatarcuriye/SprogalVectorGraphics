import Foundation
import Sprogal





// MARK: - Declaration

/// A type that provides a bezier path for rendering.
///
/// Nodes that conform to `Pathable` expose a path that can be
/// used for filling, stroking, or hit testing.
public protocol Pathable: Node {
    
    
    
    
    
    /// The current bezier path that defines this shape's geometry.
    var currentPath: BezierPath { get }
    
    
    
    
    
}
