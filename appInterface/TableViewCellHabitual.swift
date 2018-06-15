//
//  TableViewCellHabitual.swift
//  appInterface
//
//  Created by Vitor Noro on 14/06/2018.
//  Copyright © 2018 Vitor Noro. All rights reserved.
//

import UIKit

class TableViewCellHabitual: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var hora: UILabel!
    @IBOutlet weak var destino: UILabel!
    @IBOutlet weak var empresa: UILabel!
    

}
