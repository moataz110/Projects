<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SupervisorRegistration.aspx.cs" Inherits="milestone_3.SupervisorRegistration" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        
        
        <br />
        Please Register<br />
        <br />
        First Name<br />
        <asp:TextBox ID="firstname" runat="server"></asp:TextBox>
        <br />
        <br />
        Last Name<br />
        <asp:TextBox ID="lastname" runat="server"></asp:TextBox>
        <br />
        <br />
        Password<br />
        <asp:TextBox ID="password" runat="server"></asp:TextBox>
        <br />
        <br />
        Faculty<br />
        <asp:TextBox ID="faculty" runat="server"></asp:TextBox>
        <br />
        <br />
        Email<br />
        <asp:TextBox ID="email" runat="server"></asp:TextBox>
        <br />
        <br />
        <asp:Button ID="submit" OnClick="Submit" runat="server" Text="Submit" />
        <p>
        </p>
    </form>
</body>
</html>
