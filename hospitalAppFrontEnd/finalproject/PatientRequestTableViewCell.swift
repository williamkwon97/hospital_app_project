//
//  PatientRequestTableViewCell.swift
//  finalproject
//
//  Created by Peter Vail Driscoll II on 5/1/20.
//  Copyright © 2020 groupproject. All rights reserved.
//

import UIKit

class PatientRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var designatedPickupLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
