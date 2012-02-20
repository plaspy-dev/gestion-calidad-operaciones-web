using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using SDG.Componentes;
using MySql.Data.MySqlClient;

public partial class MasterPageI : System.Web.UI.MasterPage
{
    // private static readonly object _ImprimirClicked = new object();
    public event EventHandler _ImprimirClicked = null;
    public event EventHandler _ExcelClicked = null;

    protected void Page_Load(object sender, EventArgs e)
    {
        LVersion.Text = Version.GetVersion();

        Usuario usuario = Usuario.GetUsuario();
        usuario.CreateMenu(TMenu, Session["parametros"]==null ? "" : Session["parametros"].ToString());

        Session.Remove("parametros");
        lblNombre.Text = usuario.GetNombre();

        titulo_aux.Attributes["title"] = "";
        LAuxDiag.Text = "";

        if (Session["szMensaje"] != null)
        {
            lblTitulo.Text = " " + Session["szMensaje"].ToString();
            Session["szMensaje"] = null;
        } else {
            lblTitulo.Text = " " + Page.Title;
        }
        if (lnkExcel.Visible == false)
        {
            Session["excelgridview"] = null;
        }
        if(lnkImp.Visible==false) {
            
            Session["printgridview"] = null;
            Session["printfile"] = null;
        } else {
            if(Request.QueryString["p"]=="1") {
                // nos preparamos para redireccionar
                lnkImp_Click(sender, e);
            }
        }
    }

    public void SetParametros(string parametros) {

        Session["parametros"] = parametros;
    }

    public void SetTitulo(string titulo)
    {
        lblTitulo.Text = titulo;
    }

    public void SetModificacion(string idModificaciones)
    {
        MModificaciones.IdModificacion = idModificaciones;
    }

    public void SetMensaje(String mensaje) {

        LMensaje.Text = mensaje;
    }

    public void SetResultado(String titulo) {

        Session["szMensaje"] = titulo;
        Response.Redirect(Request.Url.AbsolutePath);
    }

    public void SetAuxDiag(String titulo, String texto) {

        titulo_aux.Attributes["title"] = titulo;
        LAuxDiag.Text = texto;
    }
    protected void BAceptar_Click(object sender, EventArgs e)
    {
        CConector conector = new CConector();
        Usuario usuario = Usuario.GetUsuario();
        conector.Query("USE mysql");
        string id = conector.QueryString("SELECT User FROM user WHERE User=LEFT(MD5(LOWER('" + usuario.GetLogin() + "')),15) AND Password=PASSWORD('" + TActual.Text + "')"); // verificamos la contraseña
        if (id.Length == 0)
        {
            SetMensaje("Contraseña actual equivocada");
            return;
        }
        if (conector.QueryMod("UPDATE user SET Password=PASSWORD('" + TNueva.Text + "') WHERE User=LEFT(MD5(LOWER('" + usuario.GetLogin() + "')),15)") == -1)
            return;
        if (conector.QueryMod("FLUSH PRIVILEGES;") == -1)
            return;
        lblTitulo.Text += "Contraseña cambiada correctamente.";
    }

    public LinkButton GetExcelLink()
    {
        return lnkExcel;
    }

    public void Nuevo(String url) {

        lnkNuevo.Visible = url.Length > 0;
        lnkNuevo.PostBackUrl = url;
    }

    public void Excel(GridView view)
    {
        lnkExcel.Visible = Usuario.GetUsuario().CanPrint();
        Session["excelgridview"] = view;
    }

    public void Imprimir() {
        lnkImp.Visible = Usuario.GetUsuario().CanPrint();
    }

    public void Imprimir(GridView view)
    {
        lnkImp.Visible = Usuario.GetUsuario().CanPrint();
        lnkImp.OnClientClick = "";
        Session["printgridview"] = view;
    }
    
    public void Imprimir(string archivo) {

        lnkImp.Visible = Usuario.GetUsuario().CanPrint();
        lnkImp.OnClientClick = "";
        lnkImp.Attributes["r"] = "1";
        Session["printfile"] = archivo;
    }

    public LinkButton GetPrintLink()
    {
        return lnkImp;
    }

    public LinkButton GetGuardarLink()
    {
        return lnkGuardar;
    }

