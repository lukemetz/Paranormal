import Foundation
import Nimble
import Cocoa

public func beColor(expectR : UInt, expectG : UInt, expectB : UInt, expectA : UInt)
    -> MatcherFunc<NSColor?> {
        return beNearColor(expectR, expectG, expectB, expectA, tolerance: 0)
}

public func beNearColor(expectR : UInt, expectG : UInt, expectB : UInt, expectA : UInt,
    #tolerance: Int)
        -> MatcherFunc<NSColor?> {

    return MatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "equal <\(expectR, expectG, expectB, expectA)>"
        if let color = actualExpression.evaluate() {
            if let colorUnwrap = color {
                let (gotR, gotG, gotB, gotA) =
                    (UInt(colorUnwrap.redComponent), UInt(colorUnwrap.greenComponent),
                    UInt(colorUnwrap.blueComponent), UInt(colorUnwrap.alphaComponent))

                return abs(gotR - expectR) <= tolerance &&
                       abs(gotG - expectG) <= tolerance &&
                       abs(gotB - expectB) <= tolerance &&
                       abs(gotA - expectA) <= tolerance
            }
        }
        return false
    }
}
