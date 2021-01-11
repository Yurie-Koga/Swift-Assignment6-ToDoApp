//
//  TodoTableViewController.swift
//  Swift-Assignment6-ToDoApp
//
//  Created by Uji Saori on 2021-01-10.
//

import UIKit

class TodoTableViewController: UITableViewController, AddEditTodoTVCDelegate {
        
    let cellId = "TodoCell"
    
    
//    var todos: [Todo] = []
    // section by Priority
    var sections: [GroupedSection<Int, Todo>] = [] {
        didSet {
            var arr: [Todo] = []
            for s in sections {
                arr.append(contentsOf: s.rows)
            }
            Todo.saveToFile(todos: arr)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: cellId)
        title = "Todo List"
        navigationController?.navigationBar.barTintColor = .white
        
        // nav bar buttons
        navigationItem.leftBarButtonItem = editButtonItem
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTodo))
        let delButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(delTodos))
        navigationItem.rightBarButtonItems = [addButton, delButton]
        
        // dynamic row height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        // enable multiple rows editing
        tableView.allowsMultipleSelectionDuringEditing = true
//        tableView.allowsSelectionDuringEditing = true

        // set data
        var todos: [Todo] = []
        if let savedTodos = Todo.loadFromFile() {
            todos = savedTodos
        } else {
            todos = Todo.sampleTodos
        }
        // path
//        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//        print("Document Path: ", documentsPath)
        
        // section by Priority
        self.sections = GroupedSection.group(rows: todos, by: { $0.priorityNum })
        self.sections.sort { lhs, rhs in lhs.sectionItem < rhs.sectionItem }
        
    }

    @objc func addNewTodo() {
        navigateToAddEditTVC()
    }
    
    private func navigateToAddEditTVC() {
        let addEditTVC = AddEditTodoTableViewController(style: .grouped)
        addEditTVC.delegate = self
        let addEditNC = UINavigationController(rootViewController: addEditTVC)
        present(addEditNC, animated: true, completion: nil)
    }
    
    @objc func delTodos() {
        print("going to delete")
        if let indexPaths = tableView.indexPathsForSelectedRows  {
            for i in indexPaths {
                sections[i.section].rows.remove(at: i.row)
            }
            tableView.reloadData()
        }
    }
    
    
    // delegate: add
    func add(_ todo: Todo) {
//        todos.append(todo)
        let sectionNum = todo.priorityNum
        // need to increment section's row before inserting
        sections[sectionNum].rows.append(todo)
        tableView.insertRows(at: [IndexPath(row: sections[sectionNum].rows.count - 1, section: sectionNum)], with: .automatic)
    }
    
    // delegate: edit
    func edit(_ todo: Todo) {
//        print("comes int to edit: \(tableView.indexPathForSelectedRow)")
        if let indexPath = tableView.indexPathForSelectedRow {
            let sectionNum = todo.priorityNum
            if sectionNum != indexPath.section {
                // section changed
                sections[indexPath.section].rows.remove(at: indexPath.row)
                sections[sectionNum].rows.append(todo)
                tableView.reloadData()
            } else {
                // same section
                sections[sectionNum].rows[indexPath.row] = todo
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch self.sections[section].sectionItem {
        case 0:
            return "High Priority"
        case 1:
            return "Medium Priority"
        case 2:
            return "Low Priority"
        default:
            return ""
        }
    }

    // get rows count in each section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.sections[section]
        return section.rows.count
    }
    
    // get rows count in total
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return todos.count
//    }
    
    // display cells in table: cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = self.sections[indexPath.section]
        let todo = section.rows[indexPath.row]
//        let todo = todos[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TodoTableViewCell
                
        cell.update(with: todo)
        // enalbe reorder cells
        cell.showsReorderControl = true
//        cell.delegate = self
        
        cell.completedButtonAction = { [unowned self] in
            print("comes in: \(todo)")
            if !tableView.isEditing {
                self.sections[indexPath.section].rows[indexPath.row].isCompleted = !todo.isCompleted
                tableView.reloadRows(at: [indexPath], with: .automatic)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        return cell
    }
    
    // reorder cells: moveRowAt
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let section = self.sections[sourceIndexPath.section]
        var todo = section.rows[sourceIndexPath.row]
        if sourceIndexPath.section != destinationIndexPath.section {
            // section changed
            todo.priorityNum = destinationIndexPath.section
        }
        sections[sourceIndexPath.section].rows.remove(at: sourceIndexPath.row)
        sections[destinationIndexPath.section].rows.insert(todo, at: destinationIndexPath.row)
        // update index in table view
        tableView.reloadData()
    }
    
    func tapFunction2() {
        print("tap working in table view")        
    }
    
    // edit selected cell: didSelectRowAt
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("section: \(indexPath.section)")
//        print("row: \(indexPath.row)")
        
        if !tableView.isEditing {
            let section = self.sections[indexPath.section]
            let todo = section.rows[indexPath.row]
            let addEditTVC = AddEditTodoTableViewController(style: .grouped)
            addEditTVC.delegate = self
            // pass Todo data
    //        addEditTVC.todo = todos[indexPath.row]
            addEditTVC.todo = todo
            let addEditNC = UINavigationController(rootViewController: addEditTVC)
            present(addEditNC, animated: true, completion: nil)
        }
    }
    
    // delete selelcted cell: commit
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
//            todos.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
            sections[indexPath.section].rows.remove(at: indexPath.row)
            // update index in table view
            tableView.reloadData()
        }
//        } else if editingStyle == .insert {
//            // insert + button is tapped
//        }
    }
}
