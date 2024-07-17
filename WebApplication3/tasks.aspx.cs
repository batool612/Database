using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Security.Cryptography;

namespace WebApplication3
{
    public partial class tasks : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Page.DataBind();
            if (!IsPostBack)
            {
                // Call a method to retrieve and display the assigned room
                DisplayAssignedTask();
            }
        }

        private void DisplayAssignedTask()
        {
            int userId = Convert.ToInt32(Session["user"]);
            if (isTaskExists(userId) == false)
            {
                ErrorMessageLabel1.Text = "This user has no assigned tasks!";
                ErrorMessageLabel1.Visible = true;
                return;
            }

            string connectionString = ConfigurationManager.ConnectionStrings["WebApplication1"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                SqlCommand checkRoom = new SqlCommand("ViewMyTask", connection);
                checkRoom.CommandType = CommandType.StoredProcedure;

                using (SqlDataAdapter adapter = new SqlDataAdapter(checkRoom))
                {

                    DataTable dt = new DataTable();

                    adapter.Fill(dt);

                    GridViewTasks.DataSource = dt;

                    GridViewTasks.DataBind();
                }
            }
        }

        protected static bool isTaskExists(int userId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["Web"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                string query = "SELECT task_id FROM Assigned_to WHERE @uid = user_id";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    // Add parameters to the query
                    command.Parameters.AddWithValue("@uid", userId);

                    // Execute the query and put result in roomN
                    object rid = command.ExecuteScalar();


                    if (rid != null)
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

        protected void btnFinishTask_Click(object sender, EventArgs e)
        {
            try
            {
                int userId = Convert.ToInt32(Session["user"]);
                string title = TaskTitle.Text;

                string connectionString = ConfigurationManager.ConnectionStrings["Web"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    SqlCommand FinishTask = new SqlCommand("FinishMyTask", connection);
                    FinishTask.CommandType = CommandType.StoredProcedure;

                    FinishTask.Parameters.Add(new SqlParameter("@user_Id", userId));
                    FinishTask.Parameters.Add(new SqlParameter("@title", title));

                    FinishTask.ExecuteNonQuery();

                    connection.Close();
                    outmssg1.Text = "Task completed successfully!";
                    outmssg1.Visible = true;

                }
            }
            catch (Exception ex)
            {
                Response.Write($"An error occurred while finishing the task, please make sure task title exists : {ex.Message}");
            }
        }

        protected void btnViewTaskStatus_Click(object sender, EventArgs e)
        {
            try
            {
                int userId = Convert.ToInt32(Session["user"]);
                int Task_Creator = Convert.ToInt32(Tcreator.Text);

                string connectionString = ConfigurationManager.ConnectionStrings["Web"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    using (SqlCommand cmd = new SqlCommand("ViewTask", connection))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@user_id", userId);
                        cmd.Parameters.AddWithValue("@creator", Task_Creator);


                        using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                        {

                            DataTable dt = new DataTable();


                            adapter.Fill(dt);

                            // Set the DataTable as the DataSource for the GridView
                            StatTable.DataSource = dt;

                            // Bind the data to the GridView
                            StatTable.DataBind();
                        }

                    }
                    connection.Close();
                }
            }
            catch (Exception ex)
            {
                Response.Write($"An error occurred while finishing the task, please make sure task title exists : {ex.Message}");
            }
        }

        protected void btnAddReminder_Click(object sender, EventArgs e)
        {
            try
            {
                int tid = Convert.ToInt32(remTid.Text);
                DateTime rem = TRem.SelectedDate;

                string connectionString = ConfigurationManager.ConnectionStrings["Web"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    SqlCommand addRem = new SqlCommand("AddReminder", connection);
                    addRem.CommandType = CommandType.StoredProcedure;

                    addRem.Parameters.Add(new SqlParameter("@task_id", tid));
                    addRem.Parameters.Add(new SqlParameter("@reminder", rem));

                    addRem.ExecuteNonQuery();

                    connection.Close();
                    outmssg2.Text = "Task completed successfully!";
                    outmssg2.Visible = true;
                }

            }
            catch (Exception ex)
            {
                Response.Write($"An error occurred while adding reminder, please make sure inputs are correct : {ex.Message}");
            }
        }

        protected void btnUpdateDeadline_Click(object sender, EventArgs e)
        {
            try
            {
                int taskId = Convert.ToInt32(Tid.Text);
                DateTime dead = Tdeadline.SelectedDate;

                string connectionString = ConfigurationManager.ConnectionStrings["Web"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    SqlCommand updateDeadline = new SqlCommand("UpdateTaskDeadline", connection);
                    updateDeadline.CommandType = CommandType.StoredProcedure;

                    updateDeadline.Parameters.Add(new SqlParameter("@deadline", dead));
                    updateDeadline.Parameters.Add(new SqlParameter("@task_id", taskId));

                    updateDeadline.ExecuteNonQuery();

                    connection.Close();
                    outmssg3.Text = "Deadline updated successfully!";
                    outmssg3.Visible = true;
                }
            }
            catch (Exception ex)
            {
                Response.Write($"An error occurred while adding reminder, please make sure inputs are correct : {ex.Message}");
            }
        }

        protected void Homepg_Click(object sender, EventArgs e)
        {
            Response.Redirect("ViewProfile.aspx");
        }
    }
}

    
    

