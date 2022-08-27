//
//  ViewController.swift
//  ExScale
//
//  Created by 김종권 on 2022/08/27.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
  // MARK: Constants
  private enum Const {
    static let thumbnailSize = CGSize(width: 300, height: 500)
  }
  
  // MARK: UI
  private let thumbnailImageView = UIImageView()
  
  // MARK: Properties
  private let downsamplingImageProcessor = DownsamplingImageProcessor(
    size: Const.thumbnailSize * UIScreen.main.scale
  )
  private var imageURLString: String? {
    didSet {
      guard self.imageURLString != oldValue else { return }
      self.thumbnailImageView.kf.cancelDownloadTask()
      self.thumbnailImageView.kf.setImage(
        with: self.imageURLString?.percentEncodedUrl,
        placeholder: nil,
        options: [
          .processor(self.downsamplingImageProcessor),
          .progressiveJPEG(.init(isBlur: false, isFastestScan: true, scanInterval: 0.1))
        ]
      )
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.addSubview(self.thumbnailImageView)
    self.thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.thumbnailImageView.heightAnchor.constraint(equalToConstant: Const.thumbnailSize.height),
      self.thumbnailImageView.widthAnchor.constraint(equalToConstant: Const.thumbnailSize.width),
      self.thumbnailImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
      self.thumbnailImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
    ])
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.imageURLString = "https://images.dog.ceo/breeds/dhole/n02115913_4128.jpg"
  }
}

internal extension CGSize {
  static func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
    CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
  }
}

extension String {
  /// 일반적인 인코딩을 시도할 때 내부적으로 지정된 Set을 참고하여 인코딩하지만, Set에 없는 문자 (한글, 띄어쓰기)와 같은 것들을 %인코딩된 문자로 인코딩 시도
  var percentEncodedUrl: URL? {
    self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
      .flatMap(URL.init(string:))
  }
}
