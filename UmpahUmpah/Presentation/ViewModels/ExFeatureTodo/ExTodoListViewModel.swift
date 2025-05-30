//
//  ExTodoListViewModel.swift
//  UmpahUmpah
//
//  Created by chang hyen yun on 5/29/25.
//

import Foundation
import Combine

final class ExTodoListViewModel: ObservableObject {
    @Published var todos: [ExTodo] = []

    private let getTodosUseCase: ExGetTodosUseCase

    init(getTodosUseCase: ExGetTodosUseCase) {
        self.getTodosUseCase = getTodosUseCase
        loadTodos()
    }

    func loadTodos() {
        todos = getTodosUseCase.execute()
    }
}
