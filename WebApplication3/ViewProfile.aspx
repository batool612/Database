<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewProfile.aspx.cs" Inherits="WebApplication3.Viewprofile" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
        <title></title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }

        h1 {
            text-align: center;
            color: #333;
        }

        #formContainer {
            width: 600px;
            margin: 50px auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        label {
            display: block;
            margin-top: 10px;
            color: #555;
        }

        div {
            margin-bottom: 20px;
        }

        #guestInfoContainer {
            margin-top: 20px;
        }

        #guestInfoContainer label {
            display: block;
            margin-top: 10px;
            color: #555;
        }

        #guestInfoContainer label + label {
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <h1>Welcome To Your Profile Page</h1>
    <form id="form1" runat="server">
        <div id="formContainer">
            <div>
                <label for="lblFirstName">First Name:</label>
                <asp:Label ID="lblFirstName" runat="server"></asp:Label>
            </div>
            <div>
                <label for="lblLastName">Last Name:</label>
                <asp:Label ID="lblLastName" runat="server"></asp:Label>
            </div>
            <div>
                <label for="lblEmail">Email:</label>
                <asp:Label ID="lblEmail" runat="server"></asp:Label>
            </div>
            <div>
                <label for="lblPreference">Preference:</label>
                <asp:Label ID="lblPreference" runat="server"></asp:Label>
            </div>
            <div>
                <label for="lblType">Type:</label>
                <asp:Label ID="lblType" runat="server"></asp:Label>
            </div>
            <div>
                <label for="lblAge">Age:</label>
                <asp:Label ID="lblAge" runat="server"></asp:Label>
            </div>
            <div>
                <label for="lblBirthdate">Birthdate:</label>
                <asp:Label ID="lblBirthdate" runat="server"></asp:Label>
            </div>
            <div>
                <label for="lblRoom">Room:</label>
                <asp:Label ID="lblRoom" runat="server"></asp:Label>
            </div>

            <!-- Additional labels for admin information -->
            <div>
                <label for="lblNoOfGuestsAllowed">Number of Guests Allowed:</label>
                <asp:Label ID="lblNoOfGuestsAllowed" runat="server"></asp:Label>
            </div>
            <div>
                <label for="lblSalary">Salary:</label>
                <asp:Label ID="lblSalary" runat="server"></asp:Label>
            </div>

            <!-- Additional labels for guest information -->
            <div id="guestInfoContainer">
                <label for="lblAddress">Address:</label>
                <asp:Label ID="lblAddress" runat="server"></asp:Label>

                <label for="lblArrivalDate">Arrival Date:</label>
                <asp:Label ID="lblArrivalDate" runat="server"></asp:Label>

                <label for="lblDepartureDate">Departure Date:</label>
                <asp:Label ID="lblDepartureDate" runat="server"></asp:Label>

                <label for="lblResidential">Residential:</label>
                <asp:Label ID="lblResidential" runat="server"></asp:Label>
            </div>

            <!-- Repeater for displaying guests -->
           <asp:Repeater ID="rptGuests" runat="server">
           <ItemTemplate>
            <div>
            <span><%# Eval("guest_id") %></span>
            <!-- Add a button for each guest to delete -->
            <asp:Button runat="server" Text="Remove Guest" OnClick="RemoveGuest_Click" CommandArgument='<%# Eval("guest_id") %>' />
                <asp:Label ID="lblGuestCount" runat="server" Text=""></asp:Label>
           </div>
           </ItemTemplate>
           </asp:Repeater>
            <div>
                <label for="lblGuestCount">Guest Count:</label>
                <asp:Label ID="lblGuestCount" runat="server"></asp:Label>
            <div>
   
     </div>

<!-- Add a button for redirecting to Rooms.aspx -->
<asp:Button ID="btnRooms" runat="server" Text="Rooms" OnClick="btnRooms_Click" />
<!-- Add a button for redirecting to tasks.aspx -->
<asp:Button ID="btntasks" runat="server" Text="Tasks" OnClick="btnRedirectToTasks_Click" />
</div>
</form>
</body>
</html>