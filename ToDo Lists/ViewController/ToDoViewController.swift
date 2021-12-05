//
//  ToDoViewController.swift
//  ToDo Lists
//
//  Created by Abdulmalik on 23/04/1443 AH.
//

import UIKit
import CoreData

class ToDoViewController: UIViewController {

    var toDoArray : [Todo] = []

    @IBOutlet weak var toDoTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.toDoArray = TodoStorage.getTodos()
        
        toDoTableView.dataSource = self
        toDoTableView.delegate = self
        
        // New Todo Notification
        NotificationCenter.default.addObserver(self, selector: #selector(addNewTodo), name: NSNotification.Name(rawValue: "AddNewTodo"), object: nil)
        
        // Edite Todo Notification
        NotificationCenter.default.addObserver(self, selector: #selector(currentTodoEdited), name: NSNotification.Name(rawValue: "CurrentTodoEdited"), object: nil)
        
        // Delete Todo Notification
        NotificationCenter.default.addObserver(self, selector: #selector(currentTodoDeleted), name: NSNotification.Name(rawValue: "TodoDeleted"), object: nil)
        
    }

    
    
    @objc func addNewTodo(notification : Notification){
        
        if let myTodo = notification.userInfo?["addedTodo"] as? Todo{
            
            toDoArray.append(myTodo)
            toDoTableView.reloadData()
            TodoStorage.storeTodo(todo: myTodo)
        }
  
    }
    @objc func currentTodoEdited(notification : Notification){
        if let todo = notification.userInfo?["EditedTodo"] as? Todo{
            if let index = notification.userInfo?["editedTodoIndex"] as? Int{
                toDoArray[index] = todo
                toDoTableView.reloadData()
                TodoStorage.updateTodo(todo: todo, index: index)
            }
        }
    }
    @objc func currentTodoDeleted(notification : Notification){
        
        if let index = notification.userInfo?["currentTodoDeleted"] as? Int{
            toDoArray.remove(at: index)
            toDoTableView.reloadData()
            TodoStorage.deleteTodo(index: index)
        }
        
    }
}

extension ToDoViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return toDoArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = toDoTableView.dequeueReusableCell(withIdentifier: "ToDoViewCell") as! ToDoViewCell
        
        cell.toDoTitle.text = toDoArray[indexPath.row].tilte
        
        if toDoArray[indexPath.row].image != nil {
            cell.toDoImage.image = toDoArray[indexPath.row].image
        }else{
            cell.toDoImage.image = UIImage(named: "Image")
        }
        cell.toDoImage.layer.cornerRadius = cell.toDoImage.frame.width / 2
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo1 = toDoArray[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
        if let viewController = vc {
            viewController.toDo = todo1
            viewController.index = indexPath.row
            navigationController?.pushViewController(viewController, animated: true)
                        
        }
    }
    
    
        



}









