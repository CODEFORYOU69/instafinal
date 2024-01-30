//
//  modele.swift
//  insta
//
//  Created by younes ouasmi on 21/01/2024.
//

import Foundation
import UIKit

struct ImageGrid {
    // Holds the array of images for the grid, initially set to nil
    var images: [UIImage?] = Array(repeating: nil, count: 4)
    
    // Current template type for the grid layout
    var currentTemplate: GridTemplate = .template1
    
    // Enum for different grid templates
    enum GridTemplate {
        case template1
        case template2
        case template3
    }
    
    // Returns layout configuration based on the current template and device orientation
    func getLayoutConfiguration(forOrientation orientation: UIDeviceOrientation) -> LayoutConfiguration {
        switch currentTemplate {
        case .template1:
            // Calculate widths and hidden states for template1
            let widthA = orientation.isPortrait ? 270 : 216
            let widthC = orientation.isPortrait ? 127 : 100
            return LayoutConfiguration(
                widthConstraintViewA: widthA,
                widthConstraintViewB: 0,
                widthConstraintViewC: widthC,
                widthConstraintViewD: widthC,
                isViewBHidden: true,
                isViewDHidden: false
            )
            
        case .template2:
            // Calculate widths and hidden states for template2
            let widthC = orientation.isPortrait ? 270 : 216
            let widthA = orientation.isPortrait ? 127 : 100
            return LayoutConfiguration(
                widthConstraintViewA: widthA,
                widthConstraintViewB: widthA,
                widthConstraintViewC: widthC,
                widthConstraintViewD: 0,
                isViewBHidden: false,
                isViewDHidden: true
            )
            
        case .template3:
            // Widths and visibility for template3
            let width = orientation.isPortrait ? 127 : 100
            return LayoutConfiguration(
                widthConstraintViewA: width,
                widthConstraintViewB: width,
                widthConstraintViewC: width,
                widthConstraintViewD: width,
                isViewBHidden: false,
                isViewDHidden: false
            )
        }
    }
    
    // Updates the image at specified index
    mutating func setImage(_ image: UIImage, atIndex index: Int) {
        guard index >= 0 && index < images.count else { return }
        images[index] = image
    }
    
    // Sets the current template for the grid
    mutating func setTemplate(_ template: GridTemplate) {
        currentTemplate = template
    }
    
    // Converts a UIView to an UIImage
    func convertToImage(_ view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

// Configuration for the grid layout
struct LayoutConfiguration {
    var widthConstraintViewA: Int
    var widthConstraintViewB: Int
    var widthConstraintViewC: Int
    var widthConstraintViewD: Int
    var isViewBHidden: Bool
    var isViewDHidden: Bool
}

