using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;
using System.Collections.Specialized;

public partial class seguimiento_contrato : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["idp"] != null)
        {
            ((MasterPageI)Master).SetParametros("?idp=" + Request.QueryString["idp"]);
        }

        if (!IsPostBack)
        {
            BAceptar.Enabled = false;
            GPolizas.Columns[0].Visible = false;

            if (Request.QueryString["idp"] != null)
            {
                ((MasterPageI)Master).SetModificacion(Request.QueryString["idp"]);
                Usuario usuario = Usuario.GetUsuario();
                CConector conector = new CConector();

                UCProyecto.IdProyecto = Request.QueryString["idp"];
                if (UCProyecto.IdProyecto.Length > 0)
                {
                    BAceptar.Enabled = usuario.CanInsert();
                    PDatos.Visible = true;
                }
                else
                {
                    return;
                }

                Query query = new Query("contrato_proyecto");

                query += "digilenciamiento";
                query += "entidad_ejecutadora";
                query += "responsable";
                query += "numero_contrato";
                query += "vigencia";
                query += "numero_encargo";
                query += "departamento";
                query += "municipio";
                query += "objeto";
                query += "forma_pago";
                query += "rpropios";
                query += "rcolombiah";
                query += "rotros";
                query += "uadicion";
                query += "vadicion";
                query += "inicio";
                query += "finalizacion";
                query += "prorroga";

                MySqlDataReader reader = conector.Query(query.GetSelect("proyecto='" + UCProyecto.IdProyecto + "'"));
                if (reader != null && reader.Read())
                {
                    HContrato.Value = UCProyecto.IdProyecto;
                    GPolizas.Columns[0].Visible = ((CUsuario)usuario).CanDelete(HContrato.Value);
                    BAceptar.Enabled = ((CUsuario)usuario).CanUpdate(HContrato.Value);

                    TFechaDiligenciamiento.Text = CConector.GetFromMySQLDate(reader["digilenciamiento"]);
                    TEntidadEjecutora.Text = reader["entidad_ejecutadora"].ToString();
                    TResponsable.Text = reader["responsable"].ToString();
                    TNumero.Text = reader["numero_contrato"].ToString();
                    TVigencia.Text = reader["vigencia"].ToString();
                    TNumeroEncargo.Text = reader["numero_encargo"].ToString();
                    conector.SelectInDropDown(DDepartamento, reader["departamento"]);
                    DDepartamento_SelectedIndexChanged(sender, e);

                    conector.SelectInDropDown(DMunicipio, reader["municipio"]);
                    TObjeto.Text = reader["objeto"].ToString();
                    TFormaPago.Text = reader["forma_pago"].ToString();
                    TRPropios.Text = reader["rpropios"].ToString().Replace(",", ".");
                    TRColombiaH.Text = reader["rcolombiah"].ToString().Replace(",", ".");
                    TROtras.Text = reader["rotros"].ToString().Replace(",", ".");
                    TFAdicion.Text = CConector.GetFromMySQLDate(reader["uadicion"]);
                    TAdicion.Text = reader["vadicion"].ToString().Replace(",", ".");
                    TActaInicio.Text = reader["inicio"].ToString();
                    TFinalizacion.Text = reader["finalizacion"].ToString();
                    TUProrroga.Text = reader["prorroga"].ToString();
                }
            }
        }
    }
    protected void DDepartamento_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (DDepartamento.Items.Count == 0)
            DDepartamento.DataBind();
        LGrupo.Text = new CConector().QueryString("SELECT descripcion FROM shared WHERE id='" + DDepartamento.SelectedValue + "'");
    }
    protected void BAceptar_Click(object sender, EventArgs e) {

        Query query = new Query("contrato_proyecto");
        CConector conector = new CConector();

        query["digilenciamiento"] = CConector.GetMySQLDateFormat(TFechaDiligenciamiento.Text);
        query["entidad_ejecutadora"] = TEntidadEjecutora.Text;
        query["responsable"] = TResponsable.Text;
        query["numero_contrato"] = TNumero.Text;
        query["vigencia"] = TVigencia.Text;
        query["numero_encargo"] = TNumeroEncargo.Text;
        query["departamento"] = DDepartamento.Text;
        query["municipio"] = DMunicipio.Text;
        query["objeto"] = TObjeto.Text;
        query["forma_pago"] = TFormaPago.Text;
        query["rpropios"] = TRPropios.Text.Replace(",", "");
        query["rcolombiah"] = TRColombiaH.Text.Replace(",", "");
        query["rotros"] = TROtras.Text.Replace(",", "");
        query["uadicion"] = CConector.GetMySQLDateFormat(TFAdicion.Text);
        query["vadicion"] = TAdicion.Text.Replace(",", "");
        query["inicio"] = TActaInicio.Text;
        query["finalizacion"] = TFinalizacion.Text;
        query["prorroga"] = TUProrroga.Text;

        conector.StartTransaction();

        if (HContrato.Value.Length == 0)
        {
            query["proyecto"] = UCProyecto.IdProyecto;
            if (conector.QueryMod(query.GetInsert()) == -1)
                return;
            HContrato.Value = UCProyecto.IdProyecto;
        }
        else
        {
            if (conector.QueryMod(query.GetUpdate("proyecto='" + HContrato.Value + "'")) == -1)
                return;
        }
        if (conector.InsertModificacionWeb(HContrato.Value) == -1)
            return;

        for (int i = 0; i < GPolizas.Rows.Count; i++ ) {

            Query polizas = new Query("contrato_proyecto_polizas");

            polizas["tipo"] = ((TextBox)GPolizas.Rows[i].FindControl("TTipo")).Text;
            polizas["numero"] = ((TextBox)GPolizas.Rows[i].FindControl("TNumero")).Text;
            polizas["aseguradora"] = ((DropDownList)GPolizas.Rows[i].FindControl("DAseguradora")).SelectedValue;
            polizas["vencimiento"] = ((TextBox)GPolizas.Rows[i].FindControl("TVencimiento")).Text;

            if(GPolizas.DataKeys[i].Value.ToString().Length==0) {

                polizas["proyecto"] = HContrato.Value;
                if (conector.QueryMod(polizas.GetInsert()) == -1)
                    return;
            } else {
                if (conector.QueryMod(polizas.GetUpdate("id=" + GPolizas.DataKeys[i].Value.ToString())) == -1)
                    return;
            }
        }
        
        string[] querys = SFinanciero.GetQuerys();
        if (querys != null)
        {
            for (int i = 0; i < querys.Length; i++)
            {
                if (conector.QueryMod(querys[i].Replace("@proyecto", HContrato.Value)) == -1)
                    return;
            }
        }

        /*if (conector.QueryMod("DELETE FROM reubicacion_evaluacion WHERE proyecto='" + HContrato.Value + "'") == -1)
            return;

        for (int i = 0; i < GReubicacion.Rows.Count; i++)
        {
            Query reubicacion = new Query("reubicacion_evaluacion");
            reubicacion["reubicacion"] = GReubicacion.DataKeys[i].Values["id"].ToString();
            reubicacion["estado"] = ((CheckBox)GReubicacion.Rows[i].FindControl("CEstado")).Checked ? "1" : "0";

            string id = GReubicacion.DataKeys[i].Values["idreubicacion"].ToString();
            if (id.Length == 0)
            {
                reubicacion["proyecto"] = HEvaluacion.Value;
                if (conector.QueryMod(reubicacion.GetInsert()) == -1)
                    return;
            }
            else
            {
                if (conector.QueryMod(reubicacion.GetUpdate("id='" + id + "'")) == -1)
                    return;
            }
        }

        for (int i = 0; i < GExteriores.Rows.Count; i++)
        {
            Query exteriores = new Query("exteriores_evaluacion");

            exteriores["tipo"] = GExteriores.DataKeys[i].Values["id"].ToString();
            exteriores["material"] = ((TextBox)GExteriores.Rows[i].FindControl("TMaterial")).Text;
            exteriores["estado"] = ((DropDownList)GExteriores.Rows[i].FindControl("DEstado")).SelectedValue;

            string id = GExteriores.DataKeys[i].Values["idexteriores"].ToString();
            if (id.Length == 0)
            {
                exteriores["proyecto"] = HEvaluacion.Value;
                if (conector.QueryMod(exteriores.GetInsert()) == -1)
                    return;
            }
            else
            {
                if (conector.QueryMod(exteriores.GetUpdate("id='" + id + "'")) == -1)
                    return;
            }
        }
        for (int i = 0; i < GDocumentos.Rows.Count; i++)
        {
            Query documentos = new Query("documentos_proyecto");
            string id = GDocumentos.DataKeys[i].Values["iddocumento"].ToString();

            FileUpload file = (FileUpload)GDocumentos.Rows[i].FindControl("FArchivo");
            if (file.HasFile)
            {
                if (id.Length > 0)
                {
                    if (conector.QueryMod("DELETE FROM documentos_proyecto WHERE id='" + id + "'") == -1)
                        return;
                }

                documentos["documento"] = GDocumentos.DataKeys[i].Value.ToString();
                documentos["proyecto"] = UCProyecto.IdProyecto;
                documentos["observaciones"] = ((TextBox)GDocumentos.Rows[i].FindControl("TObservaciones")).Text;

                Archivos archivo = new Archivos(file.PostedFile, 0);
                archivo.SaveFile(documentos);
            }
            else
            {
                documentos["observaciones"] = ((TextBox)GDocumentos.Rows[i].FindControl("TObservaciones")).Text;
                if (id.Length == 0)
                {
                    if (((TextBox)GDocumentos.Rows[i].FindControl("TObservaciones")).Text.Length > 0)
                    {
                        documentos["documento"] = GDocumentos.DataKeys[i].Value.ToString();
                        documentos["proyecto"] = UCProyecto.IdProyecto;
                        if (conector.QueryMod(documentos.GetInsert()) == -1)
                            return;
                    }
                }
                else
                {
                    if (conector.QueryMod(documentos.GetUpdate("id='" + id + "'")) == -1)
                        return;
                }
            }
        }*/
        conector.Commit();
        ((MasterPageI)Master).SetParametros("?idp=" + UCProyecto.IdProyecto);
        ((MasterPageI)Master).SetResultado(UCProyecto.Institucion + " modificado");
    }
    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }
    protected void BMasPolizas_Click(object sender, EventArgs e)
    {
        IOrderedDictionary data = new OrderedDictionary();
        
        data.Add("tipo", "");
        data.Add("numero", "");
        data.Add("aseguradora", null);
        data.Add("vencimiento", null);

        SPolizas.GetView().Insert(data, OnDataSourceOperationComplete);

        GPolizas.DataBind();
        GPolizas.Rows[GPolizas.Rows.Count - 1].FindControl("TTipo").Focus();
    }

    protected void DFinanciero_ItemCommand(object sender, DetailsViewCommandEventArgs e)
    {
        if (e.CommandName == "Cancel")
        {
            GFinanciero.SelectedIndex = -1;
            GFinanciero.DataBind();
        }
    }
    protected void DFinanciero_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
    {
        GFinanciero.DataBind();
    }
    protected void DFinanciero_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
    {
        GFinanciero.DataBind();
        GFinanciero.SelectedIndex = -1;
        GFinanciero.DataBind();
    }

    protected void BMasFinanciero_Click(object sender, EventArgs e)
    {
        DFinanciero.ChangeMode(DetailsViewMode.Insert);
    }

    private bool OnDataSourceOperationComplete(int count, Exception e)
    {
        if (e != null)
        {
            throw e;
        }
        return false;
    }
}
