//
//  Firebase+.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 12/10/23.
//

import FirebaseAnalytics

enum GAEventName: String {
    case pageView = "page_view"
    case like
    case unlike
    case itemClick = "item_click"
    case tabbarClick = "tabbar_click"
    case navbarClick = "navbar_click"
    case sortFilterClick = "sort_filter_click"
    case recommendFilterClick = "recommend_filter_click"
    case categoryFilterClick = "category_filter_click"
    case eventFilterClick = "event_filter_click"
    case eventClick = "event_click"
    case keywordSearch = "keyword_search"
    case withdrawalClick = "withdrawal_click"
    case writeReviewClick = "writeReviewClick"
    case closeScreen = "close_screen"
    case bannerClick = "banner_click"
}

enum GAScreenName: String {
    case splash
    case socialLogin = "social_login"
    case termofuse = "termofuse"
}

enum GATabName: String {
    case home = "main_home"
    case event = "main_event"
    case favorite = "main_like"
    case profile = "main_my"
}

enum GAParameterKey: String {
    case screenName = "screen_name"
    case searchProductName = "search_product_name"
    case productName = "product_name"
    case tabName = "tab_name"
    case pbNavName = "pb_nav_name"
    case eventNavName = "event_nav_name"
    case sortFilterName = "sort_filter_name"
    case searchSortFilterName = "search_sort_filter_name"
    case reviewSortFilterName = "review_sort_filter_name"
    case recommendFilterName = "recommend_filter_name"
    case categoryFilterName = "categoryFilterName"
    case eventFilterName = "event_filter_name"
    case cuEventName = "cu_event_name"
    case gsEventName = "gs_event_name"
    case emartEventName = "emart_event_name"
    case sevenEventName = "sevene_event_name"
    case searchKeyword = "search_keyword"
    case count = "count"
    case bannerName = "banner_name"
}

func logging(_ event: GAEventName, parameter: [GAParameterKey: String]) {
    var rawParameter: [String: String] = [:]
    parameter.map { ($0.key.rawValue, $0.value) }.forEach { (key, value) in
        rawParameter[key] = value
    }
    #if DEBUG
    print("🧵 \(event.rawValue) - \(parameter)")
    #endif
    Analytics.logEvent(event.rawValue, parameters: rawParameter)
}
