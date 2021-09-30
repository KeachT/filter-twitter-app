//
//  SettingsModalViewController.swift
//  FilterTwitterApp
//
//  Copyright (c) 2021 Keach.T
//

import UIKit

class SettingsModalViewController: UIViewController {
    
    //設定値を保存するためにUserDefaultsを使用する
    let userDefaultsStandard = UserDefaults.standard
    
    //セグメントのアウトレット クラス -> Recieved Actions -> Value Changed -> セグメントコントロールに紐付け
    @IBOutlet weak var segmentedControlRetweets: UISegmentedControl!
    @IBOutlet weak var segmentedControlLiles: UISegmentedControl!
    @IBOutlet weak var segmentedControlLink: UISegmentedControl!
    @IBOutlet weak var segmentedControlImage: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // UserDefaultsの値をセグメントコントロールの状態に反映する
        segmentedControlRetweets.selectedSegmentIndex = userDefaultsStandard.integer(forKey: "retweetsSelectedSegmentIndex")
        segmentedControlLiles.selectedSegmentIndex = userDefaultsStandard.integer(forKey: "LikesSelectedSegmentIndex")
        segmentedControlLink.selectedSegmentIndex = userDefaultsStandard.integer(forKey: "linkSelectedSegmentIndex")
        segmentedControlImage.selectedSegmentIndex = userDefaultsStandard.integer(forKey: "imageSelectedSegmentIndex")
    }
    
    // リツイート数の設定
    @IBAction func segmentedControlRetweets(_ sender: UISegmentedControl) {
        let retweetsSetting = "min_retweets:" + String(sender.titleForSegment(at: sender.selectedSegmentIndex)!) + " "
        
        // リツイート数の設定とセグメントのインデックスをUserDefaultsに保存
        userDefaultsStandard.set(retweetsSetting, forKey: "retweetsSetting")
        userDefaultsStandard.set(segmentedControlRetweets.selectedSegmentIndex, forKey: "retweetsSelectedSegmentIndex")
    }
    
    // いいね数の設定
    @IBAction func segmentedControlLikes(_ sender: UISegmentedControl) {
        let LikesSetting = "min_faves:" + String(sender.titleForSegment(at: sender.selectedSegmentIndex)!) + " "
        
        // いいね数の設定とセグメントのインデックスをUserDefaultsに保存
        userDefaultsStandard.set(LikesSetting, forKey: "LikesSetting")
        userDefaultsStandard.set(segmentedControlLiles.selectedSegmentIndex, forKey: "LikesSelectedSegmentIndex")
    }
    
    // リンクありなしの設定
    @IBAction func segmentedControlLink(_ sender: UISegmentedControl) {
        let linkSetting = sender.titleForSegment(at: sender.selectedSegmentIndex)!
        
        // リンクありなしの設定とセグメントのインデックスをUserDefaultsに保存
        switch linkSetting {
        case "With link":
            userDefaultsStandard.set("filter:links ", forKey: "linkSetting")
        default:
            userDefaultsStandard.set(" ", forKey: "linkSetting")
        }
        userDefaultsStandard.set(segmentedControlLink.selectedSegmentIndex, forKey: "linkSelectedSegmentIndex")
    }
    
    // 画像ありなしの設定
    @IBAction func segmentedControlImage(_ sender: UISegmentedControl) {
        let imageSetting = sender.titleForSegment(at: sender.selectedSegmentIndex)!
        
        // 画像ありなしの設定とセグメントのインデックスをUserDefaultsに保存
        switch imageSetting {
        case "With images":
            userDefaultsStandard.set("filter:images ", forKey: "imageSetting")
        default:
            userDefaultsStandard.set(" ", forKey: "imageSetting")
        }
        userDefaultsStandard.set(segmentedControlImage.selectedSegmentIndex, forKey: "imageSelectedSegmentIndex")
    }
    
    // Viewが閉じる時、セッティングの合計値を保存する
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // セッティング各設定値
        let retweetCountSetting = userDefaultsStandard.string(forKey: "retweetsSetting") ?? "min_retweets:30 "
        let niceCountSetting = userDefaultsStandard.string(forKey: "LikesSetting") ?? "min_faves:30 "
        let linkSetting = userDefaultsStandard.string(forKey: "linkSetting") ?? " "
        let imageSetting = userDefaultsStandard.string(forKey: "imageSetting") ?? " "
        
        // セッティング各設定値の合計 + RTは表示しない
        let wordsOfSettingModal = retweetCountSetting + niceCountSetting + linkSetting + imageSetting + "-filter:replies "
        
        // UserDefaultsに保存
        userDefaultsStandard.set(wordsOfSettingModal, forKey: "wordsOfSettingModal")
        
        // test
        print("userDefaultsStandard.string(forKey: wordsOfSettingModal)!")
        print(userDefaultsStandard.string(forKey: "wordsOfSettingModal")!)
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
