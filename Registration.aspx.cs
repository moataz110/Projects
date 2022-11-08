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
    public partial class Registration : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Register(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["GUC"].ToString();
            SqlConnection conn = new SqlConnection(connStr);
            //int id = Int16.Parse(username.Text);
            string fname = firstname.Text;
            string lname = lastname.Text;
            string fac = faculty.Text;
            string addr = address.Text;
            string mail = email.Text;
            string pass = password.Text;
            
            SqlCommand studentReg = new SqlCommand("studentRegister", conn);
            studentReg.CommandType = CommandType.StoredProcedure;
            studentReg.Parameters.Add(new SqlParameter("@first_name", fname));
            studentReg.Parameters.Add(new SqlParameter("@last_name", lname));
            studentReg.Parameters.Add(new SqlParameter("@password", pass));
            studentReg.Parameters.Add(new SqlParameter("@faculty", fac));
            studentReg.Parameters.Add(new SqlParameter("@email", mail));
            studentReg.Parameters.Add(new SqlParameter("@address", addr));
            if(DD.SelectedValue == "GUCian")
            {
                studentReg.Parameters.Add(new SqlParameter("@Gucian", true));

            }
            if (DD.SelectedValue == "NonGUCian")
            {
                studentReg.Parameters.Add(new SqlParameter("@Gucian", false));

            }
            conn.Open();
            studentReg.ExecuteNonQuery();
            conn.Close();
            Response.Redirect("Login.aspx");




        }



            protected void RadioButton1_CheckedChanged(object sender, EventArgs e)
            {

            }

        protected void Button1_Click(object sender, EventArgs e)
        {

        }

        
    }
    } 