import UIKit

//https://www.linkedin.com/posts/vitorneves0_solid-swift-activity-7245537945955274756-dEO3?utm_source=share&utm_medium=member_desktop

//S – Single Responsibility Principle (Princípio da Responsabilidade Única)

//Each class or structure should have a single responsibility or reason for change.
//In other words, it should do only one thing and do it well.

//WRONG
class UserWrong {
    func getUserData() -> String {
        return "User Data"
    }
    
    func saveUserData(data: String) {
        // Logic for saving data.
    }
    
    func validateUserData(data: String) -> Bool {
        // Validation logic.
        return true
    }
}

//CORRECT
class User {
    func getUserData() -> String {
        return "User Data"
    }
}

class UserDataSaver {
    func saveUserData(data: String) {
        // Logic for saving data.
    }
}

class UserDataValidator {
    func validateUserData(data: String) -> Bool {
        // Validation logic.
        return true
    }
}

//O – Open/Closed Principle (Princípio Aberto/Fechado)

//The code should be open for extension but closed for modification.
//This means you can add new functionalities without changing the existing code.

//WRONG
class DiscountWrong {
    func calculateDiscount(type: String, amount: Double) -> Double {
        if type == "Christmas" {
            return amount * 0.9
        } else if type == "NewYear" {
            return amount * 0.8
        } else {
            return amount
        }
    }
}

//CORRECT
protocol Discount {
    func apply(amount: Double) -> Double
}

class ChristmasDiscount: Discount {
    func apply(amount: Double) -> Double {
        return amount * 0.9
    }
}

class NewYearDiscount: Discount {
    func apply(amount: Double) -> Double {
        return amount * 0.8
    }
}

class DiscountCalculator {
    func calculateDiscount(discount: Discount, amount: Double) -> Double {
        return discount.apply(amount: amount)
    }
}

//L – Liskov Substitution Principle (Princípio da Substituição de Liskov)

//The code should be open for extension but closed for modification.
//This means that you can add new functionalities without altering the existing code.

//WRONG
class BirdWrong {
    func fly() {
        print("Flying")
    }
}

class PenguinWrong: BirdWrong {
    override func fly() {
        // Penguins don’t fly; this breaks the principle!
    }
}

//CORRECT
class Bird {
    func move() {
        print("Moving")
    }
}

class FlyingBird: Bird {
    func fly() {
        print("Flying")
    }
}

class Penguin: Bird {
    override func move() {
        print("Walking or swimming")
    }
}

//I – Interface Segregation Principle (Princípio da Segregação de Interface)

//Clients should not be forced to depend on interfaces they do not use.
//This means that when designing interfaces, you should break them down into smaller, more specific parts.

//WRONG
protocol WorkerWrong {
    func work()
    func attendMeetings()
}

class DeveloperWrong: WorkerWrong {
    func work() {
        print("writing code")
    }
    func attendMeetings() {
        print("I don’t like meetings, but I have to go.")
    }
}

class ManagerWrong: WorkerWrong {
    func work() {
        print("Managing the team.")
    }
    func attendMeetings() {
        print("I love meetings!")
    }
}

//CORRECT
protocol Workable {
    func work()
}

protocol MeetingAttendable {
    func attendMeetings()
}

class Developer: Workable {
    func work() {
        print("writing code")
    }
}

class Manager: Workable, MeetingAttendable {
    func work() {
        print("Managing the team.")
    }
    
    func attendMeetings() {
        print("I love meetings!")
    }
}

//D – Dependency Inversion Principle (Princípio da Inversão de Dependência)

//Clients should not be forced to depend on interfaces they do not use.
//This means that when designing interfaces, you should break them down into smaller and more specific parts.

//WRONG
class EmailServiceWrong {
    func sendEmail(message: String) {
        print("sending email: \(message)")
    }
}

class NotificationWrong {
    let emailService = EmailServiceWrong()
    
    func sendNotification(message: String) {
        emailService.sendEmail(message: message)
    }
}

//CORRECT
protocol MessageService {
    func sendMessage(message: String)
}

class EmailService: MessageService {
    func sendMessage(message: String) {
        print("sending email: \(message)")
    }
}

class SMSService: MessageService {
    func sendMessage(message: String) {
        print("sending SMS: \(message)")
    }
}

class Notification {
    let service: MessageService
    
    init(service: MessageService) {
        self.service = service
    }
    
    func sendNotification(message: String) {
        service.sendMessage(message: message)
    }
}
