//
//  ViewController.swift
//  LeaderboardApp
//
//  Created by AndyLin on 2022/8/17.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var optionButton: UIButton!
    
    enum mode : Int{
        case music = 0
        case podcasts = 1
        case apps = 2
        case books = 3
        case audiobooks = 4
    }
    
    var urlSelection = mode.music // 初始的 Model
    var urlApplemarket = "https://rss.applemarketingtools.com/api/v2/us/" // url 重複的部分
    var urlFinally = "" // 最終組合的 Url
    var responseItems = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewinit()
        // Do any additional setup after loading the view.
    }

    func enUrl(){
        if(self.urlFinally == "")
        {
            print("沒選")
        }else
        {
            if let url = URL(string: self.urlFinally) {
            do {
            let data = try Data(contentsOf: url)
                //print("EN \(data)")
                // data 轉換成 string
                if let content = String(data: data, encoding: .utf8){
                    print(content)
                    }
                } catch {
                print(error)
                }
                
                //使用 URLSession.shared 讓下載在背景執行 dataTask 回傳抓資料的任務
                URLSession.shared.dataTask(with: url) { data, response, error in
                    
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    if let data{
                        do{
                            let searchResponse = try decoder.decode(SearchResponse.self, from: data)
                            //print("showDate \(searchResponse.feed.results[0])")
                            DispatchQueue.main.async {
                                self.responseItems = searchResponse.feed.results
                            }
                        }catch{
                            print("error")
                        }
                    }else{
                        print("error")
                    }
                }.resume()
            }
        }
    }
    
    func viewinit()
    {
        self.buttonInit()
    }
    
    func buttonInit(){
        self.optionButton.showsMenuAsPrimaryAction = true
        self.optionButton.menu = UIMenu(children: [
        UIAction(title: "Music", image: UIImage(systemName: "music.quarternote.3"), handler: { action in
            self.optionButton.setTitle("Music", for: .normal)
            self.urlSelection = mode.music
            self.combinationUrl(value: self.urlSelection)
            //print("\(self.urlSelection)")
        }),
        UIAction(title: "Podcasts", image: UIImage(systemName: "earbuds"), handler: { action in
            self.optionButton.setTitle("Podcasts", for: .normal)
            self.urlSelection = mode.podcasts
            self.combinationUrl(value: self.urlSelection)
            //print("\(self.urlSelection)")
        }),
        UIAction(title: "Apps", image: UIImage(systemName: "apps.iphone"), handler: { action in
            self.optionButton.setTitle("Apps", for: .normal)
            self.urlSelection = mode.apps
            self.combinationUrl(value: self.urlSelection)
            //print("\(self.urlSelection)")
        }),
        UIAction(title: "Books", image: UIImage(systemName: "book.closed"), handler: { action in
            self.optionButton.setTitle("Books", for: .normal)
            self.urlSelection = mode.books
            self.combinationUrl(value: self.urlSelection)
            //print("\(self.urlSelection)")
        }),
        UIAction(title: "Audio Books", image: UIImage(systemName: "book.fill"), handler: { action in
            self.optionButton.setTitle("AudioBooks", for: .normal)
            self.urlSelection = mode.audiobooks
            self.combinationUrl(value: self.urlSelection)
            //print("\(self.urlSelection)")
        })
        ])
    }
    
    func combinationUrl(value:mode)
    {
        switch(value){
        case .music :
            urlFinally = urlApplemarket + "\(self.urlSelection)" + "/most-played/10/albums.json"
        case .podcasts:
            urlFinally = urlApplemarket + "\(self.urlSelection)" + "/top/10/podcasts.json"
        case .apps:
            urlFinally = urlApplemarket + "\(self.urlSelection)" + "/top-free/10/apps.json"
        case .books:
            urlFinally = urlApplemarket + "\(self.urlSelection)" + "/top-free/10/books.json"
        case .audiobooks:
            urlFinally = urlApplemarket + "/audio-books/top/10/audio-books.json"
        }
       
        //print(urlFinally)
    }
    
    @IBAction func callApiAction(_ sender: Any) {
        self.enUrl()
        performSegue(withIdentifier: "toLeaderboardSegue", sender: nil)
    }
    
    @IBSegueAction func toLeaderboardSegueAction(_ coder: NSCoder) -> LeaderboardListViewController? {
        guard LeaderboardListViewController(coder: coder) != nil else {return nil}

        return LeaderboardListViewController(coder: coder, items: responseItems)
    }
    
}

