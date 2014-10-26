import Foundation
import Cocoa

class DocumentSettings : NSManagedObject {

    @NSManaged var baseImage : NSString?

    override init(entity: NSEntityDescription,
        insertIntoManagedObjectContext context: NSManagedObjectContext?) {

            super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}