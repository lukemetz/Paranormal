import Foundation
import Cocoa
import OpenGL

enum QueueEntry {
    case Point(CGPoint, Brush)
    case Finish
    case Destroy
}

class GLDrawingKernel : NSThread, DrawingKernel {
    let imageSize : CGSize
    var queue : [QueueEntry] = []
    var queueLock : NSLock = NSLock()

    var openGLContext : NSOpenGLContext!

    var program : GLuint = GLuint()
    var vertexArray : GLuint = GLuint()

    var scaleUniform : GLint = GLint()
    var offsetUniform : GLint = GLint()
    var colorUniform : GLint = GLint()
    var hardnessUniform : GLint = GLint()

    //delegation pattern here instead?
    var updateFunc : ((image : NSImage) -> Void)?
    var finishFunc : (() -> Void)?

    init(size : CGSize) {
        self.imageSize = size
        super.init()
        self.start()
    }

    func startDraw(update : (image : NSImage) -> Void) {
        updateFunc = update
    }

    func addPoint(point : CGPoint, brush : Brush) {
        queueLock.lock()
        queue.append(.Point(point, brush))
        queueLock.unlock()
    }

    func stopDraw(finish : () -> Void) {
        finishFunc = finish
        queueLock.lock()
        queue.append(.Finish)
        queueLock.unlock()
    }

    func doneDrawing() -> Bool {
        queueLock.lock()
        let left = queue.count
        queueLock.unlock()
        return left == 0
    }

    func destroy() {
        queueLock.lock()
        queue.append(.Destroy)
        queueLock.unlock()
    }

    // Must only be called on the GLDrawingThread
    func tearDownOpenGL() {
        openGLContext.clearDrawable()
    }

    func createShaderProgram() {
        // Compile shaders and create glsl program
        let vertexShader : GLuint = glCreateShader(GLenum(GL_VERTEX_SHADER))
        let vertPath = NSBundle.mainBundle().pathForResource("GLDrawingKernelVsh",
            ofType: "vsh")!
        let vertSource = NSString(contentsOfFile: vertPath,
            encoding: NSUTF8StringEncoding, error: nil)!
        glShaderSource(vertexShader, 1, [vertSource.UTF8String],
            [GLint(Int32(vertSource.length))])
        glCompileShader(vertexShader)

        let fragPath = NSBundle.mainBundle().pathForResource("GLDrawingKernelFsh",
            ofType: "fsh")!
        let fragmentShader : GLuint = glCreateShader(GLenum(GL_FRAGMENT_SHADER))
        let fragSource = NSString(contentsOfFile: fragPath,
            encoding: NSUTF8StringEncoding, error: nil)!
        glShaderSource(fragmentShader, 1, [fragSource.UTF8String],
            [GLint(Int32(fragSource.length))])
        glCompileShader(fragmentShader)

        program = glCreateProgram()
        glAttachShader(program, vertexShader)
        glAttachShader(program, fragmentShader)
        glLinkProgram(program)
    }

