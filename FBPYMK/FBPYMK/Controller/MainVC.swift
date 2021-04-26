//
//  MainVC.swift
//  FBPYMK
//
//  Created by Hiram Castro on 25/04/21.
//

import UIKit

class MainVC:UIViewController {
    
    let suggestionsTableView:UITableView = {
        var tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    var mainVM:MainVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainVM = MainVM(jsonFile: "mock")
        
        configUI()
    }
    
    private func configUI() {
        self.view.backgroundColor  = .white
        self.navigationController?.navigationBar.isHidden = true
        
        self.view.addSubview(suggestionsTableView)
        
        NSLayoutConstraint.activate([
            suggestionsTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            suggestionsTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            suggestionsTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            suggestionsTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        
        suggestionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        suggestionsTableView.dataSource = self
        
        suggestionsTableView.reloadData()
    }
    
}

extension MainVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainVM?.friendsSuggestions.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        
        let friendSuggestion = mainVM?.friendsSuggestions[indexPath.row]
        
        let mutualFriends = mainVM?.mutualFriends[friendSuggestion?.id ?? 0]
        let socialDistance = mainVM?.socialDistance[friendSuggestion?.id ?? 0]
        
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.text = ("\(friendSuggestion?.name ?? "") `-` \((socialDistance?.count ?? 0) > 0 ? "Social distance: \(socialDistance?.count ?? 0)" : "") \(mutualFriends?.count ?? 0 > 0 ? ", Mutual friends: \(mutualFriends?.count ?? 0)" : "")")
        
        return cell
    }
    
}
