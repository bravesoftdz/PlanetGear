unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Samples.Spin, Vcl.StdCtrls, Math,
  constants, Planet_Gear_2KH, Materials, Vcl.ComCtrls, Vneshn, Vnut;

type

  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    SpinEdit1: TSpinEdit;
    Button1: TButton;
    Label6: TLabel;
    Edit2: TEdit;
    Label7: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    ComboBox4: TComboBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    ComboBox5: TComboBox;
    ComboBox6: TComboBox;
    ComboBox7: TComboBox;
    ComboBox8: TComboBox;
    ComboBox9: TComboBox;
    ComboBox10: TComboBox;
    ComboBox11: TComboBox;
    ComboBox12: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label17: TLabel;
    Button2: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Input: TInput;
  Output: TOutput;
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
Var
  Planet: TPlanet_Gear_2KH;
  I: Integer;
begin
  Input.ih := strtofloat(Edit1.Text);
  Input.Nw := SpinEdit1.Value;
  Input.P := strtofloat(Edit2.Text);
  Input.N := strtoint(Edit3.Text);
  if ComboBox1.Text = '������������' then
    Input.Wikr_1 := 0;
  if ComboBox1.Text = '����������' then
    Input.Wikr_1 := 1;
  if ComboBox1.Text = '�����������' then
    Input.Wikr_1 := 2;

  if ComboBox5.Text = '������������' then
    Input.Wikr_2 := 0;
  if ComboBox5.Text = '����������' then
    Input.Wikr_2 := 1;
  if ComboBox5.Text = '�����������' then
    Input.Wikr_2 := 2;

  if ComboBox9.Text = '������������' then
    Input.Wikr_3 := 0;
  if ComboBox9.Text = '����������' then
    Input.Wikr_3 := 1;
  if ComboBox9.Text = '�����������' then
    Input.Wikr_3 := 2;

  if ComboBox2.Text = '�������' then
    Input.Zagotowka_1 := 0;
  if ComboBox2.Text = '���������' then
    Input.Zagotowka_1 := 1;
  if ComboBox2.Text = '������' then
    Input.Zagotowka_1 := 2;
  if ComboBox2.Text = '�������' then
    Input.Zagotowka_1 := 3;

  if ComboBox7.Text = '�������' then
    Input.Zagotowka_2 := 0;
  if ComboBox7.Text = '���������' then
    Input.Zagotowka_2 := 1;
  if ComboBox7.Text = '������' then
    Input.Zagotowka_2 := 2;
  if ComboBox7.Text = '�������' then
    Input.Zagotowka_2 := 3;

  if ComboBox1.Text = '�������' then
    Input.Zagotowka_3 := 0;
  if ComboBox1.Text = '���������' then
    Input.Zagotowka_3 := 1;
  if ComboBox1.Text = '������' then
    Input.Zagotowka_3 := 2;
  if ComboBox1.Text = '�������' then
    Input.Zagotowka_3 := 3;

  if ComboBox3.Text = 'Ra1.6' then
    Input.Ra_1 := 0;
  if ComboBox3.Text = 'Ra3.2' then
    Input.Ra_1 := 1;
  if ComboBox3.Text = 'Ra6.3' then
    Input.Ra_1 := 2;

  if ComboBox8.Text = 'Ra1.6' then
    Input.Ra_2 := 0;
  if ComboBox8.Text = 'Ra3.2' then
    Input.Ra_2 := 1;
  if ComboBox8.Text = 'Ra6.3' then
    Input.Ra_2 := 2;

  if ComboBox12.Text = 'Ra1.6' then
    Input.Ra_3 := 0;
  if ComboBox12.Text = 'Ra3.2' then
    Input.Ra_3 := 1;
  if ComboBox12.Text = 'Ra6.3' then
    Input.Ra_3 := 2;

  Input.Termobr_Material_1 := ComboBox4.Text;
  Input.Termobr_Material_2 := ComboBox6.Text;
  Input.Termobr_Material_3 := ComboBox10.Text;
  Input.Lh := strtoint(Edit4.Text);

  Planet := TPlanet_Gear_2KH.create(Input);
  Planet.raschet;
  Planet.record_Output(Output);
  Memo1.Clear;
  with Memo1 do
  begin
    Lines.Add('---------------------�������� ���������--------------------------');
    Lines.Add('����� ����� �������� - ' + Output.Material_1);
    Lines.Add('����� ����� ��������� - ' + Output.Material_2);
    Lines.Add('����� ����� ������ - ' + Output.Material_3);
    Lines.Add('�������������� �������� - ' + Output.termobr_1);
    Lines.Add('�������������� ��������� - ' + Output.termobr_2);
    Lines.Add('�������������� ������ - ' + Output.termobr_3);
    Lines.Add('������� �������� ������ - ' + floattostrf(Output.Nv,ffFixed,7,2)+', ��/���');
    Lines.Add('������ �� ���� �������� - ' + floattostrf(Output.T_1,ffFixed,7,2)+', �*�');
    Lines.Add('��������� ������ �� ���� ������ - ' + floattostrf(Output.T_h,ffFixed,7,2)+', �*�');
    Lines.Add('��������� ��������� ������ ����� ��������� � ���������� - ' +
      floattostrf(Output.Tp_12,ffFixed,7,2)+', �*�');
    Lines.Add('��������� ��������� ������ ����� ��������� � ������� - ' +
      floattostrf(Output.Tp_13,ffFixed,7,2)+', �*�');
    Lines.Add('������ - ' + Output.M.tostring);
    Lines.Add('���������� ������ �������� - ' + Output.z_1.ToString);
    Lines.Add('���������� ������ ��������� - ' + Output.z_2.ToString);
    Lines.Add('���������� ������ ������ - ' + Output.z_3.ToString);
    Lines.Add('��������� ���������� - ' + Output.aw.ToString+', mm');
    Lines.Add('������������ ��������� ����� ��������� � ���������� - ' +
      floattostrf(Output.u_12,ffFixed,7,2));
    Lines.Add('������������ ��������� ����� ���������� � ������� - ' +
      floattostrf(Output.u_23,ffFixed,7,2));
    Lines.Add('������ ����� �������� - ' + floattostrf(Output.B_1,ffFixed,7,2)+', mm');
    Lines.Add('������ ����� ��������� - ' + floattostrf(Output.B_2,ffFixed,7,2)+', mm');
    Lines.Add('������ ����� ������ - ' + floattostrf(Output.B_3,ffFixed,7,2)+', mm');
    Lines.Add('������� ���������� ������ �������� - ' + floattostrf(Output.Da_1,ffFixed,7,2)+', mm');
    Lines.Add('������� ���������� ������ ��������� - ' + floattostrf(Output.Da_2,ffFixed,7,2)+', mm');
    Lines.Add('������� ���������� ������ ������ - ' + floattostrf(Output.Da_3,ffFixed,7,2)+', mm');
    Lines.Add('����������� ������� �������� - ' + floattostrf(Output.D_1,ffFixed,7,2)+', mm');
    Lines.Add('����������� ������� ��������� - ' + floattostrf(Output.D_2,ffFixed,7,2)+', mm');
    Lines.Add('����������� ������� ������ - ' + floattostrf(Output.D_3,ffFixed,7,2)+', mm');
    Lines.Add('�������� ������ � ���������� - ' + floattostrf(Output.Ft,ffFixed,7,2)+', H');
    Lines.Add('���������� ���������� ����� ���������� � ��������� - ' +
      floattostrf(Output.Sigma_H_12,ffFixed,7,2)+', ���');
    Lines.Add('���������� ���������� ����� ���������� � ������� - ' +
      floattostrf(Output.Sigma_H_23,ffFixed,7,2)+', ���');
    Lines.Add('���������� ������ � ���� �������� - ' +
      floattostrf(Output.Sigma_F_1,ffFixed,7,2)+', ���');
    Lines.Add('���������� ������ � ���� ��������� - ' +
      floattostrf(Output.Sigma_F_2,ffFixed,7,2)+', ���');
    Lines.Add('����������� ����������� ���������� ���������� - ' +
      floattostrf(Output.Sigma_Hp_min,ffFixed,7,2)+', ���');
    Lines.Add('����������� ����������� ���������� ������ - ' +
      floattostrf(Output.Sigma_Fp_min,ffFixed,7,2)+', ���');
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  DrawKol(Output.m,0,Output.B_1,round(Output.z_1));
  DrawKol(Output.m,0,Output.B_2,round(Output.z_2));
  DrawKolVnut(Output.m,0,Output.B_3,round(Output.z_3));
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  I: Integer;
  str: string;
