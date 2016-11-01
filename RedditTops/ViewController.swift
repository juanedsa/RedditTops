//
//  ViewController.swift
//  RedditTops
//
//  Created by Juan Salazar on 22/10/16.
//  Copyright © 2016 Juan Salazar. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet var labelPrincipal: UILabel!
    @IBOutlet var table: UITableView!
    
    var blueColor: UIColor!
    var orangeColor: UIColor!
    
    var redditTops = []
    let URL_API:String = "https://www.reddit.com/top.json?limit=25"
    
    let context = DataController().managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // init Colors
        blueColor = UIColor(red:0.12, green:0.53, blue:0.90, alpha:1.0)
        orangeColor = UIColor(red:1.00, green:0.72, blue:0.30, alpha:1.0)
        
        /** Si existen Tops en la base de datos se muestran primero */
        if exitsTops() {
            redditTops = getTops()
        }

        initRedditTops()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /** Funcion encargada de optener los Tops del Api */
    func initRedditTops() {

        let url = NSURL(string: URL_API)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) ->
            Void in
            
            if let dataResponse = data {
                if let json = Utils.NSDataToJSON(dataResponse) as? NSDictionary {
                    if let childrenArray = json["data"]!["children"]! as? NSArray {
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.resetDataBase()
                            
                            self.redditTops = Utils.getTops(childrenArray)  
                            self.table.reloadData()
                            self.labelPrincipal.text = "Total \(childrenArray.count) Tops"
                            
                        })
                    }
                }
            }
            
        })
        
        task.resume()
        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return redditTops.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "Celda")
        
        if let post = self.redditTops[indexPath.row] as? Post {
            
            insertTop(post, index: indexPath.row)

            let imageView: UIImageView = UIImageView(frame: CGRectMake(10.0,10.0,80.0,80.0))
            
            let titleLabel: UILabel = UILabel(frame: CGRectMake(100.0, 10.0, 300.0, 30.0))
            titleLabel.font = UIFont(name: "verdana", size: 14)
            titleLabel.text = "\(post.title)"
            titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            titleLabel.numberOfLines = 3
            
            let authorLabel: UILabel = UILabel(frame: CGRectMake(100.0, 28.0, 300.0, 30.0))
            authorLabel.font = UIFont(name: "verdana", size: 12)
            authorLabel.textColor = blueColor
            authorLabel.text = "Autor: \(post.author)"
            
            
            let commetsLabel: UILabel = UILabel(frame: CGRectMake(100.0, 44.0, 300.0, 30.0))
            commetsLabel.font = UIFont(name: "verdana", size: 12)
            commetsLabel.textColor = blueColor
            commetsLabel.text = "Comentarios: \(post.comments)"
            
            let subRedditLabel: UILabel = UILabel(frame: CGRectMake(100.0, 60.0, 300.0, 30.0))
            subRedditLabel.font = UIFont(name: "verdana", size: 10)
            subRedditLabel.textColor = orangeColor
            subRedditLabel.text = "SubReddit: \(post.subReddit)"
            
            if post.thumbnail == "self" || post.thumbnail == "default" {
                imageView.image = UIImage(named: "noImageAvailable")!
            } else {
                if let url = NSURL(string: post.thumbnail), let data = NSData(contentsOfURL: url) {
                    imageView.image = UIImage( data: data)
                }
            }
            
            cell.addSubview(titleLabel)
            cell.addSubview(authorLabel)
            cell.addSubview(commetsLabel)
            cell.addSubview(imageView)
            cell.addSubview(subRedditLabel)
            
        }
        
        return cell
    }
    
    
    /** Core Data **/
    
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
        redditTops = []
        
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

