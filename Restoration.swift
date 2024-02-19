//  Restoration.swift
//  OrderApp
//  Created by .b[u]mpagram on 19/2/24.
//

import Foundation

extension NSUserActivity {
    // “Notice that you cannot include custom types—or even Codable types. To get around this limitation, you'll store the Order as an encoded JSON Data object, created the same way as when you send an Order to the server.
    
    var order: Order? {
        get {
            guard let jsonData = userInfo?["order"] as? Data else {return nil}
            return try? JSONDecoder().decode(Order.self, from: jsonData)
        }
        set {
            if let newValue = newValue, let jsonData = try? JSONEncoder().encode(newValue) {
                addUserInfoEntries(from: ["order" : jsonData])
            } else {
                userInfo?["order"] = nil
            }
        }
    }
    
    
    
}
