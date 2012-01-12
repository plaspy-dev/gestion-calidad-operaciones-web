<%@ Page Title="Cantidades de obra" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="cantidadobra.aspx.cs" Inherits="proyectos_cantidadobra" %>
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

            var ttotal = parseFloat($("#<%=LTotal.ClientID %>").text().replace(/,/g, "").replace(/\$/g, ""));
            if (isNaN(ttotal))
                ttotal = 0;
            if (isNaN(antiguo))
                antiguo = 0;
            if (isNaN(total))
                total = 0;
            ttotal += total - antiguo;
            $("#<%=LTotal.ClientID %>").text(currencyFormatted(ttotal.toString()));
        }

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
                        <asp:Label ID="LC" Font-Bold="true" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "szReservado") %>'></asp:Label>
                        <asp:Label ID="LN" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "nombre") %>'></asp:Label>
                        </td><td align=right nowrap=nowrap>
                            <asp:Label ID="LT" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "total", "{0:c}") %>' Visible='<%# DataBinder.Eval(Container.DataItem, "parent").ToString()=="0" %>'></asp:Label>
                    </td></tr></table>
                </td>
                <asp:Panel runat="server" ID="S" Visible='<%# Convert.ToInt32(DataBinder.Eval(Container.DataItem, "hijos"))==0 %>'>
                    <td>
                        <asp:HiddenField ID="HE" runat="server" Value='<%# DataBinder.Eval(Container.DataItem, "id") %>' />
                        <asp:HiddenField ID="HC" runat="server" Value='<%# DataBinder.Eval(Container.DataItem, "idcantidad") %>' />
                        <asp:Label ID="LD"  runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "descripcion") %>'></asp:Label>
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
        SelectCommand="SELECT elemento.id, elemento.nombre, elemento.descripcion,elemento.szReservado,IFNULL(elemento.parametro1,0) AS parent
                        ,cantidades_obra.id AS idcantidad,cantidades_obra.vtotal,cantidades_obra.vunitario,cantidades_obra.cantidad,cantidades_obra.observaciones
                        ,cantidades_obra.elemento!=elemento.id AS hijos
                        ,(SELECT IFNULL(SUM(cantidades_obra.vtotal),0) FROM cantidades_obra LEFT JOIN shared AS e ON (e.id=cantidades_obra.elemento) WHERE cantidades_obra.proyecto=@proyecto AND e.szReservado LIKE CONCAT(elemento.szReservado,'%')) AS total
                        FROM cantidades_obra 
                        LEFT JOIN shared AS elemento ON 
                        (elemento.nReservado=122 AND elemento.szReservado!=-1 AND (SELECT LEFT(shared.szReservado,LENGTH(elemento.szReservado))=elemento.szReservado FROM shared WHERE id=cantidades_obra.elemento))
                        WHERE cantidades_obra.proyecto=@proyecto
                        AND elemento.id IS NOT NULL
                        AND (cantidades_obra.cantidad IS NOT NULL 
                        OR cantidades_obra.vunitario IS NOT NULL)
                        GROUP BY elemento.id
                        ORDER BY GetCodigo(elemento.szReservado)">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="UCProyecto" Name="proyecto" PropertyName="IdProyecto" />
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
                                <b><%# DataBinder.Eval(Container.DataItem, "szReservado") %></b> <%# DataBinder.Eval(Container.DataItem, "nombre") %>
                            </td>
                            <asp:Panel runat="server" ID="S" Visible='<%# Convert.ToInt32(DataBinder.Eval(Container.DataItem, "hijos"))==0 %>'>
                                <td>
                                    <%# DataBinder.Eval(Container.DataItem, "descripcion") %>
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
                    SelectCommand="SELECT shared.id, shared.nombre, shared.descripcion,shared.szReservado,IFNULL(shared.parametro1,0) AS parent
                        ,(SELECT COUNT(*) FROM shared AS s WHERE s.nReservado=122 AND s.szReservado!=-1 AND s.parametro1=shared.id) AS hijos 
                        ,cantidades_obra.id AS idcantidad,cantidades_obra.vtotal,cantidades_obra.vunitario,cantidades_obra.cantidad,cantidades_obra.observaciones
                        FROM shared 
                        LEFT JOIN cantidades_obra ON (cantidades_obra.elemento=shared.id AND cantidades_obra.proyecto=@proyecto)
                        WHERE @actualid=@actual AND shared.nReservado=122 AND shared.szReservado LIKE CONCAT(@capitulo,'%') AND shared.szReservado!=-1 AND shared.id!=@actualid ORDER BY GetCodigo(shared.szReservado)">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="HSel" Name="padre" PropertyName="Value" />
                        <asp:ControlParameter ControlID="UCProyecto" Name="proyecto" PropertyName="IdProyecto" />
                        <asp:ControlParameter ControlID="LCapitulo" Name="actual" PropertyName="CommandArgument" />
                        <asp:ControlParameter ControlID="HSel" Name="actualid" PropertyName="Value" />
                        <asp:ControlParameter ControlID="LCapitulo" Name="capitulo" PropertyName="CommandName" />
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
        SelectCommand="SELECT shared.id, shared.szReservado AS cap, CONCAT(shared.szReservado, ' ',shared.nombre) AS nombre 
                        ,(SELECT IFNULL(SUM(cantidades_obra.vtotal),0) FROM cantidades_obra LEFT JOIN shared AS elemento ON (elemento.id=cantidades_obra.elemento) WHERE cantidades_obra.proyecto=@proyecto AND elemento.szReservado LIKE CONCAT(shared.szReservado,'%')) AS total
                        FROM shared 
                        WHERE shared.nReservado=122 AND shared.szReservado!=-1 
                        AND shared.parametro1 IS NULL ORDER BY GetCodigo(shared.szReservado)">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="UCProyecto" Name="proyecto" PropertyName="IdProyecto" />
                        </SelectParameters>
    </asp:SqlDataSource>
    </ContentTemplate>
    </asp:UpdatePanel>
    <div align="right">Total: <asp:Label runat="server" ID="LTotal"></asp:Label></div>
    <div align="right">
        <asp:Button ID="BAceptar" runat="server" Text="Aceptar" 
            onclick="BAceptar_Click" /><asp:Button ID="BCancelar" runat="server" 
            Text="Cancelar" CausesValidation="false" onclick="BCancelar_Click" />
    </div>
</asp:Panel>
</asp:Content>

