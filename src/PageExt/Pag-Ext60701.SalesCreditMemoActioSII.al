pageextension 60701 "Sales Credit Memo ActioSII" extends "Sales Credit Memo"
{
    layout
    {
        addafter("ABPSII Credit Memo Type")
        {
            field("ABPSII Excl Inf. Immed. Supply"; Rec."ABPSII Excl Inf. Immed. Supply")
            {
                ApplicationArea = All;
            }
        }
    }
}
