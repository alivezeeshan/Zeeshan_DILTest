//
//  ViewController.swift
//  DrawingAppDiligent
//
//  Created by Zeeshan on 04/11/23.
//

import UIKit

class ArtViewController: UIViewController {

    var colorsArray: [UIColor] = [#colorLiteral(red: 1, green: 0.2993683021, blue: 0.2822492289, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)]
   
    @IBOutlet weak var artView: ArtView!
   
    @IBOutlet weak var collectionView: UICollectionView!
   
    override func viewWillAppear(_ animated: Bool) {
     
        collectionView.reloadData()
        artView.strokeColor = .red
    }
    
    @IBAction func undo(_ sender: Any) {
        artView.undo()
    }
    
    @IBAction func erase(_ sender: Any) {
        artView.clear()
    }
}

extension ArtViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let view = cell.viewWithTag(100) {
            view.layer.cornerRadius = 5
            view.backgroundColor = colorsArray[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let color = colorsArray[indexPath.row]
        artView.strokeColor = color
    }
}



