//
//  AppDelegate.swift
//  RxSwiftDemo
//
//  Created by 陈圣晗 on 04/04/2017.
//  Copyright © 2017 Thor Chen. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = nil

    private let disposeBag: DisposeBag = DisposeBag()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {

        RxEventHub
            .sharedHub
            .eventObservable(CartConfirmedEventProvider())
            .observeOn(MainScheduler.instance)
            .subscribeNext { [weak self] (quantity, price) in
                guard quantity > 0 else {
                    let alert = UIAlertController.init(title: "Oops!", message: "You just missed a change to buy 🍫...", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction.init(title: "Got it", style: .Default, handler: nil))
                    self?.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
                    return
                }

                let message = "You just bought \(quantity) 🍫 with $\(price)"
                let alert = UIAlertController.init(title: "Congratulations!", message: message, preferredStyle: .Alert)
                alert.addAction(UIAlertAction.init(title: "Got it", style: .Default, handler: nil))
                self?.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            }
            .addDisposableTo(disposeBag)


        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let rootController = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()
        assert(rootController != nil, "no user interface, must be the D day")
        self.window?.rootViewController = rootController
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

