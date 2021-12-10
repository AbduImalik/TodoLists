//
//  AddNewViewController.swift
//  ToDo Lists
//
//  Created by Abdulmalik on 24/04/1443 AH.
//

import UIKit

class AddNewViewController: UIViewController {

    var isCreation = true
    var editedTodo : Todo?
    var editedTodoIndex : Int?
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var MainButton: UIButton!
    @IBOutlet weak var todoImageView: UIImageView!

    @IBOutlet weak var chooseImageView: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isCreation == false {
            MainButton.setTitle("تعديل", for: .normal)
            navigationItem.title = "تعديل مهمة"
            if let todo = editedTodo {
                titleTextField.text = todo.tilte
                detailsTextView.text = todo.details
                todoImageView.image = todo.image
            }
            
        }else{
            chooseImageView.setTitle("اختر صورة", for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func changeButtonClicked(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
            
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        if isCreation{
            //date creation
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yy/MM/dd h:m a"

            dateFormatter.locale = Locale(identifier: "ar")

            let dateStr = dateFormatter.string(from: date)

            let TodoAdd = Todo(tilte: titleTextField.text!, image : todoImageView.image, details: detailsTextView.text,date: dateStr)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AddNewTodo"), object: nil, userInfo: ["addedTodo":TodoAdd])
            
            let alert = UIAlertController(title: "تمت الاضافة", message: "تم اضافة المهمة بنجاح", preferredStyle: UIAlertController.Style.alert)
            
            let closeAction = UIAlertAction(title: "اغلاق", style: UIAlertAction.Style.cancel) { _ in self.tabBarController?.selectedIndex = 0
                self.titleTextField.text = ""
                self.detailsTextView.text = ""

            }
            
            alert.addAction(closeAction)
            present(alert, animated: true, completion: nil)
            
                        
        }else{
            //edit todo
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yy/MM/dd h:m a"

            dateFormatter.locale = Locale(identifier: "ar")

            let dateStr = dateFormatter.string(from: date)

            let todo = Todo(tilte: titleTextField.text!, image:todoImageView.image, details: detailsTextView.text,date: dateStr)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CurrentTodoEdited"), object: nil, userInfo: ["EditedTodo":todo,"editedTodoIndex":editedTodoIndex!])
            
            let alert = UIAlertController(title: "تم العديل", message: "تم التعديل بنجاح", preferredStyle: UIAlertController.Style.alert)
            
            let closeAction = UIAlertAction(title: "اغلاق", style: UIAlertAction.Style.cancel) { _ in
                self.navigationController?.popViewController(animated: true)
                self.titleTextField.text = ""
                self.detailsTextView.text = ""

            }
            
            alert.addAction(closeAction)
            present(alert, animated: true, completion: nil)
            
                        
        }
    }
}

extension AddNewViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        dismiss(animated: true)
        todoImageView.image = image
        
    }
    
}
