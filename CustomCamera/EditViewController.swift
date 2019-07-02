import UIKit

class EditViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var editView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var itemNum: Int?
    
    var ciContext: CIContext?
    
    // 元の画像
    var image: UIImage?
    // 元の画像の向き（画像処理後に適用する）
    var orientaion: UIImage.Orientation?
    
    // サムネイル写真のファイル名とタイトル
    struct Item {
        var title: String
        var image: UIImage
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 元の画像の向きを保存
        orientaion = image?.imageOrientation
        
        ciContext = CIContext(options: nil)
        
        // 編集画面にキャプチャ画像を設定
        editView.image = image
        
        // サムネイル画像のリスト
        let itemList = createList()
        itemNum = itemList.count
        
        // コンテンツビューを追加
        let subView = createContentsView(itemList: itemList)
        scrollView.addSubview(subView)
        
        // スクロールビューの設定
        scrollView.delegate = self
        scrollView.isPagingEnabled  = true
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        scrollView.contentSize = subView.frame.size
    }
    
    func createContentsView(itemList: Array<Item>) -> UIView {
        // コンテンツビュー
        let contentView = UIView()
        
        // 写真の幅と高さ
        let imageSize = CGSize(width: 100, height: 100)
        
        // 1ページあたりの幅と高さ
        let pageWidth = imageSize.width + 10
        let pageHeight = imageSize.height
        let pageViewRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        // コンテンツビューの位置とサイズ
        contentView.frame = CGRect(x: 0, y: 0, width: pageWidth * CGFloat(itemNum!), height: pageHeight)
        
        for i in 0..<itemList.count {
            let item = itemList[i]
            // ページ作成
            let pageView = createPage(viewRect: pageViewRect, imageSize: imageSize, item: item)
            // ページビューのX座標を変更
            let location = CGPoint(x: pageWidth * CGFloat(i), y: 0)
            pageView.frame = CGRect(origin: location, size: pageViewRect.size)
            // ページビューをサブビューに追加
            contentView.addSubview(pageView)
        }
        return contentView
    }
    
    // ページを作成
    func createPage(viewRect: CGRect, imageSize: CGSize, item: Item) -> UIView {
        let pageView = UIView(frame: viewRect)
        
        // UIImageView
        let imageView = UIImageView()
        
        // UIImageViewの設定
        let location = CGPoint(x: (pageView.frame.width - imageSize.width)/2, y: 10)
        imageView.frame = CGRect(origin: location, size: imageSize)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = item.image
        
        // ラベル
        let label = UILabel()
        label.frame = CGRect(x: location.x, y: imageView.frame.maxX + 10, width: imageSize.width, height: 20)
        label.textAlignment = .center
        label.text = item.title
        label.font = UIFont.systemFont(ofSize: 10.0)
        label.textColor = UIColor.darkGray
        
        // imageViewにタップジェスチャーを追加
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapPageView(_:)))
        // imageViewのタップイベントをオンにする
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
        
        // ページビューに追加
        pageView.addSubview(imageView)
        pageView.addSubview(label)
        
        return pageView
    }
    
    // ページビューのタップイベント
    @objc func tapPageView(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as? UIImageView
        editView.image = imageView?.image
        
        self.image = imageView?.image
        print("##tapPageView")
    }
    
    // 画像にフィルタ加工をも施す
    func createList() -> Array<Item> {
        // Item型リスト
        var list = [Item]()
        
        // CIImage
        let original = CIImage(image: image!)
        
        // clampフィルタ
        let clampImage = clampFilter(original!, inputMin: CIVector(x: 0, y: 0, z: 0, w: 0), inputMax: CIVector(x: 1.0, y: 1.0, z: 0.3, w: 0.8))
        let clamp = Item(title: "Clamp", image: clampImage)
        list.append(clamp)
        
        // bloomフィルタ
        let bloomImage = bloomFilter(original!, intensity: 1.9, radius: 10)
        let bloom = Item(title: "Bloom", image: bloomImage)
        list.append(bloom)
        
        // crystalizeフィルタ
        let crystalImage = crystallizeFilter(original!, radius: 100, center: CIVector(x: 150, y: 150))
        let crystal = Item(title: "Crystal", image: crystalImage)
        list.append(crystal)
        
        // gaussianフィルタ
        let gaussianImage = gaussianFilter(original!, radius: 10)
        let gaussian = Item(title: "Gaussian", image: gaussianImage)
        list.append(gaussian)
        
        // originalフィルタ
        let cgOriginal = ciContext?.createCGImage(original!, from: original!.extent)
        let uiOriginal = UIImage(cgImage: cgOriginal!, scale: 0, orientation: orientaion!)
        let ori = Item(title: "Original", image: uiOriginal)
        list.append(ori)
        
        return list
    }
    
    // キャンセルボタン
    @IBAction func cancel(_ sender: Any) {
        // 現在のシーンを閉じカメラ画面へ戻る
        self.dismiss(animated: true, completion: nil)
    }
    
    // 保存ボタン
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        guard let saveImage = editView.image else {
            print("写真の保存失敗")
            self.dismiss(animated: true, completion: nil)
            return
        }
        // 写真をアルバムに保存
        UIImageWriteToSavedPhotosAlbum(self.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        // 保存完了を通知
        /*
        let alert = UIAlertController(title: "保存", message: "写真を保存しました", preferredStyle: UIAlertController.Style.alert)
        self.present(alert, animated: true, completion: nil)
        */
        self.dismiss(animated: true, completion: nil)
    }
    
    // 写真の保存終了後
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        print("didFinishSavingWithError")
        print("\(image)")
        
        guard let error = error else {
            // エラーなし
            return
        }
        print("\(error)")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
