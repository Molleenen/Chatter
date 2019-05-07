//
//  AvatarPickerViewController.swift
//  Chatter
//

// 3. UISegmentControll valueChanged handler?
// 4. Collection view reloadData() in UISegmentControll valueChanged handler or not?

import UIKit

class AvatarPickerViewController: UIViewController {
    
    private let viewModel: AvatarPickerViewModel
    private let rootView: AvatarPickerRootView

    init(viewModel: AvatarPickerViewModel, rootView: AvatarPickerRootView) {
        self.viewModel = viewModel
        self.rootView = rootView
        super.init(nibName: nil, bundle: nil)
        self.rootView.delegate = self
        self.rootView.dataSource = self
        self.viewModel.dismissHandler = dismissView
        self.rootView.dismissHandler = dismissView
        self.rootView.avatarTypeChangeHandler = avatarTypeChanged(to:)
    }

    @available(*, unavailable, message: "Use init(viewModel:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = rootView
    }

    private func dismissView() {
        dismiss(animated: true, completion: nil)
    }

    private func avatarTypeChanged(to type: AvatarType) {
        viewModel.avatarType = type
        rootView.reloadData()
    }
}

extension AvatarPickerViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel.getNumberOfItems()
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "avatarCell",
            for: indexPath) as? AvatarPickerCell
            else { return AvatarPickerCell() }
        cell.configureCell(index: indexPath.item, type: viewModel.avatarType)
        return cell
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if viewModel.avatarType == .dark {
            viewModel.userSelectedAvatar(avatarName: "dark\(indexPath.item)")
        } else {
            viewModel.userSelectedAvatar(avatarName: "light\(indexPath.item)")
        }
    }
}

extension AvatarPickerViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(
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
}
