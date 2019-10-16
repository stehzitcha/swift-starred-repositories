//
//  LoadingCeell.swift
//  swift-starred-repositories
//
//  Created by Stella Iemma Braz on 15/10/19.
//  Copyright © 2019 stella. All rights reserved.
//

import UIKit

class LoadingCell: UITableViewCell {
    
    @IBOutlet weak var uiSpinner: UIActivityIndicatorView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
