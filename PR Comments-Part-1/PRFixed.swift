import UIKit

class SomeViewController: UIViewController {
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var detailViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var detailView: UIView!
    
    var detailVC: UIViewController?
    var dataArray: [Any] = []
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib(nibName: "someCell", bundle: nil), forCellWithReuseIdentifier: "someCell")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .plain, target: self, action: #selector(dismissController))
        fetchData()
    }
    
    @objc func dismissController() {
        // Implement your dismiss logic here
    }
    
    func isIPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    func fetchData() {
        let urlString = "testreq"
        NetworkManager.shared.fetchData(from: urlString) { [weak self] (json, error) in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }

            if let json = json {
                
                self?.dataArray = json
                // Reload the collectionView on the main thread
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
    }

    
    @IBAction func closeShowDetails() {
        detailViewWidthConstraint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        } completion: { (completed) in
            self.detailVC?.removeFromParent()
        }
    }
    
    @IBAction func showDetail() {
        detailViewWidthConstraint.constant = 100
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        } completion: { (completed) in
            self.view.addSubview(self.detailView)
        }
    }
}

extension SomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showDetail()
    }
}

extension SomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var widthMultiplier: CGFloat = 0.2929
        if isIPhone() {
            widthMultiplier = 0.9
        }
        return CGSize(width: view.frame.width * widthMultiplier, height: 150.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let frameWidth = (view.frame.width * 0.2929 * 3) + 84
        var minSpacing: CGFloat = (view.frame.width - frameWidth) / 2
        if isIPhone() {
            minSpacing = 24
        }
        return minSpacing
    }
}

extension SomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Implement your cell creation logic here
        return UICollectionViewCell()
    }
}

class NetworkManager {
    static let shared = NetworkManager() // Singleton instance

    private init() {} // Make the initializer private to prevent multiple instances

    func fetchData(from urlString: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(nil, error) // Handle network error
                    return
                }

                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            completion(json, nil)  data
                        } else {
                            completion(nil, NSError(domain: "InvalidJSON", code: 0, userInfo: nil))
                        }
                    } catch {
                        completion(nil, error) // JSON deserialization error
                    }
                }
            }
            task.resume()
        }
    }
}
