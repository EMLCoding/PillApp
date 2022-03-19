//
//  AlertView.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 19/03/2022.
//

import SwiftUI



struct AlertView: View {
    var image: String
    var title: String
    var text: String
    var seeButtons: Bool
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
            VStack(spacing: 25) {
                Image(systemName: image)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color("MainColor"))
                
                
                Text(title)
                    .font(.title)
                    .foregroundColor(Color("MainColor"))
                    .multilineTextAlignment(.center)
                Text(text)
                    .multilineTextAlignment(.center)
                
                if (seeButtons) {
                    Spacer()
                    Divider()
                    Button("OK") {
                        NotificationCenter.default.post(name: .hideAlert, object: nil)
                    }
                }                
            }
            .frame(width: UIScreen.main.bounds.width - 150, height: seeButtons ? UIScreen.main.bounds.height - 450 : UIScreen.main.bounds.height * 0.3, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .padding(.vertical,25)
            .padding(.horizontal, 30)
            .background(BlurView())
            .cornerRadius(30)
        }
    }
}

struct BlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
        
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(image: "heart.text.square.fill", title: "Medicines reminder", text: "Reminders have been created successfully", seeButtons: true)
    }
}
