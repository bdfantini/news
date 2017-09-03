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
    
    // MARK: File Private funtions
    fileprivate func updateView() {
        if let story = self.story {
            self.titleLabel.text = story.title
            self.subtitleLabel.text = "\(story.author) - \(story.createdAt.prettyTimeAgo())"
        }
    }
}
