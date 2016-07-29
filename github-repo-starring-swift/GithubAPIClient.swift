//
//  GithubAPIClient.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class GithubAPIClient {
    
    class func getRepositoriesWithCompletion(completion: (NSArray) -> ()) {
        let secret = Secrets()
        let urlString = "https://api.github.com/repositories?client_id=\(secret.clientID)&client_secret=\(secret.clientSecret)"
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let task = session.dataTaskWithURL(unwrappedURL) { (data, response, error) in
            guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
            
            if let responseArray = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray {
                if let responseArray = responseArray {
                    completion(responseArray)
                }
            }
        }
        task.resume()
    }
    
    class func checkIfRepositoryIsStarred(fullName: String, completion: (Bool) -> ()) {
        let secret = Secrets()
        let urlString = "https://api.github.com/user/starred/\(fullName)"
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        
        let request = NSMutableURLRequest(URL: unwrappedURL)
        request.HTTPMethod = "GET"
        request.addValue(secret.token, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTaskWithRequest(request){data, response, error in
            guard let responseValue = response as? NSHTTPURLResponse else {
                assertionFailure("Assignment failed")
                return
            }
            
            if responseValue.statusCode == 204 {
                completion(true)
                print ("Repo is valid")
            } else if responseValue.statusCode == 404 {
                completion(false)
                print ("404 ERROR")
            } else {
                print ("Other status code \(responseValue.statusCode)")
            }
        }
        
        task.resume()
    }
    
    class func starRepository(fullName: String, completion:() -> ()) {
        let secret = Secrets()
        let urlString = "https://api.github.com/user/starred/\(fullName)"
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        
        let request = NSMutableURLRequest(URL: unwrappedURL)
        request.HTTPMethod = "PUT"
        request.addValue(secret.token, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTaskWithRequest(request){data, response, error in
            guard let responseValue = response as? NSHTTPURLResponse else {
                assertionFailure("Assignment failed")
                return
            }
            
            if responseValue.statusCode == 204 {
                completion()
                print("STARRED")
            } else {
                print ("Other status code \(responseValue.statusCode)")
            }
        }
        
        task.resume()
    }
    
    class func unStarRepository(fullName: String, completion:() -> ()) {
        let secret = Secrets()
        let urlString = "https://api.github.com/user/starred/\(fullName)"
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        
        let request = NSMutableURLRequest(URL: unwrappedURL)
        request.HTTPMethod = "DELETE"
        request.addValue(secret.token, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTaskWithRequest(request){data, response, error in
            guard let responseValue = response as? NSHTTPURLResponse else {
                assertionFailure("Assignment failed")
                return
            }
            
            if responseValue.statusCode == 204 {
                completion()
                print("UnSTARRED")
            } else {
                print ("Other status code \(responseValue.statusCode)")
            }
        }
        
        task.resume()
    }
}

