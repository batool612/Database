using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication3
{
    public partial class Room : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            Page.DataBind();
            if (!IsPostBack)
            {
                // Call a method to retrieve and display the assigned room
                DisplayAssignedRoom();
                DisplayVacantRooms();
                AdminPanel.Visible = IsUserAdmin();
            }

        }
        protected static bool IsValidRoom(int room) //created it to make sure user doesn't enter an invalid room
        {
            string connectionString = ConfigurationManager.ConnectionStrings["Web"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                string query = "SELECT room_id FROM Room WHERE @room = room_id";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    // Add parameters to the query
                    command.Parameters.AddWithValue("@room", room);

                    // Execute the query and put result in roomN
                    object roomN = command.ExecuteScalar();


                    if (roomN != null)
                    {
                        return true; //room was found
                    }
                    else
                    {
                        return false; //room does not exist
                    }
                }
            }
        }

        protected bool IsUserAdmin() //i created this for the panel visibility
        {
            int userId = Convert.ToInt32(Session["user"]);
            string connectionString = ConfigurationManager.ConnectionStrings["Web"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                string query = "SELECT type FROM Users WHERE ID = @UserId"; //check if this is correct
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    // Add parameters to the query
                    command.Parameters.AddWithValue("@UserId", userId);

                    // Execute the query and put result in Utype
                    object Utype = command.ExecuteScalar();


                    if (Utype != null && Utype.ToString() == "Admin")
                    {
                        return true; //user is an admin
                    }
                    else
                    {
                        return false; //user isn't an admin (guest)
                    }
                }
            }
        }

        private void DisplayAssignedRoom()
        {

            int userId = Convert.ToInt32(Session["user"]);

            string connectionString = ConfigurationManager.ConnectionStrings["Web"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string query = "SELECT r.* FROM Room r WHERE r.room_id IN (SELECT room FROM Users WHERE ID = @userId)";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    // Add parameters to the query
                    command.Parameters.AddWithValue("@UserId", userId);

                    using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                    {
                        // Datatable to place proc results
                        DataTable dt = new DataTable();

                        // Fill the DataTable with the result of the stored procedure?
                        adapter.Fill(dt);

                        // Set the DataTable as the DataSource for the GridView
                        RoomInfo.DataSource = dt;

                        // Bind the data to the GridView
                        RoomInfo.DataBind();
                    }

                }
            }
        }

        public void DisplayVacantRooms()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["Web"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString)) //creates an instance of a connection
            {
                connection.Open();
                SqlCommand checkRoom = new SqlCommand("ViewRoom", connection); //this creates a connection to procedure in db
                checkRoom.CommandType = CommandType.StoredProcedure; //to my understanding we need to put this to say that check room is a stored procedure and that i can execute it

                using (SqlDataAdapter adapter = new SqlDataAdapter(checkRoom)) //adapter to place query results in gridview
                {
                    // Datatable to place proc results
                    DataTable dt = new DataTable();

                    // Fill the DataTable with the result of the stored procedure?
                    adapter.Fill(dt);

                    // Set the DataTable as the DataSource for the GridView
                    VacRooms.DataSource = dt;

                    // Bind the data to the GridView
                    VacRooms.DataBind();
                }
            }
        }


        protected void Button1_Click(object sender, EventArgs e) //this button is the schedule room one i forgot to name it
        {
            try
            {
                int userId = Convert.ToInt32(Session["user"]);
                int roomNum = Convert.ToInt32(RoomNum1.Text);

                DateTime startD = REstart.SelectedDate;
                DateTime endD = REend.SelectedDate;
                String roomAction = R_action.Text;
                //this if condition is to give an error message in the case the button is pressed and the textboxes are empty
                if (RoomNum1.Text.Equals("") || startD.ToString().Equals("") || endD.ToString().Equals("") || R_action.Text.Equals(""))
                {
                    ErrorMessageLabel2.Text = "Please make sure all inputs were given";
                    ErrorMessageLabel2.Visible = true;
                    return;
                }

                if (IsValidRoom(roomNum) == false) //make sure a valid room number was given!!
                {
                    ErrorMessageLabel2.Text = "Invalid room number. Please enter a valid room number.";
                    ErrorMessageLabel2.Visible = true;
                    return;
                }

                string connectionString = ConfigurationManager.ConnectionStrings["Web"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    SqlCommand ScheduleRE = new SqlCommand("CreateSchedule", connection); //check name of connection
                    ScheduleRE.CommandType = CommandType.StoredProcedure;

                    ScheduleRE.Parameters.Add(new SqlParameter("@creator_id", userId));
                    ScheduleRE.Parameters.Add(new SqlParameter("@room_id", roomNum));
                    ScheduleRE.Parameters.Add(new SqlParameter("@start_time", startD));
                    ScheduleRE.Parameters.Add(new SqlParameter("@end_time", endD));
                    ScheduleRE.Parameters.Add(new SqlParameter("@action", roomAction));


                    ScheduleRE.ExecuteNonQuery();

                    connection.Close();
                }
            }
            catch (Exception ex) //in case anything goes wromg website doesn;t crash
            {
                Response.Write($"An error occurred while scheduling a room, this could be due to invalid/no inputs: {ex.Message}");
            }

        }

        protected void Book_Click(object sender, EventArgs e) //book a room button
        {
            try
            {
                int roomNum = Convert.ToInt32(bookingN.Text);
                if (bookingN.Text.Equals(""))
                {
                    ErrorMessageLabel1.Text = "Please enter the room number!";
                    ErrorMessageLabel1.Visible = true;
                    return;
                }
                if (IsValidRoom(roomNum) == false)
                {
                    ErrorMessageLabel1.Text = "Invalid room number. Please enter a valid room number.";
                    ErrorMessageLabel1.Visible = true;
                    return;
                }
                int userId = Convert.ToInt32(Session["user"]);

                string connectionString = ConfigurationManager.ConnectionStrings["Web"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    SqlCommand bookRoom = new SqlCommand("AssignRoom", connection); //check name of connection
                    bookRoom.CommandType = CommandType.StoredProcedure;

                    bookRoom.Parameters.Add(new SqlParameter("@user_id", userId));
                    bookRoom.Parameters.Add(new SqlParameter("@room_id", roomNum));

                    bookRoom.ExecuteNonQuery();

                    DisplayAssignedRoom(); //update the label? not sure if this is right and can't run

                    connection.Close();


                }
            }
            catch (Exception ex) //in case anything goes wromg website doesn;t crash
            {
                Response.Write($"An error occurred while booking the room, this could be due to invalid/no inputs: {ex.Message}");
            }

        }

        protected void Button2_Click(object sender, EventArgs e) //button to change the status
        {
            try
            {
                int roomNum = Convert.ToInt32(RoomNum2.Text);
                if (RoomNum2.Text.Equals(""))
                {
                    ErrorMessageLabel1.Text = "Please enter the room number!";
                    ErrorMessageLabel1.Visible = true;
                    return;
                }
                if (IsValidRoom(roomNum) == false)
                {
                    ErrorMessageLabel3.Text = "Invalid room number. Please enter a valid room number.";
                    ErrorMessageLabel3.Visible = true;
                    return;
                }
                string roomStat = NewStat.SelectedValue;

                string connectionString = ConfigurationManager.ConnectionStrings["Web"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    SqlCommand changeStatus = new SqlCommand("RoomAvailability", connection); //check name of connection
                    changeStatus.CommandType = CommandType.StoredProcedure;

                    changeStatus.Parameters.Add(new SqlParameter("@location", roomNum));
                    changeStatus.Parameters.Add(new SqlParameter("@status", roomStat));

                    changeStatus.ExecuteNonQuery();

                    connection.Close();

                }
            }
            catch (Exception ex) //in case anything goes wromg website doesn;t crash
            {
                Response.Write($"An error occurred while updating the room status, this could be due to invalid/no inputs: {ex.Message}");
            }
        }

        protected void Homepg_Click(object sender, EventArgs e)
        {
            Response.Redirect("ViewProfile.aspx");
        }
    }
}