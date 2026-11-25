//
//  SecurityBlurEffect.swift
//  Runner
//
//  Created by 三夜 on 2021/2/9.
//

import Foundation
import UIKit


public class SecurityBlurEffect {
    private static let blurViewTag = 19999

    class func addBlurEffect(window: UIWindow?) {
        // UIScene 生命周期下 keyWindow 可能为空，拿不到窗口时直接跳过，避免强制解包崩溃
        guard let window = window else { return }

        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)

        blurEffectView.tag = blurViewTag
        blurEffectView.alpha = 0.99
        blurEffectView.frame = window.bounds

        window.backgroundColor = UIColor.clear

        window.addSubview(blurEffectView)
    }


    class func removeBlurEffect(window: UIWindow?) {
        guard let window = window else { return }

        for view in window.subviews {
            if view.tag == blurViewTag {
                if view is UIVisualEffectView {
                    UIView.animate(withDuration: 0.3, animations: {
                        view.removeFromSuperview()
                    })
                }
            }
        }
    }
}
