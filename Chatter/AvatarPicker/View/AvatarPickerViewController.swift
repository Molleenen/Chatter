//
//  AvatarPickerViewController.swift
//  Chatter
//

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
        self.viewModel.dismissViewHandler = dismissView
        self.rootView.dismissViewHandler = dismissView
        self.rootView.avatarTypeChangeHandler = avatarTypeChanged(to:)
    }

    @available(*, unavailable, message: "Use init(viewModel: rootView:) instead")
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
            withReuseIdentifier: String(describing: AvatarPickerCell.self),
            for: indexPath) as? AvatarPickerCell
        else { return AvatarPickerCell() }
        cell.configureCell(index: indexPath.item, avatarType: viewModel.avatarType)
        return cell
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        switch viewModel.avatarType {
        case .dark:
            viewModel.userSelectedAvatar(avatarName: "dark\(indexPath.item)")
        case .light:
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

        var numbersOfColumns: CGFloat = 4
        if Int(UIScreen.main.bounds.width) < 375 {
            numbersOfColumns = 3
        }

        let spaceBetweenCells: CGFloat = 10
        let padding: CGFloat = 40
        let cellDimension =
            ((collectionView.bounds.width - padding) - (numbersOfColumns - 1) * spaceBetweenCells) / numbersOfColumns

        return CGSize(width: cellDimension, height: cellDimension)
    }
}
