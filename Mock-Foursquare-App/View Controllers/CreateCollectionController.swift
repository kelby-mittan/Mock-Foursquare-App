//
//  CreateCollectionController.swift
//  Mock-Foursquare-App
//
//  Created by Kelby Mittan on 2/24/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit
import DataPersistence

class CreateCollectionController: UIViewController {

    @IBOutlet var collectionNameTextField: UITextField!
    
    
    public var venuePersistence: DataPersistence<Venue>
    public var collectionPersistence: DataPersistence<UserCollection>
    
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
    }
    
    @objc private func createButtonPressed(_ sender: UIBarButtonItem) {
        print("create button pressed")
    }
    
    @IBAction func pickPhotoButton(_ sender: UIButton) {
        
        
    }
    

}
