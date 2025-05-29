//
//  ExTodoRepository.swift
//  UmpahUmpah
//
//  Created by chang hyen yun on 5/29/25.
//

import Foundation

final class ExTodoRepository: ExTodoRepositoryProtocol {
    private let localDataSource: ExTodoLocalDataSource
    
    init(localDataSource: ExTodoLocalDataSource) {
        self.localDataSource = localDataSource
    }
    
    func fetchTodos() -> [ExTodo] {
        localDataSource.loadTodos()
    }
}
