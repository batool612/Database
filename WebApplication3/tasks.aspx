<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="tasks.aspx.cs" Inherits="WebApplication3.tasks" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Page Title</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 20px;
        }

        form {
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        label {
            display: block;
            margin-bottom: 5px;
        }

        input[type="text"], input[type="button"], input[type="submit"], #Tdeadline, #TRem {
            margin-bottom: 10px;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        #GridViewTasks, #StatTable {
            border-collapse: collapse;
            width: 100%;
        }

        #GridViewTasks th, #StatTable th, #GridViewTasks td, #StatTable td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }

        #GridViewTasks th, #StatTable th {
            background-color: #4CAF50;
            color: #fff;
        }

        .button {
            background-color: #4CAF50;
            color: #fff;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
         #TRem, #Tdeadline {
        width: 100%;
        max-width: 300px; /* Adjust the max-width as needed */
        margin: 10px 0;
        border: 1px solid #ccc;
        border-radius: 5px;
        box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
    }

    #TRem table, #Tdeadline table {
        width: 100%;
    }

    #TRem th, #Tdeadline th, #TRem td, #Tdeadline td {
        padding: 8px;
        text-align: center;
    }

    #TRem th, #Tdeadline th {
        background-color: #4CAF50;
        color: #fff;
    }

    #TRem a, #Tdeadline a {
        color: #333;
        text-decoration: none;
        display: block;
        padding: 8px;
        text-align: center;
    }

    #TRem a:hover, #Tdeadline a:hover {
        background-color: #ddd;
    }
    </style>
</head>
<body>
    <form id="form1" runat="server">
         <!-- View User's Tasks -->
 <asp:GridView ID="GridViewTasks" runat="server" AutoGenerateColumns="False" GridLines="None" Height="96px" Width="562px">
     <Columns>
         <asp:BoundField DataField="id" HeaderText="Task ID" />
         <asp:BoundField DataField="name" HeaderText="Task Title" />
         <asp:BoundField DataField="creation_date" HeaderText="Task Status" />
         <asp:BoundField DataField="due_date" HeaderText="Due Date" />
         <asp:BoundField DataField="category" HeaderText="Creation Date" />
         <asp:BoundField DataField="creator" HeaderText="Category" />
         <asp:BoundField DataField="status" HeaderText="Creator" />
         <asp:BoundField DataField="reminder_date" HeaderText="Reminder Date" />
         <asp:BoundField DataField="priority" HeaderText="Priority" />
     </Columns>
 </asp:GridView>
        <asp:Label ID="ErrorMessageLabel1" runat="server" ForeColor="Red" Visible="false"></asp:Label>
         <br />
         <br />
         <asp:Label ID="Label5" runat="server" Text="Task Title:"></asp:Label>
         <br />
 <asp:TextBox ID="TaskTitle" runat="server" Height="31px" Width="127px"></asp:TextBox>

 <br />

 <!-- Finish User's Task -->
 &nbsp;
 <asp:Button ID="btnFinishTask" runat="server" CssClass="button" Text="Finish Task" OnClick="btnFinishTask_Click" />

 <!-- View Task Status -->
         <br />
         <asp:Label ID="outmssg1" runat="server" Text="Label" Visible="false"></asp:Label>
         <br />
         <br />
         <asp:Label ID="Label4" runat="server" Text="Task Creator:"></asp:Label>
         <br />

 <asp:TextBox ID="Tcreator" runat="server" Height="27px" Width="130px"></asp:TextBox>
 <br />
 <asp:Button ID="btnViewTaskStatus" runat="server" CssClass="button" Text="View Task Status" OnClick="btnViewTaskStatus_Click" />

         <br />

         <br />
         <asp:GridView ID="StatTable" runat="server" AutoGenerateColumns="False"> 
             <Columns>
    <asp:BoundField DataField="id" HeaderText="Task ID" />
    <asp:BoundField DataField="name" HeaderText="Task Title" />
    <asp:BoundField DataField="creation_date" HeaderText="Task Status" />
    <asp:BoundField DataField="due_date" HeaderText="Due Date" />
    <asp:BoundField DataField="category" HeaderText="Creation Date" />
    <asp:BoundField DataField="creator" HeaderText="Category" />
    <asp:BoundField DataField="status" HeaderText="Creator" />
    <asp:BoundField DataField="reminder_date" HeaderText="Reminder Date" />
    <asp:BoundField DataField="priority" HeaderText="Priority" />
         </Columns>
       </asp:GridView>
         <br />
 <br />

 <!-- Add Reminder to Task -->

 <!-- Update Deadline of a Specific Task -->
 &nbsp;
 <asp:Calendar ID="TRem" runat="server" Height="72px" Width="730px"></asp:Calendar>
         <asp:Label ID="Label3" runat="server" Text="Task id: "></asp:Label>
         <br />
         <asp:TextBox ID="remTid" runat="server"></asp:TextBox>
         <br />
         <br />
 <asp:Button ID="btnAddReminder" runat="server" CssClass="button" Text="Add Reminder" OnClick="btnAddReminder_Click" />

         <br />
         <br />
         <asp:Label ID="outmssg2" runat="server" Text="Label" Visible="false"></asp:Label>

         <br />
         <br />
         <asp:Label ID="Label1" runat="server" Text="New deadline: "></asp:Label>
 <br />

 <!-- Display task-related information -->
 
         <asp:Calendar ID="Tdeadline" runat="server"></asp:Calendar>
 
         <br />
         <asp:Label ID="Label2" runat="server" Text="Task id: "></asp:Label>
 
         <br />
         <br />
 <asp:TextBox ID="Tid" runat="server" ></asp:TextBox>
         <br />
 <asp:Button ID="btnUpdateDeadline" runat="server" CssClass="button" Text="Update Deadline" OnClick="btnUpdateDeadline_Click" Height="38px" />

         <br />
         <asp:Label ID="outmssg3" runat="server" Text="Label"  Visible="false"></asp:Label>
         <br />
         <br />
 
 <asp:Label ID="lblTaskInfo" runat="server" Text=""></asp:Label>
  <!-- to back to the homepage -->
         <br />
        <asp:Button ID="Button1" runat="server" CssClass="button" Text="Go back to home page" OnClick="Homepg_Click" />

    </form>
</body>
</html>
