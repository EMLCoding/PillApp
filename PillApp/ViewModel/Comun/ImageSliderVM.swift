//
//  ImageSliderVM.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 25/3/22.
//

import SwiftUI

final class ImageSliderVM: ObservableObject {
    
    @Published var downloadedImages: [UIImage] = []
    
    let images: [Foto]
    
    init(images: [Foto]) {
        self.images = images
        
        Task {
            do {
                try await getImages()
            } catch {
                print("ERROR getting images: \(error.localizedDescription)")
            }
        }
    }
    
    func getImages() async throws {
        for image in images {
            if let urlImage = URL(string: image.url) {
                let image = try await getNetwork(url: urlImage) {
                    UIImage(data: $0)
                }
                downloadedImages.append(image)
            }
        }
    }
    
    func getNetwork<Element>(url: URL, builder: @escaping (Data) -> Element?) async throws -> Element {
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let element = builder(data) else {
            throw URLError(.badServerResponse)
        }
        return element
    }
    
    
}
