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
    let allAssets = PHAsset.fetchAssets(with: .image, options: nil)

    let sizes: [CGSize] = [
      CGSize(width: 750, height: 750),
      CGSize(width: 960, height: 960)
    ]

    for asset in [allAssets.lastObject!] {
      for targetSize in sizes {
        DispatchQueue.global(qos: .background).async {
          self.requestImage(for: asset, targetSize: targetSize)
        }
        sleep(1)
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
}

