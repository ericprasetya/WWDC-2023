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
            title: "Hi! Welcome To enCanting",
            desc: "This is an interactive app that helps you to understand the creation process of Batik from Indonesia"
        ),
        Chat(
            id: 1,
            title: "",
            desc: "Batik is the work of the Indonesian nation which is a blend of art and technology by the ancestors of the Indonesian people. Batik patterns are usually used on clothes. Batik Fabric is made either by drawing dots and lines from wax called **malam** in Javanese with a spouted tool called a **canting**. (source: bbkb.kemenperin.go.id)"
        ),
        Chat(
            id: 2,
            title: "\n\n\nNow Let's Get Started To Create Your First Batik!",
            desc: ""
        ),
        Chat(
            id: 3,
            title: "Use Canting To Trace Batik In Canvas",
            desc: "This activity is called **nembok** in Javanese language. We fill our canting with wax that already melted by using stove."
        ),
        Chat(
            id: 4,
            title: "Color Your Batik",
            desc: "After being covered with **malam**, we can color our batik without having to be afraid that the paint color will hit the pattern."
        ),
        Chat(
            id: 5,
            title: "Put Batik in Hot Water",
            desc: "Now we need to boil our batik fabric in hot water so that the wax that is on the cloth can melt and disappear."
        ),
        Chat(
            id: 6,
            title: "Wait For 5 Seconds To Melt The Wax",
            desc: ""
        ),
        Chat(
            id: 7,
            title: "You Are Done!",
            desc: "The wax has been removed and after we dry the batik cloth, the cloth is ready to be made into clothes."
        ),
        Chat(
            id: 8,
            title: "Thank You!!!",
            desc: "Before closing the application, please first read the fun facts about batik above. Once again, thank you!"
        )
    ]
}
