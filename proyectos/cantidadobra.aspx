<%@ Page Title="Cantidades de obra" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="cantidadobra.aspx.cs" Inherits="proyectos_cantidadobra" %>
<%@ Register src="proyector.ascx" tagname="proyector" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<style type="text/css">
    .ui-widget-contentb { border-bottom: 1px solid #a6c9e2; color: #222222; }
    .ui-widget-contentl { border-left: 1px solid #a6c9e2; color: #222222; }
    .ui-widget-contentr { border-right: 1px solid #a6c9e2; color: #222222; }
    .ui-accordion .ui-accordion-header { cursor: pointer; position: relative; margin-top: 1px; zoom: 1; display: block; font-size: 1em; padding: .5em .5em .5em .7em; }
</style>
<script type="text/javascript">
    $(function() {

        function indent(e, ind) {
            $('#elementos [p="' + $(e).attr("t") + '"]').each(function(i) {
                indent(this, ind + 20);
            });
            $(e).children("td").first().css("text-indent", ind);
        }
        function esconder2(elemento) {
            var hijos = false;
            $('#elementos [p="' + $(elemento).attr("t") + '"]').each(function(i) {
                hijos = true;
                if (esconder2(this)) {
                    $(this).removeClass("pv").addClass("ph")
                    .children("td").removeClass("ui-state-active ui-corner-top").addClass("ui-state-default ui-corner-all")
                    .children("span").removeClass("ui-icon-triangle-1-s").addClass("ui-icon-triangle-1-e");
                }
                $(this).hide();
            });
            return hijos;
        }
        function toggle(e) {
            var mostrar = false;
            var show = 100;
            $('#elementos [p="' + $(e).attr("t") + '"]').each(function(i) {
                if (!$(this).is(":visible")) {
                    $(this).show(show);
                    mostrar = true;
                } else {
                    if (esconder2(this)) {
                        $(this).removeClass("pv").addClass("ph")
                        .children("td").removeClass("ui-state-active ui-corner-top").addClass("ui-state-default ui-corner-all")
                        .children("span").removeClass("ui-icon-triangle-1-s").addClass("ui-icon-triangle-1-e");
                    }
                    $(this).hide(show);
                }
                show += 100;
            });
            return mostrar;
        }
        function esconder(elemento) {

            var c = false;
            $('#elementos [p="' + $(elemento).attr("t") + '"]').each(function(i) {
                c = true;
                esconder(this);
                $(this).hide();
            });
            if (c) { // tiene hijos
                $("<span></span>")
				    .addClass("ui-icon ui-icon-triangle-1-e")
				    .prependTo($(elemento).children("td"));

                $(elemento).children("td").addClass("ui-accordion-header ui-helper-reset ui-state-default ui-corner-all");
                $(elemento).addClass("ph").hover(function() {
                    $(this).addClass("ui-state-hover");
                }, function() {
                    $(this).removeClass("ui-state-hover");
                }).click(function() {
                    if (toggle(this)) {
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
                $(elemento).children("td").addClass("ui-helper-reset ui-widget-contentb ui-accordion-content-active")
                $(elemento).children("td").first().addClass("ui-widget-contentl");
                $(elemento).children("td").last().addClass("ui-widget-contentr");
            }
        }
        $("#mostrar").click(function() {

            var texto = $(this).text();
            if (texto == "Mostrar todo") {
                $('#elementos .ph').click();
            } else {
                $('#elementos [p="0"]').each(function(i) {
                    if ($(this).hasClass("pv")) {
                        $(this).click();
                    }
                });
            }
            $(this).text(texto == "Mostrar todo" ? "Ocultar todo" : "Mostrar todo");
        });

        $('#elementos [p="0"]').each(function(i) {
            esconder(this);
            indent(this, 10);
        });

        function calcular(cantidad) {

            var total = 1;
            l = cantidad.replace(/TCantidad/g, "TL");
            a = cantidad.replace(/TCantidad/g, "TA");
            p = cantidad.replace(/TCantidad/g, "TP");

            $(l + "," + a + "," + p).each(function(i) {
                total*= parseFloat($(this).val().replace(/,/g, ""));
            });
            $(cantidad).numeric('value', isNaN(total) ? 0 : total)
        }

        $('input[name$="TCantidad"]').each(function(i) {

            var cantidad = $(this).attr("id");
            $(this).attr("readonly", true);
            
            l = cantidad.replace(/TCantidad/g, "TL");
            a = cantidad.replace(/TCantidad/g, "TA");
            p = cantidad.replace(/TCantidad/g, "TP");

            $("#" + l + ",#" + a + ",#" + p).change(function() {
                calcular("#" + cantidad);
            });
        });
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
<uc1:proyector ID="UCProyecto" runat="server" />
<asp:Panel runat="server" ID="PDatos" Visible="false">
    <div align="right"><a id="mostrar" href='#'>Mostrar todo</a></div>
    <asp:Repeater ID="RElementos" runat="server" DataSourceID="SElementos">
        <HeaderTemplate>
            <table id='elementos' class='ui-accordion ui-widget ui-helper-reset ui-accordion-icons' cellspacing='0'>
                <tr class="GridHeader" style="text-align:center">
                    <td>Descripción</td>
                    <td>Unidad</td>
                    <td>L</td>
                    <td>A</td>
                    <td>P</td>
                    <td>Cantidad</td>
                    <td>Observaciones</td>
                </tr>
        </HeaderTemplate>
        <ItemTemplate>
            <tr p='<%# DataBinder.Eval(Container.DataItem, "parent").ToString() %>' t='<%# DataBinder.Eval(Container.DataItem, "id") %>' 
                class='<%# DataBinder.Eval(Container.DataItem, "parent").ToString()=="0" ? "" : "hide" %>'>
                <td colspan='<%# Convert.ToInt32(DataBinder.Eval(Container.DataItem, "hijos"))>0 ? "7" : "0" %>'>
                    <%# DataBinder.Eval(Container.DataItem, "szReservado") %><%# DataBinder.Eval(Container.DataItem, "nombre") %>
                    <asp:HiddenField ID="HIdElemento" runat="server" Value='<%# DataBinder.Eval(Container.DataItem, "id") %>' />
                    <asp:HiddenField ID="HIdCantidad" runat="server" Value='<%# DataBinder.Eval(Container.DataItem, "idcantidad") %>' />
                </td>
                <asp:Panel runat="server" ID="PSinHijos" Visible='<%# Convert.ToInt32(DataBinder.Eval(Container.DataItem, "hijos"))==0 %>'>
                    <td>
                        <%# DataBinder.Eval(Container.DataItem, "descripcion") %>
                    </td>
                    <td>
                        <asp:TextBox runat="server" ID="TL" CssClass="float" Width="50px" Text='<%# DataBinder.Eval(Container.DataItem, "l") %>'></asp:TextBox>
                    </td>
                    <td>
                        <asp:TextBox runat="server" ID="TA" CssClass="float" Width="50px" Text='<%# DataBinder.Eval(Container.DataItem, "a") %>'></asp:TextBox>
                    </td>
                    <td>
                        <asp:TextBox runat="server" ID="TP" CssClass="float" Width="50px" Text='<%# DataBinder.Eval(Container.DataItem, "p") %>'></asp:TextBox>
                    </td>
                    <td>
                        <asp:TextBox runat="server" ID="TCantidad" CssClass="float" Width="50px" Text='<%# DataBinder.Eval(Container.DataItem, "cantidad") %>'></asp:TextBox>
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
                        ,cantidades_obra.id AS idcantidad,cantidades_obra.a,cantidades_obra.l,cantidades_obra.p,cantidades_obra.cantidad,cantidades_obra.observaciones
                        FROM shared 
                        LEFT JOIN cantidades_obra ON (cantidades_obra.elemento=shared.id AND cantidades_obra.proyecto=@proyecto)
                        WHERE shared.nReservado=122 AND shared.szReservado!=-1 ORDER BY GetCodigo(shared.szReservado)">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="UCProyecto" Name="proyecto" PropertyName="IdProyecto" />
                        </SelectParameters>
    </asp:SqlDataSource>
    <div align="right">
        <asp:Button ID="BAceptar" runat="server" Text="Aceptar" 
            onclick="BAceptar_Click" /><asp:Button ID="BCancelar" runat="server" 
            Text="Cancelar" CausesValidation="false" onclick="BCancelar_Click" />
    </div>
</asp:Panel>
</asp:Content>

