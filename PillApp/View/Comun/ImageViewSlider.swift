//
//  ImageViewSlider.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 25/3/22.
//

import SwiftUI

struct ImageViewSlider: View {
    
    @ObservedObject var imageSliderVM: ImageSliderVM
    
    var body: some View {
        TabView {
            ForEach(imageSliderVM.downloadedImages, id: \.self) { image in
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

struct ImageViewSlider_Previews: PreviewProvider {
    static var previews: some View {
        ImageViewSlider(imageSliderVM: ImageSliderVM(images: []))
    }
}
