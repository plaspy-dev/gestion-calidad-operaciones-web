using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;
using SDG.Componentes;
using MySql.Data.MySqlClient;

public partial class proyectos_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master)._ImprimirClicked+= new EventHandler(OnImprimir);

        if (Request.QueryString["idp"] != null)
        {
            ((MasterPageI)Master).SetParametros("?idp=" + Request.QueryString["idp"]);
        }

        if (!IsPostBack)
        {
            Usuario usuario = Usuario.GetUsuario();
            BAceptar.Enabled = usuario.CanInsert();
            ((MasterPageI)Master).SetModificacion(Request.QueryString["idp"]);

            if (Request.QueryString["idp"] != null)
            {
                Query query = new Query("proyecto");

                query += "contrato";
                query += "departamento";
                query += "municipio";
                query += "localidad";
                query += "nombre";
                query += "tintervencion";
                query += "tinstitucion";
                query += "presupuesto_inicial";
                query += "area_afectada";
                query += "presupuesto_dotacion";
                query += "observaciones";
                query += "telefono";
                query += "direccion";
                query += "ips";
                query += "objeto";
                query += "dotacion";
                query += "visita";
                query += "prestador";

                CConector conector= new CConector();
                MySqlDataReader reader = conector.Query(query.GetSelect("id='" + Request.QueryString["idp"] + "'"));
                if(reader!=null && reader.Read()) {

                    ((MasterPageI)Master).Imprimir("~/imprimir/proyecto.htm");

                    HProyecto.Value = Request.QueryString["idp"];
                    DDepartamento.SelectedValue = reader["departamento"].ToString();
                    DContrato.SelectedValue = reader["contrato"].ToString();
                    DDepartamento_SelectedIndexChanged(null, null);
                    DMunicipio.SelectedValue = reader["municipio"].ToString();
                    DLocalidad.SelectedValue = reader["localidad"].ToString();
                    TNombre.Text = reader["nombre"].ToString();
                    DTIntervencion.SelectedValue = reader["tintervencion"].ToString();
                    DTInstitucion.SelectedValue = reader["tinstitucion"].ToString();
                    TPInicial.Text = reader["presupuesto_inicial"].ToString().Replace(",", ".");
                    TAreaAfectada.Text = reader["area_afectada"].ToString().Replace(",", ".");
                    TPDotacion.Text = reader["presupuesto_dotacion"].ToString().Replace(",", ".");
                    TObservaciones.Text = reader["observaciones"].ToString();
                    TTelefono.Text = reader["telefono"].ToString();
                    TDireccion.Text = reader["direccion"].ToString();
                    TIPS.Text = reader["ips"].ToString();
                    TObjeto.Text = reader["objeto"].ToString();
                    CDotacion.Checked = reader["dotacion"].ToString() == "1";
                    TFVisita.Text = CConector.GetFromMySQLDate(reader["visita"]);
                    TPrestador.Text = reader["prestador"].ToString();

                    /*Query archivos= new Query("archivos_proyecto");
                    
                    archivos+="id";
                    archivos+="nombre";
                    archivos+="tipo";
                    archivos+="fecha";

                    UCSubir.QueryFiles= archivos.GetSelect("proyecto='" + HProyecto.Value + "'");
                    UCSubir.QueryFile = "SELECT archivo FROM archivos_proyecto WHERE id={0}";*/
                } else {
                    DDepartamento_SelectedIndexChanged(null, null);
                }
            } else {
                DDepartamento_SelectedIndexChanged(null, null);
            }
        }
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        Query query = new Query("proyecto");
        CConector conector = new CConector();

        query["departamento"] = DDepartamento.SelectedValue;
        query["contrato"] = DContrato.SelectedValue;
        query["municipio"] = DMunicipio.SelectedValue;
        query["localidad"] = DLocalidad.SelectedValue;
        query["nombre"] = TNombre.Text;
        query["tintervencion"] = DTIntervencion.SelectedValue;
        query["tinstitucion"] = DTInstitucion.SelectedValue;
        query["presupuesto_inicial"] = TPInicial.Text.Replace(",","");
        query["area_afectada"] = TAreaAfectada.Text;
        query["presupuesto_dotacion"] = TPDotacion.Text.Replace(",", "");
        query["observaciones"] = TObservaciones.Text;
        query["telefono"] = TTelefono.Text;
        query["direccion"] = TDireccion.Text;
        query["ips"] = TIPS.Text;
        query["objeto"] = TObjeto.Text;
        query["dotacion"] = CDotacion.Checked ? "1" : "";
        query["visita"] = CConector.GetMySQLDateFormat(TFVisita.Text);
        query["prestador"] = TPrestador.Text;

        if (HProyecto.Value.Length == 0)
        {
            int res = conector.QueryMod(query.GetInsert(), true);
            if (res == -1)
                return;
            if (HProyecto.Value.Length == 0)
                HProyecto.Value = res.ToString();
        }
        else
        {
            if (conector.QueryMod(query.GetUpdate("id='" + HProyecto.Value + "'")) == -1)
                return;
        }
        if (conector.InsertModificacionWeb(HProyecto.Value) == -1)
            return;

        for (int i = 0; i < GDocumentos.Rows.Count; i++)
        {
            Query documentos = new Query("documentos_proyecto");

            FileUpload file = (FileUpload)GDocumentos.Rows[i].FindControl("FArchivo");
            if(file.HasFile) {

                string id = GDocumentos.DataKeys[i].Values["iddocumento"].ToString();
                if (id.Length > 0)
                {
                    if (conector.QueryMod("DELETE FROM documentos_proyecto WHERE id='" + id + "'") == -1)
                        return;
                }

                documentos["documento"] = GDocumentos.DataKeys[i].Value.ToString();
                documentos["proyecto"] = HProyecto.Value;

                Archivos archivo = new Archivos(file.PostedFile, 0);
                archivo.SaveFile(documentos);
            }
        }

        ((MasterPageI)Master).SetResultado(TNombre.Text + " modificado");
    }
    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }
    protected void DDepartamento_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (DDepartamento.Items.Count == 0)
            DDepartamento.DataBind();
        LGrupo.Text = new CConector().QueryString("SELECT descripcion FROM shared WHERE id='" + DDepartamento.SelectedValue + "'");
    }

    protected void OnImprimir(object sender, EventArgs e) {

        string resultado = (string)sender;
        // resultado = resultado.Replace("NoViable", CViable.Checked ? "" : "X");
        resultado = resultado.Replace("NoViable", "");
        resultado = resultado.Replace("OAMe", DTIntervencion.SelectedItem.Text=="ADECUACION MENOR" ? "X" : "");
        resultado = resultado.Replace("OAMa", DTIntervencion.SelectedItem.Text=="ADECUACION MAYOR" ? "X" : "");
        resultado = resultado.Replace("Dotacion", DTIntervencion.SelectedItem.Text == "DOTACION" ? "X" : "");

        bool completa = true;
        for (int i = 0; i < GDocumentos.Rows.Count; i++)
        {
             if(GDocumentos.DataKeys[i].Values["iddocumento"].ToString().Length==0) {
                 completa = false;
                 break;
             }
        }
        resultado = resultado.Replace("szCompleta", completa ? "X" : "");
        resultado = resultado.Replace("szTramite", completa  ? "" : "X");

        double pinicial = string.IsNullOrEmpty(TPInicial.Text) ? 0 : Convert.ToDouble(TPInicial.Text.Replace(",", ""));
        double area = string.IsNullOrEmpty(TAreaAfectada.Text) ? 0 : Convert.ToDouble(TAreaAfectada.Text.Replace(",", ""));
        double pdotacion = string.IsNullOrEmpty(TPDotacion.Text) ? 0 : Convert.ToDouble(TPDotacion.Text.Replace(",", ""));
        double total= pinicial+pdotacion;

        CultureInfo culture = new CultureInfo("en-US");

        resultado = resultado.Replace("szTotal", string.Format(culture, "{0:0,0.##}", total));
        resultado = resultado.Replace("pvalor", string.Format(culture, "{0:0,0.##}", total != 0 ? pinicial * 100 / total : 0));
        resultado = resultado.Replace("pdotacion", string.Format(culture, "{0:0,0.##}", total != 0 ? pdotacion * 100 / total : 0));
        resultado = resultado.Replace("szCostoIntervencion", string.Format(culture, "{0:0,0.##}", area != 0 ? total / area : 0));


        CConector conector = new CConector();
        Query query = new Query("evaluacion");

        query["observaciones"] = "evaluacion.observaciones";
        query["reposicion"] = "reposicion.nombre";
        query["adecuacion"] = "adecuacion.nombre";

        MySqlDataReader reader = conector.Query(query.GetSelect("evaluacion.proyecto='" + HProyecto.Value + "'",
            "LEFT JOIN shared AS reposicion ON (reposicion.id=evaluacion.reposicion) "
            + "LEFT JOIN shared AS adecuacion ON (adecuacion.id=evaluacion.adecuacion)" ));
        if (reader != null && reader.Read())
        {
            resultado = resultado.Replace("szObservaciones", reader["observaciones"].ToString());
            resultado = resultado.Replace("szReposicion", reader["reposicion"].ToString());
            resultado = resultado.Replace("szReubicacion", reader["adecuacion"].ToString());
        } else {
            resultado = resultado.Replace("szObservaciones", "");
            resultado = resultado.Replace("szReposicion", "");
            resultado = resultado.Replace("szReubicacion", "");
        }

        Response.Clear();
        Response.Write(resultado);
        Response.End();
    }

    protected void GDocumentos_SelectedIndexChanged(object sender, EventArgs e)
    {
        Query archivos = new Query("documentos_proyecto");

        archivos += "id";
        archivos += "nombre";
        archivos += "tipo";

        Archivos archivo = new Archivos(archivos.GetSelect("id='" + GDocumentos.SelectedDataKey.Values["iddocumento"].ToString() + "'"),
            "SELECT archivo FROM documentos_proyecto WHERE id={0}");

        archivo.ShowFile(Response);
    }
}
