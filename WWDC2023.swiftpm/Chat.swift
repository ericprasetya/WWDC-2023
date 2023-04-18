//
//  Chat.swift
//  WWDC2023
//
//  Created by Eric Prasetya Sentosa on 18/04/23.
//

import SwiftUI

struct Chat {
    var id: Int
    var title: String
    var desc: String
}

extension Chat {
    static let all = [
        Chat(
            id: 0,
            title: "Hi! Welcome to enCanting",
            desc: "This is an interactive app that helps you to understand the creation process of Batik from Indonesia"
        ),
        Chat(
            id: 1,
            title: "",
            desc: "Batik is an Indonesian technique of wax-resist (called 'malam' in Javanese)  dyeing applied to the whole cloth. This technique originated from the island of Java, Indonesia. Batik is made either by drawing dots and lines of the resist with a spouted tool called a canting"
        ),
        Chat(
            id: 2,
            title: "\n\n\nNow let's get started to create your first batik!",
            desc: ""
        ),
        Chat(
            id: 3,
            title: "Use Canting to trace batik from the image in canvas",
            desc: "This activity is called with \'nembok\' in Javanese language. We fill our canting with wax that already melted by using stove"
        ),
        Chat(
            id: 4,
            title: "Drag and Drop Color",
            desc: "After the pattern is covered with malam, now we can color our batik without having to be afraid that the paint color will hit the pattern"
        ),
        Chat(
            id: 5,
            title: "Put Batik in Hot Water",
            desc: "Now we need to boil our batik cloth in hot water so that the wax that is on the cloth can melt and disappeared"
        ),
        Chat(
            id: 6,
            title: "Wait for 5 seconds to melt the wax",
            desc: ""
        ),
        Chat(
            id: 7,
            title: "You Are Done!",
            desc: "The wax has been removed and after we dry the batik fabric, it will finished"
        )
    ]
}
