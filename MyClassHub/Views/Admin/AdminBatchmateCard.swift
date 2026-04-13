import SwiftUI

struct AdminBatchmateCard: View {
    let batchmate: Batchmate
    var onDelete: () -> Void
    var onEdit: () -> Void  // ← add this line only

    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(url: URL(string: batchmate.image ?? "")) { phase in
                if case .success(let img) = phase {
                    img.resizable().scaledToFill()
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .padding(16)
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            .frame(width: 70, height: 70)
            .clipShape(Circle())
            .id(batchmate.image)  // ← add this line only

            Text(batchmate.name).foregroundColor(.white)
            Text(batchmate.roll).foregroundColor(.gray)

            HStack {
                NavigationLink {
                    EditBatchmateView(batchmate: batchmate)
                        .onDisappear { onEdit() }  // ← add this line only
                } label: {
                    Image(systemName: "pencil")
                        .foregroundColor(.teal)
                }
                Spacer()
                Button(role: .destructive) {
                    onDelete()
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
        .padding()
        .background(Color(hex: "#16130b"))
        .cornerRadius(16)
    }
}
