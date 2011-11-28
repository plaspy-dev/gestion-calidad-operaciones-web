<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="evaluacion2.aspx.cs" Inherits="proyectos_evaluacion2" %>
<%@ Register src="proyector.ascx" tagname="proyector" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function() {
        addDialog("#<%= PEAfectados.ClientID %>", "#dAfectados");
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph" Runat="Server">
    <uc1:proyector ID="UCProyecto" runat="server" />
    <asp:Panel runat="server" ID="PDatos" Visible="false">
        <asp:Repeater ID="REAfectados" runat="server" DataSourceID="SEAfectados" 
            onitemcommand="REAfectados_ItemCommand">
            <HeaderTemplate>
                <table border="1">
            </HeaderTemplate>
            <ItemTemplate>
                 <tr>
                    <td><asp:ImageButton ID="IEditar" runat="server" CommandName="Editar" CommandArgument='<%# DataBinder.Eval(Container.DataItem,"id") %>' ImageUrl="~/imgs/edit.gif" /></td>
                    <td><asp:ImageButton ID="IBorrar" runat="server" CommandName="Eliminar" CommandArgument='<%# DataBinder.Eval(Container.DataItem,"id") %>' ImageUrl="~/imgs/eliminar.gif" /></td>
                    <td>
                    <table border="1" width="100%">
                      <tr>
                        <td>Servicio</td>
                      </tr>
                      <tr>
                        <td style="font-weight: bold;"><asp:HiddenField runat="server" ID="HId" Value='<%# DataBinder.Eval(Container.DataItem,"id") %>' />
                        <%# DataBinder.Eval(Container.DataItem,"servicio") %></td>
                      </tr>
                      <tr>
                        <td>Área o ambiente</td>
                      </tr>
                      <tr>
                        <td style="font-weight: bold;"><%# DataBinder.Eval(Container.DataItem,"area") %></td>
                      </tr>
                    </table>
                    </td>
                    <asp:Repeater runat="server" ID="RElementos" DataSourceID="SElementos">
                        <HeaderTemplate></HeaderTemplate>
                        <ItemTemplate>
                        <td>
                            <table border="1" width="100%">
                              <tr>
                                <td class="celdaTitulo" colspan="2"><%# DataBinder.Eval(Container.DataItem, "nombre") %>
                                </td>
                              </tr>
                              <tr>
                                <td>Material</td>
                                <td>Estado</td>
                              </tr>
                              <tr>
                                <td style="font-weight: bold;white-space: nowrap;"><%# DataBinder.Eval(Container.DataItem, "material") %></td>
                                <td style="font-weight: bold;white-space: nowrap;"><%# DataBinder.Eval(Container.DataItem, "estado") %></td>
                              </tr>
                              <tr>
                                <td>Cantidad</td>
                                <td style="font-weight: bold;text-align: right"><%# DataBinder.Eval(Container.DataItem, "cantidad") %></td>
                              </tr>
                            </table>
                        </td>
                        </ItemTemplate>
                        <FooterTemplate></FooterTemplate>
                    </asp:Repeater>
                    <asp:SqlDataSource ID="SElementos" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT shared.nombre
                                ,IFNULL(evaluacion_elemento_afectado_detalle.material,'&nbsp;') AS material
                                ,estado.nombre AS estado
                                ,evaluacion_elemento_afectado_detalle.cantidad
                                FROM shared 
                                LEFT JOIN evaluacion_elemento_afectado_detalle ON (evaluacion_elemento_afectado_detalle.evaluacion_elemento_afectado=@elemento AND evaluacion_elemento_afectado_detalle.elemento=shared.id)
                                LEFT JOIN shared AS estado ON (evaluacion_elemento_afectado_detalle.estado=estado.id)
                                WHERE shared.nReservado=120 AND shared.szReservado IS NULL" >
                            <SelectParameters>
                                <asp:ControlParameter ControlID="HId" Name="elemento" PropertyName="Value" DefaultValue="0" />
                            </SelectParameters>
                    </asp:SqlDataSource>
              </tr>
            </ItemTemplate>
            <FooterTemplate>
                </table>
            </FooterTemplate>
        </asp:Repeater>
        <asp:SqlDataSource ID="SEAfectados" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                    ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                    SelectCommand="SELECT id,servicio,area FROM evaluacion_elemento_afectado WHERE proyecto=@proyecto"
                    >
                    <SelectParameters>
                        <asp:ControlParameter ControlID="UCProyecto" Name="proyecto" PropertyName="IdProyecto" DefaultValue="0" />
                    </SelectParameters>
            </asp:SqlDataSource>
            <div style="text-align: right">
                <asp:Button ID="BMas" runat="server" Text="+" onclick="BMas_Click" />
            </div>
            
            <asp:Panel runat="server" ID="PEAfectados" Visible="false">
            <div id="dAfectados" title="Elemento afectado" style="display:none;">
                <table border="1">
                  <tr>
                     <td>Servicio</td>
                     <td>
                        <asp:HiddenField runat="server" ID="HIdEAfectado" Value="" /><asp:TextBox runat="server" ID="TServicio" Text="" ></asp:TextBox>
                        <asp:RequiredFieldValidator ControlToValidate="TServicio" ErrorMessage="Por favor ingrese un servicio." ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                     </td>
                  </tr>
                  <tr>
                    <td>Área o ambiente</td>
                    <td><asp:TextBox runat="server" ID="TArea" Text=""></asp:TextBox></td>
                  </tr>
                    <asp:Repeater runat="server" ID="RElementos" DataSourceID="SElementos">
                        <HeaderTemplate></HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td class="celdaTitulo" colspan="2"><%# DataBinder.Eval(Container.DataItem, "nombre") %>
                                    <asp:HiddenField runat="server" ID="HId" Value='<%# DataBinder.Eval(Container.DataItem, "id") %>' />
                                    <asp:HiddenField runat="server" ID="HIdElemento" Value='<%# DataBinder.Eval(Container.DataItem, "idelemento") %>' />
                                </td>
                            </tr>
                            <tr>
                               <td>Material</td>
                               <td><asp:TextBox runat="server" ID="TMaterial" Text='<%# DataBinder.Eval(Container.DataItem, "material") %>'></asp:TextBox></td>
                            </tr>
                            <tr>
                               <td>Estado</td>
                               <td><asp:DropDownList ID="DEstado" runat="server" DataSourceID="SEstado" DataTextField="nombre" DataValueField="id" SelectedValue='<%# DataBinder.Eval(Container.DataItem, "estado") %>' AppendDataBoundItems="true">
                                        <asp:ListItem Text="(No definido)" Value=""></asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:SqlDataSource ID="SEstado" runat="server" 
                                        ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                                        ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                                        SelectCommand="SELECT id, nombre FROM shared WHERE nReservado=119 AND szReservado IS NULL ORDER BY nombre" >
                                </asp:SqlDataSource></td>
                            </tr>
                            <tr>
                                <td>Cantidad</td>
                                <td><asp:TextBox runat="server" ID="TCantidad" CssClass="float" Text='<%# DataBinder.Eval(Container.DataItem, "cantidad") %>'></asp:TextBox></td>
                              </tr>
                        </ItemTemplate>
                        <FooterTemplate></FooterTemplate>
                    </asp:Repeater>
                    <asp:SqlDataSource ID="SElementos" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:MySQLConnectionString %>" 
                            ProviderName="<%$ ConnectionStrings:MySQLConnectionString.ProviderName %>" 
                            SelectCommand="SELECT shared.id,shared.nombre
                                ,evaluacion_elemento_afectado_detalle.material
                                ,evaluacion_elemento_afectado_detalle.estado
                                ,evaluacion_elemento_afectado_detalle.cantidad
                                ,evaluacion_elemento_afectado_detalle.id AS idelemento
                                FROM shared 
                                LEFT JOIN evaluacion_elemento_afectado_detalle ON (evaluacion_elemento_afectado_detalle.evaluacion_elemento_afectado=@elemento AND evaluacion_elemento_afectado_detalle.elemento=shared.id)
                                WHERE shared.nReservado=120 AND shared.szReservado IS NULL" >
                            <SelectParameters>
                                <asp:ControlParameter ControlID="HIdEAfectado" Name="elemento" PropertyName="Value" DefaultValue="0" />
                            </SelectParameters>
                    </asp:SqlDataSource>
              </table>
              <div style="text-align: right;">
                  <asp:Button ID="BAceptar" runat="server" Text="Aceptar" 
                      onclick="BAceptar_Click" />
                  <asp:Button ID="BCancelar" runat="server" Text="Cancelar" 
                      CausesValidation="false" onclick="BCancelar_Click" />
              </div>
            </div>
            </asp:Panel>
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="true" />
    </asp:Panel>
</asp:Content>