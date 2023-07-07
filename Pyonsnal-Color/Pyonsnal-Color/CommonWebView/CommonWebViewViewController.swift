//
//  CommonWebViewViewController.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/07.
//

import ModernRIBs
import UIKit
import WebKit

protocol CommonWebViewPresentableListener: AnyObject {
    func detachCommonWebView()
}

final class CommonWebViewViewController: UIViewController,
                                         CommonWebViewPresentable,
                                         CommonWebViewViewControllable {

    enum Size {
        static let navigationViewHeight: CGFloat = 47
    }
    
    weak var listener: CommonWebViewPresentableListener?
    private let viewHolder: ViewHolder = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        configureBackButton()
    }
    
    func update(with subTermsInfo: SubTerms) {
        viewHolder.navigationView.setText(with: subTermsInfo.title)
        if let urlString = subTermsInfo.type.urlString,
            let url = URL(string: urlString) {
            let urlRequest = URLRequest(url: url)
            viewHolder.webView.load(urlRequest)
        }
    }
    
    // MARK: - Private method
    private func configureBackButton() {
        viewHolder.navigationView.delegate = self
    }
    
    private func configureUI() {
        view.backgroundColor = .white
    }
}

// MARK: - BackNavigationViewDelegate
extension CommonWebViewViewController: BackNavigationViewDelegate {
    func didTapBackButton() {
        listener?.detachCommonWebView()
    }
}

extension CommonWebViewViewController {
    class ViewHolder: ViewHolderable {
        // MARK: - UI Component
        let navigationView: BackNavigationView = {
            let navigationView = BackNavigationView(payload: .init(mode: .text,
                                                                   title: "",
                                                                   iconImageKind: nil))
            return navigationView
            
        }()
                                                
        let webView: WKWebView = {
            let webView = WKWebView()
            return webView
        }()
        
        func place(in view: UIView) {
            view.addSubview(navigationView)
            view.addSubview(webView)
        }
        
        func configureConstraints(for view: UIView) {
            navigationView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(Size.navigationViewHeight)
            }
            
            webView.snp.makeConstraints {
                $0.top.equalTo(navigationView.snp.bottom)
                $0.leading.trailing.bottom.equalToSuperview()
            }
        }
    }
}
