//
//  SerchResultsTableViewController.swift
//  FilterTwitterApp
//
//  Copyright (c) 2021 Keach.T
//

import UIKit
import Swifter
import RealmSwift
import SafariServices
import LinkPresentation

class SerchResultsTableViewController: UITableViewController {
    
    // MainViewControllerのSearchBarに入力された文字列を受け取る変数
    var searchBarInputedWord: String?
    
    // Swifterクラスのインスタンスを作成、TwitterAPIのキーを使用する
    let swifter = Swifter(consumerKey: twitterAPIconsumerKey, consumerSecret: twitterAPIconsumerSecret)
    
    // UserDefaults使用準備
    let userDefaultsStandard = UserDefaults.standard
    
    // ツイートのテキスト、リンク先、メデイアの要素保存用
    var tweetTexts: [Int: String] = [:]
    var linkURLs: [Int: String] = [:]
    var mediaURLs: [Int: String] = [:]
    var mediaImages: [Int: UIImage] = [:]
    
    // インジケーター用意（ローディング画面）
    var activityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // インジケーターを表示
        activityIndicatorView.center = view.center
        view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
        // セルの区切り線を設定
        tableView.separatorColor = .systemGray2
        
        // セッティングモーダル設定値
        let wordsOfSettingModal = userDefaultsStandard.string(forKey: "wordsOfSettingModal") ?? "min_retweets:30 min_faves:30 -filter:replies "
        // 検索フレーズ　＝　セッティングモーダル設定値　＋　SearchBarに入力された文字列
        let searchWords = wordsOfSettingModal + searchBarInputedWord!
        
        //test
        print("searchWords")
        print(searchWords)
        
        // Swifterのメソッドでツイートを検索（success、failiure引数はクロージャ）
        swifter.searchTweet(
            //検索するフレーズ
            using: searchWords,
            
            // 取得するツイート数
            count: 30,
            
            // 検索処理成功時のクロージャ
            // jsonはツイート+ユーザの情報、json2はメンション先などの情報
            success: { json,json2 in
                
                for indexNumber in 0...30 {
                    
                    let tweetText = json[indexNumber]["text"].string ?? "NO DATA"
                    
                    // ツイートのテキスト情報がある場合のみ辞書型に保存する
                    if tweetText != "NO DATA" {
                        // ツイートのテキスト情報は、URLを除いたものを追加する
                        self.tweetTexts[indexNumber] = tweetText.removeURL(text: tweetText)
                        self.linkURLs[indexNumber] = json[indexNumber]["entities"]["urls"][0]["expanded_url"].string ?? "NO DATA"
                        self.mediaURLs[indexNumber] = json[indexNumber]["entities"]["media"][0]["media_url_https"].string ?? "NO DATA"
                        
                        // メデイアのイメージをリサイズして辞書に保存
                        // メディアあり絵のアイコン、リンクありSafariアイコン、リンクなし✖︎アイコンをリサイズして保存
                        if self.mediaURLs[indexNumber] != "NO DATA"{
                            let image: UIImage = UIImage(named: "paint")!
                            self.mediaImages[indexNumber] = image.resize(size: CGSize(width: 30, height: 30))
                        } else if self.linkURLs[indexNumber] != "NO DATA" {
                            let image: UIImage = UIImage(named: "browzer")!
                            self.mediaImages[indexNumber] = image.resize(size: CGSize(width: 30, height: 30))
                        } else {
                            let image: UIImage = UIImage(named: "nolink")!
                            self.mediaImages[indexNumber] = image.resize(size: CGSize(width: 30, height: 30))
                        }
                    }
                }
                // ツイートの情報を各辞書型に格納後、tableviewをリロードする
                self.tableView.reloadData()
            },
            // 検索処理失敗時のクロージャ
            failure: { error in print(error) }
        )
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        // セルを収めるセクション数を設定
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if tweetTexts == [:] {
            // ツイートの検索完了まではセルを表示しない
            return 0
        } else {
            // ツイートの検索完了後インジケーターの表示を停止し、ツイートのテキスト要素分のセルを表示
            activityIndicatorView.stopAnimating()
            return tweetTexts.count
        }
    }
    
    // withIdentifier: storyboardのcell -> attribute inspector -> Identifierを指定する（String型）
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath)
        // Configure the cell...
        
        // ツイートのテキスト情報、アイコンをセルに表示
        cell.textLabel!.text = tweetTexts[indexPath.row]
        cell.imageView!.image = mediaImages[indexPath.row]
        // テキストは折り返しあり、ラベルはセルの左側に表示
        cell.textLabel!.numberOfLines = 0
        cell.textLabel!.textAlignment = NSTextAlignment.left
        // DynamicType対応
        cell.textLabel!.font = UIFont.preferredFont(forTextStyle: .subheadline)
        cell.textLabel!.adjustsFontForContentSizeCategory = true
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //タップした時の選択色を消す
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let linkURL = linkURLs[indexPath.row] ?? "NO DATA"
        let mediaURL = mediaURLs[indexPath.row] ?? "NO DATA"
        
        // Safariでリンクを表示（リンク先をメディアより優先して表示）
        // リンク先がないときはアラートを表示
        if linkURL != "NO DATA" {
            let urlInTweet = URL(string: linkURL)!
            let safariVC = SFSafariViewController(url: urlInTweet)
            safariVC.modalPresentationStyle = .pageSheet
            present(safariVC, animated: true, completion: nil)
        } else if mediaURL != "NO DATA" {
            let urlInTweet = URL(string: mediaURL)!
            let safariVC = SFSafariViewController(url: urlInTweet)
            safariVC.modalPresentationStyle = .pageSheet
            present(safariVC, animated: true, completion: nil)
        } else {
            //アラートのタイトル
            let dialog = UIAlertController(title: "", message: "リンクがありません", preferredStyle: .alert)
            //ボタンのタイトル
            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(dialog, animated: true, completion: nil)
        }
    }
    
    // Viewが閉じる時、Realmに検索したツイートの情報を書き込む
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // ツイートの検索が成功していた場合のみRealmへ書き込み処理をする
        if tweetTexts != [:] {
            
            // RealmインスタンスとHistoryModelインスタンスを作成
            let realm = try! Realm()
            let historyModel = HistoryModel()
            
            // historyModelにツイートのテキスト、リンク先、メデイアの各要素を保存
            try! realm.write {
                
                historyModel.searchWord = searchBarInputedWord ?? "NO DATA"
                realm.add(historyModel)
                
                // ツイートのテキスト情報の数だけ保存する
                for indexNumber in 0...tweetTexts.count - 1 {
                    
                    /*
                     繰り返しの中でhistoryModelに追加するlist型のインスタンスを宣言する
                     historyModel１つに複数のlist型のインスタンスが結びつくので、historyModelに格納したい分のlist型インスタンスを生成する必要がある
                     繰り返しインスタンスを生成、初期化->追加する
                     */
                    let searchTweetResultHistoryDict = HistorySearchedTweets()
                    
                    searchTweetResultHistoryDict.tweetText = tweetTexts[indexNumber] ?? "NO DATA"
                    searchTweetResultHistoryDict.linkURL = linkURLs[indexNumber] ?? "NO DATA"
                    searchTweetResultHistoryDict.mediaURL = mediaURLs[indexNumber] ?? "NO DATA"
                    searchTweetResultHistoryDict.mediaImageData = mediaImages[indexNumber]?.pngData()
                    
                    historyModel.HistorySearchedTweet.append(searchTweetResultHistoryDict)
                }
            }
        } else {
            
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
