//
//  ViewController.swift
//  Find Me
//
//  Created by Aashana on 10/30/17.
//  Copyright © 2017 Aashana. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet var locate : UIButton!
    @IBOutlet var countriesButton : UIButton!
    @IBOutlet var countriesTable : UITableView!
    @IBOutlet var statesButton : UIButton!
    @IBOutlet var statesTable : UITableView!
    @IBOutlet var yearButton : UIButton!
    @IBOutlet var yearTable : UITableView!
    @IBOutlet var addButton : UIButton!
    
    @IBOutlet var nameCheck : UIImageView!
    @IBOutlet var passCheck : UIImageView!
    @IBOutlet var cityCheck : UIImageView!
    
    var countryTableData:Array< String >!
    var stateTableData : Array<String>!
    var yearTableData : Array<String>!
    var addUser : [String:Any]!
    
    @IBOutlet var nickname : UITextField!
    @IBOutlet var password : UITextField!
    @IBOutlet var city : UITextField!
    
    @IBOutlet var errLabel : UILabel!
    
    override func viewDidLoad() {
         super.viewDidLoad()
        countriesButton.setTitle("Select Country \u{25BE}", for: .normal)
        statesButton.setTitle("Select State \u{25BE}", for: .normal)
        yearButton.setTitle("Select year \u{25BE}", for: .normal)
        locate.setTitle("Locate \u{25b8}", for: .normal)
        countriesButton.backgroundColor = .clear
        countriesButton.layer.cornerRadius = 5
        countriesButton.layer.borderWidth = 1
        countriesButton.layer.borderColor = UIColor.black.cgColor
        statesButton.backgroundColor = .clear
        statesButton.layer.cornerRadius = 5
        statesButton.layer.borderWidth = 1
        statesButton.layer.borderColor = UIColor.black.cgColor
        yearButton.backgroundColor = .clear
        yearButton.layer.cornerRadius = 5
        yearButton.layer.borderWidth = 1
        yearButton.layer.borderColor = UIColor.black.cgColor
        locate.backgroundColor = .clear
        locate.layer.cornerRadius = 5
        locate.layer.borderWidth = 1
        locate.layer.borderColor = UIColor.black.cgColor
        addButton.layer.cornerRadius = 5
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = UIColor.black.cgColor
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
            
        }
        yearTable.isHidden = true
        self.yearTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        nameCheck.isHidden = true
        nickname.delegate = self
        nameCheck.layer.cornerRadius = nameCheck.bounds.size.width/2
        passCheck.isHidden = true
        password.delegate = self
        passCheck.layer.cornerRadius = nameCheck.bounds.size.width/2
        cityCheck.isHidden = true
        city.delegate = self
        cityCheck.layer.cornerRadius = nameCheck.bounds.size.width/2
        
        UserDefaults.standard.set(0.0, forKey: "Latitude")
        UserDefaults.standard.set(0.0, forKey: "Longitude")
        nickname.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        password.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        city.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        errLabel.isHidden = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView)))
        
       
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        if UserDefaults.standard.double(forKey: "Latitude") != 0.0
        {
            locate.titleLabel?.font = UIFont(name: "American TypeWriter", size: 12)
            locate.setTitle("Lat: "+String(format: "%.3f",UserDefaults.standard.double(forKey: "Latitude"))+" Long: "+String(format: "%.3f",UserDefaults.standard.double(forKey: "Longitude")), for: .normal)
        }
    }
    @IBAction func onLocate(sender : UIButton)
    {
        let mapViewController = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        mapViewController.state = statesButton.currentTitle
        self.navigationController?.pushViewController(mapViewController, animated: true)
    }

    @IBAction func buttonClick(sender : UIButton)
    {
        city.resignFirstResponder()
        password.resignFirstResponder()
        nickname.resignFirstResponder()
        if sender == countriesButton
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
        else if sender == statesButton && countriesButton.currentTitle == "Select Country \u{25BE}"
        {
            let alert = UIAlertController(title: "Alert", message: "Please select a country", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if sender == statesButton
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
        else if sender == yearButton
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
            countriesButton.setTitle(name, for: .normal)
            countriesTable.isHidden = true
            statesButton.setTitle("Select State \u{25BE}", for: .normal)
            getStatesData(name:name)
        }
        else if tableView == statesTable
        {
            let name = self.stateTableData[indexPath.row]
            statesButton.setTitle(name, for: .normal)
            statesButton.titleLabel?.font = UIFont(name: "American TypeWriter", size: 14)
            statesTable.isHidden = true
        }
        else
        {
            let name = self.yearTableData[indexPath.row]
            yearButton.setTitle(name, for: .normal)
            yearTable.isHidden = true
        }
        
    }
    @objc func textFieldDidChange(_ textField: UITextField)
    {
        
        if textField == nickname && nickname.text != ""
        {
             nameCheck.isHidden = false
            if(!checkWhiteSpace(name: nickname.text!))
            {
                checkNickname(name:nickname.text!.lowercased())
            }
            else
            {
                self.nameCheck.image = UIImage(named: "wrong")
            }
        }
        else if textField == nickname && nickname.text == ""
        {
            nameCheck.isHidden = false
             self.nameCheck.image = UIImage(named: "wrong")
        }
        else if textField == password && password.text != ""
        {
            passCheck.isHidden = false
            if (password.text?.count)! < 3
            {
                self.passCheck.image = UIImage(named: "wrong")
            }
            else
            {
                self.passCheck.image = UIImage(named: "correct")
            }
        }
        else if textField == password && password.text == ""
        {
            passCheck.isHidden = false
            self.passCheck.image = UIImage(named: "wrong")
        }
        else if textField == city && city.text != ""
        {
            if city.text!.first != " "
            {
                cityCheck.isHidden = false
                self.cityCheck.image = UIImage(named: "correct")
            }
            else
            {
                let trimmedString = city.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                cityCheck.isHidden = false
                city.text = trimmedString
                if city.text == ""
                {
                    self.cityCheck.image = UIImage(named: "wrong")
                }
                else
                {
                    self.cityCheck.image = UIImage(named: "correct")
                }
            }
        }
        else if textField == city && city.text == ""
        {
            cityCheck.isHidden = false
            self.cityCheck.image = UIImage(named: "wrong")
        }
    }
    func checkNickname(name:String)
    {
        let url = URL(string: "https://bismarck.sdsu.edu/hometown/nicknameexists?name="+name)
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            let json = try? JSONSerialization.jsonObject(with: data,options:.allowFragments) as? Bool
            
            if json! == true
            {
                DispatchQueue.main.async
                {
                    self.nameCheck.image = UIImage(named: "wrong")
                }
            }
            else
            {
                DispatchQueue.main.async
                {
                    self.nameCheck.image = UIImage(named: "correct")
                }
            }
        }
        
        task.resume()
        
    }
    func checkWhiteSpace(name:String) -> Bool
    {
        let whiteSpace = NSCharacterSet.whitespaces
        if name.rangeOfCharacter(from: whiteSpace) != nil
        {
            return true
        } else {
            return false
        }
    }
    @IBAction func onAddUser(sender : UIButton)
    {
        errLabel.isHidden = false
        if nameCheck.image == UIImage(named : "wrong")
        {
            errLabel.text = "Enter valid Nickname"
        }
        else if passCheck.image == UIImage(named : "wrong")
        {
            errLabel.text = "Enter valid Password"
        }
        else if countriesButton.currentTitle == "Select Country \u{25BE}"
        {
            errLabel.text = "Choose valid Country"
        }
        else if statesButton.currentTitle == "Select State \u{25BE}"
        {
            errLabel.text = "Choose valid State"
        }
        else if cityCheck.image == UIImage(named : "wrong")
        {
             errLabel.text = "Enter valid City"
        }
        else if yearButton.currentTitle == "Select year \u{25BE}"
        {
            errLabel.text = "Choose valid Year"
        }
        else
        {
            errLabel.isHidden = true
            if locate.currentTitle == "Locate \u{25b8}"
            {
                addUser = {[ "nickname" : nickname.text!,
                      "password" : password.text!,
                      "country" : countriesButton.currentTitle!,
                      "state" : statesButton.currentTitle!,
                      "city" : city.text!,
                      "year" : (Int(yearButton.currentTitle!)!)]}()
            }
            else
            {
                addUser =
                    {[ "nickname" : nickname.text!,
                      "password" : password.text!,
                      "country" : countriesButton.currentTitle!,
                      "state" : statesButton.currentTitle!,
                      "city" : city.text!,
                      "year" : (Int(yearButton.currentTitle!)!),
                      "latitude" : UserDefaults.standard.double(forKey: "Latitude"),
                      "longitude" : UserDefaults.standard.double(forKey: "Longitude")
                        ]}()
            }
            let jsonData = try? JSONSerialization.data(withJSONObject: addUser)

            let url = URL(string: "https://bismarck.sdsu.edu/hometown/adduser")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                DispatchQueue.main.async{
                if let responseJSON = responseJSON as? [String: Any] {
                    self.notifyUser(message:responseJSON)
                }
                }}

            task.resume()
        }
    }
    func notifyUser(message:Any)
    {
        if String(describing: message) == "[\"message\": ok]"
        {
            let alert = UIAlertController(title: "Find Me", message: "The user has been added successfully!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in self.clearData()}))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func clearData()
    {
        countriesButton.setTitle("Select Country \u{25BE}", for: .normal)
        statesButton.setTitle("Select State \u{25BE}", for: .normal)
        yearButton.setTitle("Select year \u{25BE}", for: .normal)
        locate.setTitle("Locate \u{25b8}", for: .normal)
        nickname.text = ""
        password.text = ""
        city.text = ""
        nameCheck.image = UIImage(named: "wrong")
        passCheck.image = UIImage(named: "wrong")
        cityCheck.image = UIImage(named: "wrong")
        nameCheck.isHidden = true
        passCheck.isHidden = true
        cityCheck.isHidden = true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        countriesTable.isHidden = true
        statesTable.isHidden = true
        yearTable.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == city
        {
            textField.resignFirstResponder()
        }
        else if textField == nickname
        {
            password.becomeFirstResponder()
        }
        else if textField == password
        {
            city.becomeFirstResponder()
        }
        return true
    }
    @objc func didTappedOnBackgroundView(){
        countriesTable.isHidden = true
        statesTable.isHidden = true
        yearTable.isHidden = true
        city.resignFirstResponder()
        password.resignFirstResponder()
        nickname.resignFirstResponder()
        
    }
    
}

