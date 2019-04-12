//
//  HomeRoomsVC.swift
//  homeKitTest
//
//  Created by Minewtech on 2019/4/3.
//  Copyright © 2019 Minewtech. All rights reserved.
//

import UIKit
import HomeKit

class HomeRoomsVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var table : UITableView!
    var home : HMHome!
    var rooms : Array<HMRoom>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Rooms"
        
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
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellString = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellString) ?? UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellString)
        cell.textLabel?.text = rooms[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let room = rooms[indexPath.row]
        
        let vc = RoomAccessoryVC.init()
        vc.home = home
        vc.room = room
        vc.accessories = room.accessories
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    //MARK: - btn events
    //add Room
    @objc func addRoom() -> Void {
        
        let alert = UIAlertController.init(title: "Add Room", message: "", preferredStyle: UIAlertController.Style.alert)
        
        var textF = UITextField.init()
        
        alert.addTextField { (textF1) in
            textF = textF1
        }
        let cancelAction = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
            print("cancel")
        }
        let defaultAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default) { (action) in
            if textF.text?.lengthOfBytes(using: String.Encoding.utf8) == 0 {
                print("roomName string is nil")
                return
            }
            self.home.addRoom(withName: textF.text!) { (room, error) in
                if (error != nil) {
                    print(error?.localizedDescription as Any)
                }
                else {
                    self.rooms.append(room!)
                    self.table.reloadData()
                }
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - callback function

    deinit {
        print("\(self.classForCoder) dealloc")
    }

}
