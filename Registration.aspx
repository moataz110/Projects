<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Registration.aspx.cs" Inherits="milestone_3.Registration" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
           
            
            
            First Name<br />
            <asp:TextBox ID="firstname" runat="server"></asp:TextBox>
            <br />
            <br />
            Last Name<br />
            <asp:TextBox ID="lastname" runat="server"></asp:TextBox>
            <br />
            <br />
            Faculty
            <br />
            <asp:TextBox ID="faculty" runat="server"></asp:TextBox>
            <br />
            <br />
            
           &nbsp;Address<br />
            <asp:TextBox ID="address" runat="server"></asp:TextBox>
            <br />
            <br />
            Email<br />
            <asp:TextBox ID="email" runat="server"></asp:TextBox>
            <br />
            <br />
            Password<br />
            <asp:TextBox ID="password" runat="server"></asp:TextBox>
            <br />
            
            <br />
            Please choose your category<br />
            <asp:DropDownList ID="DD" runat="server">
                <asp:ListItem>GUCian</asp:ListItem>
                <asp:ListItem>NonGUCian</asp:ListItem>
          
            </asp:DropDownList >
            <br />
            <br />
             <asp:Button ID="signup" runat="server" OnClick="Register"  Text="Submit" />
        </div>
       
    </form>
</body>
</html>
