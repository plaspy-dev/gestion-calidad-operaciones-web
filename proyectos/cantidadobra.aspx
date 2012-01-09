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

            if ($(elemento).attr("p") == '0' || hijos) { // tiene hijos

                $("<span></span>")
				    .addClass("ui-icon " + (hijos ? "ui-icon-triangle-1-s" : "ui-icon-triangle-1-e"))
				    .prependTo($(elemento).children("td"));

                $(elemento).children("td").addClass("ui-accordion-header ui-helper-reset " + (hijos ? "ui-state-active ui-corner-top" : "ui-state-default ui-corner-all"));
                $(elemento).hover(function() {
                    $(this).children("td").addClass("ui-state-hover");
                }, function() {
                    $(this).children("td").removeClass("ui-state-hover");
                });
                if (hijos) {
                    nactual++;
                    for (; nactual < len; nactual++) {
                        var e = arreglo[nactual];
                        if (e.p == elemento.p || e.p != elemento.t) { // tiene el mismo padre
                            nactual--;
                            break;
                        }
                        esconder(e, indent + 20);
                    };
                    if ($(elemento).attr("p") == '0') {  // es el seleccionado
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
            arreglo = $('#elementos tr');
            len = arreglo.length;
            nactual = 1;
            for (; nactual < len; nactual++) {
                var e = arreglo[nactual];
                esconder(e, 10);
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
            $("#<%= LFiltro.ClientID %>").click(function() { return confirm('Esta acción revertira todos los cambios realizados. ¿Desea continuar?'); });
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
                </tr>
        </HeaderTemplate>
        <ItemTemplate>
            <tr t=1>
                <td>
                    <asp:Label ID="LC" Font-Bold="true" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "szReservado") %>'></asp:Label>
                    <asp:Label ID="LN" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "nombre") %>'></asp:Label>
                    <asp:HiddenField ID="HE" runat="server" Value='<%# DataBinder.Eval(Container.DataItem, "id") %>' />
                    <asp:HiddenField ID="HC" runat="server" Value='<%# DataBinder.Eval(Container.DataItem, "idcantidad") %>' />
                </td>
                <td>
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
                <td>
                    <asp:TextBox runat="server" ID="TO" Text='<%# DataBinder.Eval(Container.DataItem, "observaciones") %>'></asp:TextBox>
                </td>
            </tr>
        </ItemTemplate>
        <FooterTemplate>
            </table>
        </FooterTemplate>
    </asp:Repeater>
    <asp:SqlDataSource ID="SFiltrar" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
        SelectCommand="SELECT shared.id, shared.nombre, shared.descripcion,shared.szReservado
                        ,cantidades_obra.id AS idcantidad,cantidades_obra.vtotal,cantidades_obra.vunitario,cantidades_obra.cantidad,cantidades_obra.observaciones
                        FROM shared 
                        LEFT JOIN cantidades_obra ON (cantidades_obra.elemento=shared.id AND cantidades_obra.proyecto=@proyecto)
                        WHERE shared.nReservado=122 AND shared.szReservado!=-1 AND cantidades_obra.cantidad IS NOT NULL ORDER BY GetCodigo(shared.szReservado)">
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
                </tr>
        </HeaderTemplate>
        <ItemTemplate>
            <tr p=0 t=<%# DataBinder.Eval(Container.DataItem, "id") %>>
                <td colspan=6>
                    <asp:LinkButton CommandName='<%# DataBinder.Eval(Container.DataItem, "cap") %>' CommandArgument='<%# DataBinder.Eval(Container.DataItem, "id") %>' runat="server" ID="LCapitulo" OnClick="LCapitulo_Click"
                        Text='<%# DataBinder.Eval(Container.DataItem, "nombre") %>'></asp:LinkButton>
                </td>
            </tr>
            <asp:Repeater runat="server" ID="R" DataSourceID="SHijos" onitemdatabound="R_ItemDataBound">
                    <ItemTemplate>
                        <tr p='<%# DataBinder.Eval(Container.DataItem, "parent").ToString() %>' t=<%# DataBinder.Eval(Container.DataItem, "id") %>>
                            <td <%# Convert.ToInt32(DataBinder.Eval(Container.DataItem, "hijos"))>0 ? "colspan=6" : "" %>>
                                <b><%# DataBinder.Eval(Container.DataItem, "szReservado") %></b> <%# DataBinder.Eval(Container.DataItem, "nombre") %>
                                <asp:HiddenField ID="HE" runat="server" Value='<%# DataBinder.Eval(Container.DataItem, "id") %>' />
                                <asp:HiddenField ID="HC" runat="server" Value='<%# DataBinder.Eval(Container.DataItem, "idcantidad") %>' />
                            </td>
                            <asp:Panel runat="server" ID="S" Visible='<%# Convert.ToInt32(DataBinder.Eval(Container.DataItem, "hijos"))==0 %>'>
                                <td>
                                    <%# DataBinder.Eval(Container.DataItem, "descripcion") %>
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
                                <td>
                                    <asp:TextBox runat="server" ID="TO" Text='<%# DataBinder.Eval(Container.DataItem, "observaciones") %>'></asp:TextBox>
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
        SelectCommand="SELECT shared.id, shared.szReservado AS cap, CONCAT(shared.szReservado, ' ',shared.nombre) AS nombre FROM shared WHERE shared.nReservado=122 AND shared.szReservado!=-1 AND shared.parametro1 IS NULL ORDER BY GetCodigo(shared.szReservado)">
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

