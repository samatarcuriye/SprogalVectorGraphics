import Foundation
import Sprogal





// MARK: - Declaration

/// A 2D path composed of one or more subpaths, each a chain of
/// cubic Bézier curves anchored at a start point.
///
/// `BezierPath` always stores its geometry as cubic Bézier
/// curves. Straight lines are represented as degenerate cubics
/// via ``CubicBezierCurve/straightLine(from:to:)``,
/// so the storage is homogeneous and renderers only ever see one
/// curve type.
///
/// Paths are built immutably with a fluent API:
///
/// ```swift
/// let triangle = try BezierPath()
///     .move(to: Point(x: 0, y: 0))
///     .addLine(to: Point(x: 4, y: 0))
///     .addLine(to: Point(x: 2, y: 3))
///     .closeSubpath()
/// ```
///
/// Each builder method returns a new path; the original is
/// unchanged.
public struct BezierPath {
    
    
    
    
    
    /// The subpaths comprising this path, in the order they
    /// were added.
    public let subpaths: [Subpath]
    
    
    
    
    
    /// Creates an empty path with no subpaths.
    public init() {
        self.subpaths = []
    }
    
    
    
    
    
    /// Creates a path from explicitly provided subpaths.
    /// - Parameter subpaths: The subpaths comprising the path.
    public init(subpaths: [Subpath]) {
        self.subpaths = subpaths
    }
    
    
    
    
    
}





// MARK: - Subpath

/// A connected chain of curves within a bezier path.
extension BezierPath {
    
    
    
    
    
    /// A connected chain of curves anchored at a start point.
    ///
    /// The subpath begins at ``startPoint`` and continues
    /// through ``curves`` in order. A closed subpath ends at
    /// its ``startPoint``.
    public struct Subpath {
        
        
        
        
        
        /// The point at which the subpath begins.
        public let startPoint: Point
        
        
        
        
        
        /// The chain of curves forming the subpath, in order.
        public let curves: [CubicBezierCurve]
        
        
        
        
        
        /// `true` if the subpath is closed via
        /// ``BezierPath/closeSubpath()``.
        public let isClosed: Bool
        
        
        
        
        
        /// Creates a subpath with the given start point, curves, and closed flag.
        /// - Parameters:
        ///   - startPoint: The point at which the subpath begins.
        ///   - curves: The chain of curves forming the subpath.
        ///   - isClosed: Whether the subpath is closed.
        public init(startPoint: Point, curves: [CubicBezierCurve], isClosed: Bool) {
            self.startPoint = startPoint
            self.curves = curves
            self.isClosed = isClosed
        }
        
        
        
        
        
    }
    
    
    
    
    
}





// MARK: - Subpath Properties

/// Computed properties for subpaths.
extension BezierPath.Subpath {
    
    
    
    
    
    /// The end point of the subpath — the last curve's end
    /// anchor, or ``startPoint`` if the subpath has no curves.
    public var endPoint: Point {
        return self.curves.last?.endAnchorPoint ?? self.startPoint
    }
    
    
    
    
    
}





// MARK: - Subpath Interpolatable

/// Component-by-component interpolation between two subpaths.
extension BezierPath.Subpath: Interpolatable {
    
    
    
    
    
    /// Interpolates between two subpaths component by component.
    ///
    /// Both subpaths must have the same number of curves and the same
    /// closure state. If the structures do not match, the start subpath
    /// is returned unchanged.
    /// - Parameters:
    ///   - start: The subpath at `progress = 0`.
    ///   - end: The subpath at `progress = 1`.
    ///   - progress: The interpolation factor, typically in `0...1`.
    /// - Returns: The interpolated subpath.
    public static func interpolate(
        from start: BezierPath.Subpath,
        to end: BezierPath.Subpath,
        progress: Scalar
    ) -> BezierPath.Subpath {
        guard start.curves.count == end.curves.count,
              start.isClosed == end.isClosed else {
            return start
        }
        let interpolatedStartPoint = Point.interpolate(
            from: start.startPoint,
            to: end.startPoint,
            progress: progress
        )
        let interpolatedCurves = zip(start.curves, end.curves).map { startCurve, endCurve in
            return BezierPath.CubicBezierCurve.interpolate(
                from: startCurve,
                to: endCurve,
                progress: progress
            )
        }
        return BezierPath.Subpath(
            startPoint: interpolatedStartPoint,
            curves: interpolatedCurves,
            isClosed: start.isClosed
        )
    }
    
    
    
    
    
}





