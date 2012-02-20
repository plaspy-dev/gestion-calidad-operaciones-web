<%@ Page Title="Presupuesto de obra" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="cantidadobra.aspx.cs" Inherits="proyectos_cantidadobra" %>
<%@ Register src="proyector.ascx" tagname="proyector" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<style type="text/css">
    .ui-widget-contentb { border-bottom: 1px solid #a6c9e2; color: #222222; }
    .ui-widget-contentl { border-left: 1px solid #a6c9e2; color: #222222; }
    .ui-widget-contentr { border-right: 1px solid #a6c9e2; color: #222222; }
    .ui-accordion .ui-accordion-header { cursor: pointer; position: relative; margin-top: 1px; zoom: 1; padding: .5em .5em .5em .7em;}
    .ft,dt,tt {text-align: right;}
</style>
<script type="text/javascript">
    $(function() {

        var arreglo = null;
        var nactual = 0;
        var len = 0;

        function esconder(elemento, indent) {

            $(elemento).children("td").first().css("text-indent", indent);
            var hijos = $(elemento).next().attr("p") == $(elemento).attr("t");

            if ($(elemento).attr("p") == "0" || hijos) { // tiene hijos

                $("<span></span>")
				    .addClass("ui-icon " + (hijos ? "ui-icon-triangle-1-s" : "ui-icon-triangle-1-e"))
				    .prependTo($(elemento).children("td").first());

                $(elemento).children("td").first().addClass("ui-accordion-header ui-helper-reset " + (hijos ? "ui-state-active ui-corner-top" : "ui-state-default ui-corner-all"));
                $(elemento).hover(function() {
                    $(this).children("td").first().addClass("ui-state-hover");
                }, function() {
                    $(this).children("td").first().removeClass("ui-state-hover");
                });
                if (hijos) {
                    nactual++;
                    for (; nactual < len; nactual++) {
                        var e = arreglo[nactual];
                        if ($(e).attr("p") == $(elemento).attr("p") || $(e).attr("p") != $(elemento).attr("t")) { // tiene el mismo padre
                            nactual--;
                            break;
                        }
                        esconder(e, indent + 10);
                    };
                    if ($(elemento).attr("p") == "0") {  // es el seleccionado
                        $("html:not(:animated),body:not(:animated)").animate({ scrollTop: $(elemento).offset().top }, 1100);
                    }
                }
            } else {
                $(elemento).children("td").addClass("ui-helper-reset ui-widget-contentb")
                $(elemento).children("td").first().addClass("ui-widget-contentl");
                $(elemento).children("td").last().addClass("ui-widget-contentr");
            }
            return true;
        }

        function calcular(vtotal) {

            var total = 1;
            var antiguo = $(vtotal).numeric('value');
            cantidad = vtotal.replace(/TT/g, "TC");
            vunitario = vtotal.replace(/TT/g, "TU");

            total = parseFloat($(cantidad).val().replace(/,/g, ""));
            total *= parseFloat($(vunitario).val().replace(/,/g, ""));
            $(vtotal).numeric('value', isNaN(total) ? 0 : total);

            var ttotal = parseFloat($("#<%=LSubTotal.ClientID %>").text().replace(/,/g, "").replace(/\$/g, ""));
            if (isNaN(ttotal))
                ttotal = 0;
            if (isNaN(antiguo))
                antiguo = 0;
            if (isNaN(total))
                total = 0;
            ttotal += total - antiguo;
            $("#<%=LSubTotal.ClientID %>").text(currencyFormatted(ttotal.toString()));
            $("#<%= TImprevistos.ClientID %>").change();
        }

        $("#<%= TImprevistos.ClientID %>").change(function() {
            var ttotal = parseFloat($("#<%=LSubTotal.ClientID %>").text().replace(/,/g, "").replace(/\$/g, ""));
            if (isNaN(ttotal))
                ttotal = 0;
            var imprevistos = parseFloat($("#<%= TImprevistos.ClientID %>").val().replace(/,/g, ""));
            if (isNaN(imprevistos))
                imprevistos = 0;
            imprevistos = ttotal * imprevistos / 100;
            $("#<%= LImprevistos.ClientID %>").text(currencyFormatted(imprevistos.toString()));
            ttotal += imprevistos;
            $("#<%= LTotal.ClientID %>").text(currencyFormatted(ttotal.toString()));
        }).change();

        function inicio() {
            arreglo = $('#elementos > tbody > tr');
            len = arreglo.length;
            nactual = 1;
            for (; nactual < len; nactual++) {
                var e = arreglo[nactual];
                esconder(e, 15);
            };
            $(".ft").change(function() {
                calcular("#" + $(this).attr("id").replace(/TC/g, "TT").toString());
            }).numeric({ format: "0.##", buttons: false, minValue: 0 }).first().numeric('select');

            $(".dt").change(function() {
                calcular("#" + $(this).attr("id").replace(/TU/g, "TT").toString());
            }).numeric({ format: "#,000.##", buttons: false, minValue: 0 });

            $(".tt").attr("readonly", true).numeric({ format: "#,000.##", buttons: false, minValue: 0 });
        }

        $('#<%=UCantidad.ClientID%>').panelUpdated(function() {

            inicio();
            $("#<%= LFiltro.ClientID %>").unbind('click').click(function() { return confirm('Esta acción revertira todos los cambios realizados. ¿Desea continuar?'); });
        });
        inicio();
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<uc1:proyector ID="UCProyecto" runat="server" />
<asp:Panel runat="server" ID="PDatos" Visible="false">
    <asp:HiddenField runat="server" ID="HDepartamento" />
    <asp:HiddenField runat="server" ID="HUpdate" Value="1" />
    <div align="right"><asp:LinkButton runat="server" ID="LFiltro" Text="Filtrar" onclick="LFiltro_Click"></asp:LinkButton></div>
    <asp:Repeater ID="RFiltrar" runat="server" DataSourceID="SFiltrar" Visible="false">
        <HeaderTemplate>
            <table id='elementos' class='ui-accordion ui-widget ui-helper-reset ui-accordion-icons' cellspacing='0'>
                <tr class="ui-state-default" style="text-align:center">
                    <td>Descripción</td>
                    <td>Unidad</td>
                    <td>Cantidad</td>
                    <td>Vr. unitario</td>
                    <td>Vr. total</td>
                    <td>Observaciones</td>
                    <td>Total Capítulo</td>
                </tr>
        </HeaderTemplate>
        <ItemTemplate>
            <tr p='<%# DataBinder.Eval(Container.DataItem, "parent").ToString() %>' t=<%# DataBinder.Eval(Container.DataItem, "id") %>>
                <td <%# Convert.ToInt32(DataBinder.Eval(Container.DataItem, "hijos"))>0 ? "colspan=7" : "" %>>
                    <table width=100%><tr><td style="width:100%;">
                        <asp:Label ID="LC" Font-Bold="true" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "codigo") %>'></asp:Label>
                        <asp:Label ID="LN" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "nombre") %>'></asp:Label>
                        </td><td align=right nowrap=nowrap>
                            <asp:Label ID="LT" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "total", "{0:c}") %>' Visible='<%# DataBinder.Eval(Container.DataItem, "parent").ToString()=="0" %>'></asp:Label>
                    </td></tr></table>
                </td>
                <asp:Panel runat="server" ID="S" Visible='<%# Convert.ToInt32(DataBinder.Eval(Container.DataItem, "hijos"))==0 %>'>
                    <td>
                        <asp:HiddenField ID="HE" runat="server" Value='<%# DataBinder.Eval(Container.DataItem, "id") %>' />
                        <asp:HiddenField ID="HC" runat="server" Value='<%# DataBinder.Eval(Container.DataItem, "idcantidad") %>' />
                        <asp:Label ID="LD"  runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "unidad") %>'></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox runat="server" ID="TC" CssClass="ft" Width="60px" Text='<%# DataBinder.Eval(Container.DataItem, "cantidad").ToString().Replace(",", ".") %>'></asp:TextBox>
                    </td>
                    <td>
                        <asp:TextBox runat="server" ID="TU" CssClass="dt" Width="80px" Text='<%# DataBinder.Eval(Container.DataItem, "vunitario").ToString().Replace(",", ".") %>'></asp:TextBox>
                    </td>
                    <td>
                        <asp:TextBox runat="server" ID="TT" CssClass="tt" Width="80px" Text='<%# DataBinder.Eval(Container.DataItem, "vtotal").ToString().Replace(",", ".") %>'></asp:TextBox>
                    </td>
                    <td colspan=2>
                        <asp:TextBox runat="server" Width="95%" ID="TO" Text='<%# DataBinder.Eval(Container.DataItem, "observaciones") %>'></asp:TextBox>
                    </td>
                </asp:Panel>
            </tr>
        </ItemTemplate>
        <FooterTemplate>
            </table>
        </FooterTemplate>
    </asp:Repeater>
    <asp:SqlDataSource ID="SFiltrar" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
        SelectCommand="SELECT elemento.id, elemento.nombre, elemento.unidad,elemento.codigo,IFNULL(elemento.padre,0) AS parent
                        ,cantidades_obra.id AS idcantidad,cantidades_obra.vtotal,cantidades_obra.vunitario,cantidades_obra.cantidad,cantidades_obra.observaciones
                        ,cantidades_obra.elemento!=elemento.id AS hijos
                        ,(SELECT IFNULL(SUM(cantidades_obra.vtotal),0) FROM cantidades_obra LEFT JOIN elemento_cantidad_obra AS e ON (e.id=cantidades_obra.elemento) WHERE cantidades_obra.proyecto=@proyecto AND e.departamento=@departamento AND e.codigo LIKE CONCAT(elemento.codigo,'%')) AS total
                        FROM cantidades_obra 
                        LEFT JOIN elemento_cantidad_obra AS elemento ON 
                        (elemento.estado IS NULL AND (SELECT LEFT(elemento_cantidad_obra.codigo,LENGTH(elemento.codigo))=elemento.codigo FROM elemento_cantidad_obra WHERE elemento.departamento=@departamento AND id=cantidades_obra.elemento))
                        WHERE cantidades_obra.proyecto=@proyecto
                        AND elemento.id IS NOT NULL
                        AND (cantidades_obra.cantidad IS NOT NULL 
                        OR cantidades_obra.vunitario IS NOT NULL)
                        GROUP BY elemento.id
                        ORDER BY GetCodigo(elemento.codigo)">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="UCProyecto" Name="proyecto" PropertyName="IdProyecto" />
                        <asp:ControlParameter ControlID="HDepartamento" Name="departamento" PropertyName="Value" />
                    </SelectParameters>
    </asp:SqlDataSource>
    <asp:UpdatePanel runat="server" ID="UCantidad" UpdateMode="Conditional">
    <ContentTemplate>
    <asp:HiddenField ID="HSel" runat="server" />
    <asp:Repeater ID="E" runat="server" DataSourceID="SElementos">
        <HeaderTemplate>
            <table id='elementos' class='ui-accordion ui-widget ui-helper-reset ui-accordion-icons' cellspacing='0'>
                <tr class="ui-state-default" style="text-align:center">
                    <td>Descripción</td>
                    <td>Unidad</td>
                    <td>Cantidad</td>
                    <td>Vr. unitario</td>
                    <td>Vr. total</td>
                    <td>Observaciones</td>
                    <td>Total Capítulo</td>
                </tr>
        </HeaderTemplate>
        <ItemTemplate>
            <tr p=0 t=<%# DataBinder.Eval(Container.DataItem, "id") %>>
                <td colspan=7>
                    <table width=100%><tr><td width=100%>
                    <asp:LinkButton CommandName='<%# DataBinder.Eval(Container.DataItem, "cap") %>' CommandArgument='<%# DataBinder.Eval(Container.DataItem, "id") %>' runat="server" ID="LCapitulo" OnClick="LCapitulo_Click"
                        Text='<%# DataBinder.Eval(Container.DataItem, "nombre") %>'></asp:LinkButton>
                    </td><td align=right nowrap=nowrap><%# DataBinder.Eval(Container.DataItem, "total", "{0:c}") %></td></tr></table>
                </td>
            </tr>
            <asp:Repeater runat="server" ID="R" DataSourceID="SHijos" onitemdatabound="R_ItemDataBound">
                    <ItemTemplate>
                        <tr p='<%# DataBinder.Eval(Container.DataItem, "parent").ToString() %>' t=<%# DataBinder.Eval(Container.DataItem, "id") %>>
                            <td <%# Convert.ToInt32(DataBinder.Eval(Container.DataItem, "hijos"))>0 ? "colspan=7" : "" %>>
                                <b><%# DataBinder.Eval(Container.DataItem, "codigo")%></b> <%# DataBinder.Eval(Container.DataItem, "nombre") %>
                            </td>
                            <asp:Panel runat="server" ID="S" Visible='<%# Convert.ToInt32(DataBinder.Eval(Container.DataItem, "hijos"))==0 %>'>
                                <td>
                                    <%# DataBinder.Eval(Container.DataItem, "unidad")%>
                                    <asp:HiddenField ID="HE" runat="server" Value='<%# DataBinder.Eval(Container.DataItem, "id") %>' />
                                    <asp:HiddenField ID="HC" runat="server" Value='<%# DataBinder.Eval(Container.DataItem, "idcantidad") %>' />
                                </td>
                                <td>
                                    <asp:TextBox runat="server" ID="TC" CssClass="ft" Width="60px" Text='<%# DataBinder.Eval(Container.DataItem, "cantidad").ToString().Replace(",", ".") %>'></asp:TextBox>
                                </td>
                                <td>
                                    <asp:TextBox runat="server" ID="TU" CssClass="dt" Width="80px" Text='<%# DataBinder.Eval(Container.DataItem, "vunitario").ToString().Replace(",", ".") %>'></asp:TextBox>
                                </td>
                                <td>
                                    <asp:TextBox runat="server" ID="TT" CssClass="tt" Width="80px" Text='<%# DataBinder.Eval(Container.DataItem, "vtotal").ToString().Replace(",", ".") %>'></asp:TextBox>
                                </td>
                                <td colspan=2>
                                    <asp:TextBox runat="server" Width="95%" ID="TO" Text='<%# DataBinder.Eval(Container.DataItem, "observaciones") %>'></asp:TextBox>
                                </td>
                            </asp:Panel>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:SqlDataSource ID="SHijos" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT elemento_cantidad_obra.id, elemento_cantidad_obra.nombre, elemento_cantidad_obra.unidad,elemento_cantidad_obra.codigo,IFNULL(elemento_cantidad_obra.padre,0) AS parent
                        ,(SELECT COUNT(*) FROM elemento_cantidad_obra AS s WHERE s.estado IS NULL AND s.departamento=@departamento AND s.padre=elemento_cantidad_obra.id) AS hijos 
                        ,cantidades_obra.id AS idcantidad,cantidades_obra.vtotal,cantidades_obra.vunitario,cantidades_obra.cantidad,cantidades_obra.observaciones
                        FROM elemento_cantidad_obra 
                        LEFT JOIN cantidades_obra ON (cantidades_obra.elemento=elemento_cantidad_obra.id AND cantidades_obra.proyecto=@proyecto)
                        WHERE @actualid=@actual AND elemento_cantidad_obra.estado IS NULL AND elemento_cantidad_obra.departamento=@departamento AND elemento_cantidad_obra.codigo LIKE CONCAT(@capitulo,'%') AND elemento_cantidad_obra.codigo!=-1 AND elemento_cantidad_obra.id!=@actualid ORDER BY GetCodigo(elemento_cantidad_obra.codigo)">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="HSel" Name="padre" PropertyName="Value" />
                        <asp:ControlParameter ControlID="UCProyecto" Name="proyecto" PropertyName="IdProyecto" />
                        <asp:ControlParameter ControlID="LCapitulo" Name="actual" PropertyName="CommandArgument" />
                        <asp:ControlParameter ControlID="HSel" Name="actualid" PropertyName="Value" />
                        <asp:ControlParameter ControlID="LCapitulo" Name="capitulo" PropertyName="CommandName" />
                        <asp:ControlParameter ControlID="HDepartamento" Name="departamento" PropertyName="Value" />
                    </SelectParameters>
                </asp:SqlDataSource>
        </ItemTemplate>
        <FooterTemplate>
            </table>
        </FooterTemplate>
    </asp:Repeater>
    <asp:SqlDataSource ID="SElementos" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
        SelectCommand="SELECT elemento_cantidad_obra.id, elemento_cantidad_obra.codigo AS cap, CONCAT(elemento_cantidad_obra.codigo, ' ',elemento_cantidad_obra.nombre) AS nombre 
                        ,(SELECT SUM(cantidades_obra.vtotal) FROM cantidades_obra LEFT JOIN elemento_cantidad_obra AS elemento ON (elemento.id=cantidades_obra.elemento) WHERE cantidades_obra.proyecto=@proyecto AND elemento.departamento=@departamento AND elemento.codigo LIKE CONCAT(elemento_cantidad_obra.codigo,'%')) AS total
                        FROM elemento_cantidad_obra 
                        WHERE elemento_cantidad_obra.estado IS NULL 
                        AND elemento_cantidad_obra.departamento=@departamento
                        AND elemento_cantidad_obra.padre IS NULL ORDER BY GetCodigo(elemento_cantidad_obra.codigo)">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="UCProyecto" Name="proyecto" PropertyName="IdProyecto" />
                            <asp:ControlParameter ControlID="HDepartamento" Name="departamento" PropertyName="Value" />
                            <asp:ControlParameter ControlID="HUpdate" Name="update" PropertyName="Value" />
                        </SelectParameters>
    </asp:SqlDataSource>
    </ContentTemplate>
    </asp:UpdatePanel>
    <div align="right">
    <table>
        <tr>
            <td colspan=2>Subtotal</td>
            <td><asp:Label runat="server" ID="LSubTotal"></asp:Label></td>
        </tr>
        <tr>
            <td>ÍTEMS NO PREVISTO O CANTIDADES MAYORES DE OBRA</td>
            <td><asp:TextBox runat="server" Width="30" ID="TImprevistos" CssClass="float"></asp:TextBox>%</td>
            <td><asp:Label runat="server" ID="LImprevistos"></asp:Label></td>
        </tr>
        <tr>
            <td colspan=3><hr /></td>
        </tr>
        <tr>
            <td colspan=2>Total</td>
            <td><asp:Label runat="server" ID="LTotal"></asp:Label></td>
        </tr>
    </table>
    </div>
    <asp:Panel DefaultButton="BAgregar" runat="server" ID="PAgregar">
        <fieldset>
            <legend>Nuevo</legend>
            <table border="0" width="100%">
                <tr>
                    <td colspan="3"><asp:Label runat="server" ID="LMensaje" ForeColor="#FF0000" Text=""></asp:Label></td>
                </tr>
                <tr>
                    <td>
                        Código</td>
                    <td align="right">
                        <asp:TextBox ID="TCodigo" runat="server" Text=""></asp:TextBox>
                    </td>
                    <td>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ValidationGroup="nuevo"
                            ControlToValidate="TCodigo" Display="Dynamic" 
                            ErrorMessage="Por favor ingrese un codigo." SetFocusOnError="true"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                        Nombre</td>
                    <td align="right">
                        <asp:TextBox ID="TNombre" runat="server" Width="98%"></asp:TextBox>
                    </td>
                    <td>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ValidationGroup="nuevo"
                            ControlToValidate="TNombre" Display="Dynamic" 
                            ErrorMessage="Por favor ingrese un nombre." SetFocusOnError="True"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                        Unidad</td>
                    <td align="right">
                        <asp:TextBox ID="TDescripcion" runat="server" EnableViewState="False"></asp:TextBox>
                    </td>
                    <td align="right">
                    </td>
                </tr>
                <tr>
                    <td>
                        &nbsp;</td>
                    <td align="right">
                        <asp:Button ID="BAgregar" runat="server" Text="Agregar" ValidationGroup="nuevo" 
                            onclick="BAgregar_Click" />
                        <asp:Button ID="BCancelarA" runat="server" CausesValidation="False" 
                            Text="Cancelar" onclick="BCancelarA_Click" />
                    </td>
                    <td>
                        &nbsp;</td>
                </tr>
            </table>
        </fieldset>
    </asp:Panel>
    <div align="right">
        <asp:Button ID="BAceptar" runat="server" Text="Aceptar" 
            onclick="BAceptar_Click" /><asp:Button ID="BCancelar" runat="server" 
            Text="Cancelar" CausesValidation="false" onclick="BCancelar_Click" />
    </div>
</asp:Panel>
</asp:Content>