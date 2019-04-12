//
//  RoomDetailVC.swift
//  homeKitTest
//
//  Created by Minewtech on 2019/4/2.
//  Copyright © 2019 Minewtech. All rights reserved.
//

import UIKit
import HomeKit

class RoomAccessoryVC: UIViewController,UITableViewDelegate,UITableViewDataSource,HMAccessoryBrowserDelegate {

    var home : HMHome!
    var room : HMRoom!
    var accessoryBrowser : HMAccessoryBrowser!

    var table : UITableView!
    var accessoriesTable : UITableView!
    var accessoriesView : UIView!
    var cancelBtn : UIButton!

    var accessories : Array<HMAccessory>!
    var searchAccessories : Array<HMAccessory>!

    override func viewDidLoad() {
        super.viewDidLoad()

        searchAccessories = []
        
        accessoryBrowser = HMAccessoryBrowser.init()
        accessoryBrowser.delegate = self
        
        self.title = "Room's Accessories"
        self.initViews()
        
        self.startSearching()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopSearching()
    }
    
    //MARK: - initViews
    func initViews() -> Void {
        
        table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), style: UITableView.Style.plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        self.view.addSubview(table)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Add", style: UIBarButtonItem.Style.plain, target: self, action: #selector(addAccessory))

    }
    
    //MARK: - tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == table {
            return accessories.count
        }
        return searchAccessories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell.init()
        if tableView == table {
            let cellString = "cell"
            cell = table.dequeueReusableCell(withIdentifier: cellString) ?? UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellString)
            cell.textLabel?.text = accessories[indexPath.row].name
        }
        else {
            let cellString = "searchcell"
            cell = accessoriesTable.dequeueReusableCell(withIdentifier: cellString) ?? UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellString)
            cell.textLabel?.text = searchAccessories[indexPath.row].name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == table {
            
        }
        else if tableView == accessoriesTable {
            let alert = UIAlertController.init(title: "Add Accessories", message: "Are you sure add \(searchAccessories[indexPath.row].name)", preferredStyle: UIAlertController.Style.alert)
            
            let cancelAction = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
                print("cancel")
            }
            let defaultAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default) { (action) in
                
                self.home.assignAccessory(self.searchAccessories[indexPath.row], to: self.room, completionHandler: { (error) in
                    if (error != nil) {
                        print(error?.localizedDescription as Any)
                    }
                    else {
                        
                        self.table.reloadData()
                        self.accessoriesView.removeFromSuperview()
                    }
                })
            }
            alert.addAction(cancelAction)
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            
        }
    }
    
    //MARK: - homeKit delegate
    func accessoryBrowser(_ browser: HMAccessoryBrowser, didFindNewAccessory accessory: HMAccessory) {
        
        if searchAccessories.count == 0 {
            searchAccessories.append(accessory)
        }
        else {
            for target in searchAccessories {
                
                if target.uniqueIdentifier != accessory.uniqueIdentifier {
                    searchAccessories.append(accessory)
                    break
                }
            }
        }
        
        print("searchAccessories : \(String(describing: searchAccessories))")
    }
    
    func accessoryBrowser(_ browser: HMAccessoryBrowser, didRemoveNewAccessory accessory: HMAccessory) {
        print("\(accessory)")
    }
    
    //MARK: - btn events
    //add Accessory
    @objc func addAccessory() -> Void {
        
        if (accessoriesView != nil) {
            accessoriesView.isHidden = false
            accessoriesTable.reloadData()
        }
        else {
            accessoriesView = UIView.init()
            accessoriesView.frame = CGRect.init(x: self.view.frame.width/2-100, y: self.view.frame.height/2-200, width: 200, height: 400)
            accessoriesView.layer.borderWidth = 2
            accessoriesView.layer.borderColor = UIColor.blue.cgColor
            self.view.addSubview(accessoriesView)
            
            
            accessoriesTable = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 350), style: UITableView.Style.plain)
            
            accessoriesTable.delegate = self
            accessoriesTable.dataSource = self
            accessoriesTable.separatorStyle = .none
            
            accessoriesView.addSubview(accessoriesTable)
            accessoriesTable.reloadData()
            
            cancelBtn = UIButton.init(type: UIButton.ButtonType.custom)
            cancelBtn.frame = CGRect.init(x: 0, y: 350, width: 200, height: 50)
            cancelBtn.addTarget(self, action: #selector(cancelBtnClick), for: UIControl.Event.touchUpInside)
            cancelBtn.setTitle("Cancel", for: UIControl.State.normal)
            cancelBtn.setTitleColor(UIColor.black, for: UIControl.State.normal)
            accessoriesView.addSubview(cancelBtn)
            
        }
    }
    
    //MARK: - callback function
    func startSearching() -> Void {
        accessoryBrowser.startSearchingForNewAccessories()
    }
    
    func stopSearching() -> Void {
        accessoryBrowser.stopSearchingForNewAccessories()
    }
    
    @objc func cancelBtnClick() -> Void {
        accessoriesView.isHidden = true
    }
    
    deinit {
        print("\(self.classForCoder) dealloc")
    }
}
