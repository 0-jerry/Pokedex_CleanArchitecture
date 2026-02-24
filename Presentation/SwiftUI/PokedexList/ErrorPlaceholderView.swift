import SwiftUI

struct ErrorPlaceholderView: View {
    let title: String
    let description: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text(description)
                .font(.system(size: 16))
                .foregroundColor(Color.white.opacity(0.9))
                .multilineTextAlignment(.center)
            
            Button(action: retryAction) {
                Text("재시도")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal, 20)
    }
}
