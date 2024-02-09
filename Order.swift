//  Order.swift
//  OrderApp
//  Created by .b[u]mpagram on 9/2/24.
//

import Foundation

struct Order: Codable {
    
    let userSelected : [MenuItem]
    
    // хз зачем этот инициализатор в учебнике, должно и без него работать
//    init(userSelected: [MenuItem] = []) {
//            self.userSelected = userSelected
//        }
    
}
