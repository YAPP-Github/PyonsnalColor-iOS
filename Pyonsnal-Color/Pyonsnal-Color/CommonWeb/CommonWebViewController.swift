//
//  CommonWebViewController.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/07.
//

import UIKit
import WebKit
import ModernRIBs

protocol CommonWebPresentableListener: AnyObject {
    func detachCommonWebView()
}

final class CommonWebViewController: UIViewController,
                                     CommonWebPresentable,
                                     CommonWebViewControllable {

    enum Size {
        static let navigationViewHeight: CGFloat = 47
    }
    
    weak var listener: CommonWebPresentableListener?
    private let viewHolder: ViewHolder = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        configureBackButton()
    }
    
    func update(with subTermsInfo: SubTerms) {
        setNavigationViewTitle(with: subTermsInfo.title)
        loadWebView(with: subTermsInfo.type.urlString)
    }
    
    func update(with settingInfo: SettingInfo) {
        setNavigationViewTitle(with: settingInfo.title)
        loadWebView(with: settingInfo.infoUrl?.urlString)
    }
    
    private func setNavigationViewTitle(with title: String) {
        viewHolder.backNavigationView.payload = .init(
            mode: .text,
            title: title,
            iconImageKind: nil
        )
    }
    
    private func loadWebView(with urlString: String?) {
        if let urlString,
           let url = URL(string: urlString) {
            let urlRequest = URLRequest(url: url)
            viewHolder.webView.load(urlRequest)
        }
    }
    
    // MARK: - Private method
    private func configureBackButton() {
        viewHolder.backNavigationView.delegate = self
    }
    
    private func configureUI() {
        view.backgroundColor = .white
    }
}

// MARK: - BackNavigationViewDelegate
extension CommonWebViewController: BackNavigationViewDelegate {
    func didTapBackButton() {
        listener?.detachCommonWebView()
    }
}

extension CommonWebViewController {
    class ViewHolder: ViewHolderable {
        // MARK: - UI Component
        let backNavigationView: BackNavigationView = {
            let backNavigationView = BackNavigationView()
            return backNavigationView
            
        }()
                                                
        let webView: WKWebView = {
            let webView = WKWebView()
            return webView
        }()
        
        func place(in view: UIView) {
            view.addSubview(backNavigationView)
            view.addSubview(webView)
        }
        
        func configureConstraints(for view: UIView) {
            backNavigationView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(Size.navigationViewHeight)
            }
            
            webView.snp.makeConstraints {
                $0.top.equalTo(backNavigationView.snp.bottom)
                $0.leading.trailing.bottom.equalToSuperview()
            }
        }
    }
}
