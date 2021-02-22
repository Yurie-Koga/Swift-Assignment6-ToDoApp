//
//  ManagedTodo.swift
//  Swift-Assignment6-ToDoApp
//
//  Created by Uji Saori on 2021-02-21.
//

import Foundation
import CoreData

class ManagedToDo: NSManagedObject {
    
    class func findOrCreateTodo(matching todoInfo: Todo, with priorityNum: Int, in context: NSManagedObjectContext) throws -> ManagedToDo {
        
        let request: NSFetchRequest<ManagedToDo> = ManagedToDo.fetchRequest()
        request.predicate = NSPredicate(format: "title = %@", todoInfo.title)

        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
              assert(matches.count == 1, "ManagedToDo.findOrCreateTodo -- database inconsistency")
                return matches[0]
            }
            
        } catch {
            throw error
        }
        
        // no match is found
        let todo = ManagedToDo(context: context)
        todo.title = todoInfo.title
        todo.todoDescription = todoInfo.todoDescription
        todo.priorityNum = Int64(todoInfo.priorityNum)  // as per data type in CDTodo
        todo.isCompleted = todoInfo.isCompleted
        return todo
    }
    
    class func deleteTodos(matching todoInfos: [Todo], in context: NSManagedObjectContext) {
        for todo in todoInfos {
            try? deleteTodo(matching: todo, in: context)
        }
    }
    
    class func deleteTodo(matching todoInfo: Todo, in context: NSManagedObjectContext) throws {
        let request: NSFetchRequest<ManagedToDo> = ManagedToDo.fetchRequest()
        request.predicate = NSPredicate(format: "title = %@", todoInfo.title)
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                context.delete(matches[0])
            }
            
        } catch {
            throw error
        }
    }
}
