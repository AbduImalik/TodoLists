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
        
        self.toDoArray = getTodos()
        
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
            storeTodo(todo: myTodo)
        }
  
    }
    @objc func currentTodoEdited(notification : Notification){
        if let todo = notification.userInfo?["EditedTodo"] as? Todo{
            if let index = notification.userInfo?["editedTodoIndex"] as? Int{
                toDoArray[index] = todo
                toDoTableView.reloadData()
                updateTodo(todo: todo, index: index)
            }
        }
    }
    @objc func currentTodoDeleted(notification : Notification){
        
        if let index = notification.userInfo?["currentTodoDeleted"] as? Int{
            toDoArray.remove(at: index)
            toDoTableView.reloadData()
            deleteTodo(index: index)
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
    
    func storeTodo(todo:Todo){
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let mangedContext = appdelegate.persistentContainer.viewContext
        guard let todoEntity = NSEntityDescription.entity(forEntityName: "Todos", in: mangedContext) else { return }
        let todoObj = NSManagedObject.init(entity: todoEntity, insertInto: mangedContext)
        todoObj.setValue(todo.tilte, forKey: "title")
        todoObj.setValue(todo.details, forKey: "details")
        if let image = todo.image {
            let imageData = image.jpegData(compressionQuality: 1)
            todoObj.setValue(imageData, forKey: "image")
        }
        do {
            try mangedContext.save()
            print("==== success ====")
        } catch {
            print("==== erorr ====")
        }
        
    }
    
    func getTodos() -> [Todo] {
        var todos : [Todo] = []
        
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else{return []}
        
        let context = appdelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todos")
        
        do{
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            for managedTodo in result {
                let title = managedTodo.value(forKey: "title") as? String
                let details = managedTodo.value(forKey: "details") as? String
                var todoImage : UIImage?
                if let imageFromContext = managedTodo.value(forKey: "image") as? Data{
                    todoImage = UIImage(data: imageFromContext)
                    
                }
                let todo = Todo(tilte: title ?? "" ,image: todoImage,details: details ?? "")
                
                todos.append(todo)
            }
            
        }catch{
            
        }
        return todos
    }
    
    func updateTodo(todo:Todo , index : Int){
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        
        let context = appdelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todos")
        
        do{
            
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            result[index].setValue(todo.tilte, forKey: "title")
            result[index].setValue(todo.details, forKey: "details")
            if let image = todo.image {
                let imageData = image.jpegData(compressionQuality: 1)
                result[index].setValue(imageData, forKey: "image")

            }
            try context.save()
            
            
        }catch{
            print("error")
        }
        
    }
    func deleteTodo(index : Int){
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        
        let context = appdelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todos")
        
        do{
            
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            let todoToDelete = result[index]
            context.delete(todoToDelete)
            try context.save()
            
            
        }catch{
            print("error")
        }
        
    }

}









