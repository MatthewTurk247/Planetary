//
//  GmailResponse.swift
//  Hackin the Web
//
//  Created by Kyle Lee on 6/18/17.
//  Copyright © 2017 MonitorMOJO, Inc. All rights reserved.
//

import Foundation
import SwiftSoup

enum HTMLError: Error {
    case badInnerHTML
}

struct PlanetaryResponse {
    
    let posts: [PlanetaryPost]
    
    init(_ innerHTML: Any?) throws {
        guard let htmlString = innerHTML as? String else { throw HTMLError.badInnerHTML }
        let doc = try SwiftSoup.parse(htmlString)
        let containers:Array<Element> = try! doc.select("div.row").array()
        
        var posts = [PlanetaryPost]()
        for i in 0...(containers.count - 5) {
            //This is where the magic happens.
            //First level
            let title = try containers[i].select("div.eight.columns").select("h4").first()!.text()
            let desc = try containers[i].select("div.eight.columns").select("p.listDesc").first()!.text()
            let author = try containers[i].select("div.eight.columns").select("p.listDetails").select("a").first()!.text()
            let url = try containers[i].select("div.four.columns").select("a").attr("href")
            let imgUrl = try containers[i].select("div.four.columns").select("img").attr("src")
            let post = PlanetaryPost(title: title, desc: desc, author: author, url: url, imgUrl: imgUrl)
            posts.append(post)
        }
        self.posts = posts
    }
    
}
