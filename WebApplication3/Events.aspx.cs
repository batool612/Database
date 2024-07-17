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
    public partial class Events : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void create_eventbtn_Click(object sender, EventArgs e)
        {

            int eventID = Convert.ToInt32(EventID.Text);
            int userID = Convert.ToInt32(UserID.Text);
            string eventName = EventName.Text;
            string description = Description.Text;
            string location = Location.Text;
            DateTime reminderDate = Convert.ToDateTime(ReminderDateTextBox.Text);
            int otherUserID = string.IsNullOrEmpty(OtherUserIDTextBox.Text) ? 0 : Convert.ToInt32(OtherUserIDTextBox.Text);

            CreateEvent(eventID, userID, eventName, description, location, reminderDate, otherUserID);
            SuccessLabel.Text = "Event created successfully!";

            ErrorLabel.Text = "An error occurred: " + ex.Message;
        }



        private void CreateEvent(int eventID, int userID, string eventName, string description, string location, DateTime reminderDate, int otherUserID)
        {
            // Get the connection string from your web.config file
            string connectionString = ConfigurationManager.ConnectionStrings["server=MSSQLLocalDB;Initial Catalog=HomeSync;Integrated Security=True"].ConnectionString;

            // Create a SqlConnection and a SqlCommand to execute the stored procedure
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                using (SqlCommand command = new SqlCommand("CreateEvent", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;

                    // Add the parameters to the command
                    command.Parameters.AddWithValue("@event_id", eventID);
                    command.Parameters.AddWithValue("@user_id", userID);
                    command.Parameters.AddWithValue("@name", eventName);
                    command.Parameters.AddWithValue("@description", description);
                    command.Parameters.AddWithValue("@location", location);
                    command.Parameters.AddWithValue("@reminder_date", reminderDate);
                    command.Parameters.AddWithValue("@other_user_id", otherUserID);

                    try
                    {
                        // Open the connection and execute the stored procedure
                        connection.Open();
                        command.ExecuteNonQuery();
                    }
                    catch (Exception ex)
                    {
                        // Optionally, log the exception or rethrow it
                        throw new Exception("Error executing stored procedure", ex);
                    }
                }
            }
        }


        protected void Remove_eventbtn_Click(object sender, EventArgs e)
        {
            int userID = Convert.ToInt32(UserID.Text);
            int eventID = string.IsNullOrWhiteSpace(EventID.Text) ? -1 : Convert.ToInt32(EventIDTextBox.Text);

            // Call the stored procedure to view the event(s)
            DataTable eventData = ViewEvent(userID, eventID);

            if (eventData.Rows.Count > 0)
            {
                // Display the event(s) data or perform other actions
                EventGridView.DataSource = eventData;
                EventGridView.DataBind();
            }
            else
            {
                // Display a message indicating that no event(s) were found
                NoEventsLabel.Text = "No events found.";
            }
        }

        protected void uninvite_user_Click(object sender, EventArgs e)
        {
            int userID = Convert.ToInt32(UserDropDownList.SelectedValue);
            int eventID = Convert.ToInt32(EventDropDownList.SelectedValue);

            // Call the stored procedure to assign the user to the event
            bool assignmentSuccess = AssignUserToEvent(userID, eventID);

            if (assignmentSuccess)
            {
                // Display a success message or perform other actions
                SuccessLabel.Text = "User assigned to the event successfully!";
            }
            else
            {
                // Display an error message or perform error handling
                ErrorLabel.Text = "User or event not found.";
            }
        }

        private bool AssignUserToEvent(int userID, int eventID)
        {
            // Get the connection string from your web.config file
            string connectionString = ConfigurationManager.ConnectionStrings["server=MSSQLLocalDB;Initial Catalog=HomeSync;Integrated Security=True"].ConnectionString;

            // Create a SqlConnection and a SqlCommand to execute the stored procedure
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                using (SqlCommand command = new SqlCommand("AssignUser", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;

                    // Add the parameters to the command
                    command.Parameters.AddWithValue("@user_id", userID);
                    command.Parameters.AddWithValue("@event_id", eventID);

                    // Output parameter to check if the assignment was successful
                    SqlParameter outputParam = new SqlParameter("@success", SqlDbType.Bit);
                    outputParam.Direction = ParameterDirection.Output;
                    command.Parameters.Add(outputParam);

                    try
                    {
                        // Open the connection and execute the stored procedure
                        connection.Open();
                        command.ExecuteNonQuery();

                        // Check the output parameter to see if the assignment was successful
                        bool assignmentSuccess = Convert.ToBoolean(outputParam.Value);
                        return assignmentSuccess;
                    }
                    catch (Exception ex)
                    {
                        // Handle any errors here
                        ErrorLabel.Text = "An error occurred: " + ex.Message;
                        return false;

                    }



                }
            }
        }
        protected void view_eventbtn_Click(object sender, EventArgs e)
        {
            int event_id = Convert.ToInt32(EventDropDownList.SelectedValue);
            int user_id = Convert.ToInt32(UserDropDownList.SelectedValue);
            Uninvite(event_id, user_id);
            // Call the stored procedure to uninvite the user from the event
            bool uninviteSuccess = Uninvite(event_id, user_id);

            if (uninviteSuccess)
            {
                // Display a success message or perform other actions
                SuccessLabel.Text = "User uninvited from the event successfully!";
            }
            else
            {
                // Display an error message or perform error handling
                ErrorLabel.Text = "An error occurred while uninviting the user.";
            }
        }
    }
}