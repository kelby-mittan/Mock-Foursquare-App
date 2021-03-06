//
//  CreateCollectionController.swift
//  Mock-Foursquare-App
//
//  Created by Kelby Mittan on 2/24/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit
import DataPersistence
import AVFoundation

protocol AddToCollection: AnyObject {
    func updateCollectionView(userCollection: UserCollection)
}

class CreateCollectionController: UIViewController {
    
    @IBOutlet var collectionNameTextField: UITextField!
    @IBOutlet var selectedImageView: UIImageView!
    @IBOutlet var alphaView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var libraryButton: UIButton!
    @IBOutlet var changePhotoLabel: UILabel!
    
    public var venuePersistence: DataPersistence<Venue>
    public var collectionPersistence: DataPersistence<UserCollection>
    
    private let imagePickerController = UIImagePickerController()
    
    public var selectedImage: UIImage?
    private var collectionName = ""
    public var venue: Venue?
    public var venueDetail: VenueDetail?
    
    weak var collectionDelegate: AddToCollection?
    
    private lazy var createButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(createButtonPressed(_:)))
        return button
    }()
    
    init?(coder: NSCoder, venuePersistence: DataPersistence<Venue>, collectionPersistence: DataPersistence<UserCollection>) {
        self.venuePersistence = venuePersistence
        self.collectionPersistence = collectionPersistence
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setRightBarButton(createButton, animated: true)
        collectionNameTextField.delegate = self
        setupUI()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        collectionNameTextField.text = "    " + collectionName
//    }
    
    private func setupUI() {
        collectionNameTextField.layer.borderWidth = 4
        collectionNameTextField.layer.borderColor = UIColor.darkGray.cgColor
        collectionNameTextField.layer.cornerRadius = 5
        view.backgroundColor = .systemBackground
        alphaView.isHidden = true
        alphaView.clipsToBounds = true
        selectedImageView.clipsToBounds = true
        alphaView.layer.cornerRadius = 15
        selectedImageView.layer.cornerRadius = 15
        titleLabel.isHidden = true
        
        if selectedImage != nil {
            selectedImageView.image = selectedImage
        }
    }
    
    @objc private func createButtonPressed(_ sender: UIBarButtonItem) {
        collectionName = collectionNameTextField.text ?? ""
        titleLabel.text = collectionName
        
        if collectionName == "" {
            showAlert(title: "Yo....", message: "Please Enter a Name for Collection")
            return
        }
        guard let image = selectedImage else {
            showAlert(title: "Yo....", message: "Please Select a Picture for Collection")
            return
        }
        let size = UIScreen.main.bounds.size
        let rect = AVMakeRect(aspectRatio: image.size, insideRect: CGRect(origin: CGPoint.zero, size: size))
        let resizeImage = image.resizeImage(to: rect.size.width, height: rect.size.height)
        
        guard let resizedImageData = resizeImage.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        let userCollection = UserCollection(collectionName: collectionName, pickedImage: resizedImageData)
        if venue != nil && venueDetail != nil {
            let savedVenue = Venue(id: venue?.id ?? "", name: venue?.name ?? "", location: (venue?.location ?? nil)!, customCategory: collectionName, venuePhoto: resizedImageData, description: venueDetail?.response.venue.description ?? "", venueDetail: venueDetail)
            do {
                try venuePersistence.createItem(savedVenue)
            } catch {
                print("could not create item")
            }
        }
        
        collectionDelegate?.updateCollectionView(userCollection: userCollection)
        animatePhoto()
        
    }
    
    private func animatePhoto() {
        UIView.animate(withDuration: 0.75, delay: 0.0, options: [], animations: {
            self.selectedImageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            self.alphaView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            self.titleLabel.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            
        }) { (done) in
            UIView.animate(withDuration: 0.75, animations: {
                self.selectedImageView.transform = CGAffineTransform(translationX: 120, y: 600)
                self.alphaView.transform = CGAffineTransform(translationX: 120, y: 600)
                self.titleLabel.transform = CGAffineTransform(translationX: 120, y: 600)
                
            }) {(done) in
                let collectionsVC = UserCollectionsController(self.venuePersistence, collectionPersistence: self.collectionPersistence)
                self.navigationController?.pushViewController(collectionsVC, animated: true)
            }
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func pickPhotoButton(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            imagePickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            
            imagePickerController.sourceType = .photoLibrary
            
            self.present(imagePickerController, animated: true)//, animated: true, completion: nil)
        }
        
    }
    
    
}

extension CreateCollectionController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.text != "" && selectedImage != nil {
            createButton.isEnabled = true
        }
        collectionName = textField.text ?? "no photo description"
        titleLabel.text = collectionName
        return true
    }
    
}

extension CreateCollectionController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("image selected not found")
            return
        }
        selectedImage = image
        selectedImageView.image = image
        selectedImageView.alpha = 0.45
        alphaView.isHidden = false
        titleLabel.isHidden = false
        libraryButton.isHidden = true
        changePhotoLabel.isHidden = true
        
        dismiss(animated: true)
    }
}


extension UIImage {
    func resizeImage(to width: CGFloat, height: CGFloat) -> UIImage {
        let size = CGSize(width: width, height: height)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

extension UIViewController {
    func showAlert(title: String, message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: completion)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
