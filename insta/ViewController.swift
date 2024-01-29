//
//  ViewController.swift
//  instagrid 2
//
//  Created by younes ouasmi on 15/12/2023.
//

import UIKit
import Photos
import LinkPresentation



class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var imageGrid = ImageGrid()

    
    
    @IBOutlet weak var addPicture: UIStackView!
    
    @IBOutlet weak var widthConstraintViewD: NSLayoutConstraint!
    @IBOutlet weak var widthConstraintViewC: NSLayoutConstraint!
    

    @IBOutlet weak var widthConstraintViewB: NSLayoutConstraint!
    @IBOutlet weak var widthConstraintViewA: NSLayoutConstraint!
    @IBOutlet weak var ViewA: UIView!
    @IBOutlet weak var ViewB: UIView!

    @IBOutlet weak var PictureContainer: UIStackView!
    @IBOutlet weak var Template1: UIButton!
    @IBOutlet weak var Template2: UIButton!
    @IBOutlet weak var Template3: UIButton!
    
    @IBOutlet weak var ViewD: UIView!
    @IBOutlet weak var ViewC: UIView!
    var selectedImageView: UIImageView?
    var currentSelectedButton: UIButton?

    @IBOutlet weak var imageA: UIImageView!

    @IBOutlet weak var imageB: UIImageView!
    @IBOutlet weak var imageC: UIImageView!
    @IBOutlet weak var imageD: UIImageView!
    
    

    private var selectedImageViews: UIImageView?



    
    @IBAction func selectViewA(_ sender: UITapGestureRecognizer) {
        selectedImageViews = imageA
        checkAndOpenPhotoLibrary()
    }
    @IBAction func selectViewB(_ sender: UITapGestureRecognizer) {
        selectedImageViews = imageB
        checkAndOpenPhotoLibrary()
    }
    
    @IBAction func selectViewC(_ sender: UITapGestureRecognizer) {
        selectedImageViews = imageC
        checkAndOpenPhotoLibrary()
    }
    
    @IBAction func selectViewD(_ sender: UITapGestureRecognizer) {
        selectedImageViews = imageD
        checkAndOpenPhotoLibrary()
    }
    
    // Check and request permission to access photo library
    private func checkAndOpenPhotoLibrary() {
            let authorizationStatus = PHPhotoLibrary.authorizationStatus()
            
            switch authorizationStatus {
            case .authorized:
                openPhotoLibrary()
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { [weak self] newStatus in
                    if newStatus == .authorized {
                        DispatchQueue.main.async {
                            self?.openPhotoLibrary()
                        }
                    }
                }
            case .denied, .restricted:

                break
            case .limited:
                openPhotoLibrary()
            @unknown default:
                break
            }
        }

        private func openPhotoLibrary() {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }
    
    // Delegate method for image picker
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {

            if let selectedTag = selectedImageView?.tag {
                imageGrid.setImage(selectedImage, atIndex: selectedTag)
                updateImageViews()
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Update image views to reflect changes in the model
    func updateImageViews() {

        imageA.image = imageGrid.images[0]
        imageB.image = imageGrid.images[1]
        imageC.image = imageGrid.images[2]
        imageD.image = imageGrid.images[3]

    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
  
        // Assign tags and configure gesture recognizers for image views
            imageA.tag = 0
            imageB.tag = 1
            imageC.tag = 2
            imageD.tag = 3
           configureImageView(imageA)
           configureImageView(imageB)
           configureImageView(imageC)
           configureImageView(imageD)
           applyLayoutForCurrentTemplate()
           defaultTemplateButton()
            let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
            swipeUpGesture.direction = .up
            addPicture.addGestureRecognizer(swipeUpGesture)

            let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
            swipeLeftGesture.direction = .left
            addPicture.addGestureRecognizer(swipeLeftGesture)
        
    }
    private func defaultTemplateButton() {
        // Puisque Template1 est le template par défaut
        if let defaultButton = Template1 {
                // Ajoutez la sous-vue sélectionnée à ce bouton
                let selectedImageView = UIImageView(image: UIImage(named: "Selected"))
                selectedImageView.frame = defaultButton.bounds
                selectedImageView.tag = 100 // Utiliser le même tag que celui utilisé dans templateButtonPressed
                defaultButton.addSubview(selectedImageView)
            }
    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        // Animate and share based on the orientation and swipe direction
        if UIDevice.current.orientation.isPortrait && gesture.direction == .up {
            handleSwipeAnimation(translationX: 0, y: -self.view.bounds.height)
        } else if UIDevice.current.orientation.isLandscape && gesture.direction == .left {
            handleSwipeAnimation(translationX: -self.view.bounds.width, y: 0)
        }
    }

    private func handleSwipeAnimation(translationX x: CGFloat, y: CGFloat) {
        UIView.animate(withDuration: 0.5, animations: {
            self.addPicture.transform = CGAffineTransform(translationX: x, y: y)
        }, completion: { _ in
            self.showActivityViewController()
        })
    }

    func showActivityViewController() {
        guard let imageToShare = imageGrid.convertToImage(addPicture) else { return }

        let metadata = LPLinkMetadata()
        metadata.title = "Share your instagrid"
        metadata.imageProvider = NSItemProvider(object: imageToShare)

        let itemSource = LinkMetadataItemSource(metadata: metadata)
        let activityViewController = UIActivityViewController(activityItems: [imageToShare, itemSource], applicationActivities: nil)

        activityViewController.completionWithItemsHandler = { _, _, _, _ in
            UIView.animate(withDuration: 0.5) {
                self.addPicture.transform = .identity
            }
        }
        // Present the activity view controller
        present(activityViewController, animated: true, completion: nil)
    }
    
    // Configure gesture recognizer for image views
    private func configureImageView(_ imageView: UIImageView) {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    // Handle tap gesture on image views
    @objc func imageViewTapped(_ sender: UITapGestureRecognizer) {
        if let imageView = sender.view as? UIImageView {
            selectedImageView = imageView
            checkAndOpenPhotoLibrary()
        }
    }
    
    
    // Handle template button actions
    @IBAction func templateButtonPressed(_ sender: UIButton) {
        [Template1, Template2, Template3].forEach { button in
                    button.subviews.forEach { subview in
                        if subview.tag == 100 {
                            subview.removeFromSuperview()
                        }
                    }
                }

                let selectedImageView = UIImageView(image: UIImage(named: "Selected"))
                selectedImageView.frame = sender.bounds
                selectedImageView.tag = 100
                sender.addSubview(selectedImageView)
        switch sender {
            case Template1:
                imageGrid.setTemplate(.template1)
            case Template2:
                imageGrid.setTemplate(.template2)
            case Template3:
                imageGrid.setTemplate(.template3)
            default:
                break
            }
            applyLayoutForCurrentTemplate()
    }
    
    // Apply layout based on the current template
    func applyLayoutForCurrentTemplate() {
        let orientation = UIDevice.current.orientation

        let config = imageGrid.getLayoutConfiguration(forOrientation: orientation)

        UIView.animate(withDuration: 0.5, animations: {
            
            // Set constraints based on the layout configuration
                    self.widthConstraintViewA.constant = CGFloat(config.widthConstraintViewA)
                    self.widthConstraintViewB.constant = CGFloat(config.widthConstraintViewB)
                    self.widthConstraintViewC.constant = CGFloat(config.widthConstraintViewC)
                    self.widthConstraintViewD.constant = CGFloat(config.widthConstraintViewD)
                
            self.ViewB.isHidden = config.isViewBHidden
            self.ViewD.isHidden = config.isViewDHidden

            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.resizeImagesForNewLayout()
        })
    }
    
    // Resize images for new layout
    func resizeImagesForNewLayout() {
        [imageA, imageB, imageC, imageD].forEach { imageView in
            if let image = imageView?.image {
                imageView?.image = image
            }
        }
    }
        }
    
   

