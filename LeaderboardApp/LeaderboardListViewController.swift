//
//  LeaderboardListViewController.swift
//  LeaderboardApp
//
//  Created by AndyLin on 2022/8/17.
//

import UIKit
import Kingfisher

class LeaderboardListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {


    var itemsArray = [Item]()
    
    @IBOutlet weak var LeaderboardTableView: UITableView!
    
    // 初始化
    init?(coder: NSCoder, items: [Item]) {
        self.itemsArray = items
        super.init(coder: coder)
    }
    
    // 初始化失敗時
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.LeaderboardListViewInit()
        // Do any additional setup after loading the view.
    }
    
    func LeaderboardListViewInit(){
        LeaderboardTableView.delegate = self
        LeaderboardTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: indexPath) as! LeaderboardCell
      
        let data = itemsArray[indexPath.row]
        cell.photoImageView.kf.setImage(with: data.artworkUrl100)
        cell.artistLabel.text = data.artistName
        cell.nameLabel.text = data.name
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
