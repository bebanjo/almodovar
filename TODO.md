* Let tests pass both in Ruby and JRuby
* Rethink how factories are made, maybe its more obvious to have other kind of conditional code (see how other examples are made)
  How about..
    |_ Aleternatives
        |_ MRI
        |_ Jruby

  And a more comprehensive syntax for factories, like 
    Almodovar::JSONParser, Almodovar::RackHelper, Almodovar::HttpSession
