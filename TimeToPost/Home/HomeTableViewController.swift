//
//  HomeTableViewController.swift
//  TimeToPost
//
//  Created by Uzair Ishaq on 15/04/2019.
//  Copyright © 2019 Uzair Ishaq. All rights reserved.
//

import UIKit

protocol HomeViewDisplayLogic: class {
    func displayFetchedPosts(instagramPostSections: [InstagramPostSection], hour: String, weekday: String)
    func diplayFetchMediaFailureAlert(title: String, message: String)
}

class HomeTableViewController: UITableViewController, HomeViewDisplayLogic {
    
    // MARK: properties
    
    var interactor: HomeInteractor?
    var presenter: HomePresenter?
    var sections: [InstagramPostSection]?
    var storedOffsets = [Int: CGFloat]()
    
    @IBOutlet weak var headerView: UIView?
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var weekdayLabel: UILabel!
    
    // MARK: object life cycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: setup
    
    private func setup() {
        let viewController = self
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        viewController.interactor = interactor
        viewController.presenter = presenter
        interactor.presenter = presenter
        presenter.viewController = viewController
        sections = []
    }
    
    // MARK: view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchPostsOnLoad()
    }
    
    // MARK: setup ui
    
    private func setupUI() {
        tableView.register(InstagramPostSectionTableViewCell.self, forCellReuseIdentifier: AppConfiguration.TableViewCellIDs.cell)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.separatorStyle = .none
        self.headerView?.isHidden = true
        
    }
    
    // MARK: fetch posts
    
    func fetchPostsOnLoad(){
        DispatchQueue.global(qos: .background).async {
            self.interactor?.loadPosts()
        }
    }
    

    

    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = sections else { return 0 }
        return sections.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppConfiguration.TableViewCellIDs.cell, for: indexPath) as? InstagramPostSectionTableViewCell else {
            return InstagramPostSectionTableViewCell()
        }
        let instagramItemSection = self.sections?[indexPath.row]
        cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        cell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
        cell.sectionNameLabel.text = instagramItemSection?.sectionTitle

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath){
        guard let tableViewCell = cell as? InstagramPostSectionTableViewCell else { return }
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
    
    // MARK: actions
    
    @IBAction func refresh(_ sender: Any){
        fetchPostsOnLoad()
    }
    
    func displayFetchedPosts(instagramPostSections: [InstagramPostSection], hour: String, weekday: String) {
        self.sections = instagramPostSections
        DispatchQueue.main.async {
            self.headerView?.isHidden = false
            self.hourLabel.text = hour
            self.weekdayLabel.text = weekday
            self.tableView.reloadData()
        }
    }
    
    func diplayFetchMediaFailureAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: AppConfiguration.Messages.okButton, style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeTableViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: collection view data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let index = collectionView.tag
        let instagramPostSection = self.sections?[index]
        return (instagramPostSection?.instagramPostViews.count) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = collectionView.tag
        let instagramPostSection = self.sections?[index]
        let post = instagramPostSection?.instagramPostViews[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConfiguration.TableViewCellIDs.cell, for: indexPath) as? InstagramPostCollectionViewCell else { return InstagramPostCollectionViewCell() }
        cell.postModelView = post
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let h = collectionView.frame.height - 10
        return CGSize(width: 324/2, height: h)
    }
}
