//
//  TableViewController.swift
//  weighted-stock
//
//  Created by TimChen on 2017/9/17.
//  Copyright © 2017年 dogtim. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    var stocks = [Stock]()
    let CELL_IDENTIFIER : String = "Cell"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CELL_IDENTIFIER)
    }

    override func viewWillAppear(_ animated: Bool) {
        let api = WeightedStockListApi()
        api.apiDelegate = self
        api.start()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER, for: indexPath) as UITableViewCell
        
        if let myLabel = cell.textLabel {
            myLabel.text =
            "\(stocks[indexPath.row].name)"
        }
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byCharWrapping
        return cell
    }
    
    @IBAction func backTouchUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension TableViewController: ApiProtocol {
    
    func complete(api : WeightedStockListApi) {
        self.stocks = api.stocks
        self.tableView.reloadData()
    }
    func error(error : Error) {
    
    }

}
