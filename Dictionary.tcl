foreach fileName [getSourceFileNames] {
  #Read source file
  set scanFile [open $fileName r]
  set scanFileData [read $scanFile]
  close $scanFile

  #read Dictionary file
  set dictionary [open "dictionary.txt" r]
  set dictionaryData [read $dictionary]
  close $dictionary

  #Set array of allowed words
  set splittedDictionary [split $dictionaryData "\n"]

  #Get tokens of source file
  set fileTokens [getTokens $fileName 1 0 -1 -1 {}]

  foreach token $fileTokens {
    set value [lindex $token 0]
    set name [lindex $token 3]
    set line [lindex $token 1]
    set badWord 1
    #puts "$name - name of token"

    if {$name == "identifier"} {
      set pieces [regexp -all -inline {[a-z]+|[A-Z][a-z]*} $value]
      foreach piece $pieces {
        foreach goodWord $splittedDictionary {
          if {$goodWord == [string tolower $piece]} {
            set badWord 0
          }
        }
      }
      if {$badWord == 1} {
      report $fileName $line "Identificator '${value}' is not allowed"
      }
    }
  }
}
