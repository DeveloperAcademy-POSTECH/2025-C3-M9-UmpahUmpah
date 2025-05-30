//
//  ExGetTodosUseCase.swift
//  UmpahUmpah
//
//  Created by chang hyen yun on 5/29/25.
//

import Foundation

final class ExGetTodosUseCase {
    private let repository: ExTodoRepositoryProtocol

    init(repository: ExTodoRepositoryProtocol) {
        self.repository = repository
    }

    func execute() -> [ExTodo] {
        repository.fetchTodos()
    }
}
