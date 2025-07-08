pageextension 60700 "BookkeeperRoleCenter ActioSII" extends "Bookkeeper Role Center"
{
    layout
    {
        addbefore(Control1901197008)
        {
            part("SII"; "ABPSII InformImmedSupplyCue2")
            {
                ApplicationArea = All;
            }
        }
    }
}
