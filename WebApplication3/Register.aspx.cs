using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication3
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void Register_Click(object sender, EventArgs e)
        {
            // Get user input
            string userType = ddlUserType.SelectedValue;
            string firstName = txtFirstName.Text;
            string lastName = txtLastName.Text;
            string email = txtEmail.Text;
            string password = txtPassword.Text;
            DateTime birthDate;

            // Check if all fields are filled
            if (string.IsNullOrEmpty(userType) || string.IsNullOrEmpty(firstName) || string.IsNullOrEmpty(lastName) ||
                string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password) || !DateTime.TryParse(txtBirthDate.Text, out birthDate))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please fill in all fields.');", true);
                return; // Exit the method if any field is not filled
            }

            int userId = 0;

            // Perform user registration
            if (RegisterUser(userType, firstName, lastName, email, password, birthDate, out userId))
            {
                // Store the user ID in session
                Session["user"] = userId;

                // Redirect to the user's profile page
                Response.Redirect("ViewProfile.aspx");
            }
            else
            {
                Response.Write("Registration failed.");
            }
        }

        private bool RegisterUser(string userType, string firstName, string lastName, string email, string password, DateTime birthDate, out int userId)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["Web"].ToString();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string insertQuery = "UserRegister";

                using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
                {
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    // Add parameters
                    cmd.Parameters.AddWithValue("@usertype", userType);
                    cmd.Parameters.AddWithValue("@first_name", firstName);
                    cmd.Parameters.AddWithValue("@last_name", lastName);
                    cmd.Parameters.AddWithValue("@email", email);
                    cmd.Parameters.AddWithValue("@password", password);
                    cmd.Parameters.AddWithValue("@birth_date", birthDate);

                    // Output parameter for user ID
                    SqlParameter userIdParam = new SqlParameter("@user_id", System.Data.SqlDbType.Int);
                    userIdParam.Direction = System.Data.ParameterDirection.Output;
                    cmd.Parameters.Add(userIdParam);

                    conn.Open();
                    cmd.ExecuteNonQuery();

                    // Get the generated user ID
                    userId = Convert.ToInt32(cmd.Parameters["@user_id"].Value);

                    // If registration is successful, return true
                    return userId > 0;
                }
            }
        }
    }
}