import UIKit
import Photos
import PhotosUI
// TODO: Refactor this
class AssetDetailViewController: UIViewController {
    var asset: PHAsset!
    var completion: ((PHAsset) -> Void)?
    weak var coordinator: Coordinator!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var livePhotoView: LivePhotoView!
    
    private var videoView: StatusVideoView = StatusVideoView()
    private var isPlayingHint = false
        
//    private let playVideoButton = YerrButton()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSelf()
        PHPhotoLibrary.shared().register(self)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
//    override func viewWillLayoutSubviews() {
//    }
//
    @IBAction func addButtonClick(_ sender: UIBarButtonItem) {
        completion?(asset)
        coordinator.pop()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if asset.mediaType == .video {
             play()
        } else {
            view.layoutIfNeeded()
            updateImage()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
   
    /// - Tag: PlayVideo
    @IBAction func play() {
        videoView.isHidden = false
        videoView.play()
    }

    // MARK: Image display
    
    var targetSize: CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: imageView.bounds.width * scale, height: imageView.bounds.height * scale)
    }
    
    func updateImage() {
        if asset.mediaSubtypes.contains(.photoLive) {
            updateLivePhoto()
        } else  {
            updateStaticImage()
        }
    }
    
    func updateLivePhoto() {
        // Prepare the options to pass when fetching the live photo.
        let options = PHLivePhotoRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.progressHandler = { progress, _, _, _ in
            // The handler may originate on a background queue, so
            // re-dispatch to the main queue for UI work.
            DispatchQueue.main.sync {
//                self.progressView.progress = Float(progress)
            }
        }
        
        // Request the live photo for the asset from the default PHImageManager.
        PHImageManager.default().requestLivePhoto(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options,
                                                  resultHandler: { livePhoto, info in
                                                    // PhotoKit finishes the request, so hide the progress view.
//                                                    self.progressView.isHidden = true
                                                    
                                                    // Show the Live Photo view.
                                                    guard let livePhoto = livePhoto else { return }
                                                    
                                                    // Show the Live Photo.
                                                    self.videoView.isHidden = true
                                                    self.imageView.isHidden = true
                                                    self.livePhotoView.isHidden = false
                                                    self.livePhotoView.livePhoto = livePhoto
                                                                                                        
                                                    if !self.isPlayingHint {
                                                        // Play back a short section of the Live Photo, similar to the Photos share sheet.
                                                        self.isPlayingHint = true
                                                        self.livePhotoView.startPlayback(with: .hint)
                                                    }
        })
    }
    
    func updateStaticImage() {
        // Prepare the options to pass when fetching the (photo, or video preview) image.
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.progressHandler = { progress, _, _, _ in
            // The handler may originate on a background queue, so
            // re-dispatch to the main queue for UI work.
            DispatchQueue.main.sync {
//                self.progressView.progress = Float(progress)
            }
        }
        
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options,
                                              resultHandler: { image, _ in
                                                // PhotoKit finished the request, so hide the progress view.
//                                                self.progressView.isHidden = true
                                                
                                                // If the request succeeded, show the image view.
                                                guard let image = image else { return }
                                                
                                                // Show the image.
                                                self.videoView.isHidden = true
                                                self.livePhotoView.isHidden = true
                                                self.imageView.isHidden = false
                                                self.imageView.image = image
//                                                self.view.backgroundColor = image.avarageColor
        })
    }
}

// MARK: PHPhotoLibraryChangeObserver
extension AssetDetailViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        // The call might come on any background queue. Re-dispatch to the main queue to handle it.
        DispatchQueue.main.sync {
            // Check if there are changes to the displayed asset.
            guard let details = changeInstance.changeDetails(for: asset) else { return }
            
            // Get the updated asset.
            asset = details.objectAfterChanges
            
            // If the asset's content changes, update the image and stop any video playback.
            if details.assetContentChanged {
                updateImage()
                videoView.pause() // Do we wanna pause
            }
        }
    }
}

// MARK - View helper functions
private extension AssetDetailViewController {
    
    private func configureSelf() {
        videoView.autoresizingOff()
        videoView.delegate = self
        videoView.hideLabel()
        view.addSubview(videoView)
        videoView --> view
        if asset.mediaType == .video {
            videoView.setPHAsset(asset: asset)
            videoView.isUserInteractionEnabled = true
        }
        view.backgroundColor = Const.Color.roundViewsBackground
        self.videoView.isHidden = true
        self.imageView.isHidden = true
        self.livePhotoView.isHidden = true
    }
    
  
//    private func configurePlayVideoButton() {
//        playVideoButton.autoresizingOff()
//        view.addSubview(playVideoButton)
//        let image = Const.Assets.TrimVideo.playVideoIcon?.withRenderingMode(.alwaysTemplate)
//        playVideoButton.setImage(fillBoundsWith: image)
//        playVideoButton.tintColor = Const.Color.TrimVideo.playVideo
//        playVideoButton.widthAnchor --> 80
//        playVideoButton.heightAnchor --> 80
//        playVideoButton.centerYAnchor --> view.centerYAnchor + -22
//        playVideoButton.centerXAnchor --> view.centerXAnchor
//        playVideoButton.addTarget(self, action: #selector(play), for: .touchUpInside)
//        playVideoButton.backgroundColor = .red
//    }
}

extension AssetDetailViewController: StatusVideoViewDelegate {
    func didFinishPlayingVideo() {
        
    }
    
    func didStartPlayingVideo() {
        
    }
    
    func currentlyPlaying(seconds: Double) {
        
    }
}

