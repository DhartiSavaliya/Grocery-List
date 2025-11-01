//
//  ContentView.swift
//  Grocery List
//
//  Created by Dharti Savaliya on 10/31/25.
//
/** Note
 Multiline Coding
 1. select first letter then press shift+ control + downArrow
 2.then press shift+ command + sidearraow then commnd + c
 3.then whreever you want to write coding press downarraow howmany time you want to write a code
 4. then shift + control + uparraow then write code
 */
import SwiftUI
import SwiftData
import TipKit

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var item: String = ""
    @FocusState private var isFocused: Bool
    
    //-------------for tip-----------------------
    let buttonTip = ButtonTip()
    
    init() {
        setupTips()
    }
    func setupTips() {
        do {
            try Tips.resetDatastore()
            try Tips.configure([
                .displayFrequency(.immediate)
            ])
             Tips.showAllTipsForTesting()
        }catch {
            print("Error Initializing TipKit \(error.localizedDescription)")
        }
    }
    
    func addEssantialFoods(){
//        modelContext.insert(Item(title: "Backery", isCompleted: false))
//        modelContext.insert(Item(title: "Beans", isCompleted: true))
//        modelContext.insert(Item(title: "Sugar", isCompleted: .random()))
//        modelContext.insert(Item(title: "Veggies", isCompleted: .random()))
//        modelContext.insert(Item(title: "Milk and Butter", isCompleted: .random()))
    }
    
    var body: some View {
            NavigationStack {
    //------------------------ created item list
                List {
                    ForEach(items) { item in
                        Text(item.title)
                            .font(.title3.weight(.medium))
                            .padding(.vertical, 2)
                            .foregroundStyle(item.isCompleted == false ? Color.primary : Color.accentColor)
                            .strikethrough(item.isCompleted)
                        //---------swipe Actions-------------
                            .swipeActions{
                                Button(role: .destructive){
                                    withAnimation{
                                        modelContext.delete(item)
                                    }
                                }label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .swipeActions(edge: .leading){
                                Button("", systemImage: item.isCompleted == false ? "checkmark.circle": "x.circle"){
                
                                item.isCompleted.toggle()
                                    }.tint(item.isCompleted == false ? .green : .accentColor)
                            }
                    }
                }
                .navigationTitle("Grocery List")
                //--------Toolbar items
                .toolbar {
                    if items.isEmpty {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                               addEssantialFoods()
                            }label: {
                                Image(systemName: "carrot")
                            }
                            .popoverTip(buttonTip)
                        }
                    }
                }
                //--------Empty list screen----------------
                .overlay{
                    if items.isEmpty {
                        ContentUnavailableView("Empty Cart", systemImage: "cart.circle", description: Text("Add some items to the shopping list."))
                    }
                }
                
                //------------Textfield plus save data button -------------
                .safeAreaInset(edge: .bottom){
                    VStack(spacing: 12) {
                        TextField("",text: $item)
                            .textFieldStyle(.plain)
                            .padding(12)
                            .background(.tertiary)
                            .cornerRadius(12)
                            .font(.title.weight(.light))
                            .focused($isFocused)
                        Button {
                            guard !item.isEmpty else {
                                return
                            }
                           let newItem = Item(title: item, isCompleted: false)
                            modelContext.insert(newItem)
                            item = ""
                            isFocused = false
                            
                        } label:{
                            Text("Save")
                                .font(.title2.weight(.bold))
                                .frame(maxWidth: .infinity)
                            }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.roundedRectangle)
                        .controlSize(.extraLarge)
                        }.padding()
                        .background(.bar)
                    
                    
                    
                }
                
            }
        }
}

//-----------------------Preview----------------------------------------//

#Preview("Sample Data") {
    let sampleData: [Item] = [
        Item(title: "Backery", isCompleted: false),
        Item(title: "Beans", isCompleted: true),
        Item(title: "Sugar", isCompleted: .random()),
        Item(title: "Veggies", isCompleted: .random()),
        Item(title: "Milk and Butter", isCompleted: .random())
    ]
    let container = try! ModelContainer(for: Item.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    for item in sampleData {
        container.mainContext.insert(item)
    }
                                   
    return ContentView()
        .modelContainer(container)
}
#Preview("Empty List") {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
