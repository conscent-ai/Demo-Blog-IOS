//
//  Toast.swift
//  Demo-Blog
//
//  Created by Sam on 29/06/23.
//

import Foundation
import UIKit

class Toast {
    enum ToastAlignment {
        case top
        case center
        case bottom
    }

    static let shared = Toast()

    private var toastView: UIView?

    private init() { }

    func showToast(message: String, duration: TimeInterval = 2.0, backgroundColor: UIColor = .black, textColor: UIColor = .white, font: UIFont = UIFont.systemFont(ofSize: 14), cornerRadius: CGFloat = 10, alignment: ToastAlignment = .bottom) {

        // Remove any existing toast view
        hideToast()

        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textColor = textColor
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.numberOfLines = 0

        let toastSize = CGSize(width: 200, height: 40) // Change the size as per your needs

        let toastContainer = UIView()
        toastContainer.backgroundColor = backgroundColor
        toastContainer.alpha = 0.8
        toastContainer.layer.cornerRadius = cornerRadius
        toastContainer.clipsToBounds = true
        toastContainer.translatesAutoresizingMaskIntoConstraints = false

        toastContainer.addSubview(toastLabel)
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.centerXAnchor.constraint(equalTo: toastContainer.centerXAnchor).isActive = true
        toastLabel.centerYAnchor.constraint(equalTo: toastContainer.centerYAnchor).isActive = true
        toastLabel.widthAnchor.constraint(equalTo: toastContainer.widthAnchor, constant: -20).isActive = true

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first else {
                return
        }

        window.addSubview(toastContainer)
        window.bringSubviewToFront(toastContainer)

        switch alignment {
        case .top:
            toastContainer.topAnchor.constraint(equalTo: window.topAnchor, constant: 20).isActive = true
        case .center:
            toastContainer.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
        case .bottom:
            toastContainer.bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        }

        toastContainer.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
        toastContainer.widthAnchor.constraint(equalToConstant: toastSize.width).isActive = true
        toastContainer.heightAnchor.constraint(equalToConstant: toastSize.height).isActive = true

        toastView = toastContainer

        UIView.animate(withDuration: 0.3, delay: duration, options: .curveEaseOut, animations: {
            toastContainer.alpha = 0
        }, completion: { _ in
            self.hideToast()
        })
    }

    func hideToast() {
        if let toast = toastView {
            toast.removeFromSuperview()
            toastView = nil
        }
    }
}

