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

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    func addEssantialFoods(){
        modelContext.insert(Item(title: "Backery", isCompleted: false))
        modelContext.insert(Item(title: "Beans", isCompleted: true))
        modelContext.insert(Item(title: "Sugar", isCompleted: .random()))
        modelContext.insert(Item(title: "Veggies", isCompleted: .random()))
        modelContext.insert(Item(title: "Milk and Butter", isCompleted: .random()))
    }
    
    var body: some View {
            NavigationStack {
                List {
                    ForEach(items) { item in
                        Text(item.title)
                            .font(.title3.weight(.medium))
                            .padding(.vertical, 2)
                            .foregroundStyle(item.isCompleted == false ? Color.primary : Color.accentColor)
                            .strikethrough(item.isCompleted)
                    }
                }
                .navigationTitle("Grocery List")
                .toolbar {
                    if items.isEmpty {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                               addEssantialFoods()
                            }label: {
                                Label("Essentials", systemImage: "carrot")
                            }
                        }
                    }
                }
                .overlay{
                    if items.isEmpty {
                        ContentUnavailableView("Empty Cart", systemImage: "cart.circle", description: Text("Add some items to the shopping list."))
                    }
                }
            }
        }
}

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
