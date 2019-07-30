import UIKit

extension EditViewController {
    
    // 編集リストを作成
    func createEditerList() -> Array<Item> {
        var list = [Item]()
        
        // 明るさ
        let brightnessIcon = UIImage(named: "brightness")
        let brightness = Item(name: "Brightness", image: brightnessIcon!, listType: .editer, sliderValue: 0.0, preSliderValue: 0.0)
        list.append(brightness)
        
        // コントラスト
        let contrastIcon = UIImage(named: "contrast")
        let contrast = Item(name: "Contrast", image: contrastIcon!, listType: .editer, sliderValue: 1.0, preSliderValue: 1.0)
        list.append(contrast)
        
        // 彩度
        let saturationIcon = UIImage(named: "saturation")
        let saturation = Item(name: "Saturation", image: saturationIcon!, listType: .editer, sliderValue: 1.0, preSliderValue: 1.0)
        list.append(saturation)
        
        // 回転
        let rotationIcon = UIImage(named: "rotation")
        let rotation = Item(name: "Rotation", image: rotationIcon!, listType: .editer, sliderValue: nil, preSliderValue: nil)
        list.append(rotation)
        
        return list
    }
    
}
