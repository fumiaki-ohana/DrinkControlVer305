//
//  CommentViewController.swift
//  lastDrink
//
//  Created by 鶴見文明 on 2019/11/19.
//  Copyright © 2019 Fumiaki Tsurumi. All rights reserved.
//

import Eureka

class CommentViewController: FormViewController {
    var evaluation: String = ""
    var comment:String = ""
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func cancell(_ sender: UIBarButtonItem) {
       self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
            super.viewDidLoad()
        saveButton.isEnabled = false
        
            form +++
                Section(header: "評価", footer: "昨日の飲酒量を振り返り、今の気分を入力してください。")

                <<< SegmentedRow<String>() { row in
                    row.tag = "evaluation"
                    row.value = evaluation
                    row.options = [eval.good.rawValue,
                                   eval.improving.rawValue,
                                   eval.bad.rawValue,
                                   eval.veryBad.rawValue]
                    row.onChange { row in
                        self.saveButton.isEnabled = true
                    }}
     
                +++ Section(header: "コメント", footer: "昨日の結果を振り返り、今日のあなたへのメッセージを書いてください。夕方、読み返してください。")

                <<< TextAreaRow() { row in
                    row.tag = "comment"
                    row.value = comment
                    row.placeholder = "タイプして入力"
                    row.textAreaHeight = .dynamic(initialTextViewHeight: 110)
                    row.onChange { row in
                        self.saveButton.isEnabled = true
                    }
            }
            
            }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let valuesDictionary = form.values()

        self.evaluation = valuesDictionary["evaluation"] as! String
        self.comment = valuesDictionary["comment"] as! String
     
    }
    
    override func inputAccessoryView(for row: BaseRow) -> UIView? {
        return nil
    }
    
}
