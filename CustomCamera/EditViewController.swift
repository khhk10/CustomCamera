import UIKit

class EditViewController: UIViewController, UIScrollViewDelegate {
    
    // プレビュー画面
    @IBOutlet weak var editView: UIImageView!
<<<<<<< HEAD
    // （フィルター or 編集の）リストを表示するビュー
    @IBOutlet weak var scrollView: UIScrollView!
    // ボタンやスライダーを表示するビュー
    @IBOutlet weak var componentView: UIView!
    
    // 表示するリスト（フィルターリスト or 編集リスト）
    var listMode = ListMode.filter
    // スライダーで変更されるパラーメータ（brightness / contrast / saturation）
    var changedParameter = ParameterChangedBySlider.brightness
    
    var filterItemList: [Item] = []
    var editerItemList: [Item] = []
=======
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var componentView: UIView!
    
    // 編集モード
    var editMode = EditMode.filter
    
>>>>>>> origin/master
    var filterItemNum: Int?
    var editerItemNum: Int?
    
    var ciContext: CIContext?
    
    // 元の画像
    var image: UIImage?
    // 元の画像の向き（画像処理後に適用する）
    var orientaion: UIImage.Orientation?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 元の画像の向きを保存
        orientaion = image?.imageOrientation
        
        ciContext = CIContext(options: nil)
        
        // 編集画面にキャプチャ画像を設定
        editView.image = image
        
        // フィルターのリスト
<<<<<<< HEAD
        filterItemList = createFilterList()
        filterItemNum = filterItemList.count
        // コンテンツビューを追加（フィルタ）
        let subViewFilter = createContentsView(itemList: filterItemList, imageSize: CGSize(width: 100, height: 100), itemNum: filterItemNum!)
        scrollView.addSubview(subViewFilter)
        
        // エディタのリスト
        editerItemList = createEditerList()
        editerItemNum = editerItemList.count
        // コンテンツビューを追加（エディタ）
        let subViewEditer = createContentsView(itemList: editerItemList, imageSize: CGSize(width: 70, height: 70), itemNum: editerItemNum!)
=======
        let filterItemList = createFilterList()
        filterItemNum = filterItemList.count
        // コンテンツビューを追加（フィルタ）
        let subViewFilter = createContentsView(itemList: filterItemList)
        scrollView.addSubview(subViewFilter)
        
        // エディタのリスト
        let editerItemList = createEditerList()
        // コンテンツビューを追加（エディタ）
        let subViewEditer = createContentsView(itemList: editerItemList)
>>>>>>> origin/master
        scrollView.addSubview(subViewEditer)
        
        // スクロールビューの設定
        scrollView.delegate = self
        scrollView.isPagingEnabled  = true
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        scrollView.contentSize = subViewFilter.frame.size
        
        // 最初はフィルタのリストを表示しておく
        self.scrollView.subviews[0].isHidden = false
        self.scrollView.subviews[1].isHidden = true
        
        // ボタンを表示するビュー
        let buttonView = UIView()
        buttonView.frame = CGRect(x: 0, y: 0, width: componentView.frame.width, height: componentView.frame.height)
        // let buttonView = UIView(CGRect(origin: componentView.frame.origin, size: componentView.frame.size))
        // buttonView.backgroundColor = UIColor.blue
        