// MARK: - CubicBezierCurve

/// A cubic Bézier curve nested within a bezier path.
extension BezierPath {
    
    
    
    
    
    /// A cubic Bézier curve defined by two anchor points and
    /// two control points.
    ///
    /// A cubic Bézier curve interpolates smoothly from
    /// ``startAnchorPoint`` to ``endAnchorPoint``, with its
    /// shape pulled toward ``startControlPoint`` near the
    /// beginning and toward ``endControlPoint`` near the end.
    public struct CubicBezierCurve {
        
        
        
        
        
        /// The point at which the curve begins.
        public let startAnchorPoint: Point
        
        
        
        
        
        /// The off-curve point that influences the curvature
        /// near ``startAnchorPoint``.
        public let startControlPoint: Point
        
        
        
        
        
        /// The off-curve point that influences the curvature
        /// near ``endAnchorPoint``.
        public let endControlPoint: Point
        
        
        
        
        
        /// The point at which the curve ends.
        public let endAnchorPoint: Point
        
        
        
        
        
        /// Creates a cubic Bézier curve from its four defining points.
        /// - Parameters:
        ///   - startAnchorPoint: The point at which the curve begins.
        ///   - startControlPoint: The off-curve point influencing curvature near the start.
        ///   - endControlPoint: The off-curve point influencing curvature near the end.
        ///   - endAnchorPoint: The point at which the curve ends.
        public init(
            startAnchorPoint: Point,
            startControlPoint: Point,
            endControlPoint: Point,
            endAnchorPoint: Point
        ) {
            self.startAnchorPoint = startAnchorPoint
            self.startControlPoint = startControlPoint
            self.endControlPoint = endControlPoint
            self.endAnchorPoint = endAnchorPoint
        }
        
        
        
        
        
    }
    
    
    
    
    
}





// MARK: - CubicBezierCurve Construction

/// Factory methods for creating common curve shapes.
extension BezierPath.CubicBezierCurve {
    
    
    
    
    
    /// Creates a degenerate curve that traces a straight line
    /// between two points.
    ///
    /// The control points are placed one third and two thirds
    /// of the way along the line, causing the curve to collapse
    /// onto the straight line connecting them.
    /// - Parameters:
    ///   - startPoint: The point at which the line begins.
    ///   - endPoint: The point at which the line ends.
    /// - Returns: A cubic Bézier curve whose path is a straight line.
    public static func straightLine(from startPoint: Point, to endPoint: Point) -> BezierPath.CubicBezierCurve {
        let startToEnd = Vector(
            dx: endPoint.x - startPoint.x,
            dy: endPoint.y - startPoint.y
        )
        return BezierPath.CubicBezierCurve(
            startAnchorPoint: startPoint,
            startControlPoint: startPoint + (1.0 / 3.0) * startToEnd,
            endControlPoint: endPoint - (1.0 / 3.0) * startToEnd,
            endAnchorPoint: endPoint
        )
    }
    
    
    
    
    
}





// MARK: - CubicBezierCurve Evaluation

/// Methods for evaluating points on the curve.
extension BezierPath.CubicBezierCurve {
    
    
    
    
    
    /// Evaluates the curve at the given progress using the explicit
    /// cubic Bézier formula.
    /// - Parameter progress: The parameter, in `0...1`.
    /// - Returns: The point on the curve at the given progress.
    public func evaluate(at progress: Scalar) -> Point {
        let oneMinusProgress = 1 - progress
        let oneMinusProgressSquared = oneMinusProgress * oneMinusProgress
        let oneMinusProgressCubed = oneMinusProgressSquared * oneMinusProgress
        let progressSquared = progress * progress
        let progressCubed = progressSquared * progress
        
        let x = oneMinusProgressCubed * self.startAnchorPoint.x
            + 3 * oneMinusProgressSquared * progress * self.startControlPoint.x
            + 3 * oneMinusProgress * progressSquared * self.endControlPoint.x
            + progressCubed * self.endAnchorPoint.x
        let y = oneMinusProgressCubed * self.startAnchorPoint.y
            + 3 * oneMinusProgressSquared * progress * self.startControlPoint.y
            + 3 * oneMinusProgress * progressSquared * self.endControlPoint.y
            + progressCubed * self.endAnchorPoint.y
        
        return Point(x: x, y: y)
    }
    
    
    
    
    
}





