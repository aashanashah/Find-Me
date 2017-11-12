//
//  FilterViewController.swift
//  Find Me
//
//  Created by Aashana on 11/4/17.
//  Copyright © 2017 Aashana. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    @IBOutlet var countryFilter : UIButton!
    @IBOutlet var stateFilter : UIButton!
    @IBOutlet var yearFilter : UIButton!
    @IBOutlet var showList : UIButton!
    @IBOutlet var showMap : UIButton!
    @IBOutlet var countriesTable : UITableView!
    @IBOutlet var statesTable : UITableView!
    @IBOutlet var yearTable : UITableView!
    
    var countryTableData:Array< String >!
    var stateTableData : Array<String>!
    var yearTableData : Array<String>!

    override func viewDidLoad() {
         super.viewDidLoad()
        countryFilter.setTitle("All \u{25BE}", for: .normal)
        stateFilter.setTitle("All \u{25BE}", for: .normal)
        yearFilter.setTitle("All \u{25BE}", for: .normal)
        countryFilter.backgroundColor = .clear
        countryFilter.layer.cornerRadius = 5
        countryFilter.layer.borderWidth = 1
        countryFilter.layer.borderColor = UIColor.black.cgColor
        stateFilter.backgroundColor = .clear
        stateFilter.layer.cornerRadius = 5
        stateFilter.layer.borderWidth = 1
        stateFilter.layer.borderColor = UIColor.black.cgColor
        yearFilter.backgroundColor = .clear
        yearFilter.layer.cornerRadius = 5
        yearFilter.layer.borderWidth = 1
        yearFilter.layer.borderColor = UIColor.black.cgColor
        
        countryTableData=Array<String>()
        getCountriesData()
        countriesTable.isHidden = true
        
        self.countriesTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        stateTableData=Array<String>()
        statesTable.isHidden = true
        
        self.statesTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        yearTableData = Array<String>()
        
        let data:Bundle = Bundle.main
        let yearplist:String? = data.path(forResource: "Year", ofType: "plist")
        if yearplist != nil
        {
            yearTableData = (NSArray.init(contentsOfFile: yearplist!) as! Array)
            yearTableData.insert("All", at: 0)
        }
        yearTable.isHidden = true
        self.yearTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let gesture = UITapGestureRecognizer(target: self, action: nil)
        
        gesture.delegate = self
        self.view.addGestureRecognizer(gesture)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func buttonClick(sender : UIButton)
    {
        if sender == countryFilter
        {
            if countriesTable.isHidden
            {
                countriesTable.isHidden = false
            }
            else
            {
                countriesTable.isHidden = true
            }
            statesTable.isHidden = true
            yearTable.isHidden = true
        }
        else if sender == stateFilter && (countryFilter.currentTitle == "All \u{25BE}" || countryFilter.currentTitle == "All")
        {
            let alert = UIAlertController(title: "Alert", message: "Please select a country", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if sender == stateFilter
        {
            if statesTable.isHidden
            {
                statesTable.isHidden = false
            }
            else
            {
                statesTable.isHidden = true
            }
            countriesTable.isHidden = true
            yearTable.isHidden = true
        }
        else if sender == yearFilter
        {
            if yearTable.isHidden
            {
                yearTable.isHidden = false
            }
            else
            {
                yearTable.isHidden = true
            }
            countriesTable.isHidden = true
            statesTable.isHidden = true
        }
    }
    func getCountriesData()
    {
        self.countryTableData.removeAll()
        self.countryTableData.append("All")
        let url = URL(string: "https://bismarck.sdsu.edu/hometown/countries")
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            if let countries_list = json as? NSArray
            {
                for i in 0 ..< countries_list.count
                {
                    
                    self.countryTableData.append(countries_list[i] as! String)
                }
            }
            
            DispatchQueue.main.async {
                self.countriesTable.reloadData()
            }
        }
        
        task.resume()
        
    }
    func getStatesData(name:String)
    {
        self.stateTableData.removeAll()
        self.stateTableData.append("All")
        let url = URL(string: "https://bismarck.sdsu.edu/hometown/states?country="+name)
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            if let states_list = json as? NSArray
            {
                for i in 0 ..< states_list.count
                {
                    
                    self.stateTableData.append(states_list[i] as! String)
                }
            }
            
            DispatchQueue.main.async {
                
                self.statesTable.reloadData()
            }
        }
        
        task.resume()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //print(countryTableData.count)
        if tableView == countriesTable
        {
            return countryTableData.count
        }
        else if tableView == statesTable
        {
            return stateTableData.count
        }
        else
        {
            return yearTableData.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == countriesTable
        {
            let cell =  countriesTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            cell.textLabel?.text = countryTableData[indexPath.row]
            
            return cell
        }
        else if tableView == statesTable
        {
            
            let cell =  statesTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            cell.textLabel?.text = stateTableData[indexPath.row]
            
            return cell
        }
        else
        {
            let cell =  yearTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            cell.textLabel?.text = yearTableData[indexPath.row]
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == countriesTable
        {
            let name = self.countryTableData[indexPath.row]
            countryFilter.setTitle(name, for: .normal)
            countriesTable.isHidden = true
            stateFilter.setTitle("All \u{25BE}", for: .normal)
            if name != "All"
            {
                getStatesData(name:name)
            }
        }
        else if tableView == statesTable
        {
            let name = self.stateTableData[indexPath.row]
            stateFilter.setTitle(name, for: .normal)
            stateFilter.titleLabel?.font = UIFont(name: "American TypeWriter", size: 14)
            statesTable.isHidden = true
        }
        else
        {
            let name = self.yearTableData[indexPath.row]
            yearFilter.setTitle(name, for: .normal)
            yearTable.isHidden = true
        }
        
    }
    func buildURL() -> String
    {
        var createURL = "http://bismarck.sdsu.edu/hometown/users?"
        if countryFilter.currentTitle != "All" && countryFilter.currentTitle != "All \u{25BE}"
        {
            createURL+="country="+countryFilter.currentTitle!
        }
        if stateFilter.currentTitle != "All" && stateFilter.currentTitle != "All \u{25BE}"
        {
            let newString = stateFilter.currentTitle!.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
            createURL+="&state="+newString
        }
        if yearFilter.currentTitle != "All" && yearFilter.currentTitle != "All \u{25BE}"
        {
            if countryFilter.currentTitle != "All" && countryFilter.currentTitle != "All \u{25BE}"
            {
                createURL+="&year="+yearFilter.currentTitle!
            }
            else
            {
                createURL+="year="+yearFilter.currentTitle!
            }
        }
        return createURL
    }
    @IBAction func showMap(sender : UIButton)
    {
        
        let taskurl = buildURL()
        let url = URL(string: taskurl)
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            DispatchQueue.main.async{
            if let list = json as? NSArray
            {
                let usersMapViewController = self.storyboard?.instantiateViewController(withIdentifier: "UsersMapViewController") as! UsersMapViewController
                usersMapViewController.list = list
                if self.stateFilter.currentTitle != "All" && self.stateFilter.currentTitle != "All \u{25BE}"
                {
                    usersMapViewController.dictLocation = ["state": self.stateFilter.currentTitle!]
                }
                else if self.countryFilter.currentTitle != "All" && self.countryFilter.currentTitle != "All \u{25BE}"
                {
                    usersMapViewController.dictLocation = ["country": self.countryFilter.currentTitle!]
                }
                else
                {
                    usersMapViewController.dictLocation = ["country":"USA"]
                }
                self.navigationController?.pushViewController(usersMapViewController, animated: true)
                
            }
            
            }}
        
        task.resume()
    }
    @IBAction func showList(sender : UIButton)
    {
        let taskurl = buildURL()
        let showUsersViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShowUsersViewController") as! ShowUsersViewController
        showUsersViewController.url = taskurl
        self.navigationController?.pushViewController(showUsersViewController, animated: true)
        
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        var shouldReceive = true
        if let clickedView = touch.view
        {
            if (clickedView.superview?.isKind(of: UITableViewCell.self))!
            {
                shouldReceive = false
            }
            else
            {
                countriesTable.isHidden = true
                statesTable.isHidden = true
                yearTable.isHidden = true
            }
        }
        
        return shouldReceive
    }
}
