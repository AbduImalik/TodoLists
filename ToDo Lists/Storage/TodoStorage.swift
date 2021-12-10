//
//  TodoStorage.swift
//  ToDo Lists
//
//  Created by Abdulmalik on 01/05/1443 AH.
//

import Foundation
import UIKit
import CoreData

class TodoStorage{
    
    static func storeTodo(todo:Todo){
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let mangedContext = appdelegate.persistentContainer.viewContext
        guard let todoEntity = NSEntityDescription.entity(forEntityName: "Todos", in: mangedContext) else { return }
        let todoObj = NSManagedObject.init(entity: todoEntity, insertInto: mangedContext)
        todoObj.setValue(todo.tilte, forKey: "title")
        todoObj.setValue(todo.details, forKey: "details")
        todoObj.setValue(todo.date, forKey: "date")
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
    static func updateTodo(todo:Todo , index : Int){
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
            result[index].setValue(todo.date, forKey: "date")
            try context.save()
            
            
        }catch{
            print("error")
        }
        
    }
    static func deleteTodo(index : Int){
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
    static func getTodos() -> [Todo] {
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
                let date = managedTodo.value(forKey: "date") as? String
                let todo = Todo(tilte: title ?? "" ,image: todoImage,details: details ?? "",date: date)
                
                todos.append(todo)
            }
            
        }catch{
            
        }
        return todos
    }


}
