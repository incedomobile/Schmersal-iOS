

import Foundation

struct LanguageModel
 {
    var languageID: Int
    var languageCode: String
     var languageName: String
    
    init(langId:Int, langCode: String,
                langName: String) {
        self.languageID = langId
        self.languageCode = langCode
        self.languageName = langName
    }
}
