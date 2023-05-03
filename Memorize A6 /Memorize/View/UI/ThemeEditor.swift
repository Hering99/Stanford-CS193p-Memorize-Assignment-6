//
//  ThemeEditor.swift
//  Memorize
//
//  Created by Lukas Hering on 27.03.23.
//

import SwiftUI

//View that opens when Theme gets edited
struct ThemeEditor: View {
    @Binding var theme: Theme
    @Environment(\.presentationMode) private var presentationMode
    private let emojiFontSize: CGFloat = 40
    
    var body: some View {
        NavigationView {
                Form {
                    nameSection
                    removeEmojiSection
                    addEmojiSection
                    changeNumberOfPairsOfCardsSection
                    colorPickerSection
                }
                .navigationTitle("\(name)")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) { cancelButton }
                    ToolbarItem { doneButton }
                }
            }
    }
    
    // MARK: - Save Or Cancel Section
    
    private var doneButton: some View {
        Button("Done") {
            //replace PresentationMode here and in ThemeSelector!!!!!!!!!!!!!!!!
            if presentationMode.wrappedValue.isPresented && emojiContender.count >= 2 {
                saveEdits()
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            if presentationMode.wrappedValue.isPresented {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private func saveEdits() {
        theme.name = name
        theme.emojis = emojiContender
        theme.numberOfPairsOfCards = min(numberOfPairs, emojiContender.count)
        theme.color = RGBAColor(color: newColor)
    }
    
    // MARK: - Initializer
    
    init(theme: Binding<Theme>) {
        self._theme = theme
        self._name = State(initialValue: theme.wrappedValue.name)
        self._emojiContender = State(initialValue: theme.wrappedValue.emojis)
        self._numberOfPairs = State(initialValue: theme.wrappedValue.numberOfPairsOfCards)
        self._newColor = State(initialValue: Color(rgbaColor: theme.wrappedValue.color))
    }
    
    // MARK: - Name Section
    
    @State private var name: String
    
    private var nameSection: some View {
        Section(header: Text("THEME NAME").bold()) {
            TextField("Emoji", text: $name)
        }
    }
    
    // MARK: - Remove Emojis Section
    
    @State private var emojiContender: String = ""
    
    private var removeEmojiSection: some View {
        //let emojis = theme.emojis.map { String($0) }
        
        return Section(header: HStack {
            Text("EMOJIS").bold()
            Spacer()
            Text("TAP TO REMOVE").bold()
        })
            {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: emojiFontSize))]) {
                ForEach(emojiContender.map { String($0) }, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                if emojiContender.count > 2 {
                                    emojiContender.removeAll(where: { String($0) == emoji })
                                }
                            }
                        }
                }
            }
            .font(.system(size: emojiFontSize))
        }
    }
    
    // MARK: - Add Emojis Section
    
    @State private var newEmojis = ""
    
    private var addEmojiSection: some View {
        Section(header: Text("ADD EMOJIS").bold()) {
            TextField("Emoji", text: $newEmojis)
                .onChange(of: newEmojis) { emoji in
                    addEmojis(emoji)
                }
        }
    }
    
    private func addEmojis(_ emojis: String) {
        withAnimation {
            emojiContender = (emojis + emojiContender)
                .filter { $0.isEmoji }
                .removingDuplicateCharacters
        }
    }
    
    // MARK: - Change Number Of Pairs Section
    
    @State private var numberOfPairs: Int
    
    private var changeNumberOfPairsOfCardsSection: some View {
        Section(header: Text("CARD COUNT").bold() ) {
            Stepper("\(numberOfPairs) Pairs", value: $numberOfPairs, in: emojiContender.count < 2 ? 2 ... 2 : 2...emojiContender.count)
                .onChange(of: emojiContender ) { _ in
                    numberOfPairs = max(2, min(numberOfPairs, emojiContender.count))
                }
        }
    }
    
    // MARK: - Change Color Section
    
    @State var newColor: Color = .red
    
    private var colorPickerSection: some View {
        return Section(header: Text("COLOR").bold() ) {
            ColorPicker("Current Color", selection: $newColor, supportsOpacity: false).foregroundColor(newColor)
        }
    }
}

struct ThemeEditor_Previews: PreviewProvider {
    
    static var previews: some View {
        ThemeEditor(theme: .constant(ThemeStore(named: "previews").theme(at: 0)))
    }
}

