import UIKit

extension EditViewController {
    
    // 編集リストを作成
    func createEditerList() -> Array<Item> {
        var list = [Item]()
        
        // 明るさ
        let brightnessIcon = UIImage(named: "brightness")
        let brightness = Item(title: "Brightness", image: brightnessIcon!, listType: .editer)
        list.append(brightness)
        
        // コントラスト
        let contrastIcon = UIImage(named: "contrast")
        let contrast = Item(title: "Contrast", image: contrastIcon!, listType: .editer)
        list.append(contrast)
        
        // 彩度
        let saturationIcon = UIImage(named: "saturation")
        let saturation = Item(title: "Saturation", image: saturationIcon!, listType: .editer)
        list.append(saturation)
        
        list.append(saturation)
        list.append(saturation)
        
        return list
    }
    
}
