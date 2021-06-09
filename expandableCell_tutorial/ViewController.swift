//
//  ViewController.swift
//  expandableCell_tutorial
//
//  Created by wooyeong kam on 2021/06/09.
//

import UIKit
import ExpyTableView

class ViewController: UIViewController, ExpyTableViewDelegate, ExpyTableViewDataSource, MyCellDelegate {
    
    

    let contentArray = [
        ["섹션1 - 1", "섹션1 -2"],
        ["섹션2 - 1", "섹션2 -2", "섹션2-3"],
        ["섹션3 - 1", "섹션3 -2"],
        ["섹션4 - 1", "섹션4 -2", "섹션3-3"],
        ["섹션5 - 1", "섹션5 -2"]
    ]

    @IBOutlet weak var myExpandableTableView: ExpyTableView!
    
    
    
    // MARK: - delegate methods
    // 열리고 닫히고 상태가 변경될 떼
    func tableView(_ tableView: ExpyTableView, expyState state: ExpyState, changeForSection section: Int) {
        switch state {
        case .willExpand:
            print("펼쳐질 것이다")
        case .willCollapse:
            print("닫힐 것이다")
        case .didExpand:
            print("펼쳐짐")
        case .didCollapse :
            print("닫힘")
        }
    }
    
    
    // MARK: - datasource methods
    // 펼침이 가능한지 설정
    func tableView(_ tableView: ExpyTableView, canExpandSection section: Int) -> Bool {
        return true
    }
    
    // 펼칠 섹션, 헤더 셀 설정
    func tableView(_ tableView: ExpyTableView, expandableCellForSection section: Int) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyHeaderCell") as! MyHeaderCell
        cell.titleLabel.text = "섹션 \(section + 1)"
        
        let bgView = UIView()
        bgView.backgroundColor = .white
        cell.selectedBackgroundView = bgView
        
        // 스위치 버튼을 클릭 했을 때 딜리게이트 연결
        cell.sectionIndex = section
        cell.delegate = self
        
        return cell
    }
    
    // 각 섹션의 줄 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray[section].count + 1
    }
    
    // 각 펼쳐진 셀 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyDetailCell") as! MyDetailCell
        cell.titleLabel.text = contentArray[indexPath.section][indexPath.row - 1]
        return cell
    }
    
    // 섹션의 개수 설정
    func numberOfSections(in tableView: UITableView) -> Int {
        return contentArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func didSwitchBtnClicked(cell: MyHeaderCell) {
        switch cell.mySwitch.isOn {
        case true:
            myExpandableTableView.expand(cell.sectionIndex)
        case false:
            myExpandableTableView.collapse(cell.sectionIndex)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myExpandableTableView.delegate = self
        myExpandableTableView.dataSource = self
    }
    
}

class MyHeaderCell : UITableViewCell, ExpyTableViewHeaderCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mySwitch: UISwitch!
    @IBOutlet weak var arrowImg: UIImageView!
    
    var sectionIndex : Int = 0
    
    weak var delegate : MyCellDelegate?
    
    @IBAction func onSwitchValueChanged(_ sender: UISwitch) {
        // delegate를 통해 스위치의 값이 변경 된 것을 알린다. 헤더 셀 -> 테이블 뷰
        delegate?.didSwitchBtnClicked(cell: self)
    }
    
    
    // 셀 상태를 알 수 있다.
    func changeState(_ state: ExpyState, cellReuseStatus cellReuse: Bool) {
        print("\(state)")
        switch state {
        case .willExpand:
            self.mySwitch.setOn(true, animated: !cellReuse)
            self.arrowDown(animated: !cellReuse)
        case .willCollapse:
            self.mySwitch.setOn(false, animated: !cellReuse)
            self.arrowRight(animated:!cellReuse)
        default :
            print("dk ahffkd")
        }
    }
    
    fileprivate func arrowDown(animated : Bool){
        UIView.animate(withDuration: (animated ? 0.3 : 0), animations: {
            self.arrowImg.transform = CGAffineTransform(rotationAngle: (CGFloat.pi / 2))
        })
    }
    
    fileprivate func arrowRight(animated : Bool){
        UIView.animate(withDuration: (animated ? 0.3 : 0), animations: {
            self.arrowImg.transform = CGAffineTransform(rotationAngle: 0)
        })
    }
}


class MyDetailCell : UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
}

protocol MyCellDelegate : AnyObject {
    func didSwitchBtnClicked(cell : MyHeaderCell)
}
