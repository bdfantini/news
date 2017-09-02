//
//  StoriesViewController.swift
//  news
//
//  Created by Benjamin Fantini on 8/30/17.
//  Copyright © 2017 Benjamin Fantini. All rights reserved.
//

import RealmSwift
import UIKit

class StoriesViewController: UIViewController {

    // MARK: Constants
    
    let reuseIdentifier = "tableViewReuseIdentifier"
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Attributes
    
    var storyArray = [Story]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    // MARK: Initialization
    
    convenience init(defaultNib: Bool = false) {
        // Initialize the view controller using the xib file with the same
        // filename
        if defaultNib {
            let nibName = String(describing: type(of: self))
            
            self.init(nibName: nibName,
                      bundle: Bundle.main)
        } else {
            self.init()
        }
    }
    
    // MARK: Controller Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = String(describing: StoryTableViewCell.self)
        let bundle = Bundle(for: StoryTableViewCell.self)
        let nib = UINib(nibName: nibName, bundle: bundle)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50
        self.tableView.register(nib,
                                forCellReuseIdentifier: reuseIdentifier)
        
        self.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Hide the navigation bar for this view controller
        self.navigationController?.isNavigationBarHidden = true
        
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        // Show againt the navigation bar for others controller on the
        // navigation stack
        self.navigationController?.isNavigationBarHidden = false
        
        super.viewWillDisappear(animated)
    }
    
    // MARK: Private Functions
    private func reloadData() {
        do {
            let realm = try Realm()
            
            let result = realm.objects(Story.self)
                .filter("isDeleted = false")
                .sorted(byKeyPath: "createdAt")
            
            self.storyArray = Array(result)
        } catch let error as NSError {
            print(error)
        }
    }
}

// MARK: - UITableViewDataSource

extension StoriesViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
        return self.storyArray.count
    }
    
    public func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                 for: indexPath) as! StoryTableViewCell
        
        cell.story = self.storyArray[indexPath.row]
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension StoriesViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
