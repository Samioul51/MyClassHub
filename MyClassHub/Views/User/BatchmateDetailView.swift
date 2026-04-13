//
//  BatchmateDetailView.swift
//  MyClassHub

import SwiftUI

struct BatchmateDetailView: View {
    
    let batchmates: [Batchmate]
    @State var selectedIndex: Int
    
    var batchmate: Batchmate {
        batchmates[selectedIndex]
    }
    
    var body: some View {
        
        ZStack {
            
            // MARK: BACKGROUND (ADMIN THEME)
            Color(hex: "#110e07")
                .ignoresSafeArea()
            
            TabView(selection: $selectedIndex) {
                
                ForEach(Array(batchmates.enumerated()), id: \.element.id) { index, b in
                    
                    BatchmateDetailCard(batchmate: b)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(batchmate.name)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#8dedec"))
            }
        }
        .animation(.easeInOut, value: selectedIndex)
    }
}

// Detail card

struct BatchmateDetailCard: View {
    
    let batchmate: Batchmate
    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 16) {
                
                // MARK: PROFILE CARD
                VStack(spacing: 12) {
                    
                    AsyncImage(url: URL(string: batchmate.image ?? "")) { phase in
                        switch phase {
                            
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                            
                        case .failure, .empty:
                            Image(systemName: "person.fill")
                                .font(.system(size: 40))
                                .foregroundColor(Color(hex: "#8dedec"))
                            
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(width: 90, height: 90)
                    .clipShape(Circle())
                    .background(Color(hex: "#1d1910"))
                    
                    Text(batchmate.name)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Roll: \(batchmate.roll)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(hex: "#8dedec"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color(hex: "#1d1910"))
                        .cornerRadius(20)
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(Color(hex: "#16130b"))
                .cornerRadius(24)
                .padding(.horizontal)
                
                // MARK: INFO SECTION
                VStack(spacing: 12) {
                    
                    InfoRowDark(
                        icon: "building.columns.fill",
                        color: Color(hex: "#8dedec"),
                        title: "College",
                        value: batchmate.college
                    )
                    
                    InfoRowDark(
                        icon: "mappin.circle.fill",
                        color: Color(hex: "#ff3b30"),
                        title: "Home District",
                        value: batchmate.homeDistrict
                    )
                    
                    InfoRowDark(
                        icon: "drop.fill",
                        color: Color(hex: "#ff9f0a"),
                        title: "Blood Group",
                        value: batchmate.bloodGroup
                    )
                    
                    // CONTACT
                    if let contact = batchmate.contactNumber, !contact.isEmpty {
                        
                        Button {
                            if let url = URL(string: "tel:\(contact)") {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            
                            InfoRowDark(
                                icon: "phone.fill",
                                color: Color(hex: "#34c759"),
                                title: "Contact",
                                value: contact
                            )
                        }
                        .buttonStyle(.plain)
                        
                    } else {
                        
                        InfoRowDark(
                            icon: "phone.fill",
                            color: .gray,
                            title: "Contact",
                            value: "Not available"
                        )
                        .opacity(0.6)
                    }
                }
                .padding(16)
                .background(Color(hex: "#16130b"))
                .cornerRadius(20)
                .padding(.horizontal)
                
                // MARK: SWIPE HINT
                HStack(spacing: 6) {
                    Image(systemName: "hand.draw.fill")
                    Text("Swipe to explore batchmates")
                }
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.5))
                .padding(.bottom, 20)
            }
            .padding(.top, 10)
        }
    }
}

// Info row
struct InfoRowDark: View {
    
    let icon: String
    let color: Color
    let title: String
    let value: String
    
    var body: some View {
        
        HStack(spacing: 14) {
            
            Image(systemName: icon)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color(hex: "#110e07"))
                .frame(width: 34, height: 34)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 2) {
                
                Text(title)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.5))
                
                Text(value)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color(hex: "#1d1910"))
        .cornerRadius(14)
    }
}
