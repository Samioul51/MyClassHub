import SwiftUI

struct TeacherRowView: View {
    
    let teacher: Teacher
    
    var body: some View {
        
        HStack(spacing: 14) {
            
            // PROFILE IMAGE
            AsyncImage(url: URL(string: teacher.image)) { phase in
                
                switch phase {
                    
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                    
                case .failure, .empty:
                    Image(systemName: "person.circle.fill")
                        .foregroundColor(Color(hex: "#8dedec"))
                        .font(.system(size: 24))
                    
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 44, height: 44)
            .clipShape(Circle())
            .background(Color(hex: "#1d1910"))
            
            // TEXT INFO
            VStack(alignment: .leading, spacing: 3) {
                
                Text(teacher.name)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(teacher.designation)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white.opacity(0.3))
        }
        .padding(14)
        .background(Color(hex: "#1d1910"))
        .cornerRadius(14)
    }
}
