pageextension 60703 "ABPSII Hist Salvi" extends "ABPSII HistInfImmedSupplyDocs."
{
    layout
    {
        addafter("Document No.")
        {
            field("Business Posting Group"; Rec."Business Posting Group")
            {
                Caption = 'Business Posting Group';
                ApplicationArea = All;
            }
        }
    }
}
