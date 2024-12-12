//
//  UserOnboardingView.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 5.12.24.
//

import SwiftUI

struct UserOnboardingView: View {
    @Binding var isOnboardingPresented: Bool
    
    var body: some View {
        VStack {
            Text("User Data")
                .font(.title)
            
            Spacer()
            
            Text("Hello, \nthe app will need some input information to be able to calculate your initial status.")
                .multilineTextAlignment(.center)
                .bold()
            
            Spacer()
            
            Button(action: {
                isOnboardingPresented = true
            }, label: {
                Text("Great. Lets do it!")
                    .foregroundStyle(.black)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20.0)
            })
            .background(.green, in: RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))).opacity(0.7)
            .padding(.bottom, 20)
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    @Previewable @State var value: Bool = false
    UserOnboardingView(isOnboardingPresented: $value)
}
