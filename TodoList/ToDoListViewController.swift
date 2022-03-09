//
//  ToDoListViewController.swift
//  TodoList
//
//  Created by Susumu Goto on 2021/11/09.
//
/*
 したいこと
 
 １）userDefaultsに値を保存する
 ２）userDefaultsに保存された値を取得
 ３）取得した値をoptionalの配列に格納
 ４）optionalバインディングをする
 ５）格納された文字列でcellを作成
 ６）cellをtableViewに表示
 **/

import UIKit

class ToDoListViewController: UITableViewController {
    
    var doDeleting: Bool = false
    var todo: [String]? {
        
        //todoの配列に文字列が入った時tableViewをリロードする
        didSet {
            
            //todoの配列が空でないなら画面を更新する
            if todo != nil && !doDeleting {
                print("didsetに入りました")
                tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
            //userDefaultsにある値を取得
            let userDefaults = UserDefaults.standard
            let value = userDefaults.stringArray(forKey: "todo")
            
            //userDefaultsで取得した値をtodoに格納
            todo = value
        
            tableView.allowsMultipleSelection = true
        
        
        print("viewWillAppearに入ってきています")
        
    }
    
    @IBAction func plusBotton(_ sender: UIBarButtonItem) {
        guard let vc = storyboard?.instantiateViewController(identifier: "addViewController") as? AddViewController else { return }
                vc.delegate = self
                present(vc, animated: true, completion: nil)
    }
    
    /*
     // storyboardのインスタンス取得
     guard let storyboard: UIStoryboard = self.storyboard else { return }
     
     // 遷移先ViewController(AddViewController)のインスタンス取得
     guard let addView = storyboard.instantiateViewController(withIdentifier: "AddView") as? AddViewController else { return }
     
     // 画面遷移
     self.navigationController?.present(addView, animated: true, completion: nil)
     
     **/
    
}



extension ToDoListViewController {
    
    
    
    // セルが選択された時に呼び出されるメソッド
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)

        // チェックマークを入れる
        cell?.accessoryType = .checkmark
    }
    
    // セルの選択が外れた時に呼び出されるメソッド
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
            let cell = tableView.cellForRow(at:indexPath)

            // チェックマークを外す
            cell?.accessoryType = .none
        }
        
    //何セクション表示するのかのメソッド
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }
    
    //何行表示するかのメソッド
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let _ = self.todo else { return 0 }
        return self.todo!.count
    }
    
    //cellを表示するメソッド
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    //cellを作成
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
    //cellを表示させる
        guard let todo = todo else { return cell }
        guard todo.indices.contains(indexPath.row) else {
            return cell
        }
        cell.textLabel?.text = todo[indexPath.row]
        
        return cell
    }
    
    //TableViewを編集するメソッド
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        doDeleting = true
        
        // データの削除
        guard var todo2 = self.todo else {
            doDeleting = false
            return
        }
        
        //配列から削除
        todo2.remove(at: indexPath.row)
        todo?.remove(at: indexPath.row)
        
        //表示から削除
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        //Userdefaultsから削除
        UserDefaults.standard.set(todo, forKey: "todo")
        
        doDeleting = false
    }

    
    
}

extension ToDoListViewController: AddViewControllerDelegate {
    func addViewControllerSaveContent(_: AddViewController) {
        
        //userDefaultsにある値を取得
        let userDefaults = UserDefaults.standard
        let value = userDefaults.stringArray(forKey: "todo")
        
        //userDefaultsで取得した値をtodoに格納
        todo = value
        
    }
    
    
}

