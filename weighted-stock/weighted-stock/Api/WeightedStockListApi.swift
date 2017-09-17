import Foundation

class WeightedStockListApi {
    var request : URLRequest
    var task : URLSessionTask?
    
    var callback:(Data?, URLResponse?, Error?)->Void
    
    init (cb : @escaping (Data?, URLResponse?, Error?)->Void) {
        //let url = URL(string: "http://jsinfo2.wls.com.tw/z/zm/zmd/zmdb.djhtm")!
        let url = URL(string: "http://www.taifex.com.tw/chinese/9/9_7_1.asp")!
        request = URLRequest.init(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 5)
        request.httpMethod = "Get"
        callback = cb
    }
    
    func start() {
        cancel()
        
        task = URLSession.shared.dataTask(with: request, completionHandler:callback)
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
}
