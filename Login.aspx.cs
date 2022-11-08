using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace milestone_3
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void login(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["GUC"].ToString();
            SqlConnection conn = new SqlConnection(connStr);
            //int id = Int16.Parse(username.Text);
            string pass = password.Text;
            string mail = email.Text;
            SqlCommand loginproc = new SqlCommand("loginUsingEmailandPassowrd ", conn);
            loginproc.CommandType = CommandType.StoredProcedure;
            loginproc.Parameters.Add(new SqlParameter("@email", mail));
            loginproc.Parameters.Add(new SqlParameter("@password",pass));

            SqlParameter success = loginproc.Parameters.Add("@success", SqlDbType.Int);
            success.Direction = ParameterDirection.Output;

            conn.Open();
            loginproc.ExecuteNonQuery();
            conn.Close();

            if (success.Value.ToString() == "1")
            {
                Response.Write("Hello");
               // Response.Redirect("courses.aspx");
            }
            
        }

        

        protected void Register(object sender, EventArgs e)
        {
            if (DDLog.SelectedValue == "Student")
            {
                Response.Redirect("Registration.aspx");
            }
            if (DDLog.SelectedValue == "Admin")
            {
                Response.Redirect("AdminRegistration.aspx");
            }
            if (DDLog.SelectedValue == "Supervisor")
            {
                Response.Redirect("SupervisorRegistration.aspx");
            }
        }

        protected void AddPhone(object sender, EventArgs e)
        {
            Response.Redirect("AddPhoneNumber.aspx");

        }
    }
}