import Foundation
import Cocoa

public class DocumentSettings : NSManagedObject {
    @NSManaged public var baseImage : NSString?
    @NSManaged public var width : NSNumber
    @NSManaged public var height : NSNumber
    @NSManaged public var rootLayer : Layer?

    override public init(entity: NSEntityDescription,
        insertIntoManagedObjectContext context: NSManagedObjectContext?) {

            super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}
