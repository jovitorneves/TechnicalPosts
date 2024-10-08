import UIKit

//https://www.linkedin.com/posts/vitorneves0_clean-swift-activity-7245059629922078720-OVTo?utm_source=share&utm_medium=member_desktop

//Organizing the Login Screen.

//Imagine that you are creating a simple login screen where the user enters their email and password and tries to log in.
//In Clean Swift, the responsibility of each part is clearly defined:

//View (ViewController): Responsible for receiving user interaction and displaying the result on the screen.
class LoginViewController: UIViewController {
    
    var interactor: LoginInteractorProtocol?
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func didTapLoginButton() {
        let request = Login.Request(email: emailTextField.text ?? String(),
                                    password: passwordTextField.text ?? String())
        interactor?.login(request: request)
    }
    
    func displayLoginSuccess(viewModel: Login.ViewModel) {
        // Updates the UI with the result of the login.
        showSuccessMessage(viewModel.message)
        // Navigate to home if needed
        // router?.navigateToHome()
    }

    func displayLoginError(viewModel: Login.ViewModel) {
        showErrorMessage(viewModel.message)
    }
    
    private func showSuccessMessage(_ message: String) {
        // Implement success message display logic (e.g., an alert)
        print(message)
    }

    private func showErrorMessage(_ message: String) {
        // Implement error message display logic (e.g., an alert)
        print(message)
    }
}

//Interactor: Responsible for business logic, such as data validation or network calls.
protocol LoginInteractorProtocol {
    @MainActor
    func login(request: Login.Request)
}

class LoginInteractor: LoginInteractorProtocol {
    
    var presenter: LoginPresenterProtocol?
    
    @MainActor
    func login(request: Login.Request) {
        // Validates the credentials (which can be either local validation or an API call).
        if request.email.isEmpty || request.password.isEmpty {
            let response = Login.Response(success: false,
                                          message: "Please fill in all the fields.")
            presenter?.presentLoginResponse(response: response)
        } else {
            // Calls authentication service (fictitious example).
            let success = AuthService.shared.login(email: request.email,
                                                   password: request.password)
            let message = success ? "Login successful!" : "Invalid credentials."
            let response = Login.Response(success: success, message: message)
            presenter?.presentLoginResponse(response: response)
        }
    }
}

//Presenter: Formats the response data from the Interactor so that it is suitable for display by the View
protocol LoginPresenterProtocol {
    @MainActor
    func presentLoginResponse(response: Login.Response)
}

class LoginPresenter: LoginPresenterProtocol {
    
    weak var viewController: LoginViewController?
    
    @MainActor
    func presentLoginResponse(response: Login.Response) {
        let viewModel = Login.ViewModel(message: response.message)
        
        if response.success {
            viewController?.displayLoginSuccess(viewModel: viewModel)
        } else {
            viewController?.displayLoginError(viewModel: viewModel)
        }
    }
}

//Router: Handles navigation between screens.
protocol LoginRoutingLogic {
    func navigateToHome()
}

class LoginRouter: @preconcurrency LoginRoutingLogic {
    
    weak var viewController: LoginViewController?
    
    @MainActor
    func navigateToHome() {
        // Navigates to the main screen after a successful login
        let homeViewController = UIViewController()
        viewController?.navigationController?.pushViewController(homeViewController,
                                                                 animated: true)
    }
}

struct Login {
    struct Request {
        let email: String
        let password: String
    }

    struct Response {
        let success: Bool
        let message: String
    }

    struct ViewModel {
        let message: String
    }
}

class AuthService {
    
    @MainActor
    static let shared = AuthService()
    
    func login(email: String, password: String) -> Bool {
        // Dummy logic for authentication; replace with actual authentication logic
        return email == "test@example.com" && password == "password123"
    }
}





//Separating Business Logic in a Task Management Application.

//In a task management application, where the user can create, edit, and delete tasks, Clean Swift helps to clearly separate responsibilities:

//View (ViewController): Responsible for receiving user interaction and displaying the result on the screen.
class TaskListViewController: UIViewController {
    
    var interactor: TaskListInteractorProtocol?
    var tasks: [TaskViewModel] = []
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor?.fetchTasks()
    }
    
    func displayTasks(viewModel: TaskList.ViewModel) {
        // Displays the task list.
        tasks = viewModel.tasks
        tableView.reloadData()
    }
}

//Interactor: Responsible for business logic, such as data validation or network calls.
protocol TaskListInteractorProtocol {
    func fetchTasks()
    func deleteTask(request: TaskList.DeleteTaskRequest)
}

class TaskListInteractor: @preconcurrency TaskListInteractorProtocol {
    
    var presenter: TaskListPresenterProtocol?
    
    @MainActor
    func fetchTasks() {
        // Fetches tasks from a database or API.
        let tasks = TaskService.shared.getTasks()
        let response = TaskList.Response(tasks: tasks)
        presenter?.presentTasks(response: response)
    }
    
    @MainActor
    func deleteTask(request: TaskList.DeleteTaskRequest) {
        TaskService.shared.deleteTask(taskId: request.taskId)
        fetchTasks() // Updates the list after deletion
    }
}

//Presenter: Formats the response data from the Interactor so that it is suitable for display by the View
protocol TaskListPresenterProtocol {
    func presentTasks(response: TaskList.Response)
}

class TaskListPresenter: @preconcurrency TaskListPresenterProtocol {
    
    weak var viewController: TaskListViewController?
    
    @MainActor
    func presentTasks(response: TaskList.Response) {
        let viewModel = TaskList.ViewModel(tasks: response.tasks.map { TaskViewModel(name: $0.name) })
        viewController?.displayTasks(viewModel: viewModel)
    }
}

struct TaskModel {
    let id: String
    let name: String
}

struct TaskViewModel {
    let name: String
}


class TaskService {
    
    @MainActor
    static let shared = TaskService()
    private var tasks: [TaskModel] = []

    init() {
        // Initialize with some dummy tasks
        tasks = [
            TaskModel(id: "1", name: "Buy groceries"),
            TaskModel(id: "2", name: "Walk the dog"),
            TaskModel(id: "3", name: "Finish homework")
        ]
    }

    func getTasks() -> [TaskModel] {
        return tasks
    }

    func deleteTask(taskId: String) {
        tasks.removeAll { $0.id == taskId }
    }
}

struct TaskList {
    struct Response {
        let tasks: [TaskModel]
    }

    struct ViewModel {
        let tasks: [TaskViewModel]
    }

    struct DeleteTaskRequest {
        let taskId: String
    }
}
