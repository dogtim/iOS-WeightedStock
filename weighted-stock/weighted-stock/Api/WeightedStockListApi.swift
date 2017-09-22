import Foundation
import Kanna

class WeightedStockListApi {
    private var request : URLRequest
    private var sessionTask : URLSessionTask?
    var apiDelegate : ApiProtocol?
    
    var stocks = [Stock]()
    
    
    init() {
        let url = URL(string: "http://www.taifex.com.tw/chinese/9/9_7_1.asp")!
        request = URLRequest.init(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 5)
        request.httpMethod = "Get"
    }
    
    func start() {
        cancel()
        
        sessionTask = URLSession.shared.dataTask(with: request, completionHandler:self.getCompletionHandler())
        sessionTask?.resume()
    }
    
    private func getCompletionHandler() -> ((Data?, URLResponse?, Error?)->Void) {
        return { (data, response, error) in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                DispatchQueue.main.async {
                    self.apiDelegate?.error(error: error!)
                }
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            } else {
                let responseStr = String(data: data, encoding: .utf8)!
                
                let doc = try? HTML(html: responseStr, encoding: .utf8)
                // Parse html content
                for (index, repo) in (doc?.xpath("//tr[@valign='bottom']").enumerated())! {
                    self.toParseInternal(repo.toHTML!)
                    if(index == 29) {
                        break
                    }
                }
                DispatchQueue.main.async {
                    self.apiDelegate?.complete(api: self)
                }
                
            }
        }
    }
    
    func cancel() {
        sessionTask?.cancel()
    }
    
    private func toParseInternal(_ html : String) {
        
        let doc = try? HTML(html: html, encoding: .utf8)
        var stock = Stock()
        // Parse html content
        for (index, element) in (doc?.xpath("//td").enumerated())! {
            
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
