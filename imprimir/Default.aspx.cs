using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

public partial class imprimir_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        StreamReader reader = new StreamReader(Server.MapPath("~/imprimir/prueba.htm"));
        String contenido = reader.ReadToEnd();

        for (int i = 0; i < Request.Form.Count; i++)
        {
            string valor = Request.Form[i];
            string nombre = Request.Form.GetKey(i).Replace("ctl00$cph$", "");
            if(contenido.IndexOf(nombre)!=-1) {
                contenido = contenido.Replace(nombre,valor);
            }
        }
        Response.Clear();
        Response.Write(contenido);
    }
}