// MARK: - CubicBezierCurve Subdivision

/// Methods for splitting the curve at a given parameter.
extension BezierPath.CubicBezierCurve {
    
    
    
    
    
    /// Splits the curve at the given progress using De Casteljau's
    /// algorithm, returning two curves that together trace the
    /// same shape as the original.
    ///
    /// The first element is the portion from `0` to `progress`, the
    /// second is the portion from `progress` to `1`.
    /// - Parameter progress: The parameter at which to split, in `0...1`.
    /// - Returns: An array of two curves: the leading and trailing portions.
    public func split(at progress: Scalar) -> [BezierPath.CubicBezierCurve] {
        let midStartAnchorStartControl = Point.interpolate(
            from: self.startAnchorPoint,
            to: self.startControlPoint,
            progress: progress
        )
        let midStartControlEndControl = Point.interpolate(
            from: self.startControlPoint,
            to: self.endControlPoint,
            progress: progress
        )
        let midEndControlEndAnchor = Point.interpolate(
            from: self.endControlPoint,
            to: self.endAnchorPoint,
            progress: progress
        )
        let midLeft = Point.interpolate(
            from: midStartAnchorStartControl,
            to: midStartControlEndControl,
            progress: progress
        )
        let midRight = Point.interpolate(
            from: midStartControlEndControl,
            to: midEndControlEndAnchor,
            progress: progress
        )
        let splitPoint = Point.interpolate(
            from: midLeft,
            to: midRight,
            progress: progress
        )
        
        let leadingCurve = BezierPath.CubicBezierCurve(
            startAnchorPoint: self.startAnchorPoint,
            startControlPoint: midStartAnchorStartControl,
            endControlPoint: midLeft,
            endAnchorPoint: splitPoint
        )
        let trailingCurve = BezierPath.CubicBezierCurve(
            startAnchorPoint: splitPoint,
            startControlPoint: midRight,
            endControlPoint: midEndControlEndAnchor,
            endAnchorPoint: self.endAnchorPoint
        )
        
        return [leadingCurve, trailingCurve]
    }
    
    
    
    
    
}





// MARK: - CubicBezierCurve Arc Length

/// Methods for computing the approximate arc length of the curve.
extension BezierPath.CubicBezierCurve {
    
    
    
    
    
    /// Computes the approximate arc length of the curve using
    /// recursive subdivision.
    ///
    /// Subdivides the curve until each piece is close enough
    /// to a straight line, then averages the chord length and
    /// control-polygon length as the estimate.
    /// - Parameter tolerance: The maximum allowed difference
    ///   between chord and control-polygon length before
    ///   subdivision stops. Defaults to `0.001`.
    /// - Returns: The approximate arc length of the curve.
    public func computeArcLength(tolerance: Scalar = 0.001) -> Scalar {
        let chord = self.computeChordLength()
        let polygon = self.computeControlPolygonLength()
        if polygon - chord <= tolerance {
            return (chord + polygon) / 2
        }
        let halves = self.split(at: 0.5)
        return halves[0].computeArcLength(tolerance: tolerance)
            + halves[1].computeArcLength(tolerance: tolerance)
    }
    
    
    
    
    
    /// Computes the straight-line distance from the start anchor
    /// to the end anchor.
    /// - Returns: The chord length.
    private func computeChordLength() -> Scalar {
        return self.startAnchorPoint.distance(to: self.endAnchorPoint)
    }
    
    
    
    
    
    /// Computes the total length of the control polygon — the polyline
    /// through all four defining points in order.
    /// - Returns: The control polygon length.
    private func computeControlPolygonLength() -> Scalar {
        return self.startAnchorPoint.distance(to: self.startControlPoint)
            + self.startControlPoint.distance(to: self.endControlPoint)
            + self.endControlPoint.distance(to: self.endAnchorPoint)
    }
    
    
    
    
    
}





