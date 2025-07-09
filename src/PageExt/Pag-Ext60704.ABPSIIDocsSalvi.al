pageextension 60704 "ABPSII DocsSalvi" extends "ABPSII InformImmedSupplyDocs."
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
