//
//  ViewController.swift
//  FilterTwitterApp
//
//  Copyright (c) 2021 Keach.T
//

import UIKit

// UISearchBarの入力情報を渡す下準備1：UISearchBarDelegateを追加
class MainViewController: UIViewController, UISearchBarDelegate {
    
    // UISearchBarの入力情報を渡す準備2：UISearchBarのインスタンスをIBOutletと紐付け
    @IBOutlet weak var searchField: UISearchBar!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // UISearchBarの入力情報を渡す下準備3
        // serchField.delegate = MainViewController.delegateと同じ意味
        searchField.delegate = self
        
        // ボタンを角丸にする
        historyButton.layer.cornerRadius = 20.0
        settingsButton.layer.cornerRadius = 20.0
    }
    
    // UISearchBarの入力情報を渡す下準備４：ボタンが押された時の処理（UISearchBarDelegateのメンバ）
    func searchBarSearchButtonClicked(_ searchBar:UISearchBar) {
        // キーボードを閉じる
        view.endEditing(true)
    }
    
    // キーボードの外をタッチしたらキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // キーボードを閉じる
        view.endEditing(true)
    }
    
    // UISearchBarの入力情報を渡す下準備5；入力完了時の処理（UISearchBarDelegateのメンバ）
    @IBAction func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        let mainVCStoryboard = self.storyboard!
        
        // withIdentifier: storyboard -> identiry inspector -> classを指定する（String型）
        // as! -> 遷移先のstoryboardのclassを指定する
        let serchResultsTableVC = mainVCStoryboard.instantiateViewController(withIdentifier: "SerchResultsTableViewController") as! SerchResultsTableViewController
        
        // 上でserchResultsTableViewControllerを定義→そのメンバが使用できる
        serchResultsTableVC.searchBarInputedWord = self.searchField.text
        
        // 文字入力済みならツイートの検索結果画面へ遷移、未入力なら何もしない
        if self.searchField.text != "" {
            self.present(serchResultsTableVC, animated: true)
            
        } else {
            
        }
    }
    
    // Historyボタンを押した時の画面遷移
    @IBAction func goHistoryTableVC(_ sender: Any) {
        
        let mainVCStoryboard = self.storyboard!
        
        let historyTableVC = mainVCStoryboard.instantiateViewController(withIdentifier: "HistoryTableViewController") as! HistoryTableViewController
        
        self.present(historyTableVC, animated: true)
    }
    
    // Settingsボタンを押した時の画面遷移
    @IBAction func goSettingsModalVC(_ sender: Any) {
        
        let mainViewControllerStoryboard = self.storyboard!
        
        let settingsModalVC = mainViewControllerStoryboard.instantiateViewController(withIdentifier: "SettingsModalViewController") as! SettingsModalViewController
        
        self.present(settingsModalVC, animated: true)
    }
    
}

