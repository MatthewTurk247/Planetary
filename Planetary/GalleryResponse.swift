//
//  GalleryResponse.swift
//  Hackin the Web
//
//  Created by Matthew Turk on 8/3/17.
//  Copyright © 2017 MonitorMOJO, Inc. All rights reserved.
//

import Foundation
import SwiftSoup

struct GalleryResponse {
    
    let posts: [PlanetaryPost]
    
    init(_ innerHTML: Any?) throws {
        guard let htmlString = innerHTML as? String else { throw HTMLError.badInnerHTML }
        let doc = try SwiftSoup.parse(htmlString)
        let containers:Array<Element> = try! doc.select("ul#grid.grid").first()!.select("li").array()
        print(containers.count)
        var posts = [PlanetaryPost]()
        for i in 0...(containers.count - 1) {
            //This is where the magic happens.
            //First level
            let post = PlanetaryPost(title: try! containers[i].select("p").text(), desc: "", author: "", url: try! containers[i].select("a").attr("href"), imgUrl: try! containers[i].select("img").attr("src"))
            posts.append(post)
        }
        self.posts = posts
    }
    
}
