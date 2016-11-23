import Foundation

public enum PubNubStatus {
    
}

public struct MessageResult {
    
}

public protocol PubNubDelegate: class {
    
    func client(_ client: PubNub, didReceiveMessage message: MessageResult)
    func client(_ client: PubNub, didReceiveStatus status: PubNubStatus)
}

enum Response {
    
    case error(Error)
    case success(Data, URLResponse)
}

public enum PublishResponse {
    case error
    case success
}

extension Data {
    
    func stringRepresentation() -> String {
        
        return String(data: self, encoding: String.Encoding.utf8)!
    }
}

extension URLSession {
    
    // Sue me
    func syncCall(request: URLRequest) -> Response {
        
        let semaphore = DispatchSemaphore(value: 0)
        var response: Response? = nil
        
        let task = self.dataTask(with: request) { (data, urlResponse, error) -> Void in
            
            if let error = error {
             
                response = Response.error(error)
                
            } else {
                
                response = Response.success(data!, urlResponse!)
            }
            
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
        
        return response!
    }
}

public class PubNub {
    
    private let baseURL = URL(string: "https://pubsub.pubnub.com")!
    
    private let publishKey: String?
    private let subscribeKey: String?
    
    weak private var delegate: PubNubDelegate?
    
    public init(publishKey: String?, subscribeKey: String?) {
        
        self.publishKey = publishKey
        self.subscribeKey = subscribeKey
    }
    
    public func subscribe(to channels: [String]) {
        
    }
    
    public func publish(channel: String, json: [String : Any]) throws -> PublishResponse {
        
        let jsonString = try JSONSerialization.data(withJSONObject: json, options: []).stringRepresentation()
        
        return publish(channel: channel, json: jsonString)
    }
    
    public func publish(channel: String, json: String) -> PublishResponse {
        
        guard
            let publishKey = publishKey,
            let subscribeKey = subscribeKey
            else { return .error }
        
        // TODO: make nicer forming of paths
        
        let payload = json.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!
        
        let url = URL(string: "/publish/\(publishKey)/\(subscribeKey)/0/\(channel)/0/\(payload)",
            relativeTo: baseURL)!
        
        let request = URLRequest(url: url)
        
        let session = URLSession(configuration: .default)
        
        switch session.syncCall(request: request) {
            
        case .error(let error):
            
            print("💩 \(error.localizedDescription)")
            return .error
            
        case .success(let data, let response):
            
            print("💰 \(response)")
            print("😂 \(data.stringRepresentation())")
            
            if (response as! HTTPURLResponse).statusCode > 299 {
                return .error
            }
            
            return .success
        }
    }
    
    public func googleTest() {
        
        let request = URLRequest(url: URL(string: "http://google.com")!)
        
        let session = URLSession(configuration: .default)
        
        switch session.syncCall(request: request) {
            
        case .error(let error):
            print("💩 \(error.localizedDescription)")
            
        case .success(let data, let response):
            print(response)
            print("Received \(data.count) bytes of data")
        }
    }
}

