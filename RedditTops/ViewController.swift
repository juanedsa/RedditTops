//
//  ViewController.swift
//  RedditTops
//
//  Created by Juan Salazar on 22/10/16.
//  Copyright © 2016 Juan Salazar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet var labelPrincipal: UILabel!
    @IBOutlet var table: UITableView!
    
    var blueColor: UIColor!
    var orangeColor: UIColor!
    
    var redditTops = []
    let URL_API:String = "https://www.reddit.com/top.json?limit=25"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // init Colors
        blueColor = UIColor(red:0.12, green:0.53, blue:0.90, alpha:1.0)
        orangeColor = UIColor(red:1.00, green:0.72, blue:0.30, alpha:1.0)
        
        self.initRedditTops()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /** Funcion para convertir NSData a JSON **/
    func NSDataToJSON(data:NSData) -> AnyObject? {
        do {
            return try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
        } catch let error {
            print(error)
        }
        return nil
    }
    
    
    func initRedditTops() {

        let url = NSURL(string: URL_API)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) ->
            Void in
            
            if let dataResponse = data {
                if let json = self.NSDataToJSON(dataResponse) as? NSDictionary {
                    if let childrenArray = json["data"]!["children"]! as? NSArray {
                        
                        dispatch_async(dispatch_get_main_queue(), {
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
}

