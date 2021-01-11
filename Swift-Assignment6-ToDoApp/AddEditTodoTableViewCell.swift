//
//  AddEditTodoTableViewCell.swift
//  Swift-Assignment6-ToDoApp
//
//  Created by Uji Saori on 2021-01-10.
//

import UIKit

class AddEditTodoTableViewCell: UITableViewCell {
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        return tf
    }()
    
//    let stepperTextField: UITextField = {
//        let tf = UITextField()
//        tf.borderStyle = .roundedRect
//        tf.keyboardType = UIKeyboardType.numberPad
//        return tf
//    }()
//
//    let stepper: UIStepper = {
//        let st = UIStepper()
//        return st
//    }()
    
    let prioritySC: UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.insertSegment(withTitle: "High", at: 0, animated: true)
        sc.insertSegment(withTitle: "Mdedium", at: 1, animated: true)
        sc.insertSegment(withTitle: "Low", at: 2, animated: true)
        return sc
    }()
    
    let completedSC: UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.insertSegment(withTitle: "Completed", at: 0, animated: true)
        sc.insertSegment(withTitle: "Not Completed", at: 1, animated: true)
        return sc
    }()


    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        switch reuseIdentifier?.lowercased() {
//        case "stepper":
//            let hStackView = HorizontalStackView(arrangedSubviews: [
//                stepperTextField,
//                stepper
//            ] , spacing: 16, alignment: .fill, distribution: .fill)
//            contentView.addSubview(hStackView)
//            hStackView.matchParent(padding: .init(top: 8, left: 16, bottom: 8, right: 16))
        case "prioritysc":
            contentView.addSubview(prioritySC)
            prioritySC.matchParent(padding: .init(top: 8, left: 16, bottom: 8, right: 16))
        case "completedsc":
            contentView.addSubview(completedSC)
            completedSC.matchParent(padding: .init(top: 8, left: 16, bottom: 8, right: 16))
        default:
            contentView.addSubview(textField)
            textField.matchParent(padding: .init(top: 8, left: 16, bottom: 8, right: 16))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
