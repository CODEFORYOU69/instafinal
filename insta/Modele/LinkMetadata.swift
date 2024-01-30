//
//  LinkMetadata.swift
//  insta
//
//  Created by younes ouasmi on 29/01/2024.
//

import Foundation
import LinkPresentation



class LinkMetadataItemSource: NSObject, UIActivityItemSource {
    let metadata: LPLinkMetadata
    
    init(metadata: LPLinkMetadata) {
        self.metadata = metadata
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return metadata
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return metadata
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        return metadata
    }
}
