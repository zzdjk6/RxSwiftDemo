//
//  Events.swift
//  RxSwiftDemo
//
//  Created by 陈圣晗 on 04/04/2017.
//  Copyright © 2017 Thor Chen. All rights reserved.
//

import Foundation

// define name and type, will not conflict with others
class CartConfirmedEventProvider: RxEventProvider<(quantity: Int, price: Int)> {}
