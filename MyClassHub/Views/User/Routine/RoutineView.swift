//
//  RoutineView.swift
//  MyClassHub
//
//  Created by SIR on 16/3/26.
//
import SwiftUI

struct RoutineView: View {
    @StateObject private var viewModel = RoutineViewModel()

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading routine...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let _ = viewModel.routine {
                VStack(spacing: 0) {
                    // Section picker
                    Picker("Section", selection: $viewModel.selectedSection) {
                        ForEach(viewModel.availableSections, id: \.self) { sec in
                            Text(sec).tag(sec)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 8)

                    // Day picker
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(viewModel.days, id: \.self) { day in
                                DayChip(
                                    title: String(day.prefix(3)),
                                    isSelected: viewModel.selectedDay == day
                                ) {
                                    viewModel.selectedDay = day
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    }

                    Divider()

                    // Schedule list
                    if let daySchedule = viewModel.currentDaySchedule,
                       !daySchedule.slots.isEmpty {
                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(daySchedule.slots) { slot in
                                    ClassSlotCard(slot: slot)
                                }

                                // Room info footer
                                if !viewModel.currentRoomInfo.isEmpty {
                                    Text("📍 \(viewModel.currentRoomInfo)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 16)
                                        .padding(.bottom, 8)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 12)
                        }
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "calendar.badge.checkmark")
                                .font(.system(size: 48))
                                .foregroundColor(.secondary)
                            Text("No classes on \(viewModel.selectedDay)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 40))
                        .foregroundColor(.orange)
                    Text(viewModel.errorMessage.isEmpty ? "No routine found." : viewModel.errorMessage)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle("Class Routine")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchRoutine()
        }
    }
}
