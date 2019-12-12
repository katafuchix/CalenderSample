//
//  ViewController.swift
//  CalenderSample
//
//  Created by cano on 2019/12/10.
//  Copyright © 2019 deskplate. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var prevButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!

    //MARK: Properties
    var numberOfWeeks: Int = 0
    var daysArray: [String]!

    private let date            = CalenderDate()
    private let daysPerWeek     = 7
    private var thisYear: Int   = 0
    private var thisMonth: Int  = 0
    private var today: Int      = 0
    private var isToday         = true
    private let dayOfWeekLabel  = ["日", "月", "火", "水", "木", "金", "土"]
    private var monthCounter    = 0

    let util = CalenderUtil()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.bind()

        configure()
    }

    func configure() {
        self.getToday()
        self.numberOfWeeks = util.numberOfWeeks(year: thisYear, month: thisMonth)
        self.daysArray     = util.dateManager(year: thisYear, month: thisMonth)
        self.setTitle()
    }

    func getToday() {
        thisYear    = date.year
        thisMonth   = date.month
        today       = date.day
    }

    func bind() {
        self.prevButton.rx.tap.asDriver().drive(onNext: { [unowned self] _ in
            self.monthCounter -= 1
            self.commonSettingMoveMonth()
        }).disposed(by: rx.disposeBag)

        self.nextButton.rx.tap.asDriver().drive(onNext: { [unowned self] _ in
            self.monthCounter += 1
            self.commonSettingMoveMonth()
        }).disposed(by: rx.disposeBag)
    }

    private func commonSettingMoveMonth() {
        daysArray = nil
        let moveDate = CalenderDate(monthCounter)

        thisYear = moveDate.year
        thisMonth = moveDate.month
        self.numberOfWeeks = util.numberOfWeeks(year: thisYear, month: thisMonth)
        self.daysArray     = util.dateManager(year: thisYear, month: thisMonth)
        isToday = thisYear == moveDate.year && thisMonth == moveDate.month ? true : false
        self.setTitle()
        collectionView.reloadData()
    }

    func setTitle() {
        self.title = "\(String(thisYear))年\(String(thisMonth))月"
    }
}

//MARK:- UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 7 : (numberOfWeeks * daysPerWeek)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let label = cell.contentView.viewWithTag(1) as! UILabel
        label.backgroundColor = .clear
        dayOfWeekColor(label, indexPath.row, daysPerWeek)
        showDate(indexPath.section, indexPath.row, cell, label)
        return cell
    }

    private func dayOfWeekColor(_ label: UILabel, _ row: Int, _ daysPerWeek: Int) {
        switch row % daysPerWeek {
        case 0: label.textColor = .red
        case 6: label.textColor = .blue
        default: label.textColor = .black
        }
    }

    private func showDate(_ section: Int, _ row: Int, _ cell: UICollectionViewCell, _ label: UILabel) {
        switch section {
        case 0:
            label.text = dayOfWeekLabel[row]
            cell.selectedBackgroundView = nil
        default:
            label.text = daysArray[row]
            let selectedView = UIView()
            //selectedView.backgroundColor = .mercury()
            cell.selectedBackgroundView = selectedView
            markToday(label)
        }
    }

    private func markToday(_ label: UILabel) {
        if isToday, today.description == label.text {
            //label.backgroundColor = .myLightRed()
        }
    }

}

//MARK:- UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let weekWidth = Int(collectionView.frame.width) / daysPerWeek
        let weekHeight = weekWidth
        let dayWidth = weekWidth
        let dayHeight = (Int(collectionView.frame.height) - weekHeight) / numberOfWeeks
        return indexPath.section == 0 ? CGSize(width: weekWidth, height: weekHeight) : CGSize(width: dayWidth, height: dayHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let surplus = Int(collectionView.frame.width) % daysPerWeek
        let margin = CGFloat(surplus)/2.0
        return UIEdgeInsets(top: 0.0, left: margin, bottom: 1.5, right: margin)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}

