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
        
    override func viewDidLoad() {
        super.viewDidLoad()

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
                        //print("index \(index) , text : \()")
                        self.toParseInternal(repo.toHTML!)
                        if(index == 1) {
                            break
                        }
                    }
                }
            }
        }

        api.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    @IBAction func backTouchUp(_ sender: Any) {
        toTestKanna()
        dismiss(animated: true, completion: nil)
    }
    
    func toParseInternal(_ html : String) {
        if let doc = HTML(html: html, encoding: .utf8) {
            
            // Search for nodes by XPath
            for (index, element) in doc.xpath("//td").enumerated() {
                
                switch index % 4 {
                case 0:
                    print("排名 \(element.text!)")
                case 1:
                    print("股號 \(element.text!)")
                case 2:
                    print("公司名 \(element.text!)")
                case 3:
                    print("佔比 \(element.text!)")
                    
                default:
                    print("Unknow error")
                }
            }
        }
    }
    
    func toParseHtml(_ html : String) {
        if let doc = HTML(html: html, encoding: .utf8) {
            
            // Search for nodes by XPath
            for link in doc.xpath("//a | //link") {
                print(link.text)
                print(link["href"])
            }
        }
    }
    
    func toTestKanna() {
        let html = "<html><head></head><body><ul><li><input type='image' name='input1' value='string1value' class='abc' /></li><li><input type='image' name='input2' value='string2value' class='def' /></li></ul><span class='spantext'><b>Hello World 1</b></span><span class='spantext'><b>Hello World 2</b></span><a href='example.com'>example(English)</a><a href='example.co.jp'>example(JP)</a></body>"
        
        toParseHtml(html)
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