// MARK: - CubicBezierCurve Bounds

/// Tight bounding rectangle computation for the curve.
extension BezierPath.CubicBezierCurve {
    
    
    
    
    
    /// The tight axis-aligned bounding rectangle of the curve.
    ///
    /// Computed by finding the parameter values where the curve
    /// reaches its extrema in x and y, evaluating at those
    /// parameters, and taking the min/max across all candidate
    /// points plus the endpoints.
    public var bounds: Rect {
        var minX = min(self.startAnchorPoint.x, self.endAnchorPoint.x)
        var maxX = max(self.startAnchorPoint.x, self.endAnchorPoint.x)
        var minY = min(self.startAnchorPoint.y, self.endAnchorPoint.y)
        var maxY = max(self.startAnchorPoint.y, self.endAnchorPoint.y)
        
        let xExtrema = self.computeExtremaParameters(
            startAnchor: self.startAnchorPoint.x,
            startControl: self.startControlPoint.x,
            endControl: self.endControlPoint.x,
            endAnchor: self.endAnchorPoint.x
        )
        let yExtrema = self.computeExtremaParameters(
            startAnchor: self.startAnchorPoint.y,
            startControl: self.startControlPoint.y,
            endControl: self.endControlPoint.y,
            endAnchor: self.endAnchorPoint.y
        )
        
        for parameter in xExtrema {
            let extremeX = self.evaluate(at: parameter).x
            if extremeX < minX { minX = extremeX }
            if extremeX > maxX { maxX = extremeX }
        }
        for parameter in yExtrema {
            let extremeY = self.evaluate(at: parameter).y
            if extremeY < minY { minY = extremeY }
            if extremeY > maxY { maxY = extremeY }
        }
        
        return Rect(containing: [
            Point(x: minX, y: minY),
            Point(x: maxX, y: maxY)
        ])
    }
    
    
    
    
    
    /// Returns the parameter values in `(0, 1)` where the
    /// derivative of one axis of the curve is zero.
    private func computeExtremaParameters(
        startAnchor: Scalar,
        startControl: Scalar,
        endControl: Scalar,
        endAnchor: Scalar
    ) -> [Scalar] {
        let coefficients = self.computeDerivativeCoefficients(
            startAnchor: startAnchor,
            startControl: startControl,
            endControl: endControl,
            endAnchor: endAnchor
        )
        let roots = self.solveQuadratic(
            a: coefficients.0,
            b: coefficients.1,
            c: coefficients.2
        )
        return roots.filter { $0 > 0 && $0 < 1 }
    }
    
    
    
    
    
    /// Computes the coefficients of the quadratic derivative
    /// for one axis of the curve.
    private func computeDerivativeCoefficients(
        startAnchor: Scalar,
        startControl: Scalar,
        endControl: Scalar,
        endAnchor: Scalar
    ) -> (Scalar, Scalar, Scalar) {
        let c = 3 * (startControl - startAnchor)
        let b = 6 * (endControl - startControl) - 2 * c
        let a = 3 * (endAnchor - endControl) - c - b
        return (a, b, c)
    }
    
    
    
    
    
    /// Solves the quadratic equation `at² + bt + c = 0`,
    /// returning all real roots.
    private func solveQuadratic(a: Scalar, b: Scalar, c: Scalar) -> [Scalar] {
        if abs(a) < Scalar(1e-12) {
            return self.solveLinear(a: b, b: c)
        }
        let discriminant = b * b - 4 * a * c
        if discriminant < 0 {
            return []
        }
        let sqrtDiscriminant = sqrt(discriminant)
        let denominator = 2 * a
        let firstRoot = (-b - sqrtDiscriminant) / denominator
        let secondRoot = (-b + sqrtDiscriminant) / denominator
        if abs(discriminant) < Scalar(1e-12) {
            return [firstRoot]
        }
        return [firstRoot, secondRoot]
    }
    
    
    
    
    
    /// Solves the linear equation `at + b = 0`.
    private func solveLinear(a: Scalar, b: Scalar) -> [Scalar] {
        if abs(a) < Scalar(1e-12) {
            return []
        }
        return [-b / a]
    }
    
    
    
    
    
}





