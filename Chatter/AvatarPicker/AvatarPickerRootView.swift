//
//  AvatarPickerRootView.swift
//  Chatter
//

import Foundation

public class AvatarPickerRootView: UIView {

    typealias AvatarPickerDismissHandler = () -> Void
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

    var dismissHandler: AvatarPickerDismissHandler?
    var avatarTypeChangeHandler: AvatarTypeChangeHandler?

    private let backButton: UIButton = {
        let backButton = UIButton(type: .custom)
        backButton.setImage(#imageLiteral(resourceName: "smackBack"), for: .normal)
        backButton.heightAnchor
            .constraint(equalToConstant: 30)
            .isActive = true
        backButton.widthAnchor
            .constraint(equalToConstant: 30)
            .isActive = true
        return backButton
    }()

    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Dark", "Light"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.heightAnchor
            .constraint(equalToConstant: 30)
            .isActive = true
        segmentedControl.widthAnchor
            .constraint(equalToConstant: 150)
            .isActive = true
        return segmentedControl
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.register(AvatarPickerCell.self, forCellWithReuseIdentifier: "avatarCell")
        return collectionView
    }()

    init() {
        super.init(frame: .zero)
        backButton.addTarget(nil, action: #selector(dismiss), for: .touchUpInside)
        segmentedControl.addTarget(nil, action: #selector(update), for: .valueChanged)
    }

    @available(*, unavailable, message: "Use init() instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func didMoveToWindow() {
        backgroundColor = UIColor.white
        constructHierarchy()
        activateConstraints()
    }

    func reloadData() {
        collectionView.reloadData()
    }

    @objc private func dismiss() {
        dismissHandler?()
    }

    @objc private func update(_ selector: UISegmentedControl) {
        if selector.selectedSegmentIndex == 0 {
            avatarTypeChangeHandler?(.dark)
        } else {
            avatarTypeChangeHandler?(.light)
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
        let top = backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8)
        let leading = backButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16)
        NSLayoutConstraint.activate([top, leading])
    }

    private func activateConstraintsSegmentedControl() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        let top = segmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8)
        let centerX = segmentedControl.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        NSLayoutConstraint.activate([top, centerX])
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
