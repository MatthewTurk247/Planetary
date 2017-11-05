//
//  EventsResponse.swift
//  Planetary
//
//  Created by Matthew Turk on 7/28/17.
//  Copyright © 2017 MonitorMOJO, Inc. All rights reserved.
//

import Foundation
import SwiftSoup

struct EventsResponse {
    
    let posts: [PlanetaryPost]
    
    init(_ innerHTML: Any?) throws {
        guard let htmlString = innerHTML as? String else { throw HTMLError.badInnerHTML }
        let doc = try SwiftSoup.parse(htmlString)
        let containers:Array<Element> = try! doc.select("div.row").array()
        print(containers.count)
        var posts = [PlanetaryPost]()
        for i in 0...(containers.count - 4) {
            //This is where the magic happens.
            //First level
            var post = PlanetaryPost(title: try! containers[i].select("h1, h2, h3, h4, h5, h6").text(), desc: try! containers[i].select("p").text(), author: "", url: try! containers[i].select("h1, h2, h3, h4, h5, h6").select("a").attr("href"), imgUrl: try! containers[i].select("div.two.columns").select("a").select("img").attr("src"))
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM d yyyy"
            let result = formatter.string(from: date)
            //print(result)
            
//            var words = post.title.replacingOccurrences(of: ",", with: "").characters.split(separator: " ").map(String.init)
//            print(words)
            
            //print(currentDayNumber[0] + currentDayNumber[1]) //important
//            let planetaryDate = formatter.date(from: words[0])
            //print(planetaryDate!)
            //working on code to eliminate events that already passed
            
//            if planetaryDate! >= date {
//                posts.append(post)
//            }
            //the date stuff was working, but then it got faulty. We'll just have to deal with expired events for now and load everything async. Maybe eventually there will be two sections in the tableview so that the user can clearly see which ones already happened
            posts.append(post)
        }
        self.posts = posts
    }
    
}
