//
//  DetailsViewController.swift
//  ToDo Lists
//
//  Created by Abdulmalik on 23/04/1443 AH.
//

import UIKit

class DetailsViewController: UIViewController {

    var index : Int!
    @IBOutlet weak var imageDetailsViewC: UIImageView!
    @IBOutlet weak var tilteDetails: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    var toDo : Todo!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        

        setupUI()

        NotificationCenter.default.addObserver(self, selector: #selector(currentTodoEdited), name: NSNotification.Name(rawValue: "CurrentTodoEdited"), object: nil)
        
        
    }
    
    @objc func currentTodoEdited(notification : Notification){
        if let todo = notification.userInfo?["EditedTodo"] as? Todo{
            self.toDo = todo
            setupUI()

        }
    }
    
    func setupUI(){
        tilteDetails.text = toDo.tilte
        detailsLabel.text = toDo.details
        imageDetailsViewC.image = toDo.image
    }
    
    @IBAction func editTodoButtonClicked(_ sender: Any) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AddNewViewController") as? AddNewViewController{
            vc.isCreation = false
            vc.editedTodo = toDo
            vc.editedTodoIndex = index
            navigationController?.pushViewController(vc, animated: true)
            
        
        }
        
        
        
    }
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
        
        
        
        let confirmAlert = UIAlertController(title: "تنبيه", message: "هل تريد حذف المهمة", preferredStyle: UIAlertController.Style.alert)
        
        let confirmAction = UIAlertAction(title: "تاكيد الحذف", style: UIAlertAction.Style.destructive) { alet in
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "TodoDeleted"), object: nil, userInfo: ["currentTodoDeleted":self.index!])


            let alert =  UIAlertController(title: "حذف", message: "تم تحذف المهمة", preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "اغلاق", style: UIAlertAction.Style.default) { alert in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)

        }
        
        let cancelAction = UIAlertAction(title: "الغاء الامر", style: UIAlertAction.Style.default, handler: nil)
        
        confirmAlert.addAction(confirmAction)
        confirmAlert.addAction(cancelAction)
        present(confirmAlert, animated: true, completion: nil)
    }
    
}