    public void RenderView(GridView view) {

        bool paging = view.AllowPaging;
        if (paging)
        {
            view.AllowPaging = false;
            view.DataBind();
        }

        Response.Write("<tr>\n");
        for (int i = 0; i < view.Columns.Count; i++)
        {

            Response.Write("<td><strong>");
            Response.Write(view.Columns[i].HeaderText);
            Response.Write("</strong></td>");
        }
        Response.Write("</tr>\n");

        for (int i = 0; i < view.Rows.Count; i++)
        {
            Response.Write("<tr>\n");
            for (int j = 0; j < view.Columns.Count; j++)
            {
                Response.Write("<td>");
                if (view.Columns[j].GetType() == typeof(HyperLinkField))
                {
                    HyperLink link = (HyperLink)view.Rows[i].Cells[j].Controls[0];
                    Response.Write(link.Text);
                }
                else if (view.Columns[j].GetType() == typeof(CheckBoxField))
                {
                    CheckBox check = (CheckBox)view.Rows[i].Cells[j].Controls[0];
                    Response.Write(check.Checked ? "X" : "");
                }
                else
                {
                    Response.Write(view.Rows[i].Cells[j].Text);
                }
                Response.Write("</td>");
            }
            Response.Write("</tr>\n");
        }

        if (paging)
        {
            view.AllowPaging = true;
        }
    }

    public string ReplaceContenido(ControlCollection controles, string contenido) {

        for (int i = 0; i < controles.Count; i++)
        {
            string id = controles[i].ID;
            string valor = "";
            if (controles[i].Controls.Count > 0) {
                contenido= ReplaceContenido(controles[i].Controls, contenido);
                continue;
            }
            if (id==null || id.Length == 0)
                continue;
            id = "$" + controles[i].ID + "$";
            if (controles[i].GetType() == typeof(TextBox))
            {
                valor = ((TextBox)controles[i]).Text;
            }
            else if (controles[i].GetType() == typeof(CheckBox))
            {
                valor = ((CheckBox)controles[i]).Checked ? "X" : "";
            }
            else if (controles[i].GetType() == typeof(Label))
            {
                valor = ((Label)controles[i]).Text;
            }
            else if (controles[i].GetType() == typeof(DropDownList))
            {
                if (((DropDownList)controles[i]).SelectedItem==null)
                    ((DropDownList)controles[i]).DataBind(); // solo para depuracion
                valor = ((DropDownList)controles[i]).SelectedItem.Text;
            }
            else if (controles[i].GetType() == typeof(HiddenField))
            {
                valor = ((HiddenField)controles[i]).Value;
            }
            if (contenido.IndexOf(id) != -1)
            {
                contenido = contenido.Replace(id, valor);
            }
        }
        return contenido;
    }

    protected void lnkImp_Click(object sender, EventArgs e) {

        if (Session["printgridview"] != null)
        {
            GridView view = (GridView)Session["printgridview"];
            bool paging = view.AllowPaging;
            if (paging)
            {
                view.AllowPaging = false;
                view.DataBind();
            }
            LAuxDiag.Text = "<script type='text/javascript'>\n";
            LAuxDiag.Text += "$(function() { imprimir(); });\n";
            LAuxDiag.Text += "</script>\n";
        } else if(Session["printfile"]!=null) {
            
            StreamReader reader = new StreamReader(Server.MapPath(Session["printfile"].ToString()));
            String contenido = reader.ReadToEnd();
            reader.Close();

            contenido= ReplaceContenido(cph.Controls, contenido);
            // agregamos el script para imprimir
#if DEBUG
            contenido= contenido.Replace("</body>", "<script type='text/javascript'>window.onload = function () {}</script></body>");
            // contenido= contenido.Replace("</body>", "<script type='text/javascript'>window.onload = function () {if(window.name=='popup')return;var venImp = window.open('../imp.htm', 'popup');venImp.document.write(document.documentElement.innerHTML);venImp.document.close();if(venImp.print) {venImp.print();}window.history.back();}</script></body>");
#else
            contenido = contenido.Replace("</body>", "<script type='text/javascript'>window.onload = function () {if(window.print) {window.print();}window.close();}</script></body>");
            // contenido = contenido.Replace("</body>", "<script type='text/javascript'>window.onload = function () {if(window.name=='popup')return;var venImp = window.open('../imp.htm', 'popup');venImp.document.write(document.documentElement.innerHTML);venImp.document.close();if(venImp.print) {venImp.print();venImp.close();}window.history.back();}</script></body>");
#endif
            // llamamos a la pagina cliente
            if (_ImprimirClicked != null)
            {
                _ImprimirClicked(contenido, e);
            }
            else
            {
                Response.Clear();
                Response.Write(contenido);
                Response.End();
            }
        }
    }
    
    protected void lnkExcel_Click(object sender, EventArgs e)
    {
        if (Session["excelgridview"]!=null)
        {
            Response.Clear();
            Response.AddHeader("Content-Disposition", "inline;filename=" + Page.Title + ".xls");
            Response.ContentType = "application/vnd.ms-excel";
            Response.ContentEncoding = System.Text.Encoding.GetEncoding("ISO-8859-1");

            Response.Write("<html>");
            Response.Write("<body>\n");
            Response.Write("<table border='1'>\n");

            RenderView((GridView)Session["excelgridview"]);

            Response.Write("</table></body></html>\n");
            Response.End();
        } else if(_ExcelClicked!=null) {
            _ExcelClicked(sender, e);
        }
    }
}
