//
//  FacultyDetailsViewController.swift
//  TSUAbiturient
//

import UIKit

class FacultyDetailsViewController: BaseViewController, ActivityIndicatorViewDisplaying,
                                    EmptyStateErrorViewDisplaying, ErrorHandling, DataLoadingView {
  // MARK: - Properties
  
  let activityIndicatorView = UIActivityIndicatorView()
  let emptyStateErrorView = EmptyStateErrorView()
  
  private let scrollView = UIScrollView()
  private let stackView = UIStackView()
  private let headerView = FacultyDetailsHeaderView()
  private let photosView = PhotoCarouselView(horizontalInsets: 16)
  private let descriptionLabel = Label(textStyle: .body)
  private let locationsSectionView = FacultySectionView()
  private let contactsSectionView = FacultySectionView()
  private let linksSectionView = FacultySectionView()
  private let closeButton = UIButton(type: .system)
  
  private let viewModel: FacultyDetailsViewModel
  
  // MARK: - Init
  
  init(viewModel: FacultyDetailsViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    bindToViewModel()
    viewModel.loadData()
  }
  
  // MARK: - Public methods
  
  func reloadData() {
    if let headerViewModel = viewModel.headerViewModel {
      headerView.configure(with: headerViewModel)
    }
    photosView.configure(withURLs: viewModel.pictureURLs)
    descriptionLabel.text = viewModel.description
    
    locationsSectionView.addContentView(createBuildingsView())
    locationsSectionView.isHidden = viewModel.buildings.isEmpty
    
    contactsSectionView.addContentView(createContactsView())
    contactsSectionView.isHidden = viewModel.contacts.isEmpty
    
    linksSectionView.addContentView(createLinksView())
    linksSectionView.isHidden = viewModel.abiturientLinks.isEmpty && viewModel.otherLinks.isEmpty
    
    scrollView.isHidden = false
  }
  
  func handleRequestStarted() {
    scrollView.isHidden = true
  }
  
  // MARK: - Actions
  
  @objc private func close() {
    dismiss(animated: true)
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupScrollView()
    setupStackView()
    setupHeaderView()
    setupPhotosView()
    setupDescriptionLabel()
    setupLocationsSectionView()
    setupLinksSectionView()
    setupContactsSectionView()
    setupEmptyStateErrorView()
    setupActivityIndicatorView()
    setupCloseButton()
  }
  
  private func setupScrollView() {
    view.addSubview(scrollView)
    scrollView.showsVerticalScrollIndicator = false
    scrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func setupStackView() {
    scrollView.addSubview(stackView)
    stackView.axis = .vertical
    stackView.spacing = 0
    stackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.width.equalTo(view.snp.width)
    }
  }
  
  private func setupHeaderView() {
    stackView.addArrangedSubview(headerView)
    stackView.setCustomSpacing(16, after: headerView)
  }
  
  private func setupPhotosView() {
    stackView.addArrangedSubview(photosView)
    stackView.setCustomSpacing(16, after: photosView)
    photosView.itemSize = CGSize(width: view.bounds.width - 32, height: 200)
    photosView.snp.makeConstraints { make in
      make.height.equalTo(200)
    }
  }
  
  private func setupDescriptionLabel() {
    let descriptionView = descriptionLabel.wrapped()
    stackView.addArrangedSubview(descriptionView)
    stackView.setCustomSpacing(16, after: descriptionView)
    descriptionLabel.numberOfLines = 0
    descriptionLabel.textColor = UIColor.Light.Text.primary
  }
  
  private func setupLocationsSectionView() {
    locationsSectionView.title = Localizable.Faculties.locationsSectionTitle
    stackView.addArrangedSubview(locationsSectionView)
  }
  
  private func setupLinksSectionView() {
    linksSectionView.title = Localizable.Faculties.socialNetworksSectionTitle
    stackView.addArrangedSubview(linksSectionView)
  }
  
  private func setupContactsSectionView() {
    contactsSectionView.title = Localizable.Faculties.contactsSectionTitle
    stackView.addArrangedSubview(contactsSectionView)
  }
  
  private func setupCloseButton() {
    view.addSubview(closeButton)
    closeButton.setImage(Assets.Images.crossWithBackground.image.withRenderingMode(.alwaysOriginal), for: .normal)
    closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    closeButton.snp.makeConstraints { make in
      make.size.equalTo(48)
      make.top.trailing.equalToSuperview().inset(16)
    }
  }
  
  // MARK: - Bind
  
  private func bindToViewModel() {
    bind(to: viewModel)
    viewModel.onNeedsToOpenURL = { url in
      UIApplication.shared.open(url)
    }
  }
  
  // MARK: - Private methods
  
  private func createBuildingsView() -> UIView {
    let scrollView = UIScrollView()
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 8
    scrollView.addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.edges.height.equalToSuperview()
    }
    
    viewModel.buildings.forEach { building in
      let locationView = FacultyLocationView()
      locationView.configure(with: building)
      locationView.onDidTap = { [weak self] building in
        self?.viewModel.openMap(building: building)
      }
      stackView.addArrangedSubview(locationView)
    }
    
    return scrollView
  }
  
  private func createContactsView() -> UIView {
    let scrollView = UIScrollView()
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 8
    scrollView.addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.edges.height.equalToSuperview()
    }
    
    viewModel.contacts.forEach { contact in
      let contactsView = FacultyContactView()
      contactsView.configure(with: contact)
      contactsView.onDidTap = { [weak self] contact in
        self?.viewModel.openContact(contact)
      }
      stackView.addArrangedSubview(contactsView)
    }
    
    return scrollView
  }
  
  private func createLinksView() -> UIView {
    let containerStackView = UIStackView()
    containerStackView.axis = .vertical
    containerStackView.spacing = 8
    
    if !viewModel.abiturientLinks.isEmpty {
      let titleLabel = Label(textStyle: .body)
      titleLabel.textColor = UIColor.Light.Text.primary
      titleLabel.text = Localizable.Faculties.socialNetworksAbiturients
      containerStackView.addArrangedSubview(titleLabel.wrapped())
      
      let scrollView = UIScrollView()
      scrollView.showsHorizontalScrollIndicator = false
      scrollView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
      
      let stackView = UIStackView()
      stackView.axis = .horizontal
      stackView.spacing = 8
      scrollView.addSubview(stackView)
      stackView.snp.makeConstraints { make in
        make.edges.height.equalToSuperview()
      }
      
      viewModel.abiturientLinks.forEach { link in
        let linkView = FacultyLinkView()
        linkView.configure(with: link)
        linkView.onDidTap = { link in
          guard let url = URL(string: link.link) else { return }
          UIApplication.shared.open(url)
        }
        stackView.addArrangedSubview(linkView)
      }
      
      containerStackView.addArrangedSubview(scrollView)
      containerStackView.setCustomSpacing(16, after: scrollView)
    }
    
    if !viewModel.otherLinks.isEmpty {
      let titleLabel = Label(textStyle: .body)
      titleLabel.textColor = UIColor.Light.Text.primary
      titleLabel.text = Localizable.Faculties.socialNetworksOther
      containerStackView.addArrangedSubview(titleLabel.wrapped())
      
      let scrollView = UIScrollView()
      scrollView.showsHorizontalScrollIndicator = false
      scrollView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
      
      let stackView = UIStackView()
      stackView.axis = .horizontal
      stackView.spacing = 8
      scrollView.addSubview(stackView)
      stackView.snp.makeConstraints { make in
        make.edges.height.equalToSuperview()
      }
      
      viewModel.otherLinks.forEach { link in
        let linkView = FacultyLinkView()
        linkView.configure(with: link)
        linkView.onDidTap = { link in
          guard let url = URL(string: link.link) else { return }
          UIApplication.shared.open(url)
        }
        stackView.addArrangedSubview(linkView)
      }
      
      containerStackView.addArrangedSubview(scrollView)
    }
    
    return containerStackView
  }
}
