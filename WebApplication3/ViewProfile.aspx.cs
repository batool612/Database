using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication3
{
    public partial class Viewprofile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Assuming you have the user ID stored in a session variable
            int userId = Convert.ToInt32(Session["user"]);

            // Fetch user profile data based on the user ID
            DataTable userData = GetUserProfile(userId);

            // Bind data to labels
            if (userData.Rows.Count > 0)
            {
                lblFirstName.Text = userData.Rows[0]["f_name"].ToString();
                lblLastName.Text = userData.Rows[0]["l_name"].ToString();
                lblEmail.Text = userData.Rows[0]["email"].ToString();
                lblPreference.Text = userData.Rows[0]["preference"].ToString();
                lblType.Text = userData.Rows[0]["Type"].ToString();
                lblAge.Text = userData.Rows[0]["age"].ToString();
                lblBirthdate.Text = Convert.ToDateTime(userData.Rows[0]["birthdate"]).ToString("yyyy-MM-dd");
                lblRoom.Text = userData.Rows[0]["room"].ToString();
            }

            string userType = userData.Rows[0]["Type"].ToString();

            if (userType.Equals("Admin", StringComparison.OrdinalIgnoreCase))
            {
                DisplayAdminInfo(userId);

                // Set guest-specific information labels as not visible for admins
                SetGuestInfoLabelsVisibility(false);
            }
            else if (userType.Equals("Guest", StringComparison.OrdinalIgnoreCase))
            {
                DisplayGuestInfo(userId);

                // Set guest-specific information labels as visible for guests
                SetGuestInfoLabelsVisibility(true);
            }

        }
        private void SetGuestInfoLabelsVisibility(bool isVisible)
        {
            lblAddress.Visible = isVisible;
            lblArrivalDate.Visible = isVisible;
            lblDepartureDate.Visible = isVisible;
            lblResidential.Visible = isVisible;
        }


        private DataTable GetUserProfile(int userId)
        {
            // Connect to the database and retrieve user profile data
            string connStr = WebConfigurationManager.ConnectionStrings["Web"].ToString();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("ViewProfile", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@user_id", userId);

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dataTable = new DataTable();

                conn.Open();
                adapter.Fill(dataTable);
                conn.Close();

                return dataTable;



            }
        }
        private void DisplayAdminInfo(int userId)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["Web"].ToString();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Example SQL query to fetch admin information
                string query = "SELECT no_of_guests_allowed, salary FROM Admin WHERE admin_id = @admin_id";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@admin_id", userId);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            // Display admin-specific information
                            lblNoOfGuestsAllowed.Text = reader["no_of_guests_allowed"].ToString();
                            lblSalary.Text = reader["salary"].ToString();




                            // Add a button for each guest to delete
                            rptGuests.DataSource = GetGuestsList(userId);
                            rptGuests.DataBind();

                            // Get and display the number of guests
                            int guestCount = GetGuestCount(userId);
                            lblGuestCount.Text = guestCount.ToString();

                            // Replace 1 and 5 with the appropriate admin ID and number of guests
                            SetGuestsAllowed(1, 5); // to call the procedure 
                        }
                    }
                }

                conn.Close();
            }
        }

        private DataTable GetGuestsList(int adminId)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["Web"].ToString();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Example SQL query to fetch the list of guests for a specific admin
                string query = "SELECT guest_id,guest_of FROM Guest WHERE guest_of = @admin_id";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@admin_id", adminId);

                    SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                    DataTable dataTable = new DataTable();
                    adapter.Fill(dataTable);

                    return dataTable;
                }
            }
        }
        private int GetGuestCount(int adminId)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["Web"].ToString();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string query = "GuestNumber";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@admin_id", adminId);

                    SqlParameter guestCountParam = new SqlParameter("@number", SqlDbType.Int);
                    guestCountParam.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(guestCountParam);

                    cmd.ExecuteNonQuery();

                    return Convert.ToInt32(cmd.Parameters["@number"].Value);
                }
            }
        }


        protected void RemoveGuest_Click(object sender, EventArgs e)
        {
            // Get the guest ID from the clicked button's CommandArgument
            Button btnRemoveGuest = (Button)sender;
            int guestId = Convert.ToInt32(btnRemoveGuest.CommandArgument);

            // Get the admin ID from the session (you may need to modify this based on your authentication logic)
            // int adminId = Convert.ToInt32(Session["@admin_id"]);
            int adminId = Convert.ToInt32(Session["user"]);

            // Call the stored procedure to remove the guest
            RemoveGuest(adminId, guestId);

            // Reload the guests list after removal
            rptGuests.DataSource = GetGuestsList(adminId);
            rptGuests.DataBind();
        }

        private void RemoveGuest(int adminId, int guestId)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["Web"].ToString();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("GuestRemove", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@admin_id", adminId);
                cmd.Parameters.AddWithValue("@guest_id", guestId);

                SqlParameter guestCountParam = new SqlParameter("@number_of_allowed_guests", SqlDbType.Int);
                guestCountParam.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(guestCountParam);

                conn.Open();
                cmd.ExecuteNonQuery();

                // Get the updated guest count
                int guestCount = Convert.ToInt32(cmd.Parameters["@number_of_allowed_guests"].Value);

                lblGuestCount.Text = guestCount.ToString();
            }
        }
        private void SetGuestsAllowed(int adminId, int numberOfGuests)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["Web"].ToString();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string query = "GuestsAllowed";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@admin_id", adminId);
                    cmd.Parameters.AddWithValue("@number_of_guests", numberOfGuests);

                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void DisplayGuestInfo(int userId)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["Web"].ToString();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Example SQL query to fetch guest information
                string query = "SELECT address, arrival_date, departure_date, residential FROM Guest WHERE guest_id = @guest_id";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@guest_id", userId);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            // Display guest-specific information
                            lblAddress.Text = reader["address"].ToString();
                            lblArrivalDate.Text = Convert.ToDateTime(reader["arrival_date"]).ToString("yyyy-MM-dd");
                            lblDepartureDate.Text = Convert.ToDateTime(reader["departure_date"]).ToString("yyyy-MM-dd");
                            lblResidential.Text = reader["residential"].ToString();
                        }
                    }
                }

                conn.Close();
            }
        }
        protected void btnRedirectToTasks_Click(object sender, EventArgs e)
        {
            Response.Redirect("tasks.aspx");
        }

        protected void btnRooms_Click(object sender, EventArgs e)
        {

            Response.Redirect("Room.aspx");
        }
    }
}