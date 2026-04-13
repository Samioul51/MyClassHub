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
        ZStack {
            
            // MARK: BACKGROUND (NEW THEME)
            Color(hex: "#110e07")
                .ignoresSafeArea()
            
            Group {
                
                if viewModel.isLoading {
                    
                    ProgressView("Loading routine...")
                        .tint(Color(hex: "#8dedec"))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                } else if let _ = viewModel.routine {
                    
                    VStack(spacing: 0) {
                        
                        // MARK: SECTION PICKER (THEMED)
                        Picker("Section", selection: $viewModel.selectedSection) {
                            ForEach(viewModel.availableSections, id: \.self) { sec in
                                Text(sec)
                                    .foregroundColor(Color(hex: "#8dedec"))
                                    .tag(sec)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                        .padding(.bottom, 8)
                        .tint(Color(hex: "#8dedec"))
                        
                        // MARK: DAY PICKER (THEMED CHIPS)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                
                                ForEach(viewModel.days, id: \.self) { day in
                                    
                                    Button(action: {
                                        viewModel.selectedDay = day
                                    }) {
                                        Text(String(day.prefix(3)).uppercased())
                                            .font(.system(size: 12, weight: .bold, design: .rounded))
                                            .foregroundColor(
                                                viewModel.selectedDay == day
                                                ? Color(hex: "#110e07")
                                                : .white.opacity(0.7)
                                            )
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 8)
                                            .background(
                                                viewModel.selectedDay == day
                                                ? Color(hex: "#8dedec")
                                                : Color(hex: "#16130b")
                                            )
                                            .cornerRadius(20)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                        }
                        
                        Divider()
                            .background(Color.white.opacity(0.1))
                        
                        // MARK: SCHEDULE LIST (UNCHANGED STRUCTURE)
                        if let daySchedule = viewModel.currentDaySchedule,
                           !daySchedule.slots.isEmpty {
                            
                            ScrollView {
                                
                                VStack(spacing: 12) {
                                    
                                    ForEach(daySchedule.slots) { slot in
                                        
                                        ClassSlotCard(slot: slot)
                                    }
                                    
                                    // ROOM INFO FOOTER
                                    if !viewModel.currentRoomInfo.isEmpty {
                                        Text("📍 \(viewModel.currentRoomInfo)")
                                            .font(.system(size: 12))
                                            .foregroundColor(.white.opacity(0.5))
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal, 16)
                                            .padding(.bottom, 10)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.top, 12)
                            }
                            
                        } else {
                            
                            VStack(spacing: 10) {
                                
                                Image(systemName: "calendar.badge.checkmark")
                                    .font(.system(size: 48))
                                    .foregroundColor(Color(hex: "#8dedec"))
                                
                                Text("No classes on \(viewModel.selectedDay)")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    
                } else {
                    
                    VStack(spacing: 10) {
                        
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 40))
                            .foregroundColor(.orange)
                        
                        Text(viewModel.errorMessage.isEmpty ? "No routine found." : viewModel.errorMessage)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Class Routine")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#8dedec"))
            }
        }
        .tint(Color(hex: "#8dedec"))
        .task {
            await viewModel.fetchRoutine()
        }
            }
}


   
