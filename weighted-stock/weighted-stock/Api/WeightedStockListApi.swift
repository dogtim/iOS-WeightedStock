import Foundation

class WeightedStockListApi {
    private var request : URLRequest
    private var sessionTask : URLSessionTask?
    
    var callback:(Data?, URLResponse?, Error?)->Void
    
    init (cb : @escaping (Data?, URLResponse?, Error?)->Void) {
        let url = URL(string: "http://www.taifex.com.tw/chinese/9/9_7_1.asp")!
        request = URLRequest.init(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 5)
        request.httpMethod = "Get"
        callback = cb
    }
    
    func start() {
        cancel()
        sessionTask = URLSession.shared.dataTask(with: request, completionHandler:callback)

        if let task = sessionTask {
            task.resume()
        }
    }
    
    func cancel() {
        
        if let task = sessionTask {
            task.cancel()
        }
    }
}
