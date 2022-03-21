//
//  KeywordViews.swift
//  HomeWork
//
//  Created by Mint on 2022/3/18.
//

import UIKit

class KeywordViews: UIView {
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setKeywork(keywords:[String]) {
        var keywordViews:[UIView] = []
        // 單個keyword先刻好
        keywords.forEach { keyword in
            let keywordView = UIView()
            let keywordLabel = UILabel()
            keywordLabel.textColor = UIColor(hex: "AEB0B3")
            keywordLabel.font = UIFont.systemFont(ofSize: 12)
            keywordView.translatesAutoresizingMaskIntoConstraints = false
            keywordLabel.translatesAutoresizingMaskIntoConstraints = false
            keywordView.addSubview(keywordLabel)
            self.addSubview(keywordView)
            keywordLabel.text = keyword
            keywordView.layer.cornerRadius = 8
            keywordView.layer.borderWidth = 1
            keywordView.layer.borderColor = UIColor(hex: "686B70").cgColor
            let topKeywordLabelConstraint = NSLayoutConstraint(item: keywordLabel, attribute: .top, relatedBy: .equal, toItem: keywordView, attribute: .top, multiplier: 1, constant: 8)
            let bottomKeywordLabelConstraint = NSLayoutConstraint(item: keywordLabel, attribute: .bottom, relatedBy: .equal, toItem: keywordView, attribute: .bottom, multiplier: 1, constant: -8)
            let leftKeywordLabelConstraint = NSLayoutConstraint(item: keywordLabel, attribute: .left, relatedBy: .equal, toItem: keywordView, attribute: .left, multiplier: 1, constant: 8)
            let rightKeywordLabelConstraint = NSLayoutConstraint(item: keywordLabel, attribute: .right, relatedBy: .equal, toItem: keywordView, attribute: .right, multiplier: 1, constant: -8)
            self.addConstraint(topKeywordLabelConstraint)
            self.addConstraint(bottomKeywordLabelConstraint)
            self.addConstraint(leftKeywordLabelConstraint)
            self.addConstraint(rightKeywordLabelConstraint)
            keywordViews.append(keywordView)
        }
        
        let returnKeywordView = UIView()
        returnKeywordView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(returnKeywordView)
        for i in 0..<keywordViews.count {
                let topReturnKeywordViewConstraint = NSLayoutConstraint(item: keywordViews[i], attribute: .top, relatedBy: .equal, toItem: returnKeywordView, attribute: .top, multiplier: 1, constant: 0)
                var leftReturnKeywordViewConstraint = NSLayoutConstraint(item: keywordViews[i], attribute: .left, relatedBy: .equal, toItem: returnKeywordView, attribute: .left, multiplier: 1, constant: 0)
                // 如果不是第一筆左邊要有margin
                if keywordViews[i] != keywordViews.first {
                    leftReturnKeywordViewConstraint = NSLayoutConstraint(item: keywordViews[i], attribute: .left, relatedBy: .equal, toItem: keywordViews[i-1], attribute: .right, multiplier: 1, constant: 10 / 375 * UIScreen.main.bounds.width)
                    
                }
                if keywordViews[i] == keywordViews.last {
                    // 如果是最後一筆 要加bottom
                    let bottomReturnKeywordViewConstraint = NSLayoutConstraint(item: keywordViews[i], attribute: .bottom, relatedBy: .equal, toItem: returnKeywordView, attribute: .bottom, multiplier: 1, constant: 0)
                    self.addConstraint(bottomReturnKeywordViewConstraint)
                    
                }
                self.addConstraint(topReturnKeywordViewConstraint)
                self.addConstraint(leftReturnKeywordViewConstraint)
            
        }
        let topReturnKeywordViewConstraint = NSLayoutConstraint(item: returnKeywordView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottomReturnKeywordViewConstraint = NSLayoutConstraint(item: returnKeywordView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let leftReturnKeywordViewConstraint = NSLayoutConstraint(item: returnKeywordView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let rightReturnKeywordViewConstraint = NSLayoutConstraint(item: returnKeywordView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        self.addConstraint(topReturnKeywordViewConstraint)
        self.addConstraint(bottomReturnKeywordViewConstraint)
        self.addConstraint(leftReturnKeywordViewConstraint)
        self.addConstraint(rightReturnKeywordViewConstraint)
    }
    
}
