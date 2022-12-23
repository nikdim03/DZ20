//
//  ViewController.swift
//  DZ20
//
//  Created by Dmitriy on 11/20/22.
//

import UIKit

//view controller
//protocol
//ref to presenter

protocol CatListView {
    var presenter: CatsListPresenter? { get set }
    func update(with cats: [Cat])
    func update(with error: String)
    func handleButtonTap()
}

class CatViewController: UIViewController, CatListView {
    @IBOutlet weak var collectionView: UICollectionView!
    var presenter: CatsListPresenter?
    var cats = [Cat]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CatsApp"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Present", style: .plain, target: self, action: #selector(handleButtonTap))
        let flowLayout = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        flowLayout.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(flowLayout)
        NSLayoutConstraint.activate([
            flowLayout.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            flowLayout.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            flowLayout.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            flowLayout.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
        self.collectionView = flowLayout
    }
    func update(with cats: [Cat]) {
        DispatchQueue.main.async {
            self.cats = cats
            self.collectionView.register(for: CatCell.self)
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
            
            self.collectionView.dragInteractionEnabled = true
            self.collectionView.reorderingCadence = .fast
            self.collectionView.dropDelegate = self
            self.collectionView.dragDelegate = self
            self.collectionView.reloadData()
        }
    }
    func update(with error: String) {
        super.title = error
    }
    @objc func handleButtonTap() {
        presenter?.handleButtonTap()
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CatViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(for: CatCell.self, for: indexPath)
        cell.update(with: cats[indexPath.item])
        return cell
    }
}

//MARK: - UICollectionViewDragDelegate
extension CatViewController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let itemProvider = NSItemProvider(object: "\(indexPath)" as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        let itemProvider = NSItemProvider(object: "\(indexPath)" as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]
    }
    
}

//MARK: - UICollectionViewDropDelegate
extension CatViewController: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag, destinationIndexPath != nil {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        else {
            return UICollectionViewDropProposal(operation: .forbidden)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        switch coordinator.proposal.operation {
        case .move:
            reorderItems(coordinator: coordinator, destinationIndexPath:destinationIndexPath, collectionView: collectionView)
        default:
            break
        }
    }
    
    func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        let items = coordinator.items
        if items.count == 1, let item = items.first,
           let sourceIndexPath = item.sourceIndexPath {
            collectionView.performBatchUpdates ({
                let source = cats[sourceIndexPath.item]
                cats.remove(at: sourceIndexPath.item)
                cats.insert(source, at: destinationIndexPath.item)
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            })
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension CatViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 2
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
        + flowLayout.sectionInset.right
        + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: size, height: size)
    }
}


class CatCell: UICollectionViewCell {
    @IBOutlet weak var catImage: UIImageView!
    @IBOutlet weak var catLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.borderWidth = 3
        self.contentView.layer.borderColor = UIColor.purple.cgColor
    }
    
    func update(with cat: Cat){
        self.catLabel.text = cat.name
        self.catImage.image = UIImage(named: cat.imageName)
    }
}
