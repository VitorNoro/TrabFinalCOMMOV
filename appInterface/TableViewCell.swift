//
//  TableViewCell.swift
//  appInterface
//
//  Created by Vitor Noro on 14/06/2018.
//  Copyright © 2018 Vitor Noro. All rights reserved.
//

import UIKit

class TableViewCell : UITableViewCell{
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBOutlet weak var hora: UILabel!
    @IBOutlet weak var viagem: UILabel!
    @IBOutlet weak var empresa: UILabel!
    @IBOutlet weak var cais: UILabel!
    
}
