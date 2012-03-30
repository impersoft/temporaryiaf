inherited KRDMRelatorio: TKRDMRelatorio
  OldCreateOrder = True
  MyFormClass = 'TKRFMRelatorio'
  inherited ACLI: TActionList
    object ACTN_1: TAction
      Caption = 'ACTN_1'
      OnExecute = ACTN_1Execute
    end
    object ACTN_2: TAction
      Caption = 'ACTN_2'
      OnExecute = ACTN_2Execute
    end
    object ACTN_3: TAction
      Caption = 'ACTN_3'
      OnExecute = ACTN_3Execute
    end
    object ACTN_4: TAction
      Caption = 'ACTN_4'
      OnExecute = ACTN_4Execute
    end
    object ACTN_5: TAction
      Caption = 'ACTN_5'
      OnExecute = ACTN_5Execute
    end
    object ACTN_6: TAction
      Caption = 'ACTN_6'
      OnExecute = ACTN_6Execute
    end
  end
  object ACMA: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Items = <
              item
                Action = ACTN1
                Caption = '&ACTN1'
              end
              item
                Action = ACTN2
                Caption = 'A&CTN2'
              end
              item
                Action = ACTN3
                Caption = 'AC&TN3'
              end>
            Caption = '&Submenu de relat'#243'rio 1'
          end
          item
            Items = <
              item
                Action = ACTN4
                Caption = '&ACTN4'
              end
              item
                Action = ACTN5
                Caption = 'A&CTN5'
              end
              item
                Action = ACTN6
                Caption = 'AC&TN6'
              end>
            Caption = 'S&ubmenu de relat'#243'rio 2'
          end>
        ActionBar = KRFMRelatorio.ACMB
      end>
    Left = 30
    Top = 66
    StyleName = 'Platform Default'
    object ACTN1: TAction
      Category = 'Submenu de relat'#243'rio 1'
      Caption = 'ACTN1'
      OnExecute = ACTN1Execute
    end
    object ACTN2: TAction
      Category = 'Submenu de relat'#243'rio 1'
      Caption = 'ACTN2'
    end
    object ACTN3: TAction
      Category = 'Submenu de relat'#243'rio 1'
      Caption = 'ACTN3'
    end
    object ACTN4: TAction
      Category = 'Submenu de relat'#243'rio 2'
      Caption = 'ACTN4'
    end
    object ACTN5: TAction
      Category = 'Submenu de relat'#243'rio 2'
      Caption = 'ACTN5'
    end
    object ACTN6: TAction
      Category = 'Submenu de relat'#243'rio 2'
      Caption = 'ACTN6'
    end
  end
end
