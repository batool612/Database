<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="WebApplication3.Register" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
        <title>User Registration</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }

        #formContainer {
            width: 400px;
            margin: 50px auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        h2 {
            text-align: center;
            color: #333;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #555;
        }

        input[type="text"],
        input[type="password"],
        select {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        select {
            height: 40px; /* Match the height of input fields */
        }

        input[type="button"] {
            background-color: #808080;
            color: black; /* Set text color to black */
            padding: 15px; /* Adjust padding for a larger button */
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 100%; /* Make the button full-width */
        }

        input[type="button"]:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div id="formContainer">
            <h2>User Registration</h2>
            <label for="txtFirstName">First Name:</label>
            <asp:TextBox ID="txtFirstName" runat="server"></asp:TextBox>

            <label for="txtLastName">Last Name:</label>
            <asp:TextBox ID="txtLastName" runat="server"></asp:TextBox>

            <label for="txtEmail">Email:</label>
            <asp:TextBox ID="txtEmail" runat="server"></asp:TextBox>

            <label for="txtPassword">Password:</label>
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"></asp:TextBox>

            <label for="txtBirthDate">BirthDate:</label>
            <asp:TextBox ID="txtBirthDate" runat="server" TextMode="Date"></asp:TextBox>

            <label for="ddlUserType">User Type:</label>
            <asp:DropDownList ID="ddlUserType" runat="server">
                <asp:ListItem Text="Admin" Value="Admin"></asp:ListItem>
                <asp:ListItem Text="Guest" Value="Guest"></asp:ListItem>
            </asp:DropDownList>

            <asp:Button ID="btnRegister" runat="server" Text="Register" OnClick="Register_Click" />

        </div>
    </form>
</body>
</html>
