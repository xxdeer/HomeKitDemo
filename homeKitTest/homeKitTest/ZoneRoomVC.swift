//
//  ZoneRoomVC.swift
//  homeKitTest
//
//  Created by Minewtech on 2019/4/10.
//  Copyright © 2019 Minewtech. All rights reserved.
//

import UIKit
import HomeKit

class ZoneRoomVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var table : UITableView!
    var roomsTable : UITableView!
    var roomsView : UIView!
    var cancelBtn : UIButton!
    
    var rooms : Array<HMRoom>!
    var zone : HMZone!
    var home : HMHome!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Zone's rooms"
        
        self.initViews()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - initViews
    func initViews() -> Void {
        
        table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), style: UITableView.Style.plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        
        self.view.addSubview(table)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Add", style: UIBarButtonItem.Style.plain, target: self, action: #selector(addRoom))
        
    }
    
    //MARK: - tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == table {
            return rooms.count
        }
        return home.rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell.init()
        if tableView == table {
            let cellString = "cell"
            cell = table.dequeueReusableCell(withIdentifier: cellString) ?? UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellString)
            cell.textLabel?.text = rooms[indexPath.row].name
        }
        else {
            let cellString = "searchcell"
            cell = roomsTable.dequeueReusableCell(withIdentifier: cellString) ?? UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellString)
            cell.textLabel?.text = home.rooms[indexPath.row].name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == table {
            
        }
        else if tableView == roomsTable {
            let alert = UIAlertController.init(title: "Add Room", message: "Are you sure add \(home.rooms[indexPath.row].name)", preferredStyle: UIAlertController.Style.alert)
            
            let cancelAction = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
                print("cancel")
            }
            let defaultAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default) { (action) in
                
                self.zone.addRoom(self.home.rooms[indexPath.row], completionHandler: { (error) in
                    if (error != nil) {
                        print(error?.localizedDescription as Any)
                    }
                    else {
                        self.rooms.append(self.home.rooms[indexPath.row])
                        self.table.reloadData()
                        self.roomsView.isHidden = true
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
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        zone.removeRoom(rooms[indexPath.row]) { (error) in
            if (error != nil) {
                print(error?.localizedDescription as Any)
            }
            else {
                self.rooms.remove(at: indexPath.row)
                self.table.reloadData()
            }
        }
    }
    //MARK: - btn events
    //add Room
    @objc func addRoom() -> Void {
        
        if (roomsView != nil) {
            roomsView.isHidden = false
            roomsTable.reloadData()
        }
        else {
            roomsView = UIView.init()
            roomsView.frame = CGRect.init(x: self.view.frame.width/2-100, y: self.view.frame.height/2-200, width: 200, height: 400)
            roomsView.layer.borderWidth = 2
            roomsView.layer.borderColor = UIColor.blue.cgColor
            self.view.addSubview(roomsView)
            
            
            roomsTable = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 350), style: UITableView.Style.plain)
            
            roomsTable.delegate = self
            roomsTable.dataSource = self
            roomsTable.separatorStyle = .none
            
            roomsView.addSubview(roomsTable)
            roomsTable.reloadData()
            
            cancelBtn = UIButton.init(type: UIButton.ButtonType.custom)
            cancelBtn.frame = CGRect.init(x: 0, y: 350, width: 200, height: 50)
            cancelBtn.addTarget(self, action: #selector(cancelBtnClick), for: UIControl.Event.touchUpInside)
            cancelBtn.setTitle("Cancel", for: UIControl.State.normal)
            cancelBtn.setTitleColor(UIColor.black, for: UIControl.State.normal)
            roomsView.addSubview(cancelBtn)
            
        }
    }
    
    @objc func cancelBtnClick() -> Void {
        roomsView.isHidden = true
    }
    //MARK: - callback function
    
    deinit {
        print("\(self.classForCoder) dealloc")
    }

}
