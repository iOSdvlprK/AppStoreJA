//
//  Service.swift
//  AppStoreJA
//
//  Created by joe on 2023/04/25.
//

import Foundation

class Service {
    static let shared = Service()   // singleton
    
    func fetchApps(searchTerm: String, completion: @escaping ([Result], Error?) -> ()) {
        print("Fetching itunes apps from Service layer")
        
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
        guard let url = URL(string: urlString) else { return }
        
        // fetch data from internet
        URLSession.shared.dataTask(with: url) { data, resp, err in
            if let err = err {
                print("Failed to fetch apps:", err)
                completion([], nil)
                return
            }
            
            // success
//            print(data)
//            print(String(data: data!, encoding: .utf8))
            
            guard let data = data else { return }
            
            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                
                completion(searchResult.results, nil)
                
            } catch let jsonErr {
                print("Failed to decode json:", jsonErr)
                completion([], jsonErr)
            }
            
        }.resume()  // fires off the request
    }
    
    func fetchTopFreeApps(completion: @escaping (AppGroup?, Error?) -> ()) {
        let urlString = "https://rss.applemarketingtools.com/api/v2/us/apps/top-free/50/apps.json"
        fetchAppGroup(urlString: urlString, completion: completion)
    }
    
    func fetchTopPaidApps(completion: @escaping (AppGroup?, Error?) -> ()) {
        fetchAppGroup(urlString: "https://rss.applemarketingtools.com/api/v2/us/apps/top-paid/50/apps.json", completion: completion)
    }
    
    // helper
    func fetchAppGroup(urlString: String, completion: @escaping (AppGroup?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, resp, err in
//            print(String(data: data!, encoding: .utf8))
            
            if let err = err {
                completion(nil, err)
                return
            }
            
            do {
                let appGroup = try JSONDecoder().decode(AppGroup.self, from: data!)
                // success
//                appGroup.feed.results.forEach { print($0.name) }
                completion(appGroup, nil)
            } catch {
//                print("Failed to decode:", error)
                completion(nil, error)
            }
        }.resume()  // this will fire the request
    }
    
    func fetchSocialApps(completion: @escaping ([SocialApp]?, Error?) -> Void) {
        let urlString = "https://api.letsbuildthatapp.com/appstore/social"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, resp, err in
            
            if let err = err {
                completion(nil, err)
                return
            }
            
            do {
                let objects = try JSONDecoder().decode([SocialApp].self, from: data!)
                // success
                completion(objects, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
}
