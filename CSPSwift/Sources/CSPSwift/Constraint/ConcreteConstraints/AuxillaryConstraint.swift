/**
 An`AuxillaryConstraint` is used to ensure that for a given `Variable`, `v`,
 associated with a dual `Variable`, `d`, the assignment for `v` is equal to the
 respective value in the assignment tuple of `d`.
 */
public struct AuxillaryConstraint: BinaryConstraint {
    let mainVariableName: String
    let dualVariableName: String

    public var variableNames: [String] {
        [mainVariableName, dualVariableName]
    }

    public init?(mainVariable: any Variable, dualVariable: TernaryVariable) {
        guard dualVariable.isAssociated(with: mainVariable) else {
            return nil
        }
        self.mainVariableName = mainVariable.name
        self.dualVariableName = dualVariable.name
    }

    public func isSatisfied(state: VariableSet) -> Bool {
        guard let mainVariable = state.getVariable(mainVariableName),
              let dualVariable = state.getVariable(dualVariableName, type: TernaryVariable.self) else {
            return false
        }
        return dualVariable.assignmentSatisfied(for: mainVariable)
    }

    public func isViolated(state: VariableSet) -> Bool {
        guard let mainVariable = state.getVariable(mainVariableName),
              let dualVariable = state.getVariable(dualVariableName, type: TernaryVariable.self) else {
            return false
        }
        return dualVariable.assignmentViolated(for: mainVariable)
    }
}

extension AuxillaryConstraint: Equatable {
    public static func == (lhs: AuxillaryConstraint, rhs: AuxillaryConstraint) -> Bool {
        lhs.mainVariableName.isEqual(rhs.mainVariableName)
        && lhs.dualVariableName.isEqual(rhs.dualVariableName)
    }
}
