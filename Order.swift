//  Order.swift
//  OrderApp
//  Created by .b[u]mpagram on 9/2/24.
//

import Foundation

struct Order: Codable {
    
    var userSelected : [MenuItem]
    
    init(userSelected: [MenuItem] = []) {
        // чтобы можно было инициализировать пустой массив и положить структуру в проперти в другом файле
            self.userSelected = userSelected
        }
    
}
