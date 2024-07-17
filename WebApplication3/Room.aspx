<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Room.aspx.cs" Inherits="WebApplication3.Room" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
        <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
        </div>
        <asp:Label ID="Label13" runat="server" Text="Go back to home page:"></asp:Label>
        <br />
        <asp:Button ID="Homepg" runat="server" Text="Home Page" OnClick="Homepg_Click" />
        <br />
        <br />
        <asp:Label ID="Label1" runat="server" Text="Room info:"></asp:Label>
        <p>
            <asp:GridView ID="RoomInfo" runat="server" AutoGenerateColumns="false">
                <Columns>
        <asp:BoundField DataField="room_id" HeaderText="Room ID" SortExpression="room_id" />
        <asp:BoundField DataField="type" HeaderText="Type" SortExpression="type" />
        <asp:BoundField DataField="floor" HeaderText="Floor" SortExpression="floor" />
        <asp:BoundField DataField="status" HeaderText="Status" SortExpression="status" />
    </Columns>
            </asp:GridView>

        </p>
        <p>
            <asp:Label ID="Label3" runat="server" Text="Need to book a room?"></asp:Label>
        </p>
        <asp:Label ID="Label4" runat="server" Text="Please state the room you want to book:"></asp:Label>
        <asp:TextBox ID="bookingN" runat="server"></asp:TextBox>
        <br />
        <br />
        <asp:Label ID="ErrorMessageLabel1" runat="server" ForeColor="Red" Visible="false"></asp:Label>

        <br />

        <br />

        <asp:Panel runat="server" ID="AdminPanel">
    <!-- Controls inside this panel will only be visible if IsUserAdmin() returns true -->
    <asp:Label runat="server" ID="AdminLabel" Text="Create room schedule:" />
            <br />
            <asp:Label ID="Label5" runat="server" Text="Room Number:   "></asp:Label>
            <asp:TextBox ID="RoomNum1" runat="server" ></asp:TextBox>
            <br />
            <asp:Label ID="Label6" runat="server" Text="Room Event Start: "></asp:Label>
            &nbsp;<br />
            <asp:Calendar ID="REstart" runat="server" BackColor="White" BorderColor="#3366CC" BorderWidth="1px" CellPadding="1" DayNameFormat="Shortest" Font-Names="Verdana" Font-Size="8pt" ForeColor="#003399" Height="200px" Width="220px">
                <DayHeaderStyle BackColor="#99CCCC" ForeColor="#336666" Height="1px" />
                <NextPrevStyle Font-Size="8pt" ForeColor="#CCCCFF" />
                <OtherMonthDayStyle ForeColor="#999999" />
                <SelectedDayStyle BackColor="#009999" Font-Bold="True" ForeColor="#CCFF99" />
                <SelectorStyle BackColor="#99CCCC" ForeColor="#336666" />
                <TitleStyle BackColor="#003399" BorderColor="#3366CC" BorderWidth="1px" Font-Bold="True" Font-Size="10pt" ForeColor="#CCCCFF" Height="25px" />
                <TodayDayStyle BackColor="#99CCCC" ForeColor="White" />
                <WeekendDayStyle BackColor="#CCCCFF" />
            </asp:Calendar>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <br />
            <asp:Label ID="Label7" runat="server" Text="Room Event Finish: "></asp:Label>
            <br />
            <br />
            <asp:Calendar ID="REend" runat="server" BackColor="#FFFFCC" BorderColor="#FFCC66" BorderWidth="1px" DayNameFormat="Shortest" Font-Names="Verdana" Font-Size="8pt" ForeColor="#663399" Height="200px" ShowGridLines="True" Width="220px">
                <DayHeaderStyle BackColor="#FFCC66" Font-Bold="True" Height="1px" />
                <NextPrevStyle Font-Size="9pt" ForeColor="#FFFFCC" />
                <OtherMonthDayStyle ForeColor="#CC9966" />
                <SelectedDayStyle BackColor="#CCCCFF" Font-Bold="True" />
                <SelectorStyle BackColor="#FFCC66" />
                <TitleStyle BackColor="#990000" Font-Bold="True" Font-Size="9pt" ForeColor="#FFFFCC" />
                <TodayDayStyle BackColor="#FFCC66" ForeColor="White" />
            </asp:Calendar>
            <br />
            <asp:Label ID="Label8" runat="server" Text="Action:"></asp:Label>
            <asp:TextBox ID="R_action" runat="server"></asp:TextBox>
            <br />
            <br />
            <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Create Schedule" />
            <br />
            <asp:Label ID="ErrorMessageLabel2" runat="server" ForeColor="Red" Visible="false"></asp:Label>
            <br />
            <br />
            <asp:Label ID="Label9" runat="server" Text="Change room status:"></asp:Label>
            <br />
            <asp:Label ID="Label10" runat="server" Text="Room Number: "></asp:Label>
            <asp:TextBox ID="RoomNum2" runat="server" ></asp:TextBox>
            <br />
            <asp:Label ID="Label11" runat="server" Text="New Status: "></asp:Label>
            <asp:DropDownList ID="NewStat" runat="server">
                <asp:ListItem>Vacant</asp:ListItem>
                <asp:ListItem>Occupied</asp:ListItem>
            </asp:DropDownList>
            <br />
            <asp:Button ID="statusB" runat="server" Text="Change status" OnClick="Button2_Click" />
            <br />
            <asp:Label ID="ErrorMessageLabel3" runat="server" ForeColor="Red" Visible="false"></asp:Label>
            <br />
            <br />
            <asp:Label ID="Label12" runat="server" Text="Vacant rooms: "></asp:Label>
            <br />
            <br />
            <asp:GridView ID="VacRooms" runat="server" AutoGenerateColumns="false">
                 <Columns>
                    <asp:BoundField DataField="room_id" HeaderText="Room ID" SortExpression="room_id" />
                    <asp:BoundField DataField="type" HeaderText="Type" SortExpression="type" />
                    <asp:BoundField DataField="floor" HeaderText="Floor" SortExpression="floor" />
                    <asp:BoundField DataField="status" HeaderText="Status" SortExpression="status" />
                </Columns>
            </asp:GridView>

            <br />
</asp:Panel>

    </form>
</body>
</html>
