//
//  ExTodoLocalDataSource.swift
//  UmpahUmpah
//
//  Created by chang hyen yun on 5/29/25.
//

import Foundation

final class ExTodoLocalDataSource {
    func loadTodos() -> [ExTodo] {
        [
            ExTodo(id: UUID(), title: "Gus Nice Guy", isDone: false),
            ExTodo(id: UUID(), title: "Gus Hansome Guy", isDone: true)
        ]
    }
}
