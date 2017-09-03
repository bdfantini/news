//
//  StoriesViewController.swift
//  news
//
//  Created by Benjamin Fantini on 8/30/17.
//  Copyright © 2017 Benjamin Fantini. All rights reserved.
//

import RealmSwift
import UIKit

class StoriesViewController: DefaultViewController {

    // MARK: Constants
    
    let reuseIdentifier = "tableViewReuseIdentifier"
    
    // MARK: UI
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageLabel: UILabel!
    
    // MARK: Attributes
    
    var storyArray = [Story]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    // MARK: Controller Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // StoryTableViewCell's nib
        let nibName = String(describing: StoryTableViewCell.self)
        let bundle = Bundle(for: StoryTableViewCell.self)
        let nib = UINib(nibName: nibName, bundle: bundle)
        
        // TableView customization
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50
        self.tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
        
        // Add refresh control to the TableView
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .lightGray
        refreshControl.tintColor = .darkGray
        refreshControl.addTarget(self,
                                 action: #selector(getData),
                                 for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        
        // Add empty message at background view
        self.tableView.backgroundView = self.messageLabel
        
        // Reload data from local database
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
    
    // MARK: Internal Functions
    func getData() {
        // Get stories from the api, then reload table's data from local database
        Story.getStories { succeed, error in
            self.reloadData()
            self.tableView.refreshControl?.endRefreshing()
            
            if let error = error {
                print(error)
                //TODO: BF: Show something?
            }
        }
    }
    
    func reloadData() {
        do {
            // Load stories from local database
            let realm = try Realm()
            
            let result = realm.objects(Story.self)
                .filter("isDeleted = false")
                .sorted(byKeyPath: "createdAt", ascending: false)
            
            self.storyArray = Array(result)
        } catch let error as NSError {
            // TODO: BF: Do something
            print(error)
        }
    }
}

// MARK: - UITableViewDataSource

extension StoriesViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
        
        let count = self.storyArray.count
        
        // Show an empty message label is there isn't any data to show
        tableView.separatorStyle = count > 0 ? .singleLine : .none
        tableView.backgroundView?.isHidden = (count > 0)
        
        return count
    }
    
    public func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                 for: indexPath) as! StoryTableViewCell
        
        // Configure the cell's story
        cell.story = self.storyArray[indexPath.row]
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension StoriesViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView,
                          canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func tableView(_ tableView: UITableView,
                          commit editingStyle: UITableViewCellEditingStyle,
                          forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            do {
                let story = self.storyArray[indexPath.row]
                
                // Set isDeleted = true for the selected story
                let realm = try Realm()
                try realm.write {
                    story.isDeleted = true
                }
                
                // Remove the row (and item from the array) at indexPath
                tableView.beginUpdates()
                self.storyArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
                
            } catch let error as NSError {
                // TODO: BF: Do something
                print(error)
            }
        }
    }
    
    public func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
        let webViewController = WebViewController()
        
        // Set the WebViewController's url
        let story = self.storyArray[indexPath.row]
        webViewController.urlString = story.urlString
        
        self.navigationController?.pushViewController(webViewController,
                                                      animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