        // フィルタを表示するボタン
        let filterShowButton = UIButton(type: .system)
<<<<<<< HEAD
        filterShowButton.addTarget(self, action: #selector(showFilterList(_:)), for: .touchUpInside)
=======
        filterShowButton.addTarget(self, action: #selector(showFilters(_:)), for: .touchUpInside)
>>>>>>> origin/master
        filterShowButton.setTitle("フィルタ", for: .normal)
        filterShowButton.setTitleColor(.black, for: .normal)
        filterShowButton.frame = CGRect(x: buttonView.bounds.origin.x + 50, y: buttonView.bounds.origin.y + 30, width: 62, height: 30)
        buttonView.addSubview(filterShowButton)
        
        // エディタを表示するボタン
        let editerShowButton = UIButton(type: .system)
<<<<<<< HEAD
        editerShowButton.addTarget(self, action: #selector(showEditerList(_:)), for: .touchUpInside)
=======
        editerShowButton.addTarget(self, action: #selector(showEditers(_:)), for: .touchUpInside)
>>>>>>> origin/master
        editerShowButton.setTitle("編集", for: .normal)
        editerShowButton.setTitleColor(.lightGray, for: .normal)
        let size = CGSize(width: 31, height: 30)
        editerShowButton.frame = CGRect(x: buttonView.bounds.maxX - size.width - 100, y: buttonView.bounds.origin.y + 30, width: size.width, height: size.height)
        buttonView.addSubview(editerShowButton)
        
        // スライダー表示するビュー
        let sliderView = UIView()
        sliderView.frame = CGRect(x: 0, y: 0, width: componentView.frame.width, height: componentView.frame.height)
        // スライダー
        let slider = UISlider()
        slider.frame.size = CGSize(width: 300, height: 30)
        slider.center = sliderView.center
<<<<<<< HEAD
        slider.minimumValue = -0.5
        slider.maximumValue = 0.5
        slider.value = 0.0
        slider.addTarget(self, action: #selector(changeSlider(_:)), for: .valueChanged)
        sliderView.addSubview(slider)
        // OKボタン
        let ok = UIButton(frame: CGRect(x: sliderView.frame.width - 50, y: 20, width: 30, height: 30))
        ok.contentMode = .scaleAspectFit
        ok.setImage(UIImage(named: "checkmark"), for: .normal)
=======
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.value = 0.5
        sliderView.addSubview(slider)
        // キャンセルボタン
        let ok = UIButton(frame: CGRect(x: 0, y: 20, width: 100, height: 20))
        ok.setTitle("ok", for: .normal)
        // cancel.titleLabel?.textColor = .black
        ok.setTitleColor(.black, for: .normal)
>>>>>>> origin/master
        ok.addTarget(self, action: #selector(okSlider(_:)), for: .touchUpInside)
        sliderView.addSubview(ok)
        
        // ボタンを表示するビューを追加
        componentView.addSubview(buttonView)
        componentView.addSubview(sliderView)
        componentView.subviews[1].isHidden = true
        
        print("ボタンの座標 : \(filterShowButton.frame)")
        print("ボタンビューの座標 : \(buttonView.frame)")
    }
    
    func createContentsView(itemList: Array<Item>, imageSize: CGSize, itemNum: Int) -> UIView {
        // コンテンツビュー
        let contentView = UIView()
        
        // 写真の幅と高さ
        // let imageSize = CGSize(width: 100, height: 100)
        
        // 1ページあたりの幅と高さ
        let pageWidth = imageSize.width + 10
        let pageHeight = imageSize.height
        let pageViewRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        // コンテンツビューの位置とサイズ
<<<<<<< HEAD
        contentView.frame = CGRect(x: 0, y: 0, width: pageWidth * CGFloat(itemNum), height: pageHeight)
        
        print("アイテムの数：\(itemNum)" )
        print("コンテンツのサイズ：\(contentView.frame)")
=======
        contentView.frame = CGRect(x: 0, y: 0, width: pageWidth * CGFloat(filterItemNum!), height: pageHeight)
>>>>>>> origin/master
        
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
        imageView.accessibilityIdentifier = item.name
        
        // ラベル
        let label = UILabel()
        label.frame = CGRect(x: location.x, y: imageView.frame.maxX + 10, width: imageSize.width, height: 20)
        label.textAlignment = .center
        label.text = item.name
        label.font = UIFont.systemFont(ofSize: 10.0)
        label.textColor = UIColor.darkGray
        
        // タップイベント
        switch item.listType {
        case .filter:
            // ジェスチャを追加
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapPageView(_:)))
            // タップイベントをオンにする
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tapGesture)
        case .editer:
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showSlider(_:)))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tapGesture)
        }
        
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
    
    // スライダーを表示する
    @objc func showSlider(_ sender: UITapGestureRecognizer) {
<<<<<<< HEAD
        let sliderView = componentView.subviews[1] as! UIView
        let slider = sliderView.subviews[0] as! UISlider
        
        let imageView = sender.view as! UIImageView
        switch imageView.accessibilityIdentifier {
        case "Brightness":
            // 保存したスライダーの値の読み出し
            slider.minimumValue = -0.4
            slider.maximumValue = 0.4
            slider.value = editerItemList[0].sliderValue!
            print("item name : \(editerItemList[0].name), \(slider.value)")
            changedParameter = .brightness
        case "Contrast":
            slider.minimumValue = 0.0
            slider.maximumValue = 2.0
            slider.value = editerItemList[1].sliderValue!
            print("item name : \(editerItemList[1].name), \(slider.value)")
            changedParameter = .contrast
        case "Saturation":
            slider.minimumValue = 0.0
            slider.maximumValue = 2.0
            slider.value = editerItemList[2].sliderValue!
            print("item name : \(editerItemList[2].name), \(slider.value)")
            changedParameter = .saturation
        default:
            return
        }
        
        // ボタンを隠し、スライダーを表示する
        componentView.subviews[0].isHidden = true
        sliderView.isHidden = false
        
        print("clicked element : \(imageView.accessibilityIdentifier)")
        
=======
        componentView.subviews[0].isHidden = true
        componentView.subviews[1].isHidden = false
>>>>>>> origin/master
        /*
        let viewController = UIViewController()
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.view.backgroundColor = UIColor.blue
        viewController.view.alpha = 0.5
        viewController.view.frame = CGRect(x: 0, y: self.view.frame.height - self.view.frame.height/2, width: self.view.frame.width, height: 200)
        // キャンセルボタン追加
        let cancel = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        cancel.setTitle("cancel", for: .normal)
        cancel.titleLabel?.textColor = UIColor.white
        cancel.center = viewController.view.center
        cancel.addTarget(self, action: #selector(cancelSlider(_:)), for: .touchUpInside)
        sliderView.addSubview(cancel)
        present(viewController, animated: true, completion: nil)
         */
    }
    
