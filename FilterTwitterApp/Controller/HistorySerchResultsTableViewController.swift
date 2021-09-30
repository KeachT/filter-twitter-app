//
//  HistorySerchResultsTableViewController.swift
//  FilterTwitterApp
//
//  Copyright (c) 2021 Keach.T
//

import UIKit
import RealmSwift
import SafariServices

class HistorySerchResultsTableViewController: UITableViewController {
    
    // HistoryViewControllerから値を受け取る変数
    // この日付に合致するHistoryModelの情報を表示する
    var forSearchCreateDate: Date = Date()
    
    // Realmインスタンスを作成
    let realm = try! Realm()
    
    // 履歴のツイートのテキスト、リンク先、メデイアの要素保存用
    var tweetTexts: [Int: String] = [:]
    var linkURLs: [Int: String] = [:]
    var mediaURLs: [Int: String] = [:]
    var mediaImages: [Int: UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Date型だと完全一致（==）で検索できなかった
        // 以上（>=）で比較をして、一番始めに帰ってくるのが一番近い日付のオブジェクト
        let searchedHistoryModel = realm.objects(HistoryModel.self).filter("createDate >= %@", forSearchCreateDate).first
        
        let searchedHistoryModelTweets = searchedHistoryModel?["HistorySearchedTweet"] as! List<HistorySearchedTweets>
        
        for indexNumber in 0...searchedHistoryModelTweets.count - 1 {
            tweetTexts[indexNumber] = searchedHistoryModelTweets[indexNumber].tweetText
            linkURLs[indexNumber] = searchedHistoryModelTweets[indexNumber].linkURL
            mediaURLs[indexNumber] = searchedHistoryModelTweets[indexNumber].mediaURL
            mediaImages[indexNumber] = UIImage(data: searchedHistoryModelTweets[indexNumber].mediaImageData!)?.resize(size: CGSize(width: 30, height: 30))
        }
        
        // 履歴のツイートのデータ読み込み完了後、tableViewをリロード
        tableView.reloadData()
        
        // セルの区切り線を設定
        tableView.separatorColor = .systemGray2
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if tweetTexts == [:] {
            // 履歴のツイートのデータ読み込みが完了するまではセルを表示しない
            return 0
        } else {
            // ツイートのテキスト要素分のセルを表示
            return tweetTexts.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyTweetCell", for: indexPath)
        // Configure the cell...
        
        // 履歴ツイートのテキスト情報、アイコンをセルに表示
        cell.textLabel!.text = tweetTexts[indexPath.row]
        cell.imageView!.image = mediaImages[indexPath.row]
        // テキストは折り返しあり、ラベルはセルの左側に表示
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textAlignment = NSTextAlignment.left
        // DynamicType対応
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        cell.textLabel?.adjustsFontForContentSizeCategory = true
        
        return cell
    }
    
    //セルをタップした時の処理
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //タップした時の選択色を消す
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        // 選択したセルのリンク先、メデイア情報
        let linkURL = linkURLs[indexPath.row] ?? "NO DATA"
        let mediaURL = mediaURLs[indexPath.row] ?? "NO DATA"
        
        // Safariでリンクを表示（リンク先をメディアより優先して表示）
        // リンク先がないときはアラートを表示
        if linkURL != "NO DATA" {
            let urlInTweet:URL = URL(string: linkURL)!
            let safariVC = SFSafariViewController(url: urlInTweet)
            safariVC.modalPresentationStyle = .pageSheet
            present(safariVC, animated: true, completion: nil)
            
        } else if mediaURL != "NO DATA" {
            let urlInTweet:URL = URL(string: mediaURL)!
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
