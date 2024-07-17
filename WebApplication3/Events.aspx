<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Events.aspx.cs" Inherits="WebApplication3.Events" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
       <title>Events Page</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            Events page :<br />
            <br />
        </div>
        <p>
            <asp:Button ID="create_eventbtn" runat="server" Text="Create Event" Height="56px" Width="145px" OnClick="Button1_Click1" />
        </p>
        <p>
            <asp:Button ID="Assign_userbtn" runat="server" Height="44px" OnClick="Button2_Click" Text="Assign User" Width="141px" />
        </p>
        <p>
            <asp:Button ID="uninvite_user" runat="server" Height="47px" Text="Uninvite User" Width="143px" OnClick="Button3_Click" />
        </p>
        <p>
            <asp:Button ID="view_eventbtn" runat="server" Height="45px" OnClick="Button4_Click" Text="View Event" Width="147px" />
        </p>
        <p>
            <asp:Button ID="Remove_eventbtn" runat="server" Height="45px" Text="Remove Event" Width="139px" OnClick="RemoveEvent_Click" />
        </p>
    </form>
</body>
</html>
