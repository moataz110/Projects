<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddPhoneNumber.aspx.cs" Inherits="milestone_3.AddPhoneNumber" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            Add your phone number
            <br />
            <br />
            ID
            <br />
            <asp:TextBox ID="id" runat="server"></asp:TextBox>
            <br />
            Phone number<br />
            <asp:TextBox ID="phone" runat="server"></asp:TextBox>
            <br />
            <br />
            <asp:Button ID="add" runat="server" Text="Add" OnClick="add_Click" />
            <br />
        </div>
    </form>
</body>
</html>
