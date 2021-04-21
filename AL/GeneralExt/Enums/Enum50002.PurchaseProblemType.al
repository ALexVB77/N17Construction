enum 50002 "Purchase Problem Type"
{
    Extensible = true;
    AssignmentCompatibility = true;

    value(0; " ") { Caption = ''; }
    value(1; "Mistake") { Caption = 'Mistake'; }
    value(2; "AgrMiss") { Caption = 'AgrMiss'; }
    value(3; "RController") { Caption = 'RController'; }
    value(4; "RChecker") { Caption = 'RChecker'; }
    value(5; "RApprover") { Caption = 'RApprover'; }
    value(6; "REstimator") { Caption = 'REstimator'; }
    value(7; "Act error") { Caption = 'Act error'; }
}