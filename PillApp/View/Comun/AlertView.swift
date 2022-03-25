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
    let functionButton1: () -> ()
    let functionButton2: () -> ()
    var textButton1: String?
    var seeSecondButton = false
    var textButton2: String?
    var seeCancelButton = false
    
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
                    Divider()
                    HStack {
                        Button(action: functionButton1) {
                            Text("Hola")
                        }
                        Button(textButton1 ?? "OK") {
                            NotificationCenter.default.post(name: .hideAlert, object: nil)
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                        
                        if (seeSecondButton) {
                            Button(textButton2 ?? "") {
                                NotificationCenter.default.post(name: .hideAlert, object: nil)
                                functionButton2()
                            }
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.capsule)
                        }
                        
                        if (seeCancelButton) {
                            Button("Cancel") {
                                NotificationCenter.default.post(name: .hideAlert, object: nil)
                            }
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.capsule)
                        }
                    }
                    
                    
                }
            }
            .frame(width: 250)
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
        AlertView(image: "heart.text.square.fill", title: "Medicines reminder", text: "Reminders have been created successfully", seeButtons: true, functionButton1: {}, functionButton2: {})
    }
}
