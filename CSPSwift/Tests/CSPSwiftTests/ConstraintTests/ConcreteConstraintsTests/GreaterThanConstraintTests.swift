import XCTest
@testable import CSPSwift

final class GreaterThanConstraintTests: XCTestCase {
    var intVariableA: IntVariable!
    var intVariableB: IntVariable!

    var variableSet: VariableSet!

    var aGreaterThanBConstraint: GreaterThanConstraint!

    override func setUpWithError() throws {
        super.setUp()
        intVariableA = IntVariable(name: "intA", domain: [1, 4, 5])
        intVariableB = IntVariable(name: "intB", domain: [1, 2, 3])

        variableSet = try VariableSet(from: [intVariableA, intVariableB])

        aGreaterThanBConstraint = GreaterThanConstraint(intVariableA, isGreaterThan: intVariableB)
    }

    // MARK: Testing methods/attributes inherited from Constraint
    func testContainsAssignedVariable_allUnassigned_returnsFalse() {
        XCTAssertFalse(aGreaterThanBConstraint.containsAssignedVariable(state: variableSet))
    }

    func testContainsAssignedVariable_someAssigned_returnsTrue() throws {
        // assign A
        try variableSet.assign(intVariableA.name, to: 1)
        let assignmentA = try variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 1)

        XCTAssertTrue(aGreaterThanBConstraint.containsAssignedVariable(state: variableSet))

        // assign B
        try variableSet.assign(intVariableB.name, to: 2)
        let assignmentB = try variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 2)

        XCTAssertTrue(aGreaterThanBConstraint.containsAssignedVariable(state: variableSet))
    }

    // MARK: Testing methods/attributes inherited from BinaryConstraint
    func testDependsOn_validVariableName_returnsTrue() {
        XCTAssertTrue(aGreaterThanBConstraint.depends(on: intVariableA.name))
        XCTAssertTrue(aGreaterThanBConstraint.depends(on: intVariableB.name))
    }

    func testDependsOn_invalidVariableName_returnsFalse() {
        XCTAssertFalse(aGreaterThanBConstraint.depends(on: "nonExistentVariableName"))
    }

    func testVariableNameOtherThan_validVariableNames_returnsOtherVariableName() {
        var expected = intVariableA.name
        var actual = aGreaterThanBConstraint.variableName(otherThan: intVariableB.name)
        XCTAssertEqual(actual, expected)

        expected = intVariableB.name
        actual = aGreaterThanBConstraint.variableName(otherThan: intVariableA.name)
        XCTAssertEqual(actual, expected)
    }

    func testVariableNameOtherThan_invalidVariableName_returnsNil() {
        XCTAssertNil(aGreaterThanBConstraint.variableName(otherThan: "nonExistentVariableName"))
    }

    // MARK: Testing methods/attributes declared in GreaterThanConstraint
    func testVariableNames_returnsAllVariableNames() {
        let expectedVariableNames: [String] = [intVariableA.name, intVariableB.name]
        let actualVariableNames = aGreaterThanBConstraint.variableNames
        XCTAssertTrue(actualVariableNames == expectedVariableNames)
    }

    // MARK: tests for isSatisfied
    func testIsSatisfied_bothUnassigned_returnsFalse() {
        XCTAssertFalse(try aGreaterThanBConstraint.isSatisfied(state: variableSet))
    }

    func testIsSatisfied_oneUnassigned_returnsFalse() throws {
        // assign A
        try variableSet.assign(intVariableA.name, to: 1)
        let assignmentA = try variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 1)

        // check B is not assigned
        XCTAssertFalse(try variableSet.isAssigned(intVariableB.name))

        XCTAssertFalse(try aGreaterThanBConstraint.isSatisfied(state: variableSet))
    }

    func testIsSatisfied_aLessThanB_returnsFalse() throws {
        // assign A
        try variableSet.assign(intVariableA.name, to: 1)
        let assignmentA = try variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 1)

        // assign B
        try variableSet.assign(intVariableB.name, to: 2)
        let assignmentB = try variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 2)

        XCTAssertFalse(try aGreaterThanBConstraint.isSatisfied(state: variableSet))
    }

    func testIsSatisfied_aEqualToB_returnsFalse() throws {
        // assign A
        try variableSet.assign(intVariableA.name, to: 1)
        let assignmentA = try variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 1)

        // assign B
        try variableSet.assign(intVariableB.name, to: 1)
        let assignmentB = try variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 1)

        XCTAssertFalse(try aGreaterThanBConstraint.isSatisfied(state: variableSet))
    }

    func testIsSatisfied_aGreaterThanB_returnsTrue() throws {
        // assign A
        try variableSet.assign(intVariableA.name, to: 4)
        let assignmentA = try variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 4)

        // assign B
        try variableSet.assign(intVariableB.name, to: 1)
        let assignmentB = try variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 1)

        XCTAssertTrue(try aGreaterThanBConstraint.isSatisfied(state: variableSet))
    }

    // MARK: tests for isViolated
    func testIsViolated_bothUnassigned_returnsFalse() {
        XCTAssertFalse(try aGreaterThanBConstraint.isViolated(state: variableSet))
    }

    func testIsViolated_oneUnassigned_returnsFalse() throws {
        // assign A
        try variableSet.assign(intVariableA.name, to: 1)
        let assignmentA = try variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 1)

        // check B is not assigned
        XCTAssertFalse(try variableSet.isAssigned(intVariableB.name))

        XCTAssertFalse(try aGreaterThanBConstraint.isViolated(state: variableSet))
    }

    func testIsViolated_aGreaterThanB_returnsFalse() throws {
        // assign A
        try variableSet.assign(intVariableA.name, to: 4)
        let assignmentA = try variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 4)

        // assign B
        try variableSet.assign(intVariableB.name, to: 1)
        let assignmentB = try variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 1)

        XCTAssertFalse(try aGreaterThanBConstraint.isViolated(state: variableSet))
    }

    func testIsViolated_aLessThanB_returnsTrue() throws {
        // assign A
        try variableSet.assign(intVariableA.name, to: 1)
        let assignmentA = try variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 1)

        // assign B
        try variableSet.assign(intVariableB.name, to: 2)
        let assignmentB = try variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 2)

        XCTAssertTrue(try aGreaterThanBConstraint.isViolated(state: variableSet))
    }

    func testIsViolated_aEqualToB_returnsTrue() throws {
        // assign A
        try variableSet.assign(intVariableA.name, to: 1)
        let assignmentA = try variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 1)

        // assign B
        try variableSet.assign(intVariableB.name, to: 1)
        let assignmentB = try variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 1)

        XCTAssertTrue(try aGreaterThanBConstraint.isViolated(state: variableSet))
    }
}
