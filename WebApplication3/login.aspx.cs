using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication3
{
    public partial class login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void Login(object sender, EventArgs e)
        {
            // Take connection string from configurations
            string connStr = WebConfigurationManager.ConnectionStrings["Web"].ToString();

            // Create a new connection
            SqlConnection conn = new SqlConnection(connStr);

            // Taking inputs from the HTML
            string email = Email.Text;
            string pass = Password.Text;

            // Initialize the procedure and give it the inputs
            SqlCommand loginProc = new SqlCommand("UserLogin", conn);
            loginProc.CommandType = CommandType.StoredProcedure;
            loginProc.Parameters.Add(new SqlParameter("@email", email));
            loginProc.Parameters.Add(new SqlParameter("@password", pass));

            // Getting the output of the procedure
            SqlParameter success = loginProc.Parameters.Add("@success", SqlDbType.Bit);
            SqlParameter userId = loginProc.Parameters.Add("@User_id", SqlDbType.Int);

            success.Direction = ParameterDirection.Output;
            userId.Direction = ParameterDirection.Output;

            conn.Open();
            loginProc.ExecuteNonQuery();
            conn.Close();

            if ((bool)success.Value)
            {
                // Successful login
                Response.Write("Welcome");
                Session["user"] = (int)userId.Value;
                Response.Redirect("ViewProfile.aspx");
            }
            else
            {
                // Login failed
                Response.Write("Login failed");
            }
        }
    }
}