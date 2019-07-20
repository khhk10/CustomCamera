import UIKit

// フィルタ / エディタ
struct Item {
    let name: String
    let image: UIImage
    let listType: ListType
    var sliderValue: Float?
    
    enum ListType {
        case filter
        case editer
    }
}
