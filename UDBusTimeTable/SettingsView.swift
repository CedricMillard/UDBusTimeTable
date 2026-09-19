//
//  SettingsView.swift
//  UDBusTimeTable
//
//  Created by Cedric Millard on 19/09/2026.
//

import SwiftUI
import WidgetKit

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var currentTime: Int
    
    @AppStorage("BusTimeBuffer", store: UserDefaults(suiteName: appGroupSuite)) private var BusTimeBuffer = 5
    @AppStorage("TrainTimeBuffer", store: UserDefaults(suiteName: appGroupSuite)) private var TrainTimeBuffer = 3
    //@AppStorage("TrainDirection", store: UserDefaults(suiteName: appGroupSuite)) private var TrainDirection = "Oomiya"
    @AppStorage("TrainDirection", store: UserDefaults(suiteName: appGroupSuite)) private var TrainDirection: UDBusTrainDirection = .toOomiya
    
    @AppStorage("AvoidShonanShinjuku", store: UserDefaults(suiteName: appGroupSuite)) private var AvoidShonanShinjuku = false
    //let directions = ["Oomiya", "Kagohara", "No Train"]
    
    var body: some View {
            
            VStack(spacing:1) {
                Text("Settings")
                    .font(.title)
                HStack{
                    Spacer()
                    Text("Bus Time Buffer")
                        .frame(width:150)
                    Picker("Buffer time to catch bus", selection: $BusTimeBuffer){
                        ForEach(0...15,id:\.self){number in
                        Text("\(number)")
                                .tag(number)
                        }
                    }
                    .pickerStyle(.wheel)
                    .labelsHidden()
                    .frame(width:150, height:100)
                    .onChange(of: BusTimeBuffer) { oldvalue, newvalue in
                        currentTime = Calendar.current.component(.hour, from: Date())*60 + Calendar.current.component(.minute, from: Date())
                        //WidgetCenter.shared.reloadTimelines(ofKind: "UDBusTimeTableWidget")
                    }
                    
                    Spacer()
                }
                HStack{
                    Spacer()
                    Text("Train Direction")
                        .frame(width:150)

                    Picker("Train Direction", selection: $TrainDirection){
                        ForEach(UDBusTrainDirection.allCases){dir in
                            Text(UDBusTrainDirection.caseDisplayRepresentations[dir]?.title ?? LocalizedStringResource(stringLiteral:  dir.rawValue))
                                .tag(dir)
                        }
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .frame(width:150)
                    .onChange(of: TrainDirection) { oldvalue, newvalue in
                        currentTime = Calendar.current.component(.hour, from: Date())*60 + Calendar.current.component(.minute, from: Date())
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                    Spacer()
                }
                HStack{
                    Spacer()
                    Text("Train Time Buffer")
                        .frame(width:150)

                    Picker("Buffer time to catch train", selection: $TrainTimeBuffer){
                        ForEach(0...15,id:\.self){number in
                        Text("\(number)")
                                .tag(number)
                        }
                    }
                    .pickerStyle(.wheel)
                    .labelsHidden()
                    .frame(width:150, height:100)
                    .onChange(of: TrainTimeBuffer) { oldvalue, newvalue in
                        currentTime = Calendar.current.component(.hour, from: Date())*60 + Calendar.current.component(.minute, from: Date())
                        //WidgetCenter.shared.reloadTimelines(ofKind: "UDBusTimeTableWidget")
                    }
                    Spacer()
                }
                .opacity(TrainDirection == .noTrain ? 0 : 1)
                
                Toggle("Avoid Shonan-Shinjuku or Rapid train",isOn:$AvoidShonanShinjuku)
                    .frame(width:300)
                    .opacity(TrainDirection == .noTrain ? 0 : 1)
                    .onChange(of: AvoidShonanShinjuku) { oldvalue, newvalue in
                        currentTime = Calendar.current.component(.hour, from: Date())*60 + Calendar.current.component(.minute, from: Date())
                        //WidgetCenter.shared.reloadAllTimelines()
                    }
                
            }
            .frame(height: 350)
            
            Spacer()
            Text("Provided to you by Cédric Millard")
                .italic()
                .font(.footnote)
                .foregroundColor(Color.gray)
        Text("UDBusTimeTable version \(Bundle.main.appVersion)")
            .italic()
            .font(.footnote)
            .foregroundColor(Color.gray)
    }
}
