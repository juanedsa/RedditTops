//
//  CoreDataManager.swift
//  RedditTops
//
//  Created by Juan Salazar on 1/11/16.
//  Copyright © 2016 Juan Salazar. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager: NSObject {
    
    let delegate:AppDelegate
    let context:NSManagedObjectContext
    
    
    override init() {

         delegate = UIApplication.sharedApplication().delegate as! AppDelegate
         context = delegate.managedObjectContext
         
    }
    
    /** Funcion para validar si existen Tops */
    func exitsTops() -> Bool {
        
        var exits = false
        let request = NSFetchRequest(entityName: "Top")
        
        do {
            let results = try context.executeFetchRequest(request)
            print("\(results.count) Tops Encontrados en CD")
            if results.count > 0 {
                exits = true
            }
        } catch {
            print("No se ha podido realizar el fetch correctamente ...")
        }
        
        return exits
    }
    
    /** Funcion encargada de obtener los tops de la base de datos */
    func getTops() -> NSArray {
        
        let tops:NSMutableArray = NSMutableArray()
        var post:Post
        
        let request = NSFetchRequest(entityName: "Top")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.executeFetchRequest(request)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    
                    if let id = result.valueForKey("id") as? String,
                        let thumbnail = result.valueForKey("thumbnail") as? String,
                        let title = result.valueForKey("title") as? String,
                        let author = result.valueForKey("author") as? String,
                        let comments = result.valueForKey("comments") as? NSNumber,
                        let subReddit = result.valueForKey("subReddit") as? String {
                        
                        post = Post()
                        post.id = id
                        post.thumbnail = thumbnail
                        post.title = title
                        post.author = author
                        post.comments = comments
                        post.subReddit = subReddit
                        
                        tops.addObject(post)
                    }
                    
                }
            }
            
        } catch {
            print("No se ha podido realizar el fetch correctamente ...")
        }
        
        return tops
        
    }
    
    /** Funcion encargada de insertar un Top */
    func insertTop(post:Post, index:NSNumber) {
        
        let entity = NSEntityDescription.insertNewObjectForEntityForName("Top", inManagedObjectContext: context)
        
        entity.setValue(post.id, forKey: "id")
        entity.setValue(index, forKey: "index")
        entity.setValue(post.title, forKey: "title")
        entity.setValue(post.thumbnail, forKey: "thumbnail")
        entity.setValue(post.author, forKey: "author")
        entity.setValue(post.date, forKey: "date")
        entity.setValue(post.comments, forKey: "comments")
        entity.setValue(post.subReddit, forKey: "subReddit")
        
        do {
            try context.save()
        } catch {
            print("No se pudo guardar correctamente ....")
        }
        
    }
    
    
    /** Funcion para eliminar los Tops de la base de datos */
    func resetDataBase() {
      
        let request = NSFetchRequest(entityName: "Top")
        
        do {
            let results = try context.executeFetchRequest(request)
            if results.count > 0 {
                
                for result in results as! [NSManagedObject] {
                    
                    //Eliminar un elemento de CD
                    context.deleteObject(result)
                    
                    do {
                        try context.save()
                    } catch {
                        print("No se ha podido guardar debidamente")
                    }
                }
            }
        } catch {
            print("No se ha podido realizar el fetch correctamente ...")
        }
    }
}
