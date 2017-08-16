//
//  ViewController.swift
//  RequestImageSize
//
//  Created by Diego Sánchez on 8/14/17.
//  Copyright © 2017 Diego Sánchez. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {

  private var cachingImageManager: PHCachingImageManager!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.cachingImageManager = PHCachingImageManager()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    PHAsset.fetchAssets(with: .image, options: nil) // Trigger photos permissions request
  }

  @IBAction func buttonTapped(_ sender: Any) {
    let queue = DispatchQueue(label: "serial-queue")

    let sizes = (750...960).map { return CGSize(width: CGFloat($0), height: CGFloat($0)) }
    for asset in self.getAllAssets().reversed() {
      for targetSize in sizes {
        queue.async {
          self.requestImage(for: asset, targetSize: targetSize)
        }
      }
    }
  }

  private func requestImage(for asset: PHAsset, targetSize: CGSize) {
    let options = PHImageRequestOptions()
    options.isSynchronous = true
    options.resizeMode = .exact
    options.isNetworkAccessAllowed = true

    self.cachingImageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { (image, info) in
      let image = image!
      print(targetSize, image)
      assert(image.size.width == targetSize.width || image.size.height == targetSize.height)
    }
  }

  private func getAllAssets() -> [PHAsset] {
    var assets: [PHAsset] = []
    PHAsset.fetchAssets(with: .image, options: nil).enumerateObjects { (asset, index, _) in
      assets.append(asset)
    }
    return assets
  }
}

