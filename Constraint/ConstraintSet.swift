/**
 `ConstraintSet` holds all the constraints for a given CSP.
 */
public struct ConstraintSet {
    private(set) var allConstraints: [any Constraint]
    
    public init(allConstraints: [any Constraint] = []) {
        self.allConstraints = allConstraints
    }
    
    public mutating func add(constraint: any Constraint) {
        allConstraints.append(constraint)
    }
    
    public var allSatisfied: Bool {
        return allConstraints.allSatisfy({ $0.isSatisfied })
    }
}

extension ConstraintSet: Copyable {
    public func copy() -> ConstraintSet {
        type(of: self).init(allConstraints: allConstraints.copy())
    }
}