begin
  ComboBox1.Text := finish[0];
  for I := 0 to Length(finish) - 1 do
  begin
    ComboBox1.Items.Add(finish[I]);
  end;
  ComboBox5.Text := finish[0];
  for I := 0 to Length(finish) - 1 do
  begin
    ComboBox5.Items.Add(finish[I]);
  end;
  ComboBox9.Text := finish[0];
  for I := 0 to Length(finish) - 1 do
  begin
    ComboBox9.Items.Add(finish[I]);
  end;

  ComboBox2.Text := PatternProcess[0];
  for I := 0 to Length(PatternProcess) - 1 do
  begin
    ComboBox2.Items.Add(PatternProcess[I]);
  end;
  ComboBox7.Text := PatternProcess[0];
  for I := 0 to Length(PatternProcess) - 1 do
  begin
    ComboBox7.Items.Add(PatternProcess[I]);
  end;
  ComboBox11.Text := PatternProcess[0];
  for I := 0 to Length(PatternProcess) - 1 do
  begin
    ComboBox11.Items.Add(PatternProcess[I]);
  end;

  ComboBox3.Text := roughness[0];
  for I := 0 to Length(roughness) - 1 do
  begin
    ComboBox3.Items.Add(roughness[I]);
  end;
  ComboBox8.Text := roughness[0];
  for I := 0 to Length(roughness) - 1 do
  begin
    ComboBox8.Items.Add(roughness[I]);
  end;
  ComboBox12.Text := roughness[0];
  for I := 0 to Length(roughness) - 1 do
  begin
    ComboBox12.Items.Add(roughness[I]);
  end;

  ComboBox4.Text := marka_termobr[1];
  for I := 1 to 38 do
  begin
    ComboBox4.Items.Add(marka_termobr[I]);
  end;
  ComboBox6.Text := marka_termobr[1];
  for I := 1 to 38 do
  begin
    ComboBox6.Items.Add(marka_termobr[I]);
  end;
  ComboBox10.Text := marka_termobr[1];
  for I := 1 to 38 do
  begin
    ComboBox10.Items.Add(marka_termobr[I]);
  end;
end;

end.
