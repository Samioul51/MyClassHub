//
//  ClassSlotCard.swift
//  MyClassHub
//
//  Created by SIR on 16/3/26.
//
import SwiftUI

struct ClassSlotCard: View {
    let slot: ClassSlot

    var accentColor: Color {
        slot.isLab ? .orange : .blue
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {

            // Time column
            VStack(alignment: .center, spacing: 2) {
                Text(slot.timeStart)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(accentColor)
                Rectangle()
                    .frame(width: 1, height: 20)
                    .foregroundColor(accentColor.opacity(0.3))
                Text(slot.timeEnd)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(accentColor)
            }
            .frame(width: 44)

            // Accent bar
            RoundedRectangle(cornerRadius: 2)
                .fill(accentColor)
                .frame(width: 3)
                .padding(.vertical, 2)

            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(slot.courseCode)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(accentColor)

                    if slot.isLab {
                        Text("LAB")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(Color.orange)
                            .cornerRadius(4)
                    }

                    if let group = slot.groupInfo {
                        Text(group)
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(Color(.systemGray5))
                            .cornerRadius(4)
                    }

                    Spacer()
                    Text("P\(slot.period)")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }

                Text(slot.courseName)
                    .font(.system(size: 13))
                    .foregroundColor(.primary)
                    .lineLimit(2)

                if !slot.teacherInitials.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                        Text(slot.teacherInitials.joined(separator: ", "))
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
