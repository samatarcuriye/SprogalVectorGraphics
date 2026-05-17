import Foundation
import Sprogal





// MARK: - Path

/// Tweens for animating a curve node's path.
extension TweenBuilder {
    
    
    
    
    
    /// Animates the node's path to the given value.
    ///
    /// The node must conform to `Curve`. If it does not, the tween
    /// is created but has no effect at playback.
    /// - Parameters:
    ///   - path: The destination bezier path.
    ///   - duration: The duration of the animation in seconds.
    ///   - easing: The easing curve to apply. Defaults to `.cubicInOut`.
    /// - Returns: This builder, for chaining.
    @discardableResult
    public func setPath(to path: BezierPath, duration: Scalar, easing: Easing = .cubicInOut) -> TweenBuilder {
        let node = self.target
        let tween = Tween(duration: duration, node: node, property: "path") { startTime in
            guard let curve = node as? Curve else { return }
            let endTime = startTime + duration
            let currentPath = curve.path.value(at: startTime)
            curve.path.addKeyframe(Track<BezierPath>.Keyframe(currentPath, time: startTime, easing: .linear))
            curve.path.addKeyframe(Track<BezierPath>.Keyframe(path, time: endTime, easing: easing))
        }
        self.addTween(tween)
        return self
    }
    
    
    
    
    
}





// MARK: - Stroke

/// Tweens for animating stroke properties on strokable nodes.
extension TweenBuilder {
    
    
    
    
    
    /// Animates the node's stroke start to the given value.
    /// - Parameters:
    ///   - strokeStart: The destination stroke start value.
    ///   - duration: The duration of the animation in seconds.
    ///   - easing: The easing curve to apply. Defaults to `.cubicInOut`.
    /// - Returns: This builder, for chaining.
    @discardableResult
    public func setStrokeStart(to strokeStart: Scalar, duration: Scalar, easing: Easing = .cubicInOut) -> TweenBuilder {
        let node = self.target
        let tween = Tween(duration: duration, node: node, property: "strokeStart") { startTime in
            guard let strokable = node as? Strokable else { return }
            let endTime = startTime + duration
            let currentStart = strokable.strokeStart.value(at: startTime)
            strokable.strokeStart.addKeyframe(Track<Scalar>.Keyframe(currentStart, time: startTime, easing: .linear))
            strokable.strokeStart.addKeyframe(Track<Scalar>.Keyframe(strokeStart, time: endTime, easing: easing))
        }
        self.addTween(tween)
        return self
    }
    
    
    
    
    
    /// Animates the node's stroke end to the given value.
    /// - Parameters:
    ///   - strokeEnd: The destination stroke end value.
    ///   - duration: The duration of the animation in seconds.
    ///   - easing: The easing curve to apply. Defaults to `.cubicInOut`.
    /// - Returns: This builder, for chaining.
    @discardableResult
    public func setStrokeEnd(to strokeEnd: Scalar, duration: Scalar, easing: Easing = .cubicInOut) -> TweenBuilder {
        let node = self.target
        let tween = Tween(duration: duration, node: node, property: "strokeEnd") { startTime in
            guard let strokable = node as? Strokable else { return }
            let endTime = startTime + duration
            let currentEnd = strokable.strokeEnd.value(at: startTime)
            strokable.strokeEnd.addKeyframe(Track<Scalar>.Keyframe(currentEnd, time: startTime, easing: .linear))
            strokable.strokeEnd.addKeyframe(Track<Scalar>.Keyframe(strokeEnd, time: endTime, easing: easing))
        }
        self.addTween(tween)
        return self
    }
    
    
    
    
    