    // スライダーのキャンセルボタン
    @objc func okSlider(_ sender: UIButton) {
<<<<<<< HEAD
        // 元の画像に結果を反映
        // self.image = editView.image
        
=======
>>>>>>> origin/master
        // dismiss(animated: true, completion: nil)
        componentView.subviews[0].isHidden = false
        componentView.subviews[1].isHidden = true
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
        UIImageWriteToSavedPhotosAlbum(editView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
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
    
    // フィルタを表示するボタン
<<<<<<< HEAD
    @objc func showFilterList(_ sender: UIButton) {
        listMode = .filter
=======
    @objc func showFilters(_ sender: UIButton) {
        editMode = .filter
>>>>>>> origin/master
        // フィルタのリストを表示する
        self.scrollView.subviews[0].isHidden = false
        self.scrollView.subviews[1].isHidden = true
        // ボタンの色を変更する
        let filterButton = componentView.subviews[0].subviews[0] as! UIButton
        let editerButton = componentView.subviews[0].subviews[1] as! UIButton
<<<<<<< HEAD
        filterButton.setTitleColor(.black, for: .normal )
        editerButton.setTitleColor(.lightGray, for: .normal)
    }
    
    // 編集を表示するボタン
    @objc func showEditerList(_ sender: UIButton) {
        listMode = .editer
=======
        filterButton.setTitleColor(.lightGray, for: .normal )
        editerButton.setTitleColor(.black, for: .normal)
    }
    
    // 編集を表示するボタン
    @objc func showEditers(_ sender: UIButton) {
        editMode = .editer
>>>>>>> origin/master
        // エディタのリストを表示する
        self.scrollView.subviews[0].isHidden = true
        self.scrollView.subviews[1].isHidden = false
        // ボタンの色を変更する
        let filterButton = componentView.subviews[0].subviews[0] as! UIButton
        let editerButton = componentView.subviews[0].subviews[1] as! UIButton
<<<<<<< HEAD
        filterButton.setTitleColor(.lightGray, for: .normal)
        editerButton.setTitleColor(.black, for: .normal)
    }
    
    // リストの表示モード
    enum ListMode {
        case filter // フィルターリストを表示
        case editer // 編集リストを表示
    }
    
    // スライダーで変更されるパラメータ
    enum ParameterChangedBySlider {
        case brightness
        case contrast
        case saturation
    }
    
    // スライダー操作
    @objc func changeSlider(_ sender: UISlider) {
        DispatchQueue.main.async {
            let origiImage = CIImage(image: self.image!)
            
            var ciImage = CIImage()
            
            // CIImage取得、スライダーの値を保存
            switch self.changedParameter {
            case .brightness:
                ciImage = origiImage!.applyingFilter("CIColorControls", parameters: [kCIInputBrightnessKey : Double(sender.value)])
                self.editerItemList[0].sliderValue = sender.value
            case .contrast:
                ciImage = origiImage!.applyingFilter("CIColorControls", parameters: [kCIInputContrastKey : Double(sender.value)])
                self.editerItemList[1].sliderValue = sender.value
            case .saturation:
                ciImage = origiImage!.applyingFilter("CIColorControls", parameters: [kCIInputSaturationKey : Double(sender.value)])
                self.editerItemList[2].sliderValue = sender.value
            }
            
            // CGImage取得
            guard let cgImage = self.ciContext?.createCGImage(ciImage, from: ciImage.extent) else {
                return
            }
            self.editView.image = UIImage(cgImage: cgImage, scale: 0, orientation: self.orientaion!)
            print("Slider value : \(Double(sender.value))")
        }
=======
        filterButton.setTitleColor(.black, for: .normal)
        editerButton.setTitleColor(.lightGray, for: .normal)
    }
    
    // 編集モード
    enum EditMode {
        case filter
        case editer
>>>>>>> origin/master
    }
    
    // 画面遷移
    /*
    func goToContainerView(_ editMode: EditMode) {
        var identifier = "filter"
        switch editMode {
        case .filter:
            identifier = "filter"
        case .editer:
            identifier = "editer"
        }
        
        guard let containerViewController = self.storyboard?.instantiateViewController(withIdentifier: identifier) as? ContainerViewController else {
            return
        }
        present(containerViewController, animated: true, completion: nil)
    }
   */
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
