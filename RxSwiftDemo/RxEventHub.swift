
import Foundation
import RxSwift

public class RxEventHub {
    
    public static let sharedHub = RxEventHub()
    
    private let disposeBag = DisposeBag()
    
    private var subjectDict = Dictionary<String, AnyObject>()

    public init() {
        
    }

    public func notify<T>(provider: RxEventProvider<T>, data: T) {
        let subject = eventSubject(provider)
        subject.onNext(data)
    }
    
    public func eventObservable<T>(provider: RxEventProvider<T>) -> Observable<T> {
        let subject = eventSubject(provider)
        return subject.asObservable()
    }
    
    private func eventSubject<T>(provider: RxEventProvider<T>) -> PublishSubject<T> {
        let key = provider.typeKey()
        if let subject = subjectDict[key] as? PublishSubject<T> {
            return subject
        }
        
        let subject = provider.publishSubject()
        subjectDict[key] = subject
        return subject
    }
}

public class RxEventProvider<T> {

    public init() {

    }
    
    public func publishSubject() -> PublishSubject<T> {
        return PublishSubject<T>()
    }
    
    public func typeKey() -> String {
        let key = NSStringFromClass(self.dynamicType)
        return key
    }
}
