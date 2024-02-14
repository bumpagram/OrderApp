//  ResponseModels.swift
//  OrderApp
//  Created by .b[u]mpagram on 9/2/24.
//

import Foundation

// “The /menu endpoint returns an object with an items key that contains the MenuItem objects you're interested in. This response model can be defined as:

struct MenuResponse: Codable {
    let items: [MenuItem]
}


struct CategoriesResponse: Codable {
    let categories: [String]
}



// “Finally, you'll need a response model for the value that comes with preparation_time. This is returned from the /order endpoint and represents the amount of time until an order will be ready.”

struct OrderResponse: Codable {
    let preparaionTime: Int
    
    enum CodingKeys: String, CodingKey {
        case preparaionTime = "preparation_time"
    }
}
