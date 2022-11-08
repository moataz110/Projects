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
    public partial class SupervisorRegistration : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Submit(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["GUC"].ToString();
            SqlConnection conn = new SqlConnection(connStr);
            string fname = firstname.Text;
            string lname = lastname.Text;
            string pass = password.Text;
            string fac = faculty.Text;
            string mail = email.Text;
            
            SqlCommand supReg = new SqlCommand("supervisorRegister", conn);
            supReg.CommandType = CommandType.StoredProcedure;
            supReg.Parameters.Add(new SqlParameter("@first_name", fname));
            supReg.Parameters.Add(new SqlParameter("@last_name", lname));
            supReg.Parameters.Add(new SqlParameter("@password", pass));
            supReg.Parameters.Add(new SqlParameter("@faculty", fac));
            supReg.Parameters.Add(new SqlParameter("@email", mail));
            conn.Open();
            supReg.ExecuteNonQuery();
            conn.Close();
            Response.Redirect("Login.aspx");

        }
    }
}