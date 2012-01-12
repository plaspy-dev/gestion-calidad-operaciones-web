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
        // ((MasterPageI)Master)._ImprimirClicked+= new EventHandler(OnImprimir);

        if (Request.QueryString["idp"] != null)
        {
            ((MasterPageI)Master).SetParametros("?idp=" + Request.QueryString["idp"]);
        }

        if (!IsPostBack)
        {
            Usuario usuario = Usuario.GetUsuario();
            BAceptar.Enabled = usuario.CanInsert();
            BEliminar.Visible = usuario.CanDelete();
            ((MasterPageI)Master).SetModificacion(Request.QueryString["idp"]);

            if (Request.QueryString["idp"] != null)
            {
                Query query = new Query("proyecto");

                query += "contrato";
                query += "departamento";
                query += "municipio";
                query += "localidad";
                query += "nombre_localidad";
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

                    // ((MasterPageI)Master).Imprimir("~/imprimir/proyecto.htm");

                    HProyecto.Value = Request.QueryString["idp"];
                    BAceptar.Enabled = ((CUsuario)usuario).CanUpdate(HProyecto.Value);

                    DDepartamento.SelectedValue = reader["departamento"].ToString();
                    DContrato.SelectedValue = reader["contrato"].ToString();
                    DDepartamento_SelectedIndexChanged(null, null);
                    DMunicipio.SelectedValue = reader["municipio"].ToString();
                    DLocalidad.SelectedValue = reader["localidad"].ToString();
                    TLocalidad.Text = reader["nombre_localidad"].ToString();
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
        query["nombre_localidad"] = TLocalidad.Text;
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

        ((MasterPageI)Master).SetParametros("?idp=" + HProyecto.Value);
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

        CConector conector = new CConector();
        string resultado = (string)sender;

        resultado = resultado.Replace("$szAMenor$", DTIntervencion.SelectedItem.Text.ToLower() == "adecuación menor" ? "X" : "");
        resultado = resultado.Replace("$szAMayor$", DTIntervencion.SelectedItem.Text.ToLower() == "adecuación mayor" ? "X" : "");
        resultado = resultado.Replace("$szReposicion$", DTIntervencion.SelectedItem.Text.ToLower() == "reposición" ? "X" : "");
        resultado = resultado.Replace("$szReubicacion$", DTIntervencion.SelectedItem.Text.ToLower() == "reubicación" ? "X" : "");

        bool completa = conector.QueryString("SELECT COUNT(*)"
                            + " FROM shared "
                            + " LEFT JOIN evaluacion ON (evaluacion.proyecto="
                            + HProyecto.Value
                            + ")"
                            + " LEFT JOIN documentos_proyecto ON (documentos_proyecto.proyecto=evaluacion.proyecto AND documentos_proyecto.documento=shared.id) "
                            + " WHERE shared.nReservado=106 AND shared.szReservado='1'"
                            + " AND (shared.parametro1=evaluacion.adecuacion OR (evaluacion.dotacion=1 AND shared.parametro1 IS NULL))"
                            + " AND documentos_proyecto.id IS NULL AND documentos_proyecto.archivo IS NULL;") == "0";

        resultado = resultado.Replace("$szCompleta$", completa ? "X" : "");
        resultado = resultado.Replace("$szTramite$", completa  ? "" : "X");

        double pinicial = string.IsNullOrEmpty(TPInicial.Text) ? 0 : Convert.ToDouble(TPInicial.Text.Replace(",", ""));
        double area = string.IsNullOrEmpty(TAreaAfectada.Text) ? 0 : Convert.ToDouble(TAreaAfectada.Text.Replace(",", ""));
        double pdotacion = string.IsNullOrEmpty(TPDotacion.Text) ? 0 : Convert.ToDouble(TPDotacion.Text.Replace(",", ""));
        double total= pinicial+pdotacion;

        /*CultureInfo culture = new CultureInfo("en-US");*/

        resultado = resultado.Replace("$szPInicial$", string.Format("{0:c}", pinicial));
        resultado = resultado.Replace("$szPDotacion$", string.Format("{0:c}", pdotacion));
        resultado = resultado.Replace("$szTotal$", string.Format("{0:c}", total));
        resultado = resultado.Replace("$pvalor$", string.Format("{0:N}", total != 0 ? pinicial * 100 / total : total));
        resultado = resultado.Replace("$pdotacion$", string.Format("{0:N}", total != 0 ? pdotacion * 100 / total : total));
        resultado = resultado.Replace("$szCostoIntervencion$", string.Format("{0:c}", area != 0 ? pinicial / area : area));

        Query query = new Query("evaluacion");

        query["observaciones"] = "evaluacion.observaciones";
        query["viable"] = "evaluacion.viable";
        query["dotacion"] = "evaluacion.dotacion";
        query["objeto"] = "adecuacion.descripcion";

        MySqlDataReader reader = conector.Query(query.GetSelect("evaluacion.proyecto='" + HProyecto.Value + "'",
            "LEFT JOIN shared AS reposicion ON (reposicion.id=evaluacion.reposicion) "
            + "LEFT JOIN shared AS adecuacion ON (adecuacion.id=evaluacion.adecuacion)" 
            ));
        if (reader != null && reader.Read())
        {
            resultado = resultado.Replace("$szObservaciones$", reader["observaciones"].ToString());
            resultado = resultado.Replace("$CViable$", reader["viable"].ToString()=="1" ? "X" : "");
            resultado = resultado.Replace("$NoViable$", reader["viable"].ToString() == "1" ? "" : "X");

            string dotacion = reader["dotacion"].ToString() == "1" ? " Y DOTACIÓN " : "";
            resultado = resultado.Replace("$TObjeto$", string.Format(reader["objeto"].ToString(), dotacion, DTInstitucion.SelectedItem.Text));
        } else {
            resultado = resultado.Replace("$szObservaciones$", "");
            resultado = resultado.Replace("$CViable$","");
            resultado = resultado.Replace("$NoViable$", "");
            resultado = resultado.Replace("$TObjeto$", "");
        }

        Response.Clear();
        Response.Write(resultado);
        Response.End();
    }
    protected void BEliminar_Click(object sender, EventArgs e)
    {
        CConector conector= new CConector();
        if (conector.QueryMod("DELETE FROM proyecto WHERE id=" + HProyecto.Value + ";") == -1) return;
        if (conector.QueryMod("DELETE FROM esquema_establecimiento_evaluacion WHERE id=" + HProyecto.Value + ";") == -1) return;
        if (conector.QueryMod("DELETE FROM registro_fotografico_proyecto WHERE proyecto=" + HProyecto.Value + ";") == -1) return;
        if (conector.QueryMod("DELETE FROM evaluacion WHERE proyecto=" + HProyecto.Value + ";") == -1) return;
        if (conector.QueryMod("DELETE FROM cantidades_obra WHERE proyecto=" + HProyecto.Value + ";") == -1) return;
        if (conector.QueryMod("DELETE FROM reubicacion_evaluacion WHERE proyecto=" + HProyecto.Value + ";") == -1) return;
        if (conector.QueryMod("DELETE FROM exteriores_evaluacion WHERE proyecto=" + HProyecto.Value + ";") == -1) return;
        if (conector.QueryMod("DELETE FROM documentos_proyecto WHERE proyecto=" + HProyecto.Value + ";") == -1) return;
        if (conector.QueryMod("DELETE FROM evaluacion_elemento_afectado WHERE proyecto=" + HProyecto.Value + ";") == -1) return;
        if (conector.QueryMod("DELETE FROM evaluacion_servicios WHERE proyecto=" + HProyecto.Value + ";") == -1) return;
        ((MasterPageI)Master).SetParametros("?idp=" + HProyecto.Value);
        ((MasterPageI)Master).SetResultado(TNombre.Text + " eliminado");
    }
}
