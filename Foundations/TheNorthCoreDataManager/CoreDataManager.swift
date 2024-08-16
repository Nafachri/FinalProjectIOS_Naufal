//
//  CoreDataManager.swift
//  TaskManagement
//
//  Created by Phincon on 18/07/24.
//

import CoreData
import Foundation

public enum CoreDataManagerError: Error {
  case entityCreation
}

public class CoreDataManager {
  
  public static let shared = CoreDataManager()
  private init() {}
  private let persistanceName: String = "TheNorthCoreData"
  
  
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: persistanceName)
    container.loadPersistentStores { storeDescription, error in
      if let error = error as NSError? {
        print("Unresolved error \\(error), \\(error.userInfo)")
      }
    }
    return container
  }()
  
  var context: NSManagedObjectContext {
    return persistentContainer.viewContext
  }
  
  func saveContext() throws {
    if context.hasChanges {
      try context.save()
    }
  }
}

public extension CoreDataManager {
  
  func create<T: NSManagedObject>(object: T, properties: [String: Any]) throws {
    let entityName = String(describing: T.self)
    guard let newEntity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? T else {
      throw CoreDataManagerError.entityCreation
    }
    
    let keys = Array(object.entity.attributesByName.keys)
    for key in keys {
      newEntity.setValue(object.value(forKey: key), forKey: key)
    }
    
    try saveContext()
  }
  
  @discardableResult
  func create<T: NSManagedObject>(entity: T.Type, properties: [String: Any]) throws -> T {
    let entityName = String(describing: entity)
    guard let newEntity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? T else {
      throw CoreDataManagerError.entityCreation
    }
    
    properties.forEach { key, value in
      newEntity.setValue(value, forKey: key)
    }
    
    try saveContext()
    return newEntity
  }
  
  @discardableResult
  func fetch<T: NSManagedObject>(entity: T.Type, predicate: NSPredicate? = nil) throws -> [T] {
    let entityName = String(describing: entity)
    let fetchRequest = NSFetchRequest<T>(entityName: entityName)
    fetchRequest.predicate = predicate
    return try context.fetch(fetchRequest)
  }
  
  func update<T: NSManagedObject>(entity: T, properties: [String: Any]) throws {
    
    properties.forEach { key, value in
      entity.setValue(value, forKey: key)
    }
    
    try saveContext()
  }
  
  func update<T: NSManagedObject>(object: T, otherObject: T) throws {
    
    let keys = Array(otherObject.entity.attributesByName.keys)
    for key in keys {
      object.setValue(otherObject.value(forKey: key), forKey: key)
    }

    try saveContext()
  }
  
  func update<T: NSManagedObject>( object: inout T, onUpdate: @escaping(_ object: inout T) -> Void) throws {
    onUpdate(&object)
    try saveContext()
  }
  
  func delete<T: NSManagedObject>(entity: T) throws {
    context.delete(entity)
    try saveContext()
  }
  
}
