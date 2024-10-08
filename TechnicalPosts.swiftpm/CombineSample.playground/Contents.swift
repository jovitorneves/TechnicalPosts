import UIKit
import SwiftUI
import Combine

//https://www.linkedin.com/posts/vitorneves0_ios-swift-combine-activity-7249170094403014657-eQCl?utm_source=share&utm_medium=member_desktop

//https://www.linkedin.com/pulse/como-usar-combine-swift-para-melhorar-programa%C3%A7%C3%A3o-em-jo%C3%A3o-vitor-xufnf/?trackingId=jv5QUccsQ1mFLXJ4QoUCmg%3D%3D

class ViewModel: ObservableObject {

    @Published var postTitle: String = String()
    var cancellables = Set<AnyCancellable>()
    
    func fetchPost() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1")!
        
        // Starts the task of downloading and processing the data.
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data } // Extracts only the data from the result.
            .decode(type: Post.self, decoder: JSONDecoder()) // Decodes the JSON into a Post object.
            .receive(on: DispatchQueue.main) // Ensures that the UI update occurs on the main thread.
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error)") // Handles any errors.
                case .finished:
                    break // Success case (no action needed here).
                }
            }, receiveValue: { [weak self] post in
                self?.postTitle = post.title // Updates the property @Published
            })
            .store(in: &cancellables) // Stores the subscription to prevent memory leaks.
    }
}

struct ContentView: View {

    @StateObject var viewModel = ViewModel()
    var body: some View {
        VStack {
            Text(viewModel.postTitle)
                .padding()
            Button("Carregar Post") {
                viewModel.fetchPost()
            }
        }
    }
}

struct Post: Decodable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}
