import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var timestamp: Date?
}
