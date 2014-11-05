import Foundation
import Cocoa

class Layer : NSManagedObject{
    @NSManaged var visible : Bool
    @NSManaged var name : String
    @NSManaged var layers : NSMutableSet
    @NSManaged var parent : Layer

    override init(entity: NSEntityDescription,
        insertIntoManagedObjectContext context: NSManagedObjectContext?) {

            super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}