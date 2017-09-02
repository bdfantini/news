//
//  StoryTableViewCell.swift
//  news
//
//  Created by Benjamin Fantini on 9/2/17.
//  Copyright © 2017 Benjamin Fantini. All rights reserved.
//

import UIKit

class StoryTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    // MARK: Attributes
    weak var story: Story? {
        didSet {
            self.updateView()
        }
    }
    
    // MARK: View Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Private funtions
    private func updateView() {
        if let story = self.story {
            self.titleLabel.text = story.title
            self.subtitleLabel.text = "\(story.author) - \(story.createdAt.prettyTimeAgo())"
        }
    }
}
