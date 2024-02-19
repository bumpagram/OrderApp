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
    
    var controllerIdentifier: StateRestorationController.Identifier? {
        get {
            guard let controllerIdentifierString = userInfo?["controllerIdentifier"] as? String else {return nil}
            return StateRestorationController.Identifier(rawValue: controllerIdentifierString)
        }
        set {
            userInfo?["controllerIdentifier"] = newValue?.rawValue
        }
    }
    
    var menuCategory: String? { // вычисляемое свойство
        get {
            return userInfo?["menuCategory"] as? String
        }
        set {
            userInfo?["menuCategory"] = newValue
        }
    }
    
    var menuItem: MenuItem? {
        get {
            guard let jsonData = userInfo?["menuItem"] as? Data else {return nil}
            return try? JSONDecoder().decode(MenuItem.self, from: jsonData)
        }
        set {
            if let newValue = newValue, let jsondata = try? JSONEncoder().encode(newValue) {
                addUserInfoEntries(from: ["menuItem" : jsondata])
            } else {
                userInfo?["menuItem"] = nil
            }
        }
    }
    
}



enum StateRestorationController {
    enum Identifier : String {
        // “can be used to store an identifier for each controller”
        case categories, menu, itemDetail, order
    }
    
    case categories
    case menu(category: String)
    case itemDetail(MenuItem)
    case order
    
    var identifier: Identifier {
        // “Each identifier should be associated with a case in StateRestorationController, so you'll create an identifier computed property that switches over self and returns the respective Identifier. ”
        switch self {
        case .categories: return Identifier.categories
        case .menu: return Identifier.menu
        case .itemDetail: return Identifier.itemDetail
        case .order: return Identifier.order
        }
    }
}