// MARK: - CubicBezierCurve Interpolatable

/// Point-by-point interpolation between two cubic Bézier curves.
extension BezierPath.CubicBezierCurve: Interpolatable {
    
    
    
    
    
    /// Interpolates between two curves by interpolating each
    /// of their four defining points.
    /// - Parameters:
    ///   - startCurve: The curve at `progress = 0`.
    ///   - endCurve: The curve at `progress = 1`.
    ///   - progress: The interpolation factor, typically in `0...1`.
    /// - Returns: The interpolated curve.
    public static func interpolate(
        from startCurve: BezierPath.CubicBezierCurve,
        to endCurve: BezierPath.CubicBezierCurve,
        progress: Scalar
    ) -> BezierPath.CubicBezierCurve {
        return BezierPath.CubicBezierCurve(
            startAnchorPoint: Point.interpolate(
                from: startCurve.startAnchorPoint,
                to: endCurve.startAnchorPoint,
                progress: progress
            ),
            startControlPoint: Point.interpolate(
                from: startCurve.startControlPoint,
                to: endCurve.startControlPoint,
                progress: progress
            ),
            endControlPoint: Point.interpolate(
                from: startCurve.endControlPoint,
                to: endCurve.endControlPoint,
                progress: progress
            ),
            endAnchorPoint: Point.interpolate(
                from: startCurve.endAnchorPoint,
                to: endCurve.endAnchorPoint,
                progress: progress
            )
        )
    }
    
    
    
    
    
}





// MARK: - Interpolatable

/// Component-by-component interpolation between two bezier paths.
extension BezierPath: Interpolatable {
    
    
    
    
    
    /// Interpolates between two paths component by component.
    ///
    /// Both paths must have the same number of subpaths, and each
    /// corresponding pair must have the same number of curves and
    /// the same closure state. If the structures do not match, the
    /// start path is returned unchanged.
    /// - Parameters:
    ///   - start: The path at `progress = 0`.
    ///   - end: The path at `progress = 1`.
    ///   - progress: The interpolation factor, typically in `0...1`.
    /// - Returns: The interpolated path.
    public static func interpolate(
        from start: BezierPath,
        to end: BezierPath,
        progress: Scalar
    ) -> BezierPath {
        guard start.subpaths.count == end.subpaths.count else {
            return start
        }
        let interpolatedSubpaths = zip(start.subpaths, end.subpaths).map { startSubpath, endSubpath in
            return BezierPath.Subpath.interpolate(
                from: startSubpath,
                to: endSubpath,
                progress: progress
            )
        }
        return BezierPath(subpaths: interpolatedSubpaths)
    }
    
    
    
    
    
}





// MARK: - Bounds

/// Bounding rectangle computation for the entire path.
extension BezierPath {
    
    
    
    
    
    /// The tight axis-aligned bounding rectangle enclosing the
    /// entire path.
    ///
    /// Computed by taking the union of every curve's tight bounds
    /// across all subpaths. An empty path returns a zero-size
    /// rectangle at the origin.
    public var bounds: Rect {
        let corners = self.computeAllCurveCorners()
        guard !corners.isEmpty else {
            return Rect(size: Size(width: 0, height: 0))
        }
        return Rect(containing: corners)
    }
    
    
    
    
    
    /// Collects the bounding-box corners of every curve across
    /// all subpaths.
    /// - Returns: The combined corner points.
    private func computeAllCurveCorners() -> [Point] {
        var allCorners: [Point] = []
        for subpath in self.subpaths {
            for curve in subpath.curves {
                allCorners.append(contentsOf: curve.bounds.corners)
            }
        }
        return allCorners
    }
    
    
    
    
    
}





// MARK: - Arc Length

/// Arc length computation for the entire path.
extension BezierPath {
    
    
    
    
    
    /// Computes the total arc length of the path — the sum of
    /// the arc lengths of all curves across all subpaths.
    /// - Parameter tolerance: The subdivision tolerance passed
    ///   to each curve's arc-length computation. Defaults to `0.001`.
    /// - Returns: The total arc length in logical units.
    public func computeArcLength(tolerance: Scalar = 0.001) -> Scalar {
        var totalLength: Scalar = 0
        for subpath in self.subpaths {
            for curve in subpath.curves {
                totalLength = totalLength + curve.computeArcLength(tolerance: tolerance)
            }
        }
        return totalLength
    }
    
    
    
    
    
}





