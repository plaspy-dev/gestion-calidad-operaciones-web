<%@ Page Title="Proyecto" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="proyectos_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function() {
        $("#<%= TNombre.ClientID %>").autocomplete({
            source: function(request, response) {
                $.ajax({
                    url: "../webservice/proyecto.asmx/GetProyectos",
                    data: "{ 'q': '" + request.term + "' }",
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataFilter: function(data) { return data; },
                    success: function(data) {
                        response($.map(data.d, function(item) {
                            return {
                                value: item.value, label: item.item
                            }
                        }))
                    },
                    error: function(XMLHttpRequest, textStatus, errorThrown) {
                        alert(textStatus);
                    }
                });
            },
            minLength: 3,
            select: function(event, ui) {
                $.goURL("idp=" + ui.item.value);
                return false;
            }
        });

        function Calcular() {

            pinicial = parseFloat($("#<%= TPInicial.ClientID %>").val().replace(/,/g, ""));
            area = parseFloat($("#<%= TAreaAfectada.ClientID %>").val().replace(/,/g, ""));
            pdotacion = parseFloat($("#<%= TPDotacion.ClientID%>").val().replace(/,/g, ""));

            if (isNaN(pinicial))
                pinicial = 0;
            if (isNaN(pdotacion))
                pdotacion = 0;
            if (isNaN(area))
                area = 0;
            area = area > 0 ? pinicial / area : 0;
            pinicial += pdotacion;

            $("#<%= LCostoIntervencion.ClientID %>").text(currencyFormatted(area.toString()));
            $("#<%= LPTotal.ClientID %>").text(currencyFormatted(pinicial.toString()));
        }
        $("#<%= TPInicial.ClientID %>").change(Calcular).change();
        $("#<%= TAreaAfectada.ClientID %>").change(Calcular).change();
        $("#<%= TPDotacion.ClientID%>").change(Calcular).change();
        $("#<%= DLocalidad.ClientID %>").change(function() {
            var t = $(this).children(":selected").text().toLowerCase();
            t = t.charAt(0).toUpperCase() + t.slice(1);
            $("#<%= LLocalidad.ClientID %>").html(t);
        }).change();

        /*$("#<%= BCancelar.ClientID %>").unbind('click');
        $("#<%= BCancelar.ClientID %>").click(function() {
        alert($("#aspnetForm").attr("action"));
        $("#aspnetForm").attr("action", "<%=ResolveUrl("~/")%>imprimir/Default.aspx");
        $("#aspnetForm").attr("target", "_blank");
        $("#aspnetForm").submit();
        return false;
        });*/
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <table style="width: 100%;">
        <tr>
            <td>
                <asp:HiddenField ID="HProyecto" runat="server" />
                <table style="width: 100%;">
                <tr>
                    <td>
                        Contrato</td>
                    <td>
                        <asp:DropDownList ID="DContrato" runat="server" DataSourceID="SContrato" DataTextField="nombre" DataValueField="id" AppendDataBoundItems="true" Width="200px">
                            <asp:ListItem Text="(Ninguno)" Value=""></asp:ListItem>
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SContrato" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT contratos.id, CAST(CONCAT(LPAD(contratos.id,3,'0'),'-',shared.nombre,'-',entidades.nombre,'-',contratos.id,'-',contratos.ano) AS char) AS nombre
                                            FROM contratos
                                            LEFT JOIN shared ON (shared.id=contratos.unidad)
                                            LEFT JOIN entidades ON (entidades.id=contratos.cliente)
                                            WHERE contratos.estado IS NULL ORDER BY id" >
                        </asp:SqlDataSource>
                        <asp:RequiredFieldValidator ControlToValidate="DContrato" ErrorMessage="Por favor seleccione un contrato." InitialValue="" ID="RequiredFieldValidator2" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                        </td>
                    <td>
                        Nombre</td>
                    <td>
                        <asp:TextBox runat="server" ID="TNombre"></asp:TextBox>
                        <asp:RequiredFieldValidator ControlToValidate="TNombre" ErrorMessage="Por favor ingrese un nombre." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                        </td>
                </tr>
                <tr>
                    <td>
                        Departamento</td>
                    <td>
                        <asp:DropDownList ID="DDepartamento" runat="server" 
                            DataSourceID="SDepartamento" DataTextField="nombre" DataValueField="id" 
                            AutoPostBack="true" onselectedindexchanged="DDepartamento_SelectedIndexChanged">
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SDepartamento" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id, nombre FROM shared WHERE nReservado=101 AND szReservado IS NULL ORDER BY nombre" >
                    </asp:SqlDataSource>
                        <asp:Label ID="LGrupo" runat="server" Text=""></asp:Label></td>
                    <td>
                        Municipio</td>
                    <td>
                        <asp:DropDownList ID="DMunicipio" runat="server" DataSourceID="SMunicipio" DataTextField="nombre" DataValueField="id">
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SMunicipio" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id, nombre FROM shared 
                            WHERE nReservado=102 AND szReservado IS NULL AND descripcion=@departamento ORDER BY nombre" >
                            <SelectParameters>
                            <asp:ControlParameter ControlID="DDepartamento" Name="departamento" PropertyName="SelectedValue" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </td>
                </tr>
                <tr>
                    <td>
                        Localidad</td>
                    <td>
                        <asp:DropDownList ID="DLocalidad" runat="server" DataSourceID="SLocalidad" DataTextField="nombre" DataValueField="id">
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SLocalidad" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id, nombre FROM shared WHERE nReservado=103 AND szReservado IS NULL" >
                        </asp:SqlDataSource>
                        </td>
                    <td>
                        <asp:Label ID="LLocalidad" runat="server" Text="Localidad"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="TLocalidad" runat="server"></asp:TextBox>
                        </td>
                </tr>
                <tr>
                    <td>
                        IPS referencia</td>
                    <td>
                        <asp:TextBox ID="TIPS" runat="server"></asp:TextBox>
                        </td>
                    <td>
                        &nbsp;</td>
                    <td>
                        &nbsp;</td>
                </tr>
                <tr>
                    <td>
                        Dirección</td>
                    <td>
                        <asp:TextBox ID="TDireccion" runat="server"></asp:TextBox>
                        </td>
                    <td>
                        Teléfono</td>
                    <td>
                        <asp:TextBox ID="TTelefono" runat="server"></asp:TextBox>
                        </td>
                </tr>
                <tr>
                    <td>
                        Tipo de intervención</td>
                    <td>
                        <asp:DropDownList ID="DTIntervencion" runat="server" 
                            DataSourceID="STIntervencion" DataTextField="nombre" DataValueField="id">
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="STIntervencion" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id, nombre FROM shared WHERE nReservado=104 AND szReservado IS NULL" >
                    </asp:SqlDataSource></td>
                    <td>
                        &nbsp;</td>
                    <td>
                        <asp:CheckBox ID="CDotacion" runat="server" Text="Dotación" />
                    </td>
                </tr>
                <tr>
                    <td>
                        Tipo de institución</td>
                    <td>
                        <asp:DropDownList ID="DTInstitucion" runat="server" DataSourceID="STInstitucion" DataTextField="nombre" DataValueField="id">
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="STInstitucion" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT id, nombre FROM shared WHERE nReservado=105 AND szReservado IS NULL" >
                    </asp:SqlDataSource></td>
                    <td>
                        Fecha visita</td>
                    <td>
                        <asp:TextBox ID="TFVisita" runat="server" CssClass="fecha"></asp:TextBox>
                        <asp:RangeValidator ControlToValidate="TFVisita" runat="server" ErrorMessage="Por favor ingrese una fecha valida." MinimumValue="01/01/1930" MaximumValue="01/01/2100" ID="RangeValidator3" Display="Dynamic" Type="Date">*</asp:RangeValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                        Presupuesto inicial</td>
                    <td>
                        <asp:TextBox runat="server" CssClass="dinero" ID="TPInicial"></asp:TextBox></td>
                    <td>
                        Area afectada (m2)</td>
                    <td>
                        <asp:TextBox runat="server" CssClass="float" ID="TAreaAfectada"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>
                        Costo intervención (m2)</td>
                    <td align="right">
                        <asp:Label ID="LCostoIntervencion" runat="server" Text=""></asp:Label></td>
                    <td>
                        Presupuesto inicial de dotación</td>
                    <td>
                        <asp:TextBox runat="server" CssClass="dinero" ID="TPDotacion"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>
                        Presupuesto inicial total</td>
                    <td align="right">
                        <asp:Label ID="LPTotal" runat="server" Text=""></asp:Label></td>
                    <td>
                        Código prestador</td>
                    <td>
                        <asp:TextBox ID="TPrestador" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Observaciones</td>
                    <td align="right" colspan="3">
                        <asp:TextBox runat="server" ID="TObservaciones" TextMode="MultiLine" 
                            Width="99%"></asp:TextBox></td>
                </tr>
            </table>
            </td>
        </tr>
        <tr>
            <td align="right">
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="true" />
                <asp:Button ID="BAceptar" runat="server" Text="Aceptar" onclick="BAceptar_Click" />
                <asp:Button ID="BCancelar" runat="server" CausesValidation="false" Text="Cancelar" onclick="BCancelar_Click" />
            </td>
        </tr>
    </table>
</asp:Content>

