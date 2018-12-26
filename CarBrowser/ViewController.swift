//
//  ViewController.swift
//  AnimatedPageView
//
//  Created by Alex K. on 12/04/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit
import PaperOnboarding

class ViewController: UIViewController {

    @IBOutlet var skipButton: UIButton!

    fileprivate let items = [
//        color: UIColor(red: 0.40, green: 0.56, blue: 0.71, alpha: 1.00),
        
        OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "Launch Screen 1.jpg"),
                           title: "Discover",
                           description: "Explore and discover: Use the quick filtering options on the main screen to allow you to identify birds you haven't seen before.",
                           pageIcon:  #imageLiteral(resourceName: "0043.png"),
                           color: UIColor(red: 0.40, green: 0.6, blue: 0.4, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage:#imageLiteral(resourceName: "Launch Screen 2.jpg"),
                           title: "Explore",
                           description: "To see more information about a particular species, swipe left to open up a detail page. Swipe right to go back.",
                           pageIcon:  #imageLiteral(resourceName: "0043.png"),
                           color: UIColor(red: 0.40, green: 0.6, blue: 0.4, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage:#imageLiteral(resourceName: "Launch Screen 4.PNG"),
                           title: "Record",
                           description: "Store your observations using a marker on map. Create locations and fill in information. Come back to these observations at any time. ",
                           pageIcon:  #imageLiteral(resourceName: "0063@2x.png"),
                           color: UIColor(red: 0.40, green: 0.6, blue: 0.4, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage:#imageLiteral(resourceName: "Launch Screen 3.PNG"),
                           title: "Upload",
                           description: "Email yourself a copy of your lists for upload at eBird.org citizen science portal.",
                           pageIcon: #imageLiteral(resourceName: "0002.png"),
                           color: UIColor(red: 0.40, green: 0.6, blue: 0.4, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //skipButton.isHidden = true

        setupPaperOnboardingView()

        view.bringSubviewToFront(skipButton)
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
}

// MARK: Actions

extension ViewController {

    @IBAction func skipButtonTapped(_: UIButton) {
        print(#function)
    }
}

// MARK: PaperOnboardingDelegate

extension ViewController: PaperOnboardingDelegate {

    func onboardingWillTransitonToIndex(_ index: Int) {
        //if the button is hidden at start, it can be shown when index is reached
        //skipButton.isHidden = index == 2 ? false : true
    }

    func onboardingDidTransitonToIndex(_: Int) {
    }

    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        //item.titleLabel?.backgroundColor = .redColor()
        //item.descriptionLabel?.backgroundColor = .redColor()
        //item.imageView = ...
    }
}

// MARK: PaperOnboardingDataSource

extension ViewController: PaperOnboardingDataSource {

    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return items[index]
    }

    func onboardingItemsCount() -> Int {
        return 4
    }
    
    //    func onboardinPageItemRadius() -> CGFloat {
    //        return 2
    //    }
    //
    //    func onboardingPageItemSelectedRadius() -> CGFloat {
    //        return 10
    //    }
    //    func onboardingPageItemColor(at index: Int) -> UIColor {
    //        return [UIColor.white, UIColor.red, UIColor.green][index]
    //    }
}


//MARK: Constants
extension ViewController {
    
    private static let titleFont = UIFont(name: "Nunito-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
    private static let descriptionFont = UIFont(name: "OpenSans-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
}