// MARK: - Trimming

/// Methods for extracting a portion of the path by arc-length fraction.
extension BezierPath {
    
    
    
    
    
    /// Computes a new path containing only the portion between
    /// `startFraction` and `endFraction` of the total arc length.
    ///
    /// Both fractions are in `0...1` and are clamped. If
    /// `startFraction >= endFraction`, an empty path is returned.
    /// - Parameters:
    ///   - startFraction: The fraction at which the trimmed path begins.
    ///   - endFraction: The fraction at which the trimmed path ends.
    /// - Returns: The trimmed path.
    public func computeTrimmedPath(from startFraction: Scalar, to endFraction: Scalar) -> BezierPath {
        let clampedStart = max(0, min(1, startFraction))
        let clampedEnd = max(0, min(1, endFraction))
        guard clampedStart < clampedEnd else {
            return BezierPath()
        }
        
        let totalLength = self.computeArcLength()
        guard totalLength > 0 else {
            return self
        }
        
        let trimStartDistance = clampedStart * totalLength
        let trimEndDistance = clampedEnd * totalLength
        let trimmedCurves = self.collectTrimmedCurves(
            from: trimStartDistance,
            to: trimEndDistance
        )
        
        return self.buildPathFromCurves(trimmedCurves)
    }
    
    
    
    
    
    /// Walks all curves and collects the portions that fall
    /// within the given arc-length distance range.
    private func collectTrimmedCurves(
        from trimStartDistance: Scalar,
        to trimEndDistance: Scalar
    ) -> [CubicBezierCurve] {
        var distanceTraversed: Scalar = 0
        var collectedCurves: [CubicBezierCurve] = []
        
        for subpath in self.subpaths {
            for curve in subpath.curves {
                let curveLength = curve.computeArcLength()
                let curveStartDistance = distanceTraversed
                let curveEndDistance = distanceTraversed + curveLength
                defer { distanceTraversed = curveEndDistance }
                
                if curveEndDistance <= trimStartDistance {
                    continue
                }
                if curveStartDistance >= trimEndDistance {
                    return collectedCurves
                }
                
                let trimmedCurve = self.computeTrimmedCurve(
                    curve,
                    curveLength: curveLength,
                    curveStartDistance: curveStartDistance,
                    curveEndDistance: curveEndDistance,
                    trimStartDistance: trimStartDistance,
                    trimEndDistance: trimEndDistance
                )
                collectedCurves.append(trimmedCurve)
            }
        }
        
        return collectedCurves
    }
    
    
    
    
    
    /// Trims a single curve to the portion that falls within
    /// the trim distance range.
    private func computeTrimmedCurve(
        _ curve: CubicBezierCurve,
        curveLength: Scalar,
        curveStartDistance: Scalar,
        curveEndDistance: Scalar,
        trimStartDistance: Scalar,
        trimEndDistance: Scalar
    ) -> CubicBezierCurve {
        var workingCurve = curve
        var workingCurveLength = curveLength
        var workingStartDistance = curveStartDistance
        
        if curveStartDistance < trimStartDistance {
            let splitParameter = BezierPath.computeParameterAtDistance(
                trimStartDistance - curveStartDistance,
                along: workingCurve,
                totalCurveLength: workingCurveLength
            )
            workingCurve = workingCurve.split(at: splitParameter)[1]
            workingCurveLength = workingCurve.computeArcLength()
            workingStartDistance = trimStartDistance
        }
        
        if curveEndDistance > trimEndDistance {
            let distanceToKeep = trimEndDistance - workingStartDistance
            let splitParameter = BezierPath.computeParameterAtDistance(
                distanceToKeep,
                along: workingCurve,
                totalCurveLength: workingCurveLength
            )
            workingCurve = workingCurve.split(at: splitParameter)[0]
        }
        
        return workingCurve
    }
    
    
    
    
    
