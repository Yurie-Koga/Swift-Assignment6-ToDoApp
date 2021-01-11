//
//  TodoTableViewCell.swift
//  Swift-Assignment6-ToDoApp
//
//  Created by Uji Saori on 2021-01-10.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    let completedMark = "✔️"
    let incompletedMark = "⚪️"
    
//    let todoCompletedLable: UILabel = {
//        let lb = UILabel()
//        lb.setContentHuggingPriority(.required, for: .horizontal)
//        return lb
//    }()
    let todoCompletedButton: UIButton = {
        let btn = UIButton()
        btn.setContentHuggingPriority(.required, for: .horizontal)
        return btn
    }()
    
    let todoTitleLable: UILabel = {
        let lb = UILabel()
        return lb
    }()
    
    let todoDescriptionLable: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        return lb
    }()

    var completedButtonAction : (() -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //        let vStackView = VerticalStackView(arrangedSubviews: [
        //            todoTitleLable,
        //            todoDescriptionLable
        //        ], spacing: 0, alignment: .fill,distribution: .fill)
        
        let hStackView = HorizontalStackView(arrangedSubviews: [
//            todoCompletedLable,
            todoCompletedButton,
            todoTitleLable
        ] , spacing: 16, alignment: .fill, distribution: .fill)
        
        contentView.addSubview(hStackView)
        hStackView.matchParent(padding: .init(top: 8, left: 16, bottom: 8, right: 16))
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
//        todoCompletedLable.isUserInteractionEnabled = true
//        todoCompletedLable.addGestureRecognizer(tap)
        
        self.todoCompletedButton.addTarget(self, action: #selector(completedButtonTapped(_:)), for: .touchUpInside)
    }
  
    @objc func completedButtonTapped(_ sender: UIButton){
        // if the closure is defined (not nil)
        // then execute the code inside the subscribeButtonAction closure
        completedButtonAction?()
      }
    
//    @objc func tapFunction(sender:UITapGestureRecognizer) {
//        print("tap working")
//
////        TodoTableViewController.tapFunction2()
////        let newTodo = Todo(title: titleCell.textField.text!,
////                           todoDescription: descriptionCell.textField.text!,
////                           priorityNum: Int(priorityCell.prioritySC.selectedSegmentIndex),
////                           isCompleted: Int(completedCell.completedSC.selectedSegmentIndex) == 0 ? true : false)
////
//        let newTodo = Todo(title: "aa", todoDescription: nil, priorityNum: 2, isCompleted: false)
//        self.delegate?.edit(newTodo)
//        print("end of tap func")
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with todo: Todo) {
        todoTitleLable.text = todo.title
        todoDescriptionLable.text = todo.todoDescription
//        todoCompletedLable.text = (todo.isCompleted) ? completedMark : incompletedMark;
        let button = (todo.isCompleted) ? completedMark : incompletedMark
        todoCompletedButton.setTitle(button, for: .normal)
    }
    
}
