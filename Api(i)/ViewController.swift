//
//  ViewController.swift
//  Api(i)
//
//  Created by undhad kaushik on 23/03/23.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var apiTableView: UITableView!
    
    var arr: Welcome4!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nib()
        apiI()
    }
    private func nib(){
        apiTableView.delegate = self
        apiTableView.dataSource = self
    }
    
    private func apiI(){
        AF.request("https://api.spaceflightnewsapi.net/v3/articles", method: .get).responseData{ [self] response in
            debugPrint(response)
            if response.response?.statusCode == 200{
                guard let apiData = response.data else { return }
                do{
                    let result = try JSONDecoder().decode(Welcome4.self, from: apiData)
                    print(result)
                    arr = result
                    apiTableView.reloadData()
                }catch{
                    print(error.localizedDescription)
                }
            }else{
                print("Wrong")
            }
        }
    }


}
extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr?.posts.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ApiCell(i)", for: indexPath) as! ApiTableViewCell
        cell.nameLabelOne.text = "\(arr.posts[indexPath.row].id)"
        cell.nameLabelTwo.text = "\(arr.posts[indexPath.row].reactions)"
        cell.nameLabelThree.text = "\(arr.posts[indexPath.row].title)"
        cell.nameLabelFour.text = "\(arr.posts[indexPath.row].userID)"
        cell.nameLabelFive.text = "\(arr.posts[indexPath.row].body)"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}

struct Welcome4: Decodable {
    let posts: [Post]
    let total: Int
    let skip: Int
    let limit: Int
}


struct Post: Decodable {
    let id: Int
    let title: String
    let body: String
    let userID: Int
    let tags: [String]
    let reactions: Int
}

