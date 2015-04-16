import Foundation

public class ToolSettings {
    weak var document : Document?

    init(){
    }

    public var colorAsAngles : (direction:Float, pitch:Float) = (0.0,0.0) {
        didSet {
            updateToolSettingsView()
        }
    }

    public func updateToolSettingsView() {
        let panelVC = document?.singleWindowController?.panelsViewController
        panelVC?.toolSettingsViewController?.updateSettingsSliders()
    }

    public var colorAsNSColor : NSColor {
        let dir = colorAsAngles.direction * Float(M_PI) / 180.0
        let pitt = colorAsAngles.pitch * Float(M_PI) / 180.0
        let x = sin(dir) * sin(pitt) * 0.5 + 0.5
        let y = cos(dir) * sin(pitt) * 0.5 + 0.5
        let z = cos(pitt) * 0.5 + 0.5
        return NSColor(red: CGFloat(x),
            green: CGFloat(y), blue: CGFloat(z), alpha: 1.0)
    }

    public func setColorAsNSColor(color : NSColor) {
        let normalZero : Float = 127.0 / 255.0;
        func transform(component : Float) -> Float {
            let n = 2.0 * (component - normalZero)
            if (abs(n) < 1e-8) {
                return 1e-8
            };
            return n
        }

        let x = transform(Float(color.redComponent))
        let y = transform(Float(color.greenComponent))
        let z = transform(Float(color.blueComponent))
        var degree = atan2(x, y)*180.0/Float(M_PI)
        var pitch = atan2(sqrt(x*x + y*y),z)*180.0/Float(M_PI)
        degree = ((degree > 0) ? degree : (degree+360))
        colorAsAngles = (round(degree*1e6)/1e6, round(pitch*1e6)/1e6)
    }

    public var size : Float = 30.0 {
        didSet {
            updateToolSettingsView()
        }
    }
    public var strength : Float = 1.0 {
        didSet {
            updateToolSettingsView()
        }
    }
    public var hardness : Float = 0.9 {
        didSet {
            updateToolSettingsView()
        }
    }

    //For smooth tool, though currently not used.
    public var gaussianRadius : Float = 30 {
        didSet {
            updateToolSettingsView()
        }
    }
}
