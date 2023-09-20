import SwiftUI

struct AuthRequestView: View {
    @EnvironmentObject var presenter: AuthRequestPresenter
    
    @State var text = ""
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
            
            VStack {
                Spacer()
                
                VStack(spacing: 0) {
                    Image("header")
                        .resizable()
                        .scaledToFit()
                    
                    Text(presenter.request.payload.domain)
                        .foregroundColor(.grey8)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .padding(.top, 10)
                    
                    Text("would like to connect")
                        .foregroundColor(.grey8)
                        .font(.system(size: 22, weight: .medium, design: .rounded))
                    
                    Text(presenter.request.payload.domain)
                        .foregroundColor(.grey50)
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.top, 8)
                    
                    switch presenter.validationStatus {
                    case .unknown:
                        verifyBadgeView(imageName: "exclamationmark.circle.fill", title: "Cannot verify", color: .orange)
                        
                    case .valid:
                        verifyBadgeView(imageName: "checkmark.seal.fill", title: "Verified domain", color: .blue)
                        
                    case .invalid:
                        verifyBadgeView(imageName: "exclamationmark.triangle.fill", title: "Invalid domain", color: .red)
                        
                    case .scam:
                        verifyBadgeView(imageName: "exclamationmark.shield.fill", title: "Security risk", color: .red)
                        
                    default:
                        EmptyView()
                    }
                    
                    authRequestView()
                    
                    Group {
                        switch presenter.validationStatus {
                        case .invalid:
                            verifyDescriptionView(imageName: "exclamationmark.triangle.fill", title: "Invalid domain", description: "This domain cannot be verified. Check the request carefully before approving.", color: .red)
                            
                        case .unknown:
                            verifyDescriptionView(imageName: "exclamationmark.circle.fill", title: "Unknown domain", description: "This domain cannot be verified. Check the request carefully before approving.", color: .orange)
                            
                        case .scam:
                            verifyDescriptionView(imageName: "exclamationmark.shield.fill", title: "Security risk", description: "This website is flagged as unsafe by multiple security providers. Leave immediately to protect your assets.", color: .red)
                            
                        default:
                            EmptyView()
                        }
                    }
                    
                    HStack(spacing: 20) {
                        Button {
                            Task(priority: .userInitiated) { try await
                                presenter.onReject()
                            }
                        } label: {
                            Text("Decline")
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .padding(.vertical, 11)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            .foregroundNegative,
                                            .lightForegroundNegative
                                        ]),
                                        startPoint: .top, endPoint: .bottom)
                                )
                                .cornerRadius(20)
                        }
                        .shadow(color: .white.opacity(0.25), radius: 8, y: 2)
                        
                        Button {
                            Task(priority: .userInitiated) { try await
                                presenter.onApprove()
                            }
                        } label: {
                            Text("Allow")
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .padding(.vertical, 11)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            .foregroundPositive,
                                            .lightForegroundPositive
                                        ]),
                                        startPoint: .top, endPoint: .bottom)
                                )
                                .cornerRadius(20)
                        }
                        .shadow(color: .white.opacity(0.25), radius: 8, y: 2)
                    }
                    .padding(.top, 25)
                }
                .padding(20)
                .background(.ultraThinMaterial)
                .cornerRadius(34)
                .padding(.horizontal, 10)
                
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    private func authRequestView() -> some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Message")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(.whiteBackground)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background(Color.grey70)
                    .cornerRadius(28, corners: .allCorners)
                    .padding(.leading, 15)
                    .padding(.top, 9)
                
                VStack(spacing: 0) {
                    ScrollView {
                        Text(presenter.message)
                            .foregroundColor(.grey50)
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .frame(height: 250)
                }
                .background(Color.whiteBackground)
                .cornerRadius(20, corners: .allCorners)
                .padding(.horizontal, 5)
                .padding(.bottom, 5)

            }
            .background(.thinMaterial)
            .cornerRadius(25, corners: .allCorners)
        }
        .padding(.vertical, 30)
    }
    
    private func verifyBadgeView(imageName: String, title: String, color: Color) -> some View {
        HStack(spacing: 5) {
            Image(systemName: imageName)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(color)
            
            Text(title)
                .foregroundColor(color)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
            
        }
        .padding(5)
        .background(color.opacity(0.15))
        .cornerRadius(10)
        .padding(.top, 8)
    }
    
    private func verifyDescriptionView(imageName: String, title: String, description: String, color: Color) -> some View {
        HStack(spacing: 15) {
            Image(systemName: imageName)
                .font(.system(size: 20, design: .rounded))
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .foregroundColor(color)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                
                Text(description)
                    .foregroundColor(.grey8)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.15))
        .cornerRadius(20)
    }
}

#if DEBUG
struct AuthRequestView_Previews: PreviewProvider {
    static var previews: some View {
        AuthRequestView()
    }
}
#endif
