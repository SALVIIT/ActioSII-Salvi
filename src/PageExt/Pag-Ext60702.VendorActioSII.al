pageextension 60702 "Vendor ActioSII" extends "Vendor Card"
{
    layout
    {
        addafter("ABPSII VAT Registration Type")
        {
            field("ABPSII Purch. Inv. Default"; Rec."ABPSII Purch. Inv. Default")
            {
                ApplicationArea = All;
            }
            field("ABPSII Purch. Cr. Memo Default"; Rec."ABPSII Purch. Cr. Memo Default")
            {
                ApplicationArea = All;
            }
        }
    }
}
