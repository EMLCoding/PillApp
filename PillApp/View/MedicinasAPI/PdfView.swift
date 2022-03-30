//
//  PdfView.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 30/3/22.
//

import SwiftUI

struct PdfView: View {
    var url: String
    
    var body: some View {
        PdfReader(url: url)
    }
}

struct PdfView_Previews: PreviewProvider {
    static var previews: some View {
        PdfView(url: "https://cima.aemps.es/cima/pdfs/p/53931/P_53931.pdf")
    }
}
