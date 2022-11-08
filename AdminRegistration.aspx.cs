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
    public partial class AdminRegistration : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

       

        protected void Submit(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["GUC"].ToString();
            SqlConnection conn = new SqlConnection(connStr);
            string mail = email.Text;
            string pass = password.Text;
            SqlCommand adminReg = new SqlCommand("AdminRegister",conn);
            adminReg.CommandType = CommandType.StoredProcedure;
            adminReg.Parameters.Add(new SqlParameter("@email",mail));
            adminReg.Parameters.Add(new SqlParameter("@password", pass));

            conn.Open();
            adminReg.ExecuteNonQuery();
            conn.Close();
            Response.Redirect("Login.aspx");

        }
    }
}