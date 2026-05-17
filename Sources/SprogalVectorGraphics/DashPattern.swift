import Foundation
import Sprogal





// MARK: - Declaration

/// A pattern of dashes and gaps used to stroke a path.
///
/// The pattern repeats along the length of the path.
/// Each element alternates between a dash length and a gap
/// length.
///
/// ```swift
/// // Uniform dashes: 0.2 on, 0.1 off
/// DashPattern(lengths: [0.2, 0.1])
///
/// // Dash-dot: 0.3 on, 0.1 off, 0.05 on, 0.1 off
/// DashPattern(lengths: [0.3, 0.1, 0.05, 0.1])
///
/// // Offset start: begin 0.1 into the pattern
/// DashPattern(lengths: [0.2, 0.1], phase: 0.1)
/// ```
public struct DashPattern {
    
    
    
    
    
    /// The alternating dash and gap lengths.
    ///
    /// An empty array produces a solid stroke (no dashing).
    public let lengths: [Scalar]
    
    
    
    
    
    /// The offset into the pattern at which stroking begins.
    ///
    /// Defaults to `0`.
    public let phase: Scalar
    
    
    
    
    
    /// Creates a dash pattern with the given lengths and phase.
    ///
    /// A precondition failure occurs if any length is negative
    /// or if the phase is negative.
    /// - Parameters:
    ///   - lengths: The alternating dash and gap lengths.
    ///   - phase: The offset into the pattern. Defaults to `0`.
    public init(lengths: [Scalar], phase: Scalar = 0) {
        precondition(lengths.allSatisfy { $0 >= 0 }, "Dash lengths must not be negative.")
        precondition(phase >= 0, "Dash phase must not be negative.")
        
        self.lengths = lengths
        self.phase = phase
    }
    
    
    
    
    
    /// A solid pattern with no dashes.
    public static let solid = DashPattern(lengths: [])
    
    
    
    
    
}





// MARK: - Sendable

/// Confirms that `DashPattern` is safe to pass across concurrency boundaries.
extension DashPattern: Sendable {}
