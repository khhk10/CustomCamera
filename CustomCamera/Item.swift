import UIKit

// フィルタ / エディタ
struct Item {
    let title: String
    let image: UIImage
    let listType: ListType
    
    enum ListType {
        case filter
        case editer
    }
}
