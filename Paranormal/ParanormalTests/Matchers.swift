import Foundation
import Nimble
import Cocoa

public func beColor(expectR : UInt, expectG : UInt, expectB : UInt, expectA : UInt)
        -> MatcherFunc<NSColor?> {

    return MatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "equal <\(expectR, expectG, expectB, expectA)>"
        if let color = actualExpression.evaluate() {
            if let colorUnwrap = color {
                let (gotR, gotG, gotB, gotA) =
                    (UInt(colorUnwrap.redComponent), UInt(colorUnwrap.greenComponent),
                    UInt(colorUnwrap.blueComponent), UInt(colorUnwrap.alphaComponent))

                return abs(gotR - expectR) <= 1 &&
                       abs(gotG - expectG) <= 1 &&
                       abs(gotB - expectB) <= 1 &&
                       abs(gotA - expectA) <= 1
            }
        }
        return false
    }
}
