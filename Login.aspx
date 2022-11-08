<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="milestone_3.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    

    <form id="form1" runat="server">
        <div>
            Login<br />
            <br />
            email:</div>
        <asp:TextBox ID="email" runat="server" ></asp:TextBox>
        <br />
        password:
        <br />

        <asp:TextBox ID="password" runat="server"></asp:TextBox>
        <br /> <br />
        <asp:Button ID="signin" runat="server" OnClick="login" Text="log in" />
        <br />
        <br />

        <asp:Button ID="phone" runat="server" OnClick="AddPhone" Text="Add your number" Width="148px" Height="35px" />

        <br />

        <br />
        <asp:DropDownList ID="DDLog" runat="server">
            <asp:ListItem>Student</asp:ListItem>
            <asp:ListItem>Admin</asp:ListItem>
            <asp:ListItem>Supervisor</asp:ListItem>
            <asp:ListItem></asp:ListItem>
        </asp:DropDownList>
        <br />
        <br />
      
        <asp:Button ID="register" runat="server" OnClick="Register" Text="Register" />
      
    </form>
</body>
</html>
