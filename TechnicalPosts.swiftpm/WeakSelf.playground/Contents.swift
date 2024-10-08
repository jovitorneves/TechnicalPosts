import UIKit

//https://www.linkedin.com/posts/vitorneves0_understanding-weak-self-in-swift-memory-activity-7246481302789472258-mAq_?utm_source=share&utm_medium=member_desktop

//https://medium.com/@jo_vitorneves/understanding-weak-self-in-swift-memory-leaks-explained-e21fb643327a

//Memory Leaks and Retain Cycles

//class Person {
//    var dog: Dog?
//}
//
//class Dog {
//    var owner: Person?
//}
//
//var person: Person? = Person()
//var dog: Dog? = Dog()
//
//person?.dog = dog
//dog?.owner = person
//person = nil
//dog = nil

//Breaking Retain Cycles Using weak

class Person {
    var dog: Dog?
}

class Dog {
    weak var owner: Person?
}

var person: Person? = Person()
var dog: Dog? = Dog()

person?.dog = dog
dog?.owner = person
person = nil
dog = nil

//Closures and Retain Cycles

//class ViewController {
//    var completionHandler: (() -> Void)?
//    func setupCompletion() {
//        completionHandler = {
//            print("Completion handler called in \(self)")
//        }
//    }
//}
//
//var viewController: ViewController? = ViewController()
//
//viewController?.setupCompletion()
//viewController = nil

//Fixing the Retain Cycle with weak self

//class ViewController {
//    var completionHandler: (() -> Void)?
//
//    func setupCompletion() {
//        completionHandler = { [weak self] in
//            guard let self = self else { return }
//            print("Completion handler called in \(self)")
//        }
//    }
//}
//
//var viewController: ViewController? = ViewController()
//
//viewController?.setupCompletion()
//viewController = nil


//When to Use unowned vs weak

class ViewController {
    var completionHandler: (() -> Void)?
    func setupCompletion() {
        completionHandler = { [unowned self] in
            print("Completion handler called in \(self)")
        }
    }
}
