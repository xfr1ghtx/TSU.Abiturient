//
//  EnrollmentViewController.swift
//  TSUAbiturient
//

import Foundation
import UIKit

final class EnrollmentViewController: BaseViewController, NavigationBarHiding, DataLoadingView,
                                      ActivityIndicatorViewDisplaying, EmptyStateErrorViewDisplaying,
                                      ErrorHandling {
  // MARK: - Properties
  
  let activityIndicatorView = UIActivityIndicatorView()
  let emptyStateErrorView = EmptyStateErrorView()
  
  private let noAccountTitleContainerView = UIView()
  private let noAccountTitleLabel = Label(textStyle: .header3)
  private let noAccountSubtitleLabel = Label(textStyle: .body)
  private let loginTSUAccountsButton = CommonButton(style: .default)
  
  private let userCardView = UIView()
  private let userNameLabel = Label(textStyle: .header2)
  private let logoutButton = UIButton(type: .system)
  
  private let programsCardView = UIView()
  private let programsLabel = Label(textStyle: .header3)
  private let budgetSegmentedControl = UISegmentedControl()
  private let programsTableView = UITableView()
  
  private let dataSource = TableViewDiffableDataSource<ProgramListItemCell, DefaultTableSection, ProgramListItemViewModel>()
  
  private let viewModel: EnrollmentViewModel
  
  // MARK: - Init
  
  init(viewModel: EnrollmentViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("EnrollmentViewController init(coder:) has not been implemented")
  }
  
  // MARK: - Actions
  @objc func didTapLogout() {
    viewModel.didSelectLogout()
    configureScreen()
  }
  
  @objc func didTapLoginTSUAccount() {
    viewModel.didSelectLoginTSUAccount()
  }
  
  @objc func didChangeSegmentedControlValue() {
    reloadData()
  }
  
  // MARK: - Public methods
  
  func handleRequestStarted() {
    noAccountTitleContainerView.isHidden = true
    loginTSUAccountsButton.isHidden = true
    userCardView.isHidden = true
    programsCardView.isHidden = true
  }
  
  func handleRequestFinished() {
    configureScreen()
  }
  
  func handleErrorReceived() {
    emptyStateErrorView.isHidden = true
    configureScreen()
  }
  
  func reloadData() {
    var snapshot = dataSource.createSnapshot()
    snapshot.appendSections([.main])
    let viewModels = viewModel.getViewModelsForSelectedSegmentWith(position: budgetSegmentedControl.selectedSegmentIndex)
    snapshot.appendItems(viewModels, toSection: .main)
    dataSource.apply(snapshot)
  }
  
  // MARK: - Lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    bind(to: viewModel)
    viewModel.viewIsReady()
  }
  
  // MARK: - Private methods
  
  private func setup() {
    setupNoAccount()
    setupUserCard()
    setupProgramsList()
    setupActivityIndicatorView()
    setupEmptyStateErrorView()
    
    showNoAccountByDefault()
  }
  
  private func setupNoAccount() {
    setupNoAccountContainer()
    setupNoAccountTitleLabel()
    setupNoAccountSubtitleLabel()
    setupTSUAccountButton()
  }
  
  private func setupUserCard() {
    setupUserCardView()
    setupUserNameLabel()
    setupLogoutButton()
  }
  
  private func setupProgramsList() {
    setupProgramsCardView()
    setupProgramsLabel()
    setupSegmentedControl()
    setupProgramsTableView()
  }
  
  private func showNoAccountByDefault() {
    userCardView.isHidden = true
    programsCardView.isHidden = true
    noAccountTitleContainerView.isHidden = false
    loginTSUAccountsButton.isHidden = false
  }
  
  private func configureScreen() {
    if viewModel.hasAccountInformation {
      configureUserCard()
      if viewModel.hasEducationPrograms {
        configureEducationProgramList()
      }
    } else {
      showNoAccountByDefault()
    }
  }
  
  private func setupNoAccountTitleLabel() {
    noAccountTitleContainerView.addSubview(noAccountTitleLabel)
    noAccountTitleLabel.text = Localizable.Enrollment.NoAccount.title
    noAccountTitleLabel.lineBreakMode = .byWordWrapping
    noAccountTitleLabel.numberOfLines = 0
    noAccountTitleLabel.textAlignment = .center
    noAccountTitleLabel.snp.makeConstraints { make in
      make.top.horizontalEdges.equalToSuperview()
    }
  }
  
  private func setupNoAccountSubtitleLabel() {
    noAccountTitleContainerView.addSubview(noAccountSubtitleLabel)
    noAccountSubtitleLabel.text = Localizable.Enrollment.NoAccount.subtitle
    noAccountSubtitleLabel.lineBreakMode = .byWordWrapping
    noAccountSubtitleLabel.numberOfLines = 0
    noAccountSubtitleLabel.textAlignment = .center
    noAccountSubtitleLabel.snp.makeConstraints { make in
      make.bottom.horizontalEdges.equalToSuperview()
      make.top.equalTo(noAccountTitleLabel.snp.bottom).offset(8)
    }
  }
  
  private func setupTSUAccountButton() {
    self.view.addSubview(loginTSUAccountsButton)
    loginTSUAccountsButton.setLeftImage(Assets.Images.tsuLogo.image.withRenderingMode(.alwaysTemplate), for: .normal)
    loginTSUAccountsButton.setTitle(Localizable.Enrollment.NoAccount.loginButton, for: .normal)
    loginTSUAccountsButton.tintColor = UIColor.Light.Button.Primary.title
    loginTSUAccountsButton.snp.makeConstraints { make in
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(24)
      make.horizontalEdges.equalToSuperview().inset(16)
      make.height.equalTo(48)
    }
    loginTSUAccountsButton.addTarget(self, action: #selector(didTapLoginTSUAccount), for: .touchUpInside)
  }
  
  private func setupNoAccountContainer() {
    self.view.addSubview(noAccountTitleContainerView)
    noAccountTitleContainerView.snp.makeConstraints { make in
      make.centerX.centerY.equalToSuperview()
      make.horizontalEdges.equalToSuperview().inset(24)
    }
  }
  
  private func setupUserCardView() {
    self.view.addSubview(userCardView)
    userCardView.backgroundColor = .Light.Surface.primary
    userCardView.layer.cornerRadius = 24
    userCardView.layer.cornerCurve = .continuous
    userCardView.addShadow(offset: CGSize(width: 0, height: 12), radius: 24, color: .Light.Global.black, opacity: 0.08)
    userCardView.snp.makeConstraints { [weak self] make in
      guard let self = self else { return }
      make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(16)
      make.horizontalEdges.equalToSuperview().inset(16)
    }
  }
  
  private func setupUserNameLabel() {
    userCardView.addSubview(userNameLabel)
    userNameLabel.numberOfLines = 0
    userNameLabel.lineBreakMode = .byWordWrapping
    userNameLabel.snp.makeConstraints { make in
      make.top.horizontalEdges.equalToSuperview().inset(16)
    }
  }
  
  private func setupLogoutButton() {
    userCardView.addSubview(logoutButton)
    logoutButton.setTitle(Localizable.Enrollment.logout, for: .normal)
    logoutButton.setImage(Assets.Images.logout.image.withRenderingMode(.alwaysTemplate), for: .normal)
    logoutButton.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
    logoutButton.titleLabel?.font = .Regular.body
    logoutButton.tintColor = .Light.Icons.accent
    logoutButton.setTitleColor(.Light.Text.accent, for: .normal)
    
    if #available(iOS 15.0, *) {
      var configuration = UIButton.Configuration.plain()
      configuration.contentInsets = .zero
      configuration.imagePadding = 4
      logoutButton.configuration = configuration
    } else {
      logoutButton.imageEdgeInsets.left = 4
      logoutButton.imageEdgeInsets.right = -4
      logoutButton.contentEdgeInsets.right = 4
    }
    
    logoutButton.snp.makeConstraints { make in
      make.top.equalTo(userNameLabel.snp.bottom).offset(8)
      make.bottom.equalToSuperview().inset(16)
      make.leading.equalToSuperview().inset(16)
    }
  }
  
  private func setupProgramsCardView() {
    self.view.addSubview(programsCardView)
    programsCardView.backgroundColor = .Light.Surface.primary
    programsCardView.layer.cornerRadius = 24
    programsCardView.layer.cornerCurve = .continuous
    programsCardView.addShadow(offset: CGSize(width: 0, height: 12), radius: 24, color: .Light.Global.black, opacity: 0.08)
    programsCardView.snp.makeConstraints { make in
      make.top.equalTo(userCardView.snp.bottom).offset(24)
      make.horizontalEdges.equalToSuperview().inset(16)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(24)
    }
  }
  
  private func setupProgramsLabel() {
    programsCardView.addSubview(programsLabel)
    programsLabel.text = Localizable.Enrollment.myPrograms
    programsLabel.snp.makeConstraints { make in
      make.top.horizontalEdges.equalToSuperview().inset(16)
    }
  }
  
  private func setupSegmentedControl() {
    programsCardView.addSubview(budgetSegmentedControl)
    let selectedSegmentFont = TextStyle.bodyBold.font ?? UIFont.systemFont(ofSize: 16)
    let unselectedSegmentFont = TextStyle.body.font ?? UIFont.systemFont(ofSize: 16)
    budgetSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: selectedSegmentFont], for: .selected)
    budgetSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: unselectedSegmentFont], for: .normal)
    budgetSegmentedControl.addTarget(self, action: #selector(didChangeSegmentedControlValue), for: .valueChanged)
    budgetSegmentedControl.snp.makeConstraints { make in
      make.top.equalTo(programsLabel.snp.bottom).offset(8)
      make.horizontalEdges.equalToSuperview().inset(16)
    }
  }
  
  private func setupProgramsTableView() {
    programsCardView.addSubview(programsTableView)
    programsTableView.snp.makeConstraints { make in
      make.top.equalTo(budgetSegmentedControl.snp.bottom).offset(8)
      make.bottom.horizontalEdges.equalToSuperview().inset(16)
    }
    programsTableView.backgroundColor = UIColor.Light.Background.primary
    programsTableView.separatorStyle = .none
    programsTableView.estimatedRowHeight = 56
    programsTableView.rowHeight = UITableView.automaticDimension
    programsTableView.showsVerticalScrollIndicator = false
    programsTableView.contentInset.bottom = 12
    
    dataSource.setup(tableView: programsTableView)
    dataSource.delegate = self
  }
  
  private func configureUserCard() {
    userNameLabel.text = viewModel.userName
    userCardView.isHidden = false
  }
  
  private func configureEducationProgramList() {
    budgetSegmentedControl.removeAllSegments()
    for type in viewModel.budgetTypes {
      budgetSegmentedControl.insertSegment(withTitle: type.name, at: budgetSegmentedControl.numberOfSegments, animated: false)
    }
    budgetSegmentedControl.selectedSegmentIndex = 0
    programsCardView.isHidden = false
  }
}

// MARK: - TableViewDiffableDataSourceDelegate

extension EnrollmentViewController: TableViewDiffableDataSourceDelegate {
  func tableViewDiffableDataSource(didSelectItemAt indexPath: IndexPath) {
  }
}
