//
//  PdfReader.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 30/3/22.
//

import PDFKit
import SwiftUI

struct PdfReader: UIViewRepresentable {
    let pdfView = PDFView()
    
    var url: URL?
    
    init(url: String) {
        self.url = URL(string: url)
    }
    
    func makeUIView(context: Context) -> UIView {
            if let url = url {
                pdfView.document = PDFDocument(url: url)
            }

            return pdfView
        }

        func updateUIView(_ uiView: UIView, context: Context) {
            // Empty
        }
}
