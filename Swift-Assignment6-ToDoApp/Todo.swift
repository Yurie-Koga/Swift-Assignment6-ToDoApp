//
//  Todo.swift
//  Swift-Assignment6-ToDoApp
//
//  Created by Uji Saori on 2021-01-10.
//

import Foundation

struct Todo: Codable {
    var title: String
    var todoDescription: String?
    var priorityNum: Int    // 0: High, 1: Medium, 2: Low
    var isCompleted: Bool
    
    static var archiveURL: URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsURL.appendingPathComponent("emojis").appendingPathExtension("plist")
        
        return archiveURL
    }
    
    static var sampleTodos: [Todo] {
        return [
            Todo(title: "Eat BreakFast", todoDescription: nil, priorityNum: 0, isCompleted: false),
            Todo(title: "Sleep early", todoDescription: "rest up", priorityNum: 1, isCompleted: true),
            Todo(title: "Run", todoDescription: nil, priorityNum: 2, isCompleted: false)
        ]
    }
    
    static func saveToFile(todos: [Todo]) {
        let encoder = PropertyListEncoder()
        do {
            let encodedTodos = try encoder.encode(todos)
            try encodedTodos.write(to: Todo.archiveURL)
        } catch {
            print("Error encoding todos: \(error.localizedDescription)")
        }
    }
    
    static func loadFromFile() -> [Todo]? {
        guard let todoData = try? Data(contentsOf: Todo.archiveURL) else { return nil }
        
        do {
            let decoder = PropertyListDecoder()
            let decodedTodos = try decoder.decode([Todo].self, from: todoData)
            
            return decodedTodos
        } catch {
            print("Error decoding todos: \(error)")
            return nil
        }
    }
}
