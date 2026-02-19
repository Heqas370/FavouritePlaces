//
//  WikiResults.swift
//  FavouritePlaces
//
//  Created by Adam Herman on 19/02/2026.
//

import Foundation


struct Page: Codable, Comparable{
    let pageid: Int
    let title: String
    let terms: [String : [String]]?
    
    static func <(lhs: Page, rhs: Page) -> Bool{
        return lhs.title < rhs.title
    }
    
    var description: String{
        terms?["description"]?.first ?? "No description available"
    }
}


struct Query: Codable{
    let pages: [Int: Page]
}

struct Result: Codable{
    let query: Query
}
