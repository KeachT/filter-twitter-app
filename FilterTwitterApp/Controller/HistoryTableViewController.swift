//
//  HistoryTableViewController.swift
//  FilterTwitterApp
//
//  Copyright (c) 2021 Keach.T
//

import UIKit
import RealmSwift

class HistoryTableViewController: UITableViewController {
    
    // Realmインスタンスを作成
    let realm = try! Realm()
    
    // HistoryModelのデータ格納用
    var historyModelDates: [Int: Date] = [:]
    var historyModelTexts: [Int: String] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("RealmのDBファイルパス")
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        // HistoryModelを作成日時の降順で取り出す
        let historyModel = realm.objects(HistoryModel.self).sorted(byKeyPath: "createDate", ascending: false)
        
        // historyModelの要素を辞書に格納する
        if historyModel.count > 30 {
            for indexNumber in 0...30 {
                historyModelDates[indexNumber] = historyModel[indexNumber].createDate
                historyModelTexts[indexNumber] = historyModel[indexNumber].searchWord
            }
        } else if historyModel.count > 0 {
            for indexNumber in 0...(historyModel.count - 1) {
                historyModelDates[indexNumber] = historyModel[indexNumber].createDate
                historyModelTexts[indexNumber] = historyModel[indexNumber].searchWord
            }
        } else {
            // historyModelの要素が０なら何もしない
        }
        
        // viewDidLoadでの処理後、viewをリロード
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
        
        // 表示する行数を設定する
        if historyModelTexts == [:] {
            // todo: ツイートの検索が終わるまで、待機画面を表示する
            return 0
        } else {
            return historyModelTexts.count
        }
    }

    // override func tableViewのコメントアウトを解除した
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        
         //Configure the cell...
        
        // HistoryModelをラベルに表示
        cell.textLabel?.text = historyModelTexts[indexPath.row]
        
        // テキストは折り返しあり、ラベルはセルの左側に表示
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textAlignment = NSTextAlignment.left
        // DynamicType対応
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        cell.textLabel?.adjustsFontForContentSizeCategory = true

        return cell
    }
    
    // セルがタップされた時のアクション
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        
        // controller自身のstoryboardインスタンスを作成
        let HistoryTableVCStoryboard = self.storyboard!
        
        // as! -> 遷移先のstoryboardのclassを指定する
        let historySerchResultsTableVC = HistoryTableVCStoryboard.instantiateViewController(withIdentifier: "HistorySerchResultsTableViewController") as! HistorySerchResultsTableViewController
        
        // 上で遷移先を定義したので、遷移先のプロパティが使える
        historySerchResultsTableVC.forSearchCreateDate = historyModelDates[indexPath.row]!
        
        // 画面を遷移するメソッド
        present(historySerchResultsTableVC , animated: true)
        }

    /*
     Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         Return false if you do not want the specified item to be editable.
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
