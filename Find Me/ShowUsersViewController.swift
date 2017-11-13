//
//  ShowUsersViewController.swift
//  Find Me
//
//  Created by Aashana on 11/4/17.
//  Copyright © 2017 Aashana. All rights reserved.
//

import UIKit


class ShowUsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var userTable : UITableView!
   
    let cellReuseIdentifier = "UsersTableViewCell"
    
    
    var pageIndex : Int!
    var users = [Dictionary<String,Any>]()
    var url : String!
    var taskurl : String!
    override func viewDidLoad()
    {
        taskurl = url
            pageIndex = 0
            getUsers(index: pageIndex)
            userTable.delegate = self
            userTable.dataSource = self
           
            
        super.viewDidLoad()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UsersTableViewCell = self.userTable.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! UsersTableViewCell
        
            cell.name.text = users[indexPath.row]["nickname"] as? String
        
            cell.city.text = (users[indexPath.row]["city"] as? String)! + ","
        
            cell.state.text = (users[indexPath.row]["state"] as? String)! + ","
        
            cell.country.text = users[indexPath.row]["country"] as? String
        
        cell.year.text = "\(users[indexPath.row]["year"]!)"
        
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == users.count-1 {
            pageIndex = pageIndex + 1
            getUsers(index: pageIndex)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 140.0
    }
    
    
    func getUsers(index : Int)
    {
        taskurl = url
        if taskurl.last! == "?"
        {
            taskurl.append("page="+String(index))
        }
        else
        {
            taskurl.append("&page="+String(index))
        }
       let link = URL(string: taskurl)
        
        let task = URLSession.shared.dataTask(with: link!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [Dictionary<String,Any>]
            if json.count > 0
            {
                print(json)
                DispatchQueue.main.async
                {
                    self.users += json
                    self.userTable.reloadData()
                }
            }
            
        }
        
        task.resume()
        
        
    }
}

