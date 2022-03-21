//
//  ADImageTableViewCell.swift
//  HomeWork
//
//  Created by Mint on 2022/3/21.
//

import UIKit

class ADImageTableViewCell: UITableViewCell {
    
    let pubDateLabel = UILabel()
    let titleLabel = UILabel()
    let adImageView = UIImageView()
    let stackView = UIStackView()
    
    static let identifier = "ADImageTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.addView()
        self.setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setCell(filteredModel:FilteredModel) {
        
        self.adImageView.image = nil
        self.adImageView.clipsToBounds = true
        self.adImageView.layer.cornerRadius = 5
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = dateFormatter.date(from: filteredModel.pubDate ?? "")
        self.pubDateLabel.textColor = UIColor(hex: "74757A")
        self.pubDateLabel.font = UIFont.systemFont(ofSize: 12)
        self.pubDateLabel.text = dateFormatter.string(from: date ?? Date())
        self.titleLabel.textColor = UIColor(hex: "CDCED2")
        self.titleLabel.text = filteredModel.title
        self.titleLabel.font = UIFont.systemFont(ofSize: 20)
        
        // 計算 titleLable 在螢幕上是多寬 才能計算keywords的寬度
        let titleLabelWidth: CGFloat = UIScreen.main.bounds.width - (3 * (20 / 375 * UIScreen.main.bounds.width) + 70 / 375 * UIScreen.main.bounds.width)
        // 清除所有的arrangedSubviews，才能在增加新的
        self.stackView.arrangedSubviews.forEach { subview in
            self.stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        self.stackView.addArrangedSubview(self.pubDateLabel)
        self.stackView.addArrangedSubview(self.titleLabel)
        // keywords UI設定
        guard let keywords = filteredModel.keywords else { return }
        var keywordsWidth:CGFloat = 0
        var setKeyWords:[String] = []
        for i in 0..<keywords.count {
            keywordsWidth += (self.getWidth(withLabelText: keywords[i], height: 15, font: UIFont.systemFont(ofSize: 12)) + 16 + (10 / 375 * UIScreen.main.bounds.width))
            if keywordsWidth > titleLabelWidth {
                let keyworkViews = KeywordViews()
                keyworkViews.setKeywork(keywords: setKeyWords)
                self.stackView.addArrangedSubview(keyworkViews)
                setKeyWords = []
                keywordsWidth = 0
                setKeyWords.append(keywords[i])
                keywordsWidth += (self.getWidth(withLabelText: keywords[i], height: 15, font: UIFont.systemFont(ofSize: 12)) + 16 + (10 / 375 * UIScreen.main.bounds.width))
                if keywords[i] == keywords.last {
                    let keyworkViews = KeywordViews()
                    keyworkViews.setKeywork(keywords: setKeyWords)
                    self.stackView.addArrangedSubview(keyworkViews)
                    setKeyWords = []
                    keywordsWidth = 0
                }
            } else {
                setKeyWords.append(keywords[i])
                if keywords[i] == keywords.last {
                    let keyworkViews = KeywordViews()
                    keyworkViews.setKeywork(keywords: setKeyWords)
                    self.stackView.addArrangedSubview(keyworkViews)
                    setKeyWords = []
                    keywordsWidth = 0
                }
            }
        }
        
        guard let urlString = filteredModel.thumbs?[0].url, let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, eror) in
            if let data = data, let downloadImage = UIImage(data: data) {
                DispatchQueue.main.sync {
                    self.adImageView.image = downloadImage
                }
            }
            
        }.resume()
    }
    
    // 增加UI元件到view
    func addView() {
        self.addSubview(self.adImageView)
        self.addSubview(self.stackView)
        self.backgroundColor = UIColor.black
        self.titleLabel.numberOfLines = 0
        self.stackView.axis = .vertical
        self.stackView.spacing = 5 / 812 * UIScreen.main.bounds.height
        self.stackView.addArrangedSubview(self.pubDateLabel)
        self.stackView.addArrangedSubview(self.titleLabel)
    }
    
    // 設定autoLayout
    func setConstraint() {
        self.adImageView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let topStackViewConstraint = NSLayoutConstraint(item: self.stackView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 20 / 812 * UIScreen.main.bounds.height)
        let bottomStackViewConstraint = NSLayoutConstraint(item: self.stackView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -(20 / 812 * UIScreen.main.bounds.height))
        let leftStackViewConstraint = NSLayoutConstraint(item: self.stackView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 20 / 375 * UIScreen.main.bounds.width)
        let rightAdImageViewConstraint = NSLayoutConstraint(item: self.adImageView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -(20 / 375 * UIScreen.main.bounds.width))
        let rightStackViewConstraint = NSLayoutConstraint(item: self.stackView, attribute: .right, relatedBy: .equal, toItem: self.adImageView, attribute: .left, multiplier: 1, constant: -(20 / 812 * UIScreen.main.bounds.height))
        let heightAdImageViewConstraint = NSLayoutConstraint(item: self.adImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 70 / 375 * UIScreen.main.bounds.width)
        let widthAdImageViewConstraint = NSLayoutConstraint(item: self.adImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 70 / 375 * UIScreen.main.bounds.width)
        let centerXAdImageViewConstraint = NSLayoutConstraint(item: self.adImageView, attribute: .centerY, relatedBy: .equal, toItem: self.stackView, attribute: .centerY, multiplier: 1, constant: 0)
        
        self.addConstraint(topStackViewConstraint)
        self.addConstraint(bottomStackViewConstraint)
        self.addConstraint(leftStackViewConstraint)
        self.addConstraint(rightAdImageViewConstraint)
        self.addConstraint(widthAdImageViewConstraint)
        self.addConstraint(heightAdImageViewConstraint)
        self.addConstraint(centerXAdImageViewConstraint)
        self.addConstraint(rightStackViewConstraint)
        
    }
    
    // 取得label寬度
    func getWidth(withLabelText text: String, height: CGFloat, font: UIFont) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat(MAXFLOAT), height: height))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.width
    }
    
    
}
