//
//  SettingsViewController.swift
//  Weather Go
//
//  Created by Kevin Guo on 2017-02-01.
//  Copyright © 2017 Kevin Guo. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UITableViewController {
    
    var interactor:Interactor? = nil
    var isMetric:Bool = false
    
    var blurView: UIVisualEffectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isMetric = UserDefaults.standard.bool(forKey: "isMetric")
        
        if let image = UIImage(named: "snowy_night") {
            // create a background view
            let backgroundView = UIView()
            backgroundView.frame = self.tableView.bounds
            
            // adds image view to background view
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.frame = self.tableView.bounds
            backgroundView.addSubview(imageView)
            
            // adds blurView to backgrond view for blur effect
            blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.dark))
            blurView?.frame = self.tableView.bounds
            backgroundView.addSubview(blurView!)
            
            // set tableView's backgroundView
            self.tableView.backgroundView = backgroundView

        }
        
        // add shadow to view
        
        self.view.layer.shadowPath = UIBezierPath(rect: self.view.bounds).cgPath
        self.view.layer.shadowOpacity = 0.8
        self.view.layer.shadowColor = UIColor.black.cgColor
        self.view.layer.shadowRadius = 5.0
        self.view.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        self.view.layer.masksToBounds = false
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(indexPath.row == 1, forKey: "isMetric")
        UserDefaults.standard.synchronize()
        self.isMetric = UserDefaults.standard.bool(forKey: "isMetric")
        self.tableView.reloadData()
        self.performSegue(withIdentifier: "unwindFromSettingViewConroller", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.accessoryType = self.isMetric ? .none :.checkmark
                break
            case 1:
                cell.accessoryType = self.isMetric ? .checkmark :.none
                break
            default:
                break
            }
        default:
            break
        }
        
        return cell
        
    }
    
}