    /// Assembles a single-subpath open path from the given curves,
    /// or returns an empty path if there are no curves.
    private func buildPathFromCurves(_ curves: [CubicBezierCurve]) -> BezierPath {
        guard let firstCurve = curves.first else {
            return BezierPath()
        }
        let subpath = Subpath(
            startPoint: firstCurve.startAnchorPoint,
            curves: curves,
            isClosed: false
        )
        return BezierPath(subpaths: [subpath])
    }
    
    
    
    
    
}





// MARK: - Parameter at Distance

/// Binary search for the curve parameter at a given arc-length distance.
extension BezierPath {
    
    
    
    
    
    /// Approximates the parameter on a curve at which a given
    /// arc-length distance from the curve's start is reached.
    ///
    /// Uses binary search over the parameter space.
    /// - Parameters:
    ///   - targetDistance: The target arc-length distance.
    ///   - curve: The curve to search.
    ///   - totalCurveLength: The total arc length of the curve.
    /// - Returns: The parameter in `0...1`.
    private static func computeParameterAtDistance(
        _ targetDistance: Scalar,
        along curve: CubicBezierCurve,
        totalCurveLength: Scalar
    ) -> Scalar {
        guard totalCurveLength > 0 else {
            return 0
        }
        
        var lowerBound: Scalar = 0
        var upperBound: Scalar = 1
        var candidateParameter = targetDistance / totalCurveLength
        let tolerance: Scalar = 0.001
        let maxIterations = 20
        
        for _ in 0..<maxIterations {
            let measuredDistance = curve.split(at: candidateParameter)[0].computeArcLength()
            let error = measuredDistance - targetDistance
            
            if abs(error) < tolerance {
                return candidateParameter
            }
            
            if error > 0 {
                upperBound = candidateParameter
            } else {
                lowerBound = candidateParameter
            }
            
            candidateParameter = (lowerBound + upperBound) / 2
        }
        
        return candidateParameter
    }
    
    
    
    
    
}





// MARK: - Reversal

/// Methods for reversing the direction of the path.
extension BezierPath {
    
    
    
    
    
    /// Computes a new path that traces the same geometry in the
    /// opposite direction.
    ///
    /// Each subpath is reversed independently: curves are
    /// reordered from last to first, and each curve's start
    /// and end points are swapped. The closure state of each
    /// subpath is preserved.
    /// - Returns: The reversed path.
    public func computeReversedPath() -> BezierPath {
        let reversedSubpaths = self.subpaths.map { subpath in
            let reversedCurves = subpath.curves.reversed().map { curve in
                return CubicBezierCurve(
                    startAnchorPoint: curve.endAnchorPoint,
                    startControlPoint: curve.endControlPoint,
                    endControlPoint: curve.startControlPoint,
                    endAnchorPoint: curve.startAnchorPoint
                )
            }
            return Subpath(
                startPoint: subpath.endPoint,
                curves: reversedCurves,
                isClosed: subpath.isClosed
            )
        }
        return BezierPath(subpaths: reversedSubpaths)
    }
    
    
    
    
    
}





// MARK: - Building

/// Fluent builder methods for constructing paths immutably.
extension BezierPath {
    
    
    
    
    
    /// Begins a new subpath anchored at the given point.
    ///
    /// If the previous subpath has no curves, it is replaced
    /// rather than retained, so consecutive moves do not
    /// accumulate empty subpaths.
    /// - Parameter point: The anchor for the new subpath.
    /// - Returns: A new path with the move-to applied.
    public func move(to point: Point) -> BezierPath {
        let newSubpath = Subpath(
            startPoint: point,
            curves: [],
            isClosed: false
        )
        var newSubpaths = self.subpaths
        if let last = newSubpaths.last, last.curves.isEmpty {
            newSubpaths[newSubpaths.count - 1] = newSubpath
        } else {
            newSubpaths.append(newSubpath)
        }
        return BezierPath(subpaths: newSubpaths)
    }
    
    
    
    
    
    /// Appends a cubic Bézier curve to the active subpath.
    /// - Parameter curve: The curve to append.
    /// - Returns: A new path with the curve appended.
    /// - Throws: ``BezierPathError/noActiveSubpath`` if there is no open subpath.
    public func addCurve(_ curve: CubicBezierCurve) throws -> BezierPath {
        let active = try self.requireActiveSubpath()
        return self.appendingCurve(curve, to: active)
    }
    
    
    
    
    
