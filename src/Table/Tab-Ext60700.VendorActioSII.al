tableextension 60700 "Vendor ActioSII" extends Vendor
{
    fields
    {
        field(60700; "ABPSII Purch. Inv. Default"; Code[20])
        {
            Caption = 'ABPSII Purch. Inv. Default';
            DataClassification = ToBeClassified;
            TableRelation = "ABPSII IIS Setup Table"."Code" where(Type = const("Purchase Document Type"));
        }
        field(60701; "ABPSII Purch. Cr. Memo Default"; Code[20])
        {
            Caption = 'ABPSII Purch. Cr. Memo Default';
            DataClassification = ToBeClassified;
            TableRelation = "ABPSII IIS Setup Table"."Code" where(Type = const("Purchase Document Type"));
        }
    }
}
