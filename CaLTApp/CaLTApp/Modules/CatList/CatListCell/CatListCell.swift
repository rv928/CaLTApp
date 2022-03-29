//
//  CatListCell.swift
//  CaLTApp
//
//  Created by Vora, Ravi | Rv | RP on 2022/03/26.
//

import UIKit
import Kingfisher

class CatListCell: UITableViewCell {
    
    @IBOutlet weak private var catImageView: UIImageView?
    @IBOutlet weak private var nameLabel: UILabel?
    @IBOutlet weak private var originLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func prepareCell(with viewModel: CatListViewModel) {
        self.nameLabel?.text = viewModel.name
        self.originLabel?.text = viewModel.origin
        /**
            Used Kingfisher dependency to load the image.
        */
        self.catImageView?.downloadImage(from: viewModel.image)
    }
}
