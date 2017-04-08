//
//  CartViewModel.swift
//  RxSwiftDemo
//
//  Created by 陈圣晗 on 04/04/2017.
//  Copyright © 2017 Thor Chen. All rights reserved.
//

import Foundation
import RxSwift

class CartViewModel {

    // Variable is a special type of RxSwift, it send onNext when value changed
    let rx_itemList       : Variable<[CartItem]>  = Variable([])
    let rx_amountPrice    : Variable<Int>         = Variable(0)
    let rx_amountQuantity : Variable<Int>         = Variable(0)

    private let disposeBag: DisposeBag = DisposeBag()

    // calculated property, feels no differences from the normal stored property
    // but it's change of value could be observed
    var itemList: [CartItem] {
        get { return rx_itemList.value }
        set { rx_itemList.value = newValue }
    }

    var amountPrice: Int {
        get { return rx_amountPrice.value }
        set { rx_amountPrice.value = newValue }
    }

    var amountQuantity: Int {
        get { return rx_amountQuantity.value }
        set { rx_amountQuantity.value = newValue }
    }

    func itemAt(indexPath: NSIndexPath) -> CartItem? {
        let row = indexPath.row
        guard row < itemList.count else {
            return nil
        }
        return itemList[row]
    }

    // Normally, we run some code in a separated thread, then evoke the callback function when complete or error
    // Now, we create an Observable
    func rx_loadItemList() -> Observable<[CartItem]> {
        return Observable<[CartItem]>
            .create { (observer) -> Disposable in
                // side effect, will run on each subscription
                self.itemList.removeAll()

                let flagList  : [String] = ["🇪🇸","🇩🇿","🇦🇸","🇦🇩","🇦🇴","🇦🇮","🇦🇶"]
                let priceList : [Int]    = [5,6,7,8,9,10]
                let count     :Int       = 6

                for i in 0..<count {
                    self.addCartItem("🍫" + flagList[i], price: priceList[i])
                }

                // remember what is Observable? 
                // Yes, a type of data stream. 
                // When we have a value to send, we call onNext().
                // When complete, we call onComplete()
                observer.onNext(self.itemList)
                observer.onCompleted()

                // we won't talk much about Disposable. It's used for memory management and cancel signal
                return NopDisposable.instance
            }
            .subscribeOn(SerialDispatchQueueScheduler.init(internalSerialQueueName: "background"))
    }

    func rx_addSupply() -> Observable<CartItem> {
        return Observable<CartItem>
            .create { (observer) -> Disposable in
                // side effect, will run on each subscription
                guard arc4random_uniform(10) >= 5 else {
                    let error = NSError.init(
                        domain: String(self.dynamicType),
                        code: -1,
                        userInfo: [
                            NSLocalizedDescriptionKey: "Oops!"
                        ])

                    // When we encounter an error, we call onError
                    observer.onError(error)
                    return NopDisposable.instance
                }

                let cartItem = self.addCartItem("🍫🇨🇳", price: 5 + Int(arc4random_uniform(10)))
                observer.onNext(cartItem)
                observer.onCompleted()
                
                return NopDisposable.instance
            }
            .subscribeOn(SerialDispatchQueueScheduler.init(internalSerialQueueName: "background"))
    }

    private func addCartItem(brand: String, price: Int) -> CartItem {
        let chocolate = Chocolate()
        chocolate.brand = brand
        chocolate.price = price

        let cartItem = CartItem()
        cartItem.chocolate = chocolate
        itemList.append(cartItem)

        cartItem
            .rx_quantity
            .asObservable()
            .observeOn(SerialDispatchQueueScheduler.init(internalSerialQueueName: "background"))
            .subscribeNext { [weak self] (_) in
                self?.updateCalculatedData()
            }
            .addDisposableTo(disposeBag)

        return cartItem
    }

    private func updateCalculatedData() {
        var quantity : Int = 0
        var price    : Int = 0

        itemList.forEach { (item) in
            quantity += item.quantity
            price += item.quantity * item.chocolate.price
        }

        amountPrice    = price
        amountQuantity = quantity
    }
}
