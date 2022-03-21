//
//  ViewController.swift
//  HomeWork
//
//  Created by Mint on 2022/3/18.
//

import UIKit

class ViewController: UIViewController {
    
    var filtereds:[FilteredModel] = []
    let tableView = UITableView()
    let activityIndicatorView = UIActivityIndicatorView()
    var page = 1
    var isReload = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTableView()
        self.setActivityIndicatorView()
        
    }
    
    func setTableView() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.black
        self.tableView.separatorStyle = .none
        
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor)
        let bottomConstraint = self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        let leftConstraint = self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        let rightConstraint = self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        let tableViewConstraint = [topConstraint,bottomConstraint,leftConstraint,rightConstraint]
        NSLayoutConstraint.activate(tableViewConstraint)
        
        // 註冊 tableViewCell
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.register(ADImageTableViewCell.self, forCellReuseIdentifier: ADImageTableViewCell.identifier)
        
    }
    
    func setActivityIndicatorView() {
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.style = .large
        activityIndicatorView.backgroundColor = UIColor.gray
        activityIndicatorView.layer.cornerRadius = 10
        self.view.addSubview(activityIndicatorView)
        let widthactivityIndicatorViewConstraint = NSLayoutConstraint(item: activityIndicatorView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 70 / 375 * UIScreen.main.bounds.width)
        let heightactivityIndicatorViewConstraint = NSLayoutConstraint(item: activityIndicatorView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 70 / 375 * UIScreen.main.bounds.width)
        let centerXactivityIndicatorViewConstraint = NSLayoutConstraint(item: activityIndicatorView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
        let centerYactivityIndicatorViewConstraint = NSLayoutConstraint(item: activityIndicatorView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        self.view.addConstraint(widthactivityIndicatorViewConstraint)
        self.view.addConstraint(heightactivityIndicatorViewConstraint)
        self.view.addConstraint(centerXactivityIndicatorViewConstraint)
        self.view.addConstraint(centerYactivityIndicatorViewConstraint)
    }

}

extension ViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.height
        let contentOffsetY = scrollView.contentOffset.y
        let bottomOffsetY = scrollView.contentSize.height - contentOffsetY
        if bottomOffsetY <= height && self.isReload {
            self.isReload = false
            self.getData(page: self.page, limit: 20) { newsModel in
                self.page += 1
                guard let model = newsModel else { return }
                self.filtereds += (model.data?.filtered)!
                self.isReload = true
                DispatchQueue.main.sync {
                    self.tableView.reloadData()
                }
            }
        }
    }
    // 取得API資訊 帶入要取得的頁數，與一次要拿幾筆
    func getData(page:Int, limit:Int, completion:@escaping ((NewsModel?) -> ())) {
        
        guard var urlComponents = URLComponents(string: "https://fintech.eastasia.cloudapp.azure.com/api/news") else {  return }
        let pageItem = URLQueryItem(name: "page", value: "\(page)")
        let limitItem = URLQueryItem(name: "limit", value: "\(limit)")
        urlComponents.queryItems = [pageItem, limitItem]
        let session = URLSession.shared
        guard let url = urlComponents.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MDFiYTVhODg1MGViMzRjNTg2ODg5Y2MiLCJtb2RlbCI6IkFwcERldmljZSIsImlhdCI6MTYxMjQyNTM0NywiZXhwIjoxNjI3OTc3MzQ3fQ.8ATkhNKUP_vCSCplIyfQV6Udd6kXE6mPXeudVIZUsXs", forHTTPHeaderField: "Authorization")
        self.activityIndicatorView.startAnimating()
        let rask = session.dataTask(with: request) { data, response, error in
            guard let newsData = data else { return }
            do {
                DispatchQueue.main.sync {
                    self.activityIndicatorView.stopAnimating()
                }
                let model = try JSONDecoder().decode(NewsModel.self, from: newsData)
                completion(model)
            } catch {
                print(error)
            }
            
        }
        rask.resume()
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filtereds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath)
                as? TableViewCell, let adImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: ADImageTableViewCell.identifier, for: indexPath)
                as? ADImageTableViewCell else { return UITableViewCell() }
        // 判斷有沒有需要顯示圖片，使用不同的cell來做顯示
        if let urlString = self.filtereds[indexPath.row].thumbs?[0].url, let _ = URL(string: urlString) {
            adImageTableViewCell.setCell(filteredModel: self.filtereds[indexPath.row])
            return adImageTableViewCell
        } else {
            cell.setCell(filteredModel: self.filtereds[indexPath.row])
            return cell
        }
    }
    
}
