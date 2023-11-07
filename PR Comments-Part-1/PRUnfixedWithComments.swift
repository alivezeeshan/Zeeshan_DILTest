import UIKit
func isIPhone() -> Bool {
return UIDevice.current.userInterfaceIdiom == .phone
} // Add the function in the class
class someVC:
UIViewController,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {

@IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
@IBOutlet var detailViewWidthConstraint: NSLayoutConstraint!
@IBOutlet var collectionView: UICollectionView!
@IBOutlet var detailView: UIView!

var detailVC : UIViewController?
var dataArray : [Any]? //[[String:Any]] can be used

override func viewWillAppear(_ animated: Bool) {
fetchData() // add fetch data function call after confirming of data source andd delegate
self.collectionView.dataSource = s elf
self.collectionView.delegate = s elf
self.collectionView.register(UINib(nibName: "someCell",

bundle: nil), forCellWithReuseIdentifier: "someCell")

self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title:NSLocalizedString("Done", comment:
""), style: .plain, target: s elf, action: #s elec tor(dissmissController))
}
@objc func dissmissController () {}

func fetchData() {
let url = URL(string: “testreq")!
              // if let can be used
let task = URLSession.shared.dataTask(with: url) { [self](data, response, error) in
    // Attempt to deserialize the JSON data into an array of dictionaries
    //do try catch can be used in deserializing the data
    //model can be used to save the data array
self.dataArray = data as ? [Any]
self.collectionView.reloadData()
}
task.resume()
}

@IBAction func closeshowDetails () {

self.detailViewWidthConstraint.constant = 0
UIView.animate(withDuration: 0.5, animations:
{
self.view.layoutIfNeeded()
})
{ (completed) in
self.detailVC?.removeFromParent()
}
}
@IBAction func showDetail () {
self.detailViewWidthConstraint.constant = 100
UIView.animate(withDuration: 0.5, animations:
{
self.view.layoutIfNeeded()
})
{ (completed) in
self.view.addSubview(self.detailView)
}
}
              //add extension for collection view ->
open func collectionView(_ collectionView: UICollectionView,
layout collectionViewLayout: UICollectionViewLayout,
sizeForItemAt indexPath: IndexPath) -> CGSize {
var widthMultiplier: CGFloat = 0.2929
if isIPhone() {
widthMultiplier = 0.9
}
return CGSize(width: view.frame.width * widthMultiplier ,
height: 150.0)
}
func collectionView(_ collectionView: UICollectionView, layout
collectionViewLayout: UICollectionViewLayout,

minimumLineSpacingForSectionAt section: Int) -> CGFloat {

let frameWidth = (view.frame.width * 0.2929 * 3) + 84
var minSpacing: CGFloat = (view.frame.width - frameWidth)/2
if isIPhone() {
minSpacing = 24
}
return minSpacing
}
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
return self.dataArray?.count ?? 0
}
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
UICollectionViewCell {
return UICollectionViewCell()
}
func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
self.showDetail()
}
}


//A network manager can be added to call the api- like this
    
    import Foundation

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
                                completion(json, nil) // Successfully retrieved JSON data
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
