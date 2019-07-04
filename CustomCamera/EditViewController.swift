import UIKit

class EditViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var editView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // 編集モード
    var editMode = EditMode.filter
    
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
        let filterItemList = createFilterList()
        filterItemNum = filterItemList.count
        // コンテンツビューを追加（フィルタ）
        let subViewFilter = createContentsView(itemList: filterItemList)
        scrollView.addSubview(subViewFilter)
        
        // エディタのリスト
        let editerItemList = createEditerList()
        // コンテンツビューを追加（エディタ）
        let subViewEditer = createContentsView(itemList: editerItemList)
        scrollView.addSubview(subViewEditer)
        
        // スクロールビューの設定
        scrollView.delegate = self
        scrollView.isPagingEnabled  = true
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        scrollView.contentSize = subViewFilter.frame.size
        
        // 最初はフィルタのリストを表示しておく
        self.scrollView.subviews[0].isHidden = false
        self.scrollView.subviews[1].isHidden = true
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
        contentView.frame = CGRect(x: 0, y: 0, width: pageWidth * CGFloat(filterItemNum!), height: pageHeight)
        
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
        let viewController = UIViewController()
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.view.backgroundColor = UIColor.blue
        viewController.view.alpha = 0.5
        viewController.view.frame = CGRect(x: 0, y: self.view.frame.height - 200, width: self.view.frame.width, height: 200)
        
        // キャンセルボタン追加
        let cancel = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        cancel.setTitle("cancel", for: .normal)
        cancel.titleLabel?.textColor = UIColor.white
        cancel.center = viewController.view.center
        cancel.addTarget(self, action: #selector(cancelSlider(_:)), for: .touchUpInside)
        viewController.view.addSubview(cancel)
        present(viewController, animated: true, completion: nil)
    }
    
    // スライダーのキャンセルボタン
    @objc func cancelSlider(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
    
    // フィルタを表示するボタン
    @IBAction func showFiltersButton(_ sender: UIButton) {
        editMode = .filter
        // フィルタのリストを表示する
        self.scrollView.subviews[0].isHidden = false
        self.scrollView.subviews[1].isHidden = true
    }
    
    // 編集を表示するボタン
    @IBAction func showEditerButton(_ sender: Any) {
        editMode = .editer
        // エディタのリストを表示する
        self.scrollView.subviews[0].isHidden = true
        self.scrollView.subviews[1].isHidden = false
    }
    
    // 編集モード
    enum EditMode {
        case filter
        case editer
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
