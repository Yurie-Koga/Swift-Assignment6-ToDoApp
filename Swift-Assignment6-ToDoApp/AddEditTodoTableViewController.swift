//
//  AddEditTodoTableViewController.swift
//  Swift-Assignment6-ToDoApp
//
//  Created by Uji Saori on 2021-01-10.
//

import UIKit

// to delegate add/edit in TodoTableViewController
protocol AddEditTodoTVCDelegate: class {
    func add(_ todo: Todo)
    func edit(_ todo: Todo)
}

class AddEditTodoTableViewController: UITableViewController {
    let headers = ["Title", "Description", "Priority", "Completed"]
    lazy var saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTodo))
    
    let titleCell = AddEditTodoTableViewCell()
    let descriptionCell = AddEditTodoTableViewCell()
    let priorityCell = AddEditTodoTableViewCell(style: .default, reuseIdentifier: "prioritySC")
    let completedCell = AddEditTodoTableViewCell(style: .default, reuseIdentifier: "completedSC")
    
    // weak pointer -> create protocol as class (reference type), not as struct (value type)
    weak var delegate: AddEditTodoTVCDelegate?
    
    var todo: Todo?
    let defaultPriority = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if todo == nil {
            title = "Add Todo"
            priorityCell.prioritySC.selectedSegmentIndex = defaultPriority
            completedCell.completedSC.selectedSegmentIndex = 1
        } else {
            title = "Edit Todo"
            titleCell.textField.text = todo?.title
            descriptionCell.textField.text = todo?.todoDescription
            priorityCell.prioritySC.selectedSegmentIndex = todo?.priorityNum ?? defaultPriority
            completedCell.completedSC.selectedSegmentIndex = (todo?.isCompleted ?? false) ? 0 : 1
        }
        
        // cancel button
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissViewController))
        // save button
        navigationItem.rightBarButtonItem = saveButton
        
        // textfields add target action
        titleCell.textField.addTarget(self, action: #selector(textEditingChanged(_:)), for: .editingChanged)
        descriptionCell.textField.addTarget(self, action: #selector(textEditingChanged(_:)), for: .editingChanged)
//        priorityCell.textField.addTarget(self, action: #selector(textEditingChanged(_:)), for: .editingChanged)
//        completedCell.textField.addTarget(self, action: #selector(textEditingChanged(_:)), for: .editingChanged)
        
        updateSaveButtonState()
        
        // dissmiss keyboard
        self.hideKeyboard()
    }
    
    @objc func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true)
    }
    
    @objc func saveTodo() {
        let newTodo = Todo(title: titleCell.textField.text!,
                           todoDescription: descriptionCell.textField.text!,
                           priorityNum: Int(priorityCell.prioritySC.selectedSegmentIndex),
                           isCompleted: Int(completedCell.completedSC.selectedSegmentIndex) == 0 ? true : false)
        if todo == nil {
            delegate?.add(newTodo)
        } else {
            delegate?.edit(newTodo)
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func updateSaveButtonState() {
        let titleText = titleCell.textField.text ?? ""
        saveButton.isEnabled = !titleText.isEmpty
    }
    

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        return AddEditTodoTableViewCell()
        switch indexPath {
        case [0, 0]:
            return titleCell
        case [1, 0]:
            return descriptionCell
        case [2, 0]:
            return priorityCell
        case [3, 0]:
            return completedCell
        default:
            fatalError("Invalid number of cells")
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
}

extension UITableViewController {
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UITableViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
