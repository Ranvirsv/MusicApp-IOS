//
//  SongTableViewCell.swift
//  MusicApp
//
//  Created by Ranvir Singh Virk on 4/14/23.
//Jonathon Mangan jonmanga@iu.edu
//Ranvir Virk rsvirk@iu.edu
//Sanmeet Singh ss140@iu.edu
//Music Player app
//Submitted: 04/28/2023

import UIKit
// references
// https://stackoverflow.com/questions/6216839/how-to-add-spacing-between-uitableviewcell

class SongTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var songName: UILabel!
    var song: Song?
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
    }

}
