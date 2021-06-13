page 70228 "CRM Company"
{
    SourceTable = "CRM Company";
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'CRM Copmany';


    layout
    {
        area(content)
        {
            repeater(Repeater12370003)
            {
                field("Project Guid"; Rec."Project Guid")
                {
                    ApplicationArea = All;

                }

                field("Project Name"; Rec."Project Name")
                {
                    ApplicationArea = All;

                }

                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = All;

                }



            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Test)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    d1: Dictionary of [Text, Dictionary of [Text, Text]];
                    d2: Dictionary of [Text, Text];

                begin
                    d2.Add('key', 'value');
                    d1.Add('table', d2);
                    if not TestedDict(d1) then begin
                        Message(GetLastErrorText());
                        Message(GetLastErrorCode());
                    end;

                    TestedDict(d1);
                end;
            }

            action(Test2)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    pf: Record "CRM Prefetched Object";
                begin
                    pf.Init();
                    pf.Id := CreateGuid();
                    pf.Insert();

                    pf.TestField(Xml);

                end;
            }
        }
    }

    [TryFunction]
    local procedure TestedDict(var dict1: Dictionary of [Text, Dictionary of [Text, Text]])
    var
        dict2: Dictionary of [Text, Text];
        Str: Text;
    begin
        dict1.Get('table', dict2);
        dict2.Get('key1', Str);
    end;



}
