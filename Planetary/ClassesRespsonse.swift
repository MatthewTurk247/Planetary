//
//  ClassesRespsonse.swift
//  Planetary
//
//  Created by Matthew Turk on 7/26/17.
//  Copyright © 2017 MonitorMOJO, Inc. All rights reserved.
//

import Foundation
import SwiftSoup

struct ClassesResponse {
    
    let posts: [PlanetaryPost]
    
    init(_ innerHTML: Any?) throws {
        guard let htmlString = innerHTML as? String else { throw HTMLError.badInnerHTML }
        let doc = try SwiftSoup.parse(htmlString)
        let containers:Array<Element> = try! doc.select("h1, h2, h3, h4, h5, h6").array()
        let descriptions:Array<Element> = try! doc.select("p#description").array()
        let videos:Array<Element> = try! doc.select("iframe#vidframe").array()
        
        var posts = [PlanetaryPost]()
        for i in 0...(containers.count - 1) {
            //This is where the magic happens.
            //First level
            let post = PlanetaryPost(title: try! containers[i].text(), desc: try! descriptions[i].text(), author: "Bruce Betts", url: try! videos[i].attr("src"), imgUrl: try! "http://img.youtube.com/vi/" + videos[i].attr("src").characters.split(separator: "/").map(String.init)[3].replacingOccurrences(of: "?rel=0", with: "") + "/0.jpg")
            posts.append(post)
        }
        self.posts = posts
    }
    
}