    /// Animates the node's stroke color to the given value.
    /// - Parameters:
    ///   - strokeColor: The destination stroke color.
    ///   - duration: The duration of the animation in seconds.
    ///   - easing: The easing curve to apply. Defaults to `.cubicInOut`.
    /// - Returns: This builder, for chaining.
    @discardableResult
    public func setStrokeColor(to strokeColor: Color, duration: Scalar, easing: Easing = .cubicInOut) -> TweenBuilder {
        let node = self.target
        let tween = Tween(duration: duration, node: node, property: "strokeColor") { startTime in
            guard let strokable = node as? Strokable else { return }
            let endTime = startTime + duration
            let currentColor = strokable.strokeColor.value(at: startTime)
            strokable.strokeColor.addKeyframe(Track<Color>.Keyframe(currentColor, time: startTime, easing: .linear))
            strokable.strokeColor.addKeyframe(Track<Color>.Keyframe(strokeColor, time: endTime, easing: easing))
        }
        self.addTween(tween)
        return self
    }
    
    
    
    
    
    /// Animates the node's stroke width to the given value.
    /// - Parameters:
    ///   - strokeWidth: The destination stroke width.
    ///   - duration: The duration of the animation in seconds.
    ///   - easing: The easing curve to apply. Defaults to `.cubicInOut`.
    /// - Returns: This builder, for chaining.
    @discardableResult
    public func setStrokeWidth(to strokeWidth: Scalar, duration: Scalar, easing: Easing = .cubicInOut) -> TweenBuilder {
        let node = self.target
        let tween = Tween(duration: duration, node: node, property: "strokeWidth") { startTime in
            guard let strokable = node as? Strokable else { return }
            let endTime = startTime + duration
            let currentWidth = strokable.strokeWidth.value(at: startTime)
            strokable.strokeWidth.addKeyframe(Track<Scalar>.Keyframe(currentWidth, time: startTime, easing: .linear))
            strokable.strokeWidth.addKeyframe(Track<Scalar>.Keyframe(strokeWidth, time: endTime, easing: easing))
        }
        self.addTween(tween)
        return self
    }
    
    
    
    
    
    /// Animates the node's miter limit to the given value.
    /// - Parameters:
    ///   - miterLimit: The destination miter limit.
    ///   - duration: The duration of the animation in seconds.
    ///   - easing: The easing curve to apply. Defaults to `.cubicInOut`.
    /// - Returns: This builder, for chaining.
    @discardableResult
    public func setMiterLimit(to miterLimit: Scalar, duration: Scalar, easing: Easing = .cubicInOut) -> TweenBuilder {
        let node = self.target
        let tween = Tween(duration: duration, node: node, property: "miterLimit") { startTime in
            guard let strokable = node as? Strokable else { return }
            let endTime = startTime + duration
            let currentLimit = strokable.miterLimit.value(at: startTime)
            strokable.miterLimit.addKeyframe(Track<Scalar>.Keyframe(currentLimit, time: startTime, easing: .linear))
            strokable.miterLimit.addKeyframe(Track<Scalar>.Keyframe(miterLimit, time: endTime, easing: easing))
        }
        self.addTween(tween)
        return self
    }
    
    
    
    
    
}





// MARK: - Fill

/// Tweens for animating fill properties on fillable nodes.
extension TweenBuilder {
    
    
    
    
    
    /// Animates the node's fill color to the given value.
    /// - Parameters:
    ///   - fillColor: The destination fill color.
    ///   - duration: The duration of the animation in seconds.
    ///   - easing: The easing curve to apply. Defaults to `.cubicInOut`.
    /// - Returns: This builder, for chaining.
    @discardableResult
    public func setFillColor(to fillColor: Color, duration: Scalar, easing: Easing = .cubicInOut) -> TweenBuilder {
        let node = self.target
        let tween = Tween(duration: duration, node: node, property: "fillColor") { startTime in
            guard let fillable = node as? Fillable else { return }
            let endTime = startTime + duration
            let currentColor = fillable.fillColor.value(at: startTime)
            fillable.fillColor.addKeyframe(Track<Color>.Keyframe(currentColor, time: startTime, easing: .linear))
            fillable.fillColor.addKeyframe(Track<Color>.Keyframe(fillColor, time: endTime, easing: easing))
        }
        self.addTween(tween)
        return self
    }
    
    
    
    
    
}
