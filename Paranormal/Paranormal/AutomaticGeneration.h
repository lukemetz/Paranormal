#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface AutomaticGeneration : NSObject
// Uses finite difference method to evaluate Possion's equation on the image.
// Uses input's black pixels as dirichlet boundaries.
// Used to create the buldge effect for automatic generation.
+ (NSImage *) generatePossionHeightMap: (NSImage *) input;

// Private
+ (NSBitmapImageRep *) getBitmapRep: (NSImage *) img;
@end
