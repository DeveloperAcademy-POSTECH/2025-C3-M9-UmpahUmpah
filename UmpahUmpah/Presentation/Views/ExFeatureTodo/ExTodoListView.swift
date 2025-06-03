//
//  ExTodoListView.swift
//  UmpahUmpah
//
//  Created by chang hyen yun on 5/29/25.
//

import SwiftUI

struct ExTodoListView: View {
    @StateObject var viewModel: ExTodoListViewModel
    
    var body: some View {
        NavigationView {
                    List(viewModel.todos, id: \.id) { todo in
                        HStack {
                            Text(todo.title)
                            Spacer()
                            if todo.isDone {
                                Image(systemName: "checkmark.circle.fill")
                            } else {
                                Image(systemName: "circle")
                            }
                        }
                    }
                    .navigationTitle("Todos")
                }
    }
}

final class MockTodoRepository: ExTodoRepositoryProtocol {
    private let todos: [ExTodo]

    init(todos: [ExTodo]) {
        self.todos = todos
    }

    func fetchTodos() -> [ExTodo] {
        todos
    }
}

#Preview {
    
    let mockTodos = [
           ExTodo(id: UUID(), title: "Mock Task 1", isDone: false),
           ExTodo(id: UUID(), title: "Mock Task 2", isDone: true)
       ]

       let mockUseCase = ExGetTodosUseCase(repository: MockTodoRepository(todos: mockTodos))
       let viewModel = ExTodoListViewModel(getTodosUseCase: mockUseCase)
    
    ExTodoListView(viewModel: viewModel)
}
