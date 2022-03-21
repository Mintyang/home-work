//
//  NewsModel.swift
//  HomeWork
//
//  Created by Mint on 2022/3/18.
//

import Foundation
import UIKit

struct NewsModel: Decodable {
    /// 判斷是否有錯誤
    var err: Bool?
    
    var data: DataModel?
    
    enum CodingKeys: String, CodingKey {
        case err = "err"
        case data = "data"
      
    }
    
    init(from dictionary: [String: Any]) throws {
        do {
            self = try JSONDecoder().decode(NewsModel.self, from: JSONSerialization.data(withJSONObject: dictionary))
        } catch let error as NSError {
            throw error
        }
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.err = try values.decodeIfPresent(Bool?.self, forKey: .err) ?? false
        self.data = try values.decodeIfPresent(DataModel?.self, forKey: .data) ?? nil
        
        
    }
    
    
}

struct DataModel: Decodable {
    
    /// 總筆數
    var total: Int?
    
    /// 分頁索引
    var page: Int?
    
    var filtered: [FilteredModel]?
    
    
    
    enum CodingKeys: String, CodingKey {
        case total = "total"
        case page = "page"
        case filtered = "filtered"
        
      
    }
    
    init(from dictionary: [String: Any]) throws {
        do {
            self = try JSONDecoder().decode(DataModel.self, from: JSONSerialization.data(withJSONObject: dictionary))
        } catch let error as NSError {
            throw error
        }
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.total = try values.decodeIfPresent(Int?.self, forKey: .total) ?? nil
        self.page = try values.decodeIfPresent(Int?.self, forKey: .page) ?? nil
        self.filtered = try values.decodeIfPresent([FilteredModel]?.self, forKey: .filtered) ?? nil
        
        
    }
    
    
}


struct FilteredModel: Decodable {
    
    /// 標題
    var title: String?
    
    /// 關鍵字
    var keywords: [String]?
    
    var thumbs: [ThumbsModel]?
    
    /// 發佈日期
    var pubDate: String?
    
    
    
    enum CodingKeys: String, CodingKey {

        case title = "title"
        case keywords = "keywords"
        case thumbs = "thumbs"
        case pubDate = "pubDate"
      
    }
    
    init(from dictionary: [String: Any]) throws {
        do {
            self = try JSONDecoder().decode(FilteredModel.self, from: JSONSerialization.data(withJSONObject: dictionary))
        } catch let error as NSError {
            throw error
        }
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try values.decodeIfPresent(String?.self, forKey: .title) ?? ""
        self.keywords = try values.decodeIfPresent([String]?.self, forKey: .keywords) ?? []
        self.thumbs = try values.decodeIfPresent([ThumbsModel]?.self, forKey: .thumbs) ?? nil
        self.pubDate = try values.decodeIfPresent(String?.self, forKey: .pubDate) ?? ""
        
    }
    
    
}

struct ThumbsModel: Decodable {
    
    /// 圖片連結
    var url: String?
    
    /// 圖片
    var adImage: UIImage?
    
    enum CodingKeys: String, CodingKey {

        case url = "url"
      
    }
    
    init(from dictionary: [String: Any]) throws {
        do {
            self = try JSONDecoder().decode(ThumbsModel.self, from: JSONSerialization.data(withJSONObject: dictionary))
        } catch let error as NSError {
            throw error
        }
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try values.decodeIfPresent(String?.self, forKey: .url) ?? ""
    }

}
