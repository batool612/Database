<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="WebApplication3.login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
       <title>Login Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
        }

        #loginContainer {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        h2 {
            color: #333;
        }

        label {
            display: block;
            margin: 15px 0 5px;
            color: #555;
        }

        input[type="text"],
        input[type="password"] {
            width: 80%; /* Adjusted width */
            padding: 10px;
            margin-bottom: 15px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        #Loginbutton {
            background-color: #808080;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        #Loginbutton:hover {
            background-color: #555;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server" submitdisabledcontrols="False">
        <div id="loginContainer">
            <h2>Login Page</h2>
            Enter your Email:
            <br />
            <asp:TextBox ID="Email" runat="server"></asp:TextBox>
            <br />
            Enter your Password:
            <br />
            <asp:TextBox ID="Password" runat="server" TextMode="Password"></asp:TextBox>
            <br />
            <asp:Button ID="Loginbutton" runat="server" Text="Login" OnClick="Login" />
        </div>
    </form>
</body>
</html>