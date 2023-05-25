/**
 Represents a Variable in a CSP.
 
 Reference semantics used here to ensure that any changes to `Variable` are seen by all.
 */

public protocol Variable: AnyObject, Hashable {
    associatedtype ValueType: Value
    
    var name: String { get }
    
    /// To be used by the computed variable `domain`
    var internalDomain: Set<ValueType> { get set }

    /// To allow `undoSetDomain`
    var domainUndoStack: Stack<Set<ValueType>> { get set }
    
    /// To be used by the computed variable `assignment`
    var internalAssignment: ValueType? { get set }
    
    /// All constraints that involve this variable
    var constraints: [any Constraint] { get set }
}

extension Variable {
    public var domain: Set<ValueType> {
        get {
            internalDomain
        }
        set(newDomain) {
            guard canSetDomain(newDomain: newDomain) else {
                // TODO: throw error
                assert(false)
            }
            
            domainUndoStack.push(domain)
            internalDomain = newDomain
        }
    }
    
    public var assignment: ValueType? {
        get {
            internalAssignment
        }
        set(newAssignment) {
            guard canAssign(to: newAssignment) else {
                // TODO: throw error
                assert(false)
            }
            internalAssignment = newAssignment
        }
    }
    
    /// Returns true if this variable can be set to `newAssignment`,
    /// false otherwise.
    public func canAssign(to newAssignment: some Value) -> Bool {
        let castedNewAssignment = newAssignment as? ValueType
        return canAssign(to: castedNewAssignment)
    }
    
    /// Another setter, but takes in value of type `any Value` and does the necessary
    /// casting before assignment. If assignment fails, throws error.
    public func assign(to newAssignment: any Value) {
        guard let castedNewAssignment = newAssignment as? ValueType,
              canAssign(to: castedNewAssignment) else {
            // TODO: throw error
            assert(false)
        }
        assignment = castedNewAssignment
    }
    
    /// Takes in an array of `any Value` and casts it to a Set of `ValueType`.
    /// If casting fails for any element, throws error.
    public func createValueTypeSet(from array: [any Value]) -> Set<ValueType> {
        let set = Set(array.compactMap({ $0 as? ValueType }))
        guard array.count == set.count else {
            // TODO: throw error
            assert(false)
        }
        return set
    }
    
    /// Sets the domain to the previous domain value right before the last set operation.
    public func undoSetDomain() {
        guard let prevDomain = domainUndoStack.pop() else {
            return
        }
        internalDomain = prevDomain
    }
    
    public func unassign() {
        internalAssignment = nil
    }
    
    public func add(constraint: any Constraint) {
        constraints.append(constraint)
    }
    
    private func canAssign(to newAssignment: ValueType?) -> Bool {
        guard let unwrappedNewAssignment = newAssignment else {
            return false
        }
        return assignment == nil && domain.contains(unwrappedNewAssignment)
    }
    
    private func canSetDomain(newDomain: Set<ValueType>) -> Bool {
        guard newDomain.count > 0 else {
            return false
        }
        return Set(newDomain).isSubset(of: domain)
    }
    
    // MARK: convenience attributes
    public var domainAsArray: [ValueType] {
        Array(domain)
    }
    
    public var domainSize: Int {
        domain.count
    }
    
    public var isAssigned: Bool {
        assignment != nil
    }
    
    public var assignmentAsAnyValue: (any Value)? {
        assignment
    }
    
    public var emptyValueSet: Set<ValueType> {
        Set<ValueType>()
    }
    
    public var emptyValueArray: [ValueType] {
        [ValueType]()
    }
}

extension Variable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name && lhs.assignment == rhs.assignment
    }
}

extension Variable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
