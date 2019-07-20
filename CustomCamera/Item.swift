import UIKit

// フィルタ / エディタ
struct Item {
<<<<<<< HEAD
    let name: String
    let image: UIImage
    let listType: ListType
    var sliderValue: Float?
=======
    let title: String
    let image: UIImage
    let listType: ListType
>>>>>>> origin/master
    
    enum ListType {
        case filter
        case editer
    }
}
