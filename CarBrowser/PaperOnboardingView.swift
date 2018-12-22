//
//  PaperOnboardingView.swift
//  NZBirder
//
//  Created by Tilmann Steinmetz on 22/12/18.
//  Copyright © 2018 Acme. All rights reserved.
//

//
//  PaperOnboardingIntroScreen.swift
//  demoPaperOnboard
//
//  Created by Thehe on 9/26/18.
//  Copyright © 2018 Futurisx. All rights reserved.
//

import UIKit
import PaperOnboarding

class PagerOnboardingView : UIViewController{
    
    let items = [
        OnboardingItemInfo(informationImage: UIImage(named: "Kaka_on_Branch")!,
                           title: "a",
                           description: "a",
                           pageIcon: UIImage(),
                           color: UIColor(red: 0.40, green: 0.56, blue: 0.71, alpha: 1.00),
                           titleColor: UIColor.white,
                           descriptionColor: UIColor.white,
                           titleFont: titleFont,
                           descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: UIImage(named: "Kaka_on_Branch")!,
                           title: "a",
                           description: "a",
                           pageIcon: UIImage(),
                           color: UIColor.yellow,
                           titleColor: UIColor.white,
                           descriptionColor: UIColor.white,
                           titleFont: titleFont,
                           descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: UIImage(named: "Kaka_on_Branch")!,
                           title: "a",
                           description: "a",
                           pageIcon: UIImage(),
                           color: UIColor.red,
                           titleColor: UIColor.white,
                           descriptionColor: UIColor.white,
                           titleFont: titleFont,
                           descriptionFont: descriptionFont)
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupPaperOnboardingView()
    }
    
    private func setupPaperOnboardingView() {
        let onboarding = PaperOnboarding()
        onboarding.delegate = self
        onboarding.dataSource = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(onboarding)
        
        // Add constraints
        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
        
    }
    
    override var prefersStatusBarHidden: Bool{
        return true;
    }
}


extension PagerOnboardingView: PaperOnboardingDelegate {
    
    func onboardingWillTransitonToIndex(_ index: Int) {
    }
    
    func onboardingDidTransitonToIndex(_: Int) {
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
    }
    
}

// MARK: PaperOnboardingDataSource

extension PagerOnboardingView: PaperOnboardingDataSource {
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return items[index]
    }
    
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    func onboardinPageItemRadius() -> CGFloat {
        return 8
    }
    
    func onboardingPageItemSelectedRadius() -> CGFloat {
        return 12
    }
    
    
}

//MARK: Constants
extension PagerOnboardingView {
    static let titleFont = UIFont(name: "Nunito-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
    static let descriptionFont = UIFont(name: "OpenSans-Regular", size: 18.0) ?? UIFont.systemFont(ofSize: 18.0)
}
