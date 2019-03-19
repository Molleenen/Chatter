//
//  AvatarPickerViewController.swift
//  Chatter
//

import UIKit

class AvatarPickerViewController: UIViewController {

    private var avatarType = AvatarType.dark

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
    }

    private func setupDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    @IBAction func segmentControlChanged(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 0 {
            avatarType = .dark
        } else {
            avatarType = .light
        }
        collectionView.reloadData()
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension AvatarPickerViewController: UICollectionViewDelegate, UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Cell.avatarCell.rawValue,
            for: indexPath) as? AvatarCell
        else {
            return AvatarCell()
        }
        cell.configureCell(index: indexPath.item, type: avatarType)
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        var numbersOfColumns: CGFloat = 3
        if UIScreen.main.bounds.width > 320 {
            numbersOfColumns = 4
        }

        let spaceBetweenCells: CGFloat = 10
        let padding: CGFloat = 40
        let cellDimension =
            ((collectionView.bounds.width - padding) - (numbersOfColumns - 1) * spaceBetweenCells) / numbersOfColumns

        return CGSize(width: cellDimension, height: cellDimension)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if avatarType == .dark {
            UserDataService.instance.setAvatarName(avatarName: "dark\(indexPath.item)")
        } else {
            UserDataService.instance.setAvatarName(avatarName: "light\(indexPath.item)")
        }

        dismiss(animated: true, completion: nil)
    }
}
