//
//  Tip.swift
//  Grocery List
//
//  Created by Dharti Savaliya on 11/1/25.
//

import Foundation
import TipKit

struct ButtonTip: Tip {
    
    var title: Text = Text("Essential Foods")
    var message: Text? = Text("Add some everyday item to shopping list.")
    var image: Image? = Image(systemName: "info.circle")
}
