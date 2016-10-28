//
//  Post.swift
//  RedditTops
//
//  Created by Juan Salazar on 22/10/16.
//  Copyright © 2016 Juan Salazar. All rights reserved.
//

import Foundation
import UIKit

class  Post: NSObject {
    var title:String
    var thumbnail:String
    var author:String
    var date:String
    var comments:NSNumber
    var subReddit:String
    
    override init() {
        self.title = ""
        self.thumbnail = ""
        self.author = ""
        self.date = ""
        self.comments = 0
        self.subReddit = ""
    }
    
}
