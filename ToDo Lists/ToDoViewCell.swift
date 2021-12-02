//
//  ToDoViewCell.swift
//  ToDo Lists
//
//  Created by Abdulmalik on 23/04/1443 AH.
//

import UIKit

class ToDoViewCell: UITableViewCell {

    
    
    @IBOutlet weak var toDoTitle: UILabel!
    
    @IBOutlet weak var toDoDate: UILabel!
    
    @IBOutlet weak var toDoImage: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