    func setupOffscreenRendering() {
        let glPFAttributes:[NSOpenGLPixelFormatAttribute] = [
            UInt32(NSOpenGLPFAAccelerated),
            UInt32(NSOpenGLPFADoubleBuffer),
            UInt32(NSOpenGLPFAMultisample),
            UInt32(NSOpenGLPFASampleBuffers), UInt32(1),
            UInt32(NSOpenGLPFASamples), UInt32(4),
            UInt32(NSOpenGLPFAMinimumPolicy),
            UInt32(0)
        ]

        let pixelFormat = NSOpenGLPixelFormat(attributes: glPFAttributes)
        openGLContext = NSOpenGLContext(format: pixelFormat, shareContext: nil)
        openGLContext.makeCurrentContext()
        openGLContext.update()

        let height = UInt(imageSize.height)
        let width = UInt(imageSize.width)

        // Framebuffer for offscreen rendering and copying pixels
        var frameBuffer : GLuint = 0
        glGenFramebuffersEXT(1, &frameBuffer)
        glBindFramebufferEXT(GLenum(GL_FRAMEBUFFER_EXT), frameBuffer)
        var texture : GLuint = 0
        glGenTextures(1, &texture)
        glBindTexture(GLenum(GL_TEXTURE_2D), texture)

        glTexImage2D(GLenum(GL_TEXTURE_2D), GLint(0), GLint(GL_RGBA8),
            GLsizei(width), GLsizei(height), GLint(0), GLenum(GL_RGBA),
            GLenum(GL_UNSIGNED_BYTE), UnsafePointer.null())

        glFramebufferTexture2DEXT(GLenum(GL_FRAMEBUFFER_EXT), GLenum(GL_COLOR_ATTACHMENT0_EXT),
            GLenum(GL_TEXTURE_2D), texture, GLint(0))
        var renderbuffer : GLuint = 0
        glGenRenderbuffersEXT(1, &renderbuffer)
        glBindRenderbufferEXT(GLenum(GL_RENDERBUFFER_EXT), renderbuffer)
        glRenderbufferStorageEXT(GLenum(GL_RENDERBUFFER_EXT), GLenum(GL_RGBA8),
            GLsizei(width), GLsizei(height))
        glFramebufferRenderbufferEXT(GLenum(GL_FRAMEBUFFER_EXT), GLenum(GL_COLOR_ATTACHMENT0_EXT),
            GLenum(GL_RENDERBUFFER_EXT), renderbuffer)

        let status = glCheckFramebufferStatusEXT(GLenum(GL_FRAMEBUFFER_EXT))
        if Int32(status) != GL_FRAMEBUFFER_COMPLETE_EXT {
            log.error("Could not setup framebuffer")
        }
    }

    func setupUniforms() {
        // Get uniforms
        scaleUniform = glGetUniformLocation(program, ("scale" as NSString).UTF8String)
        if scaleUniform < 0 {
            log.error("Error in getting scale uniform")
        }

        offsetUniform = glGetUniformLocation(program, ("offset" as NSString).UTF8String)
        if offsetUniform < 0 {
            log.error("Error in getting offset uniform")
        }

        colorUniform = glGetUniformLocation(program, ("color" as NSString).UTF8String)
        if colorUniform < 0 {
            log.error("Error in getting color uniform")
        }

        hardnessUniform = glGetUniformLocation(program, ("hardness" as NSString).UTF8String)
        if hardnessUniform < 0 {
            log.error("Error in getting color uniform")
        }
    }

