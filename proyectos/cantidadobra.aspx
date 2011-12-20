<%@ Page Title="Cantidades de obra" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="cantidadobra.aspx.cs" Inherits="proyectos_cantidadobra" %>
<%@ Register src="proyector.ascx" tagname="proyector" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<style type="text/css">
    .ui-widget-contentb { border-bottom: 1px solid #a6c9e2; color: #222222; }
    .ui-widget-contentl { border-left: 1px solid #a6c9e2; color: #222222; }
    .ui-widget-contentr { border-right: 1px solid #a6c9e2; color: #222222; }
    .ui-accordion .ui-accordion-header { cursor: pointer; position: relative; margin-top: 1px; zoom: 1; padding: .5em .5em .5em .7em;}
</style>
<script type="text/javascript">
    $(function() {
        function esconder2(e) {

            if (e.next().attr("p") == e.attr("t")) { // tiene hijos

                var elemento = $(e).next();
                var t = $(e).attr("t");
                while (elemento.length!=0) {

                    if(elemento.attr("p") == t) {
                        if (esconder2(elemento)) {
                            elemento.removeClass("pv").addClass("ph")
                            .children("td").removeClass("ui-state-active ui-corner-top").addClass("ui-state-default ui-corner-all")
                            .children("span").removeClass("ui-icon-triangle-1-s").addClass("ui-icon-triangle-1-e");
                        }
                        elemento.hide();
                    }
                    elemento = elemento.next();
                }
                return true;
            }
            return false;
        }
        function toggle(e) {
            var mostrar = false;
            var t = $(e).attr("t");
            var elemento = $(e).next();

            while (elemento.length != 0) {
                if (elemento.attr("p") == t) {
                    if (!elemento.is(":visible")) {
                        elemento.show();
                        mostrar = true;
                    } else {
                        if (esconder2(elemento)) {
                            elemento.removeClass("pv").addClass("ph")
                            .children("td").removeClass("ui-state-active ui-corner-top").addClass("ui-state-default ui-corner-all")
                            .children("span").removeClass("ui-icon-triangle-1-s").addClass("ui-icon-triangle-1-e");
                        }
                        elemento.hide();
                    }
                }
                elemento = elemento.next();
            }
            return mostrar;
        }
        function esconder(elemento, indent) {

            if (elemento.indent)
                return false;
            $(elemento).children("td").first().css("text-indent", indent);
            elemento.indent = indent;

            if ($(elemento).next().attr("p") == $(elemento).attr("t")) { // tiene hijos

                $("<span></span>")
				    .addClass("ui-icon ui-icon-triangle-1-e")
				    .prependTo($(elemento).children("td"));

                $(elemento).children("td").addClass("ui-accordion-header ui-helper-reset ui-state-default ui-corner-all");
                $(elemento).addClass("ph").hover(function() {
                    $(this).children("td").addClass("ui-state-hover");
                }, function() {
                    $(this).children("td").removeClass("ui-state-hover");
                }).click(function() {
                    if (toggle(this)) {
                        // expandir

                        var t = $(this).attr("t");
                        var info = $(this).next();

                        while (info.length != 0) {
                            if (info.attr("p") == t) {
                                if (esconder($(info).get(0), indent + 20)) {
                                    var vtotal = info.children("td").children(".totalt").attr("id");
                                    if (vtotal) {
                                        $(info).children("td").children(".floatt").change(function() {
                                            calcular("#" + $(this).attr("id").replace(/TCantidad/g, "TVTotal").toString());
                                        }).numeric({ format: "0.##", buttons: false, minValue: 0 });

                                        $(info).children("td").children(".dinerot").change(function() {
                                            calcular("#" + $(this).attr("id").replace(/TVUnitario/g, "TVTotal").toString());
                                        }).numeric({ format: "#,000.##", buttons: false, minValue: 0 });

                                        $(info).children("td").children(".totalt")
                                            .attr("readonly", true)
                                            .numeric({ format: "#,000.##", buttons: false, minValue: 0 });
                                    }
                                }
                            }
                            info = info.next();
                        }
                        $(this).removeClass("ph").addClass("pv")
                        .children("td").removeClass("ui-state-default ui-corner-all").addClass("ui-state-active ui-corner-top")
                        .children("span").removeClass("ui-icon-triangle-1-e").addClass("ui-icon-triangle-1-s");
                    } else {
                        $(this).removeClass("pv").addClass("ph")
                        .children("td").removeClass("ui-state-active ui-corner-top").addClass("ui-state-default ui-corner-all")
                        .children("span").removeClass("ui-icon-triangle-1-s").addClass("ui-icon-triangle-1-e");
                    }
                });
            } else {
                $(elemento).children("td").addClass("ui-helper-reset ui-widget-contentb")
                $(elemento).children("td").first().addClass("ui-widget-contentl");
                $(elemento).children("td").last().addClass("ui-widget-contentr");
            }
            return true;
        }

        $('#elementos tr').each(function(i) {
            if ($(this).attr("p") == "0")
                esconder(this, 10);
        });

        function calcular(vtotal) {

            var total = 1;
            var antiguo = $(vtotal).numeric('value');
            cantidad = vtotal.replace(/TVTotal/g, "TCantidad");
            vunitario = vtotal.replace(/TVTotal/g, "TVUnitario");

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
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<uc1:proyector ID="UCProyecto" runat="server" />
<asp:Panel runat="server" ID="PDatos" Visible="false">
    <asp:Repeater ID="RElementos" runat="server" DataSourceID="SElementos">
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
            <tr p='<%# DataBinder.Eval(Container.DataItem, "parent").ToString() %>' t='<%# DataBinder.Eval(Container.DataItem, "id") %>' 
                class='<%# DataBinder.Eval(Container.DataItem, "parent").ToString()=="0" ? "" : "hide" %>'>
                <td colspan='<%# Convert.ToInt32(DataBinder.Eval(Container.DataItem, "hijos"))>0 ? "6" : "0" %>'>
                    <%# DataBinder.Eval(Container.DataItem, "szReservado") %><%# DataBinder.Eval(Container.DataItem, "nombre") %>
                    <asp:HiddenField ID="HIdElemento" runat="server" Value='<%# DataBinder.Eval(Container.DataItem, "id") %>' />
                    <asp:HiddenField ID="HIdCantidad" runat="server" Value='<%# DataBinder.Eval(Container.DataItem, "idcantidad") %>' />
                </td>
                <asp:Panel runat="server" ID="PSinHijos" Visible='<%# Convert.ToInt32(DataBinder.Eval(Container.DataItem, "hijos"))==0 %>'>
                    <td>
                        <%# DataBinder.Eval(Container.DataItem, "descripcion") %>
                    </td>
                    <td>
                        <asp:TextBox runat="server" ID="TCantidad" CssClass="floatt" Width="60px" Text='<%# DataBinder.Eval(Container.DataItem, "cantidad") %>'></asp:TextBox>
                    </td>
                    <td>
                        <asp:TextBox runat="server" ID="TVUnitario" CssClass="dinerot" Width="80px" Text='<%# DataBinder.Eval(Container.DataItem, "vunitario").ToString().Replace(",", ".") %>'></asp:TextBox>
                    </td>
                    <td>
                        <asp:TextBox runat="server" ID="TVTotal" CssClass="totalt" Width="80px" Text='<%# DataBinder.Eval(Container.DataItem, "vtotal").ToString().Replace(",", ".") %>'></asp:TextBox>
                    </td>
                    <td>
                        <asp:TextBox runat="server" ID="TObservaciones" Text='<%# DataBinder.Eval(Container.DataItem, "observaciones") %>'></asp:TextBox>
                    </td>
                </asp:Panel>
            </tr>
        </ItemTemplate>
        <FooterTemplate>
            </table>
        </FooterTemplate>
    </asp:Repeater>
    <asp:SqlDataSource ID="SElementos" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
        SelectCommand="SELECT shared.id, shared.nombre, shared.descripcion,shared.szReservado,IFNULL(shared.parametro1,0) AS parent
                        ,(SELECT COUNT(*) FROM shared AS s WHERE s.nReservado=122 AND s.szReservado!=-1 AND s.parametro1=shared.id) AS hijos 
                        ,cantidades_obra.id AS idcantidad,cantidades_obra.vtotal,cantidades_obra.vunitario,cantidades_obra.cantidad,cantidades_obra.observaciones
                        FROM shared 
                        LEFT JOIN cantidades_obra ON (cantidades_obra.elemento=shared.id AND cantidades_obra.proyecto=@proyecto)
                        WHERE shared.nReservado=122 AND shared.szReservado!=-1 ORDER BY CAST(GetCodigo(shared.szReservado) AS DECIMAL)">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="UCProyecto" Name="proyecto" PropertyName="IdProyecto" />
                        </SelectParameters>
    </asp:SqlDataSource>
    <div align="right">Total: <asp:Label runat="server" ID="LTotal"></asp:Label></div>
    <div align="right">
        <asp:Button ID="BAceptar" runat="server" Text="Aceptar" 
            onclick="BAceptar_Click" /><asp:Button ID="BCancelar" runat="server" 
            Text="Cancelar" CausesValidation="false" onclick="BCancelar_Click" />
    </div>
</asp:Panel>
</asp:Content>

