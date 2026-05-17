import Foundation
import Sprogal





// MARK: - Declaration

/// A node that provides a bezier path.
///
/// `Curve` is the base class for all path-based nodes.
/// It holds a `BezierPath` track and computes bounds from it.
/// Subclasses opt into `Strokable`, `Fillable`, or both
/// to control how the path is rendered.
open class Curve: Node {
    
    
    
    
    
    /// The bezier path track for this curve.
    public internal(set) var path: Track<BezierPath>
    
    
    
    
    
    /// Creates a curve node from a bezier path.
    /// - Parameter path: The bezier path.
    public init(_ path: BezierPath) {
        self.path = Track(path)
        super.init()
    }
    
    
    
    
    
    /// The curve's bounding rectangle in local coordinates,
    /// derived from the path's bounds.
    open override func computeLocalBounds() -> Rect {
        guard !self.isEmpty else {
            return Rect(size: Size(width: 0, height: 0))
        }
        return self.currentPath.bounds
    }
    
    
    
    
    
    /// Evaluates the path track at the given time
    /// in addition to the base node tracks.
    /// - Parameter time: The time to evaluate at.
    open override func update(at time: Scalar) {
        super.update(at: time)
        self.path.update(at: time)
    }
    
    
    
    
    
}





// MARK: - Pathable

/// Confirms that `Curve` provides a bezier path.
extension Curve: Pathable {}





// MARK: - Current Path

/// Accessors for the curve's current path value.
extension Curve {
    
    
    
    
    
    /// The current bezier path.
    public var currentPath: BezierPath {
        return self.path.current
    }
    
    
    
    
    
}





// MARK: - Path Properties

/// Computed properties derived from the current path.
extension Curve {
    
    
    
    
    
    /// Whether the curve's path has any drawable geometry.
    public var isEmpty: Bool {
        return self.currentPath.subpaths.allSatisfy { $0.curves.isEmpty }
    }
    
    
    
    
    
    /// Whether the curve's path is closed.
    ///
    /// A path is closed when all of its subpaths are closed.
    /// An empty path is not considered closed.
    public var isClosed: Bool {
        guard !self.currentPath.subpaths.isEmpty else {
            return false
        }
        return self.currentPath.subpaths.allSatisfy { $0.isClosed }
    }
    
    
    
    
    
    /// The start point of the path, or the origin if the path is empty.
    public var startPoint: Point {
        return self.currentPath.subpaths.first?.startPoint ?? Point(x: 0, y: 0)
    }
    
    
    
    
    
    /// The end point of the path, or the origin if the path is empty.
    public var endPoint: Point {
        return self.currentPath.subpaths.last?.endPoint ?? Point(x: 0, y: 0)
    }
    
    
    
    
    
}





// MARK: - Property Setters

/// Methods for replacing the path track with a static value.
extension Curve {
    
    
    
    
    
    /// Replaces the path track with a static value, removing any animations.
    /// - Parameter path: The new bezier path.
    /// - Returns: This curve, for chaining.
    @discardableResult
    public func setPath(_ path: BezierPath) -> Self {
        self.path = Track(path)
        return self
    }
    
    
    
    
    
}