    func setupVerticies() {

        // Set up verticies
        glGenVertexArrays(1, &vertexArray)
        glBindVertexArray(vertexArray)

        var vertexBuffer : GLuint = GLuint()
        glGenBuffers(1, &vertexBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)

        // Verticies for a size 2 square centered at the origin
        let vertexData : [GLfloat] = [
            -1.0, -1.0,
            1.0, 1.0,
            -1.0, 1.0,

            -1.0, -1.0,
            1.0, -1.0,
            1.0, 1.0
        ]

        glBufferData(GLenum(GL_ARRAY_BUFFER), vertexData.count * sizeof(GLfloat.self),
            vertexData, GLenum(GL_DYNAMIC_DRAW))

        let triangleVertexPosition = glGetAttribLocation(program,
            ("vertex_position" as NSString).UTF8String)
        if triangleVertexPosition < 0 {
            log.error("Failed to get vertex_pos attribute location")
        }

        let posIndex = GLuint(triangleVertexPosition)
        glEnableVertexAttribArray(posIndex)
        glVertexAttribPointer(posIndex, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE),
            0, UnsafePointer.null())

        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
    }

    // Must only be called on the GLDrawingThread
    func setupOpenGL() {
        setupOffscreenRendering()

        // Set up view and clear
        let height = UInt(imageSize.height)
        let width = UInt(imageSize.width)
        glViewport(0, 0, GLsizei(width), GLsizei(height))
        glClearColor(0.0, 0.0, 0.0, 0.0)
        glClear(GLenum(GL_COLOR_BUFFER_BIT))

        createShaderProgram()

        setupUniforms()

        setupVerticies()

        // Transparency support.
        glEnable(GLenum(GL_BLEND))
        glBlendEquationSeparate(GLenum(GL_FUNC_ADD), GLenum(GL_MAX))
    }

    // Must only be called on the GLDrawingThread
    func getImageFromBuffer() -> NSImage {
        let height : UInt = UInt(imageSize.height)
        let width : UInt = UInt(imageSize.width)
        let bufferSize = Int(4 * height * width)
        var buffer = UnsafeMutablePointer<UInt8>.alloc(bufferSize)
        glReadPixels(0, 0, GLsizei(width), GLsizei(height), GLenum(GL_RGBA),
            GLenum(GL_UNSIGNED_BYTE), buffer)

        let representation = NSBitmapImageRep(bitmapDataPlanes: &buffer,
            pixelsWide: Int(width),
            pixelsHigh: Int(height),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: NSCalibratedRGBColorSpace,
            bitmapFormat:NSBitmapFormat.NSAlphaNonpremultipliedBitmapFormat,
            bytesPerRow: 4 * Int(width),
            bitsPerPixel: 32)

        var image = NSImage(size: imageSize)
        if let rep = representation {
            image.addRepresentation(rep)
        } else {
            log.error("No image rep from GL")
        }

        buffer.destroy()

        return image
    }

    // Must only be called on the GLDrawingThread
    func updateDraw(point : CGPoint, brush : Brush) {
        openGLContext.makeCurrentContext()
        glUseProgram(program)
        glBindVertexArray(vertexArray)

        glUniform2f(scaleUniform, GLfloat(brush.size/imageSize.width),
            GLfloat(brush.size/imageSize.height))

        let offsetX = (point.x / imageSize.width) * 2 - 1.0
        let offsetY = 1.0 - (point.y / imageSize.height) * 2
        glUniform2f(offsetUniform, GLfloat(offsetX), GLfloat(offsetY))

        let color = brush.color
        glUniform3f(colorUniform, GLfloat(color.redComponent),
            GLfloat(color.greenComponent), GLfloat(color.blueComponent))

        glUniform1f(hardnessUniform, GLfloat(brush.hardness))

        glDrawArrays(GLenum(GL_TRIANGLES), 0, 6)

        glUseProgram(0)
        glBindVertexArray(0)
    }

    override func main() {
        setupOpenGL()

        var lastPoint : CGPoint? = nil

        while true {
            queueLock.lock()
            let count = queue.count
            queueLock.unlock()

            if count > 0 {
                queueLock.lock()
                let queueEntry = queue[0]
                queueLock.unlock()

                switch queueEntry {
                case .Point(let currentPoint, let brush):
                    if let lp = lastPoint {
                        let numInterpolate = 20
                        // Linearly interpolate and draw <numInterpolate> sprites inbetween points
                        // Relative to the image copy this is very fast.
                        // TODO: Consider varying number of sprites depending on distance
                        for i in 0..<numInterpolate {
                            let t = CGFloat(i) / CGFloat(numInterpolate)
                            let x = t*lp.x + (1.0 - t) * currentPoint.x
                            let y = t*lp.y + (1.0 - t) * currentPoint.y

                            updateDraw(CGPoint(x: x, y: y), brush: brush)
                        }
                    }
                    lastPoint = currentPoint

                    let image = getImageFromBuffer()
                    if let update = updateFunc {
                        update(image: image)
                    }

                case .Finish:
                    glClearColor(0.0, 0.0, 0.0, 0.0)
                    glClear(GLenum(GL_COLOR_BUFFER_BIT))

                    if finishFunc != nil {
                        finishFunc!()

                        lastPoint = nil
                        finishFunc = nil
                        updateFunc = nil
                    }

                case .Destroy:
                    tearDownOpenGL()
                    queueLock.lock()
                    queue.removeAtIndex(0)
                    queueLock.unlock()
                    return
                }
                // Important, remove at end to prevent a race condition
                queueLock.lock()
                queue.removeAtIndex(0)
                queueLock.unlock()
            }
        }
    }
}