    /// Appends a straight line from the current point to the given point.
    /// - Parameter point: The end point of the line.
    /// - Returns: A new path with the line appended.
    /// - Throws: ``BezierPathError/noActiveSubpath`` if there is no open subpath.
    public func addLine(to point: Point) throws -> BezierPath {
        let active = try self.requireActiveSubpath()
        let curve = CubicBezierCurve.straightLine(from: active.endPoint, to: point)
        return self.appendingCurve(curve, to: active)
    }
    
    
    
    
    
    /// Closes the active subpath.
    ///
    /// If the active subpath's last curve does not already end at the
    /// subpath's start point, a closing straight line is appended.
    /// - Returns: A new path with the active subpath closed.
    /// - Throws: ``BezierPathError/noActiveSubpath`` if there is no open subpath;
    ///   ``BezierPathError/cannotCloseEmptySubpath`` if the active subpath has no curves.
    public func closeSubpath() throws -> BezierPath {
        let active = try self.requireActiveSubpath()
        let closedSubpath = try self.computeClosedSubpath(active)
        var newSubpaths = self.subpaths
        newSubpaths[newSubpaths.count - 1] = closedSubpath
        return BezierPath(subpaths: newSubpaths)
    }
    
    
    
    
    
    /// Returns the active subpath if one exists and is open.
    /// - Returns: The active subpath.
    /// - Throws: ``BezierPathError/noActiveSubpath``.
    private func requireActiveSubpath() throws -> Subpath {
        guard let last = self.subpaths.last else {
            throw BezierPathError.noActiveSubpath
        }
        guard !last.isClosed else {
            throw BezierPathError.noActiveSubpath
        }
        return last
    }
    
    
    
    
    
    /// Returns a new path with the given curve appended to the active subpath.
    private func appendingCurve(_ curve: CubicBezierCurve, to active: Subpath) -> BezierPath {
        var curves = active.curves
        curves.append(curve)
        let updated = Subpath(
            startPoint: active.startPoint,
            curves: curves,
            isClosed: active.isClosed
        )
        var newSubpaths = self.subpaths
        newSubpaths[newSubpaths.count - 1] = updated
        return BezierPath(subpaths: newSubpaths)
    }
    
    
    
    
    
    /// Returns a closed copy of the given subpath, appending a closing line if needed.
    /// - Throws: ``BezierPathError/cannotCloseEmptySubpath`` if the subpath has no curves.
    private func computeClosedSubpath(_ active: Subpath) throws -> Subpath {
        guard let lastCurve = active.curves.last else {
            throw BezierPathError.cannotCloseEmptySubpath
        }
        var curves = active.curves
        if lastCurve.endAnchorPoint != active.startPoint {
            curves.append(
                CubicBezierCurve.straightLine(
                    from: lastCurve.endAnchorPoint,
                    to: active.startPoint
                )
            )
        }
        return Subpath(
            startPoint: active.startPoint,
            curves: curves,
            isClosed: true
        )
    }
    
    
    
    
    
}





// MARK: - BezierPathError

/// Errors raised by bezier path builder methods.
extension BezierPath {
    
    
    
    
    
    /// Errors specific to path construction.
    public enum BezierPathError: Error {
        
        
        
        
        
        /// A curve was added or a subpath was closed before any
        /// ``move(to:)``, or after the last subpath is already closed.
        case noActiveSubpath
        
        
        
        
        
        /// ``closeSubpath()`` was called on a subpath with no curves.
        case cannotCloseEmptySubpath
        
        
        
        
        
    }
    
    
    
    
    
}





// MARK: - LocalizedError

/// Provides human-readable descriptions for bezier path errors.
extension BezierPath.BezierPathError: LocalizedError {
    
    
    
    
    
    /// A human-readable description of the error.
    public var errorDescription: String? {
        switch self {
        case .noActiveSubpath:
            return "No active subpath. Call move(to:) before adding curves or closing the subpath."
        case .cannotCloseEmptySubpath:
            return "Cannot close a subpath with no curves. Add at least one curve after move(to:) before closing."
        }
    }
    
    
    
    
    
}

