import Foundation
import Cocoa

class Refraction : NSManagedObject {

    @NSManaged var indexOfRefraction : Float
    @NSManaged var environment : String?

    override init(entity: NSEntityDescription,
        insertIntoManagedObjectContext context: NSManagedObjectContext?) {

        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}
