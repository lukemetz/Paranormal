import Foundation

class PNToolUtils {
    class func toolForToolMode(toolMode: ActiveTool) -> EditorActiveTool {
        switch toolMode {
        case .Plane:
            return PlaneTool()
        case .Flatten:
            return FlattenTool()
        case .Emphasize:
            return EmphasizeTool()
        case .Smooth:
            return SmoothTool()
        case .Sharpen:
            return SharpenTool()
        case .Tilt:
            return TiltTool()
        case .Invert:
            return InvertTool()
        case .Pan:
            return PanTool()
        case .Zoom:
            return ZoomTool()
        }
    }
}
