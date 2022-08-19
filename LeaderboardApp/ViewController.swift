//
//  ViewController.swift
//  LeaderboardApp
//
//  Created by AndyLin on 2022/8/17.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate{

    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var imagePageControl: UIPageControl!
    
    enum mode : Int{
        case music = 0
        case podcasts = 1
        case apps = 2
        case books = 3
        case audiobooks = 4
    }
    
    enum Direction {
        case right
        case left
    }

    var currentIndex = 0 // 初始頁數
    var images = ["music","podcast","apps","books","audiobooks"]
    var lastTimeOffsetX = 0.0
    var timer: Timer? //宣告 timer 元件
    var direction = Direction.right
    var carouselTime = 3 // 輪播換頁的秒數
    
    var urlSelection = mode.music // 初始的 Model
    var selectType = ""
    //var responseItems = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar()
        self.viewinit()
        self.scrollController()
        self.pageController()
        self.setupImageView()
        self.setTimer()
        
        
        // Do any additional setup after loading the view.
    }
    
    func viewinit(){
        self.buttonInit()
        buttonView.layer.cornerRadius = 20
    }
    
    
    func buttonInit(){
        self.optionButton.showsMenuAsPrimaryAction = true
        self.optionButton.menu = UIMenu(children: [
        UIAction(title: "Music", image: UIImage(systemName: "music.quarternote.3"), handler: { action in
            self.optionButton.setTitle("Music", for: .normal)
            self.urlSelection = mode.music
            self.checkType(value: self.urlSelection)
            //print("\(self.urlSelection)")
        }),
        UIAction(title: "Podcasts", image: UIImage(systemName: "earbuds"), handler: { action in
            self.optionButton.setTitle("Podcasts", for: .normal)
            self.urlSelection = mode.podcasts
            self.checkType(value: self.urlSelection)
            //print("\(self.urlSelection)")
        }),
        UIAction(title: "Apps", image: UIImage(systemName: "apps.iphone"), handler: { action in
            self.optionButton.setTitle("Apps", for: .normal)
            self.urlSelection = mode.apps
            self.checkType(value: self.urlSelection)
            //print("\(self.urlSelection)")
        }),
        UIAction(title: "Books", image: UIImage(systemName: "book.closed"), handler: { action in
            self.optionButton.setTitle("Books", for: .normal)
            self.urlSelection = mode.books
            self.checkType(value: self.urlSelection)
            //print("\(self.urlSelection)")
        }),
        UIAction(title: "Audio Books", image: UIImage(systemName: "book.fill"), handler: { action in
            self.optionButton.setTitle("AudioBooks", for: .normal)
            self.urlSelection = mode.audiobooks
            self.checkType(value: self.urlSelection)
            //print("\(self.urlSelection)")
        })
        ])
    }
    
    func checkType(value:mode)
    {
        switch(value){
        case .music :
            selectType = "music"
        case .podcasts:
            selectType = "podcasts"
        case .apps:
            selectType = "apps"
        case .books:
            selectType = "books"
        case .audiobooks:
            selectType = "audiobooks"
        }
    }
    
    func scrollController(){
        
        imageScrollView.frame.size.width = self.view.frame.width // 設定 ScrollView 寬度
        imageScrollView.frame.size.height = self.view.frame.height // 設定 ScrollView 高度
        
        imageScrollView.delegate = self
        imageScrollView.showsVerticalScrollIndicator = false
        imageScrollView.showsHorizontalScrollIndicator = false
        imageScrollView.contentSize = CGSize(width: imageScrollView.frame.size.width * CGFloat(images.count + 2 ), height: imageScrollView.frame.size.height)
        imageScrollView.contentOffset = CGPoint(x: imageScrollView.frame.size.width, y: 0)

    }
    
    func pageController(){
        imagePageControl.pageIndicatorTintColor = .lightGray
        imagePageControl.currentPageIndicatorTintColor = .white
        imagePageControl.numberOfPages = images.count // 點數量等於資料陣列長度
        imagePageControl.currentPage = 0 // 初始是第一頁
    }
    
    func setupImageView(){
    
        for i in 0...(images.count + 1){
            let imageView = UIImageView(frame: CGRect(x:imageScrollView.frame.size.width * CGFloat(i),y:0,width: imageScrollView.frame.size.width ,height:imageScrollView.frame.size.height ))
            var picName: String
            
            switch i {
            case 0:
                picName = images.last!
            case images.count + 1:
                picName = images.first!
            default:
                picName = images[i - 1]
            }
            
            imageView.image = UIImage(named: picName) // 圖片名稱
            imageView.contentMode = .scaleAspectFill // 圖片顯示模式
            imageView.clipsToBounds = true
            imageView.isUserInteractionEnabled = true
            //stackView.addArrangedSubview(imageView) // 將圖片加入 stackView
            imageScrollView.addSubview(imageView) // 將圖片加入 ScrollView
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){ // scrollView 滑動時偵測
        if scrollView == imageScrollView{
            let offsetX = imageScrollView.contentOffset.x
            
            if offsetX == 0 {
                let contentOffsetMinX = imageScrollView.frame.size.width * CGFloat(images.count)
                imageScrollView.contentOffset = CGPoint(x: contentOffsetMinX, y: 0)
                lastTimeOffsetX = contentOffsetMinX
            }
            
            if offsetX == imageScrollView.frame.size.width * CGFloat(images.count + 1) {
                imageScrollView.contentOffset = CGPoint(x: imageScrollView.frame.size.width, y: 0)
                lastTimeOffsetX = imageScrollView.frame.size.width
            }
            
            let page = round(scrollView.contentOffset.x / imageScrollView.frame.size.width) - 1
            imagePageControl.currentPage = Int(page)
        }
        
    }
    
    func setTimer(){ // 計時器
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(carouselTime), repeats: true) { _ in
            self.autoScroll()
        }
    }
    
    func autoScroll(){ // 自動滑動
        switch direction{
        case .right:
            if currentIndex == images.count + 1{
                currentIndex = 2
            } else {
                currentIndex += 1
            }
        case .left:
            if currentIndex == 0 {
                currentIndex = images.count - 1
            } else {
                currentIndex -= 1
            }
        }
        
        imageScrollView.setContentOffset(CGPoint(x: imageScrollView.frame.size.width * CGFloat(currentIndex), y: 0), animated: true)
        lastTimeOffsetX = imageScrollView.frame.size.width * CGFloat(currentIndex)
    }
    
    func setNavigationBar(){
        let barAppearance =  UINavigationBarAppearance()
        barAppearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = barAppearance
    }
    
    @IBAction func callApiAction(_ sender: Any) {
        if(selectType == "")
        {
            let controller = UIAlertController(title: "尚未選擇類型 !!", message: "請選擇一個排行榜類型", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default,handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        }
        else
        {
            performSegue(withIdentifier: "toLeaderboardSegue", sender: nil)
        }
    }
    
    @IBSegueAction func toLeaderboardSegueAction(_ coder: NSCoder) -> LeaderboardListViewController? {
        return LeaderboardListViewController(coder: coder, type: selectType)
    }
    
}




