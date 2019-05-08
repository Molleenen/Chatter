//
//  AvatarPickerRootView.swift
//  Chatter
//

import Foundation

public class AvatarPickerRootView: UIView {

    typealias AvatarPickerDismissViewHandler = () -> Void
    typealias AvatarTypeChangeHandler = (AvatarType) -> Void

    var delegate: UICollectionViewDelegate? {
        set {
            collectionView.delegate = newValue
        }
        get {
            return nil
        }
    }
    var dataSource: UICollectionViewDataSource? {
        set {
            collectionView.dataSource = newValue
        }
        get {
            return nil
        }
    }

    var dismissViewHandler: AvatarPickerDismissViewHandler?
    var avatarTypeChangeHandler: AvatarTypeChangeHandler?

    private let backButton: UIButton = {
        let backButton = UIButton(type: .custom)
        backButton.setImage(#imageLiteral(resourceName: "smackBack"), for: .normal)
        return backButton
    }()

    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [AvatarType.dark.rawValue, AvatarType.light.rawValue])
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.register(
            AvatarPickerCell.self,
            forCellWithReuseIdentifier: String(describing: AvatarPickerCell.self))
        return collectionView
    }()

    init() {
        super.init(frame: .zero)
        backButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        segmentedControl.addTarget(self, action: #selector(avatarTypeChanged), for: .valueChanged)
    }

    @available(*, unavailable, message: "Use init() instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func didMoveToWindow() {
        backgroundColor = .white
        constructHierarchy()
        activateConstraints()
    }

    func reloadData() {
        collectionView.reloadData()
    }

    @objc private func dismissView() {
        dismissViewHandler?()
    }

    @objc private func avatarTypeChanged(_ selector: UISegmentedControl) {
        switch selector.selectedSegmentIndex {
        case 0:
            avatarTypeChangeHandler?(.dark)
        case 1:
            avatarTypeChangeHandler?(.light)
        default:
            avatarTypeChangeHandler?(.dark)
        }
    }

    private func constructHierarchy() {
        addSubview(backButton)
        addSubview(segmentedControl)
        addSubview(collectionView)
    }

    private func activateConstraints() {
        activateConstraintsBackButton()
        activateConstraintsSegmentedControl()
        activateConstraintsCollectionView()
    }

    private func activateConstraintsBackButton() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        let width = backButton.widthAnchor.constraint(equalToConstant: 30)
        let height = backButton.heightAnchor.constraint(equalToConstant: 30)
        let top = backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8)
        let leading = backButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16)
        NSLayoutConstraint.activate([width, height, top, leading])
    }

    private func activateConstraintsSegmentedControl() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        let width = segmentedControl.widthAnchor.constraint(equalToConstant: 150)
        let height = segmentedControl.heightAnchor.constraint(equalToConstant: 30)
        let top = segmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8)
        let centerX = segmentedControl.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        NSLayoutConstraint.activate([width, height, top, centerX])
    }

    private func activateConstraintsCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let top = collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20)
        let bottom = collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        let leading = collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        let trailing = collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        NSLayoutConstraint.activate([top, bottom, leading, trailing])
    }
}
