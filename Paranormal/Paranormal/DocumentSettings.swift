import Foundation
import Cocoa

class DocumentSettings : NSManagedObject {
    @NSManaged var baseImage : NSString?
    @NSManaged var width : NSNumber
    @NSManaged var height : NSNumber

    override init(entity: NSEntityDescription,
        insertIntoManagedObjectContext context: NSManagedObjectContext?) {

            super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}