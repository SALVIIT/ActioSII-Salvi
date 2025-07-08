codeunit 60700 "ActioSII Subscribers"
{
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", OnBeforeInsertEvent, '', false, false)]
    local procedure OnAfterInsertPurchaseHeader(var Rec: Record "Purchase Header")
    begin
        SetDefaultPurchaseDocument(Rec);
        SetExcludeImmediateSupply(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", OnBeforeModifyEvent, '', false, false)]
    local procedure OnAfterModifyPurchaseHeader(var Rec: Record "Purchase Header"; xRec: Record "Purchase Header")
    begin
        if Rec."Buy-from Vendor No." <> xRec."Buy-from Vendor No." then
            SetDefaultPurchaseDocument(Rec);
        if Rec."Posting No. Series" <> xRec."Posting No. Series" then
            SetExcludeImmediateSupply(Rec, xRec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnBeforeInsertEvent, '', false, false)]
    local procedure OnAfterInsertSalesHeader(var Rec: Record "Sales Header")
    begin
        SetExcludeImmediateSupply(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnBeforeModifyEvent, '', false, false)]
    local procedure OnAfterModifySalesHeader(var Rec: Record "Sales Header"; xRec: Record "Sales Header")
    begin
        if Rec."Posting No. Series" <> xRec."Posting No. Series" then
            SetExcludeImmediateSupply(Rec, xRec);
    end;

    local procedure SetDefaultPurchaseDocument(var PurchaseHeader: Record "Purchase Header")
    var
        Vendor: Record Vendor;
    begin
        if PurchaseHeader."Buy-from Vendor No." = '' then
            exit;

        if not Vendor.Get(PurchaseHeader."Buy-from Vendor No.") then
            exit;

        case PurchaseHeader."Document Type" of
            PurchaseHeader."Document Type"::Invoice:
                begin
                    if Vendor."ABPSII Purch. Inv. Default" <> '' then
                        PurchaseHeader.Validate("ABPSII Purchase Document", Vendor."ABPSII Purch. Inv. Default");
                end;
            PurchaseHeader."Document Type"::"Credit Memo":
                begin
                    if Vendor."ABPSII Purch. Cr. Memo Default" <> '' then
                        PurchaseHeader.Validate("ABPSII Purchase Document", Vendor."ABPSII Purch. Cr. Memo Default");
                end;
        end;
    end;

    local procedure SetExcludeImmediateSupply(var PurchaseHeader: Record "Purchase Header")
    var
        NoSeries: Record "No. Series";
    begin
        if PurchaseHeader."Posting No. Series" = '' then
            exit;

        if not IsPurchaseInvoiceOrCreditMemo(PurchaseHeader."Document Type") then
            exit;

        if NoSeries.Get(PurchaseHeader."Posting No. Series") then
            PurchaseHeader."ABPSII Exc Inf. Immed. Supply" := NoSeries."ABPSII Exc Inf. Immed. Supply";
    end;

    local procedure SetExcludeImmediateSupply(var PurchaseHeader: Record "Purchase Header"; xPurchaseHeader: Record "Purchase Header")
    var
        NoSeries: Record "No. Series";
        OldNoSeries: Record "No. Series";
    begin
        if PurchaseHeader."Posting No. Series" = '' then
            exit;

        if not IsPurchaseInvoiceOrCreditMemo(PurchaseHeader."Document Type") then
            exit;

        // Solo aplicar si el valor actual coincide con el valor anterior de la serie numérica
        if xPurchaseHeader."Posting No. Series" <> '' then
            if OldNoSeries.Get(xPurchaseHeader."Posting No. Series") then
                if PurchaseHeader."ABPSII Exc Inf. Immed. Supply" <> OldNoSeries."ABPSII Exc Inf. Immed. Supply" then
                    exit; // El usuario ha modificado manualmente el valor, no sobrescribir

        if NoSeries.Get(PurchaseHeader."Posting No. Series") then
            PurchaseHeader."ABPSII Exc Inf. Immed. Supply" := NoSeries."ABPSII Exc Inf. Immed. Supply";
    end;

    local procedure SetExcludeImmediateSupply(var SalesHeader: Record "Sales Header")
    var
        NoSeries: Record "No. Series";
    begin
        if SalesHeader."Posting No. Series" = '' then
            exit;

        if not IsSalesInvoiceOrCreditMemo(SalesHeader."Document Type") then
            exit;

        if NoSeries.Get(SalesHeader."Posting No. Series") then
            SalesHeader."ABPSII Excl Inf. Immed. Supply" := NoSeries."ABPSII Exc Inf. Immed. Supply";
    end;

    local procedure SetExcludeImmediateSupply(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header")
    var
        NoSeries: Record "No. Series";
        OldNoSeries: Record "No. Series";
    begin
        if SalesHeader."Posting No. Series" = '' then
            exit;

        if not IsSalesInvoiceOrCreditMemo(SalesHeader."Document Type") then
            exit;

        // Solo aplicar si el valor actual coincide con el valor anterior de la serie numérica
        if xSalesHeader."Posting No. Series" <> '' then
            if OldNoSeries.Get(xSalesHeader."Posting No. Series") then
                if SalesHeader."ABPSII Excl Inf. Immed. Supply" <> OldNoSeries."ABPSII Exc Inf. Immed. Supply" then
                    exit; // El usuario ha modificado manualmente el valor, no sobrescribir

        if NoSeries.Get(SalesHeader."Posting No. Series") then
            SalesHeader."ABPSII Excl Inf. Immed. Supply" := NoSeries."ABPSII Exc Inf. Immed. Supply";
    end;

    local procedure IsPurchaseInvoiceOrCreditMemo(DocumentType: Enum "Purchase Document Type"): Boolean
    begin
        exit((DocumentType = DocumentType::Invoice) or (DocumentType = DocumentType::"Credit Memo"));
    end;

    local procedure IsSalesInvoiceOrCreditMemo(DocumentType: Enum "Sales Document Type"): Boolean
    begin
        exit((DocumentType = DocumentType::Invoice) or (DocumentType = DocumentType::"Credit Memo"));
    end;
}
