//
//  AccountTableViewController.swift
//  TimeToPost
//
//  Created by Uzair Ishaq on 14/04/2019.
//  Copyright © 2019 Uzair Ishaq. All rights reserved.
//

import UIKit

class AccountTableViewController: UITableViewController {
    
    // MARK: properties
    
    @IBOutlet weak var usernameTableCell: UITableViewCell!
    
    // MARK: view life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.tableHeaderView = UIView()
        guard let name = ApppUserAccount().name else {
            usernameTableCell.textLabel?.text = NSLocalizedString("Instagram Username", comment: "")
            return
        }
        usernameTableCell.textLabel?.text = name
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        usernameTableCell.isSelected = false
    }
    
    // MARK: table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 1 {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.isSelected = false
            displayDeleteAllAlert()
        }
    }
    
    // MARK: actions
    
    private func displayDeleteAllAlert() {
        let alertController = UIAlertController(title: AppConfiguration.Messages.deleteReportsTitle, message: AppConfiguration.Messages.deleteReportsMessage, preferredStyle: .alert)
        
        let deleteAllAction = UIAlertAction(title: AppConfiguration.Messages.deleteAllButton, style: .destructive){ (_: UIAlertAction) -> Void in
            self.usernameTableCell.textLabel?.text = NSLocalizedString("Instagram Username", comment: "")
            DataService.deleteAll()
        }
        
        let cancelAction = UIAlertAction(title: AppConfiguration.Messages.cancelButton, style: .default){ (_: UIAlertAction) -> Void in
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAllAction)
        present(alertController, animated: true, completion: nil)
    }





    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
