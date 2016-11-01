//
//  Utils.swift
//  RedditTops
//
//  Created by Juan Salazar on 27/10/16.
//  Copyright © 2016 Juan Salazar. All rights reserved.
//

import Foundation
import CoreData

class Utils {
    
    /** Homologa los Tops Obtenidos del Api Rest */
    static func getTops(array : NSArray) -> NSArray {
        
        let tops:NSMutableArray = NSMutableArray()
        var post:Post
        
        for top in array {
            
            if top is NSDictionary {
                
                if let title = top["data"]!!["title"]! as? String,
                   let id = top["data"]!!["id"]! as? String,
                   let author = top["data"]!!["author"]! as? String,
                   let comments = top["data"]!!["num_comments"]! as? NSNumber,
                   let subreddit = top["data"]!!["subreddit"]! as? String,
                   let thumbnail = top["data"]!!["thumbnail"]! as? String {
                    
                    post = Post()
                    post.id = id
                    post.thumbnail = thumbnail
                    post.title = title
                    post.author = author
                    post.comments = comments
                    post.subReddit = subreddit

                    tops.addObject(post)
                }
  
            }
        }
        
        return tops
    }
    
    /** Funcion para convertir NSData a JSON **/
    static func NSDataToJSON(data:NSData) -> AnyObject? {
        do {
            return try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
        } catch let error {
            print(error)
        }
        return nil
    }
    
}
