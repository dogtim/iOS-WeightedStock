//
//  TableViewController.swift
//  weighted-stock
//
//  Created by TimChen on 2017/9/17.
//  Copyright © 2017年 dogtim. All rights reserved.
//

import UIKit
import Kanna

class TableViewController: UITableViewController {
    
    var stocks = [Stock]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func viewWillAppear(_ animated: Bool) {
        let api = WeightedStockListApi.init { (data, response, error) in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            } else {
                let responseStr = String(data: data, encoding: .utf8)!
                //print("response \(responseStr)")
                
                if let doc = HTML(html: responseStr, encoding: .utf8) {
                    
                    for (index, repo) in doc.xpath("//tr[@valign='bottom']").enumerated() {
                        self.toParseInternal(repo.toHTML!)
                        if(index == 29) {
                            break
                        }
                    }
                    self.showStocks()
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }
            }
        }
        
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

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
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
    
    func showStocks() {
        print("stock count \(stocks.count)")
        for stock in stocks {
            print(stock.name)
        }
    }
    
    func toParseInternal(_ html : String) {
        if let doc = HTML(html: html, encoding: .utf8) {
            var stock = Stock()
            
            // Search for nodes by XPath
            for (index, element) in doc.xpath("//td").enumerated() {
                
                switch index % 4 {
                case 0:
                    stock.rank = Int(element.text!)!
                case 1:
                    stock.number = element.text!
                case 2:
                    stock.name = element.text!
                case 3:
                    stock.weighted = element.text!
                    if(stock.rank <= 30) {
                        stocks.append(stock)
                    }
                    stock = Stock()
                default:
                    print("Unknow error")
                }
            }
        }
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
