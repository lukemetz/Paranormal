Contributing Guide
==================

##Quick start

Get the code

	git clone https://github.com/spritebuilder/Paranormal.git
	cd Paranormal
	git submodule update --init --recursive
	
Make changes, (with tests when appropriate).

Ensure the tests pass via

	./check.py

Submit a pull request and we will merge it in!

Looking for something to work on? Check out our [issues](https://github.com/lukemetz/Paranormal/issues).

##Architecture
Paranormal has been developed to specifically enable additions and modifications. Bellow is a summary of aspects of our codebase.

###Graphical User Interface
Paranormal uses Interface Builder for all GUI based elements. The main application window can can be found in `Application.xib`. It is controlled by [`WindowController.swift`](Paranormal/Paranormal/WindowController.swift). Subviews are then inserted into this view inside the controller.

When adding a new interface, create a `xib`, create a `ViewController` subclass for it, and then insert it into a parent view from the parent view's `ViewController`. See [PannelsViewController.swift](Paranormal/Paranormal/Panels/PanelsViewController.swift) for an example.


###Document
Paranormal uses CoreData as well as AppKit's `NSPersistedDocument` to manage open files. See [`Document.swift`](Paranormal/Paranormal/Document.swift) for Paranormals document subclass.

Unlike traditional Document based applications, Paranormal is only able to have one window open at a time due to limitations of Cocos2D. Paranormal uses a [`DocumentController`](Paranormal/Paranormal/DocumentController.swift) subclass to manage this.

###Layers
Internally, all of paranormals tools and operations are implemented as layer combinations. The [`Layer`](Paranormal/Paranormal/DocumentModels/Layer.swift) class is the CoreData model that manages one layer. A layer contains other layers, thus forming a tree. The root node for the document can be found on the current instance of `Document`.

`Layer`'s have a few key properties, bellow is a summary:

* `Layer.imageData : NSData?` which contains the `TIFFRepresentation` of an NSImage
* `Layer.parent : Layer?` Layer's parent
* `Layer.children : [Layer?]` Layer's children
* `Layer.blendMode : BlendMode` Enum value that indicates how the layer will be combined with other layers.


###BlendModes
Blend modes determine how layers are combined. They act similarly to Photoshop's blend modes but are more general. Paranormal supports a number of blend modes. The complete list can be found in the [BlendFilters](Paranormal/Paranormal/GPUImageFilters/BlendFilters) folder.

These modes can be thought of functions that takes in two input images, and outputs a result image. For speed, they are implemented as GLSL shaders that are run on the gpu via GPUImage. The shaders can be found in the [GPUImageShaders](Paranormal/Paranormal/GPUImageShaders) folder.

###Tools
Tools in our application are the main way to interact with areas of a normal map. All tools share a similar interface defined by the [`EditorActiveTool`](Paranormal/Paranormal/Tools/EditorActiveTool.swift) protocol. `BrushTool`'s Implement this protocol.

`BrushTool`'s are tools that would be most similar to brushes in applications such as Photoshop. On mouse down, `BrushTool`'s create a new layer and start laying down paint on that layer. On mouse up, the layer gets collapsed on to the previous layer via a blend mode. How the layers are combined are the heart of individual tools behavior.

As an example, the [`FlattenTool`](Paranormal/Paranormal/Tools/BrushTools/FlattenTool.swift) sets the temporary edit layer's blend mode to `Flatten` as its entire implementation. When these layers get rendered and combined, a `BlendFilter` which is created for the given blend mode in `Layer.filterForBlendMode(blend: BlendMode) -> BlendFilter` function. For the flatten tool, this filter is called [`BlendFlattenFilter`](Paranormal/Paranormal/GPUImageFilters/BlendFilters/BlendFlattenFilter.swift). This filter tells GPUImage that the fragment shader to be used is [`BlendFlatten.fsh`](Paranormal/Paranormal/GPUImageShaders/BlendFlatten.fsh). This shader is where the actual flattening logic exists.

##Tests
Paranormal strives to have an extensive test base. To make testing easier and more descriptive, we use Quick, a swift testing framework. When adding new features or fixing bugs, it is encouraged to include tests. The test suite can be run from within the as well as through `check.py`.

Before submitting a pull request, run `check.py` as it does extra checks to ensure consistent code style.

##Questions?
TODO link to some form to ask and answer questions.