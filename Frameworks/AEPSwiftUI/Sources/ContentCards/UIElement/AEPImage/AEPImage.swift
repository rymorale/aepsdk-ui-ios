/*
 Copyright 2024 Adobe. All rights reserved.
 This file is licensed to you under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License. You may obtain a copy
 of the License at http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software distributed under
 the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
 OF ANY KIND, either express or implied. See the License for the specific language
 governing permissions and limitations under the License.
 */

import SwiftUI

/// The model class representing the image UI element of the ContentCard.
/// This class handles the initialization of the image from different sources such as URL or bundle.
public class AEPImage: ObservableObject, AEPViewModel {
    /// The URL of the image to be displayed.
    var url: URL?

    /// The URL of the dark mode image to be displayed.
    var darkUrl: URL?

    /// The name of the image bundled resource.
    var bundle: String?

    /// The name of the dark mode image bundled resource.
    var darkBundle: String?

    /// custom view modifier that can be applied to the text view.
    @Published public var modifier: AEPViewModifier?

    /// The content mode of the image.
    @Published public var contentMode: ContentMode = .fit

    /// The source type of the image, either URL or bundle.
    let imageSourceType: ImageSourceType

    public lazy var view: some View = AEPImageView(model: self)

    /// Initializes a new instance of `AEPImage`
    /// Failable initializer, returns nil if the required fields are not present in the data
    /// - Parameter data: The dictionary containing server side styling and content of the Image
    public init?(_ data: [String: Any]) {
        // Attempt to initialize from URL
        if let urlString = data[Constants.CardTemplate.UIElement.Image.URL] as? String,
           let url = URL(string: urlString) {
            self.imageSourceType = .url
            self.url = url
            self.darkUrl = (data[Constants.CardTemplate.UIElement.Image.DARK_URL] as? String).flatMap { URL(string: $0) }
            return
        }

        // Attempt to initialize from bundle
        if let bundle = data[Constants.CardTemplate.UIElement.Image.BUNDLE] as? String {
            self.imageSourceType = .bundle
            self.bundle = bundle
            self.darkBundle = data[Constants.CardTemplate.UIElement.Image.DARK_BUNDLE] as? String
            return
        }

        // If no valid data is provided, return nil
        return nil
    }
}
