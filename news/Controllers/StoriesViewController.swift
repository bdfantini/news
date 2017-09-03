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
        
        let nibName = String(describing: StoryTableViewCell.self)
        let bundle = Bundle(for: StoryTableViewCell.self)
        let nib = UINib(nibName: nibName, bundle: bundle)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50
        self.tableView.register(nib,
                                forCellReuseIdentifier: reuseIdentifier)
        
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .lightGray
        refreshControl.tintColor = .darkGray
        refreshControl.addTarget(self,
                                 action: #selector(StoriesViewController.getData),
                                 for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        
        self.tableView.backgroundView = self.messageLabel
        
        self.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.getData()
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
    
    // MARK: Protected Functions
    func getData() {
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
        
        tableView.separatorStyle = count > 0 ? .singleLine : .none
        tableView.backgroundView?.isHidden = (count > 0)
        
        return count
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
                
                let realm = try Realm()
                try realm.write {
                    story.isDeleted = true
                }
                
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
        
        let story = self.storyArray[indexPath.row]
        webViewController.urlString = story.urlString
        
        self.navigationController?.pushViewController(webViewController,
                                                      animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
