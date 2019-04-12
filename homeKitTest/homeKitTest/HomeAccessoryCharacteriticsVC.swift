//
//  HomeAccessoryCharateritics.swift
//  homeKitTest
//
//  Created by Minewtech on 2019/4/11.
//  Copyright © 2019 Minewtech. All rights reserved.
//

import UIKit
import HomeKit

class HomeAccessoryCharacteriticsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var characteritics : Array<HMCharacteristic>!
    var table : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Characteritics"
        
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
        
        //        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Add", style: UIBarButtonItem.Style.plain, target: self, action: #selector(addRoom))
        
    }
    
    //MARK: - tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characteritics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell.init()
        if tableView == table {
            let cellString = "cell"
            cell = table.dequeueReusableCell(withIdentifier: cellString) ?? UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellString)
            if characteritics[indexPath.row].value != nil {
                cell.textLabel?.text = "\(characteritics[indexPath.row].localizedDescription)        \(String(describing: characteritics[indexPath.row].value!))"
            }
            else {
                cell.textLabel?.text = "\(characteritics[indexPath.row].localizedDescription) N/A"

            }
        }

        print(characteritics[indexPath.row].characteristicType)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.readCharacteriticsValue(characteritic: characteritics[indexPath.row])
        table.reloadData()
    }
    
    //MARK: - callback function
    func readCharacteriticsValue(characteritic : HMCharacteristic) -> Void {
        characteritic.readValue { (error) in
            if (error != nil) {
                print("readCharacteritic failed,error:\(String(describing: error))")
            }
            else {
                print(characteritic.value as Any)
                self.writeCharacteritic(characteritic: characteritic)
            }
        }
    }
    
    func writeCharacteritic(characteritic : HMCharacteristic) -> Void {
        characteritic.writeValue("abc") { (error) in
            if (error != nil) {
                print("writeCharacteritic failed,error:\(String(describing: error))")
            }
            else {
                print(characteritic.value as Any)
            }
        }
    }
    
    deinit {
        print("\(self.classForCoder) dealloc")
    }
}
