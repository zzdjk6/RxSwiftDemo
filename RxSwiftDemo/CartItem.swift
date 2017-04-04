//
//  CartItem.swift
//  RxSwiftDemo
//
//  Created by 陈圣晗 on 04/04/2017.
//  Copyright © 2017 Thor Chen. All rights reserved.
//

import Foundation
import RxSwift

class CartItem {

    var chocolate   : Chocolate      = Chocolate()
    let rx_quantity : Variable<Int>  = Variable(0)

    var quantity: Int {
        get { return rx_quantity.value }
        set { rx_quantity.value = newValue }
    }

    func increaseQuantity() {
        quantity += 1
    }

    func decreaseQuantity() {
        if quantity == 0 {
            return
        }

        quantity -= 1
    }
}
