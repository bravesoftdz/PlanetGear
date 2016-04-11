unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, SldWorks_TLB, SwConst_TLB,
  ComObj, Common_Unit, math;

type
  Wheels = array of array of Double;
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit3: TEdit;
    Label3: TLabel;
    Edit4: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ma,ma2: Wheels;
  A1,A2: OleVariant;
  qwerty,qwerty2: array of double;
  wheel1color, wheel2color, foncolor: TColor;
  x0, y0, delx, dely: integer;
  mashtab: Integer;
  koleso, koleso1, koleso0, koleso10: Wheels;
  I, z1, z2: Integer;
  m, x: extended;
  alfa:extended;
  J: Integer;
  bit: TBitmap;
  ugol: integer;
  h: extended;
  eps: extended;
  r: extended;
  rb: extended;
  ra: extended;
  rf: extended;
  a: extended;
  ro: extended;
  t00: extended;
  t01: extended;
  t02: extended;
  t03: extended;
  t04: extended;
  t05: extended;
  S1: Extended;
  S2: Extended;
  S3: Extended;
  S4: Extended;
  Zub:IFeature;
  Face:IFace2;
  body: IBody2;
  bodies:Variant;
   pd: IPartDoc;
  Form1: TForm1;


implementation

{$R *.dfm}

function d(t1, m, alfa:extended): extended;
begin
  Result:=r*t1-Pi*m/4;
end;

function p(t1,m, alfa:extended): extended;
begin
  Result:=d(t1,m, alfa)*Cos(DegToRad(alfa))+eps*Sin(DegToRad(alfa));
end;

function b(t2, m, alfa:extended): extended;
begin
  Result:=r*t2-Pi*m/4+h*Tan(DegToRad(alfa))+ro*(1-Sin(DegToRad(alfa)))/Cos(DegToRad(alfa));
end;

function b1(t2,m, alfa:extended): extended;
begin
  Result:=Sqrt(Sqr(a)+Sqr(b(t2,m, alfa)));
end;

function xe(t1,m, alfa: extended): Extended;
begin
  Result:=r*Sin(t1)-p(t1,m, alfa)*Cos(t1+DegToRad(alfa));
end;

function ye(t1, m, alfa: extended): Extended;
begin
  Result:=r*Cos(t1)+p(t1,m, alfa)*Sin(t1+DegToRad(alfa));
end;

function xv(t2,m, alfa: extended): Extended;
begin
  Result:=r*Sin(t2)+((1+ro/b1(t2,m, alfa))*(a*Sin(t2)-b(t2,m, alfa)*Cos(t2)));
end;

function yv(t2,m, alfa: extended): Extended;
begin
  Result:=r*Cos(t2)+((1+ro/b1(t2,m, alfa))*(a*Cos(t2)+b(t2,m, alfa)*Sin(t2)));
end;

function formuls(m, x: extended; z: integer):Wheels;
var
  count: Integer;
  t1, t2: extended;
  masx, masy, masx0, masy0, masx1, masy1, masx10, masy10: array of Extended;
  masx2, masy2, masx22, masy22: array of array of Extended;
  MasPolygon: wheels;
  I: Integer;
  J, c: Integer;
  Mas: Wheels;
begin //процедура расчета контура колеса
  count:=0;
  eps:=x*m;
  h:=1.25*m;
  r:=z*m/2;
  ro:=0.38*m;
  alfa:=20;
  rb:=r*Cos(DegToRad(alfa));
  rf:=r-h+eps;
  ra:=r+m+eps;
  a:=eps-h+ro;
  t00:=(Pi*m/4-(r+eps)*Tan(DegToRad(alfa)))/r;
  t01:=(Pi*m/4-h*Tan(DegToRad(alfa))-ro*(1-Sin(DegToRad(alfa)))/Cos(DegToRad(alfa)))/r;
  t02:=(Pi*m/4-(h-eps*Sqr(Cos(DegToRad(alfa)))-ro*(1-Sin(DegToRad(alfa))))/(Cos(DegToRad(alfa))*Sin(DegToRad(alfa))))/r;
  t03:=(Pi*m/4-(r-eps)*Tan(DegToRad(alfa))+Sqrt(Sqr(ra)-Sqr(r)*Sqr(Cos(DegToRad(alfa))))/Cos(DegToRad(alfa)))/r;
  t04:=a*Sin(xe(t03,m, alfa)/ra);
  t05:=2*Pi/2-t04;
  S1:=2*t01/10;
  S2:=(t05-t04)/10;
  S3:=(t01-t02)/10;
  S4:=(t03-t02)/10;

  t1:=t02;
  t2:=t02;

  while t1<(t03+0.001) do
    begin
      SetLength(masx,count+1);
      SetLength(masy,count+1);
      masx[count]:=xe(t1,m, alfa);
      masy[count]:=ye(t1,m, alfa);
      count:=count+1;
      t1:=t1+S4;
    end;
  count:=0;
  while t2<(t01+0.001) do
    begin
      SetLength(masx1,count+1);
      SetLength(masy1,count+1);
      masx1[count]:=xv(t2,m, alfa);
      masy1[count]:=yv(t2,m, alfa);
      count:=count+1;
      t2:=t2+S3;
    end;

  SetLength(masx2,length(masy),z);
  SetLength(masy2,length(masy),z);
  SetLength(masx22,length(masy),z);
  SetLength(masy22,length(masy),z);
  SetLength(masx10,length(masx1));
  SetLength(masy10,length(masx1));
  SetLength(mas,length(masy)+length(masy)+length(masx1)+length(masx1),2);
  i:=0;
      count:=0;
      for J := Length(masx2)-1 downto 0 do
        begin
          masx2[j,i]:=masx[j]*Cos(DegToRad((360/z)*i))-masy[j]*Sin(DegToRad((360/z)*i));
          masy2[j,i]:=masx[j]*Sin(DegToRad((360/z)*i))+masy[j]*Cos(DegToRad((360/z)*i));
          Mas[count,0]:=masx2[j,i];
          Mas[count,1]:=masy2[j,i];
          count:=count+1;
        end;
      for J := 0 to Length(masx10)-1 do
        begin
          masx10[j]:=masx1[j]*Cos(DegToRad((360/z)*i))-masy1[j]*Sin(DegToRad((360/z)*i));
          masy10[j]:=masx1[j]*Sin(DegToRad((360/z)*i))+masy1[j]*Cos(DegToRad((360/z)*i));
          Mas[count,0]:=masx10[j];
          Mas[count,1]:=masy10[j];
          count:=count+1;
        end;
      for J := Length(masx10)-1 downto 0 do
        begin
          masx10[j]:=-masx1[j]*Cos(DegToRad((360/z)*i))-masy1[j]*Sin(DegToRad((360/z)*i));
          masy10[j]:=-masx1[j]*Sin(DegToRad((360/z)*i))+masy1[j]*Cos(DegToRad((360/z)*i));
          Mas[count,0]:=masx10[j];
           Mas[count,1]:=masy10[j];
          count:=count+1;
        end;
      for J := 0 to Length(masx2)-1 do
        begin
          masx22[j,i]:=-masx[j]*Cos(DegToRad((360/z)*i))-masy[j]*Sin(DegToRad((360/z)*i));
          masy22[j,i]:=-masx[j]*Sin(DegToRad((360/z)*i))+masy[j]*Cos(DegToRad((360/z)*i));
          Mas[count,0]:=masx22[j,i];
          Mas[count,1]:=masy22[j,i];
          count:=count+1;
        end;
  Result:=Mas;
end;

procedure DrawKol(m1, x, b: extended; z: integer);
var
  e: integer;
  d1,d2, da1,da2, ra1,ra2, r1,r2: extended;
  SW: ISldWorks;
  ID: IDispatch;
  MD: IModelDoc2;
  CP: ISketchPoint;
  Points: array [0 .. 10] of ISketchPoint;
  Lines: array [0 .. 10] of ISketchSegment;
  SelMgr: ISelectionMgr;
begin
  d1 := m1 * z1;
  d2 := m1 * z2;
  r1 := d1 / 2;
  r2 := d2 / 2;
  da1 := d1 + (m1+x)*2*m;
  da2 := d2 + (m1+x)*2*m;
  ra1 := da1 / 2;
  ra2 := da2 / 2;
  SW := CreateOleObject('SldWorks.Application') as ISldWorks;
  if SW = nil then
    hr := E_OutOfMemory;
  If SW.Visible = false then
    SW.Visible := true;
  ID := SW.NewDocument
    ('C:\ProgramData\SolidWorks\SOLIDWORKS 2013\templates\gost-part.prtdot', 0,
    0, 0);
  MD := SW.NewPart as IModelDoc2;
  SelMgr := MD.ISelectionManager;

  if MD.SelectByID('', 'EXTSKETCHPOINT', 0, 0, 0) then
    CP := SelMgr.IGetSelectedObject(1) as ISketchPoint;

  //ќтрисовка первого зубчатого колеса сателлита

  MD.InsertSketch;
  Lines[0] := MD.ICreateCircle2(0, 0, 0, qwerty[1] / 1000, 0, 0);
  CP.Select(true);
  MD.SketchAddConstraints('sgCONCENTRIC');
  MD.ClearSelection;

  Lines[0].Select(true);
  MD.AddDimension(-(ra + 10) / 1000, 0, 0);
  (MD.Parameter('D1@Ёскиз1') as IDimension).SystemValue := qwerty[1]*2 / 1000;
  MD.ClearSelection;
  MD.FeatureManager.FeatureExtrusion2(true, false, false, 0, 0, b / 1000, 0,
    false, false, false, false, 0.0, 0.0, false, false, false, false, true,
    false, true, 0, 0, true);

  //Ёвольвента дл€ первого зубчатого колеса сателлита

  MD.SelectByID('', 'FACE', 0, 0, 0);
  MD.InsertSketch;
  MD.CreateSpline(A1);
  MD.ClearSelection;

  if MD.SelectByID('Point1', 'SKETCHPOINT', qwerty[0] / 1000, qwerty[1] / 1000, 0) then
    Points[2] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;
  if MD.SelectByID('Point'+IntToStr(Length(qwerty)-1), 'SKETCHPOINT', qwerty[Length(qwerty)-3] / 1000, qwerty[Length(qwerty)-2] / 1000, 0) then
    Points[3] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;

  Lines[1] := MD.ICreateLine2(qwerty[0] / 1000, qwerty[1] / 1000, 0,
    qwerty[Length(qwerty)-3] / 1000, qwerty[Length(qwerty)-2] / 1000, 0);
  MD.ClearSelection;
  if MD.SelectByID('Point'+IntToStr(Length(qwerty)), 'SKETCHPOINT', qwerty[0] / 1000, qwerty[1] / 1000, 0) then
    Points[0] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;
  if MD.SelectByID('Point'+IntToStr(Length(qwerty)+1), 'SKETCHPOINT', qwerty[Length(qwerty)-3] / 1000, qwerty[Length(qwerty)-2] / 1000, 0) then
    Points[1] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;

  Points[0].Select(true);
  Points[2].Select(true);
  MD.SketchAddConstraints('sgMERGEPOINTS');
  MD.ClearSelection;

  Points[1].Select(true);
  Points[3].Select(true);
  MD.SketchAddConstraints('sgMERGEPOINTS');
  MD.ClearSelection;

  Zub:=MD.FeatureManager.FeatureCut3(true, false, false, 0, 0, b / 1000, 0.1, false,
    false, false, false, 1.74532925199433E-02, 1.74532925199433E-02, false,
    false, false, false, false, true, true, true, true, false, 0, 0, false);
  MD.ClearSelection;

  // руговой массив дл€ первого зубчатого колеса сателлита

   pd:= md as IPartDoc;
  bodies:= pd.getbodies(swSolidBody);
  body:= IDispatch(bodies[0]) as IBody2;
  Face :=body.IGetFirstFace;
  while face <> nil do
  begin
    if face.IGetSurface.IsCylinder then
    begin
      break;
    end;
    face:= face.IGetNextFace;
  end;
  (face as IEntity).SelectByMark(false, 1);
  Zub.SelectByMark(true, 4);
   md.FeatureManager.FeatureCircularPattern4(z1, 6.3, False, 'NULL', False, True, False);

   //ќтрисовка перешейка между сателлитами

  MD.Extension.SelectByID2('', 'FACE', -7.73414184925514E-03, -1.57609512430668E-03, 0, False, 0, nil, 0);
  MD.SketchManager.CreateCircle(0, 0, 0, 0.019196, -0.000517, 0);
  MD.Extension.SelectByID2('Arc1', 'SKETCHSEGMENT', 0, 0, 0, False, 0, nil, 0);
  MD.FeatureManager.FeatureExtrusion2(True, False, False, 0, 0, 0.01, 0.01, False, False, False, False,
   1.74532925199433E-02, 1.74532925199433E-02, False, False, False, False, True, True, True, 0, 0, False);

 //ќтрисовка ¬торого зубчатого колеса сателлита
   MD.InsertSketch;
   MD.Extension.SelectByID2('', 'FACE', 9.67300375629065E-03, 4.62859919519687E-03, -9.99999999993406E-03, False, 0, nil, 0);
  Lines[0] := MD.ICreateCircle2(0, 0, 0, qwerty[1] / 1000, 0, 0);
  CP.Select(true);
  MD.SketchAddConstraints('sgCONCENTRIC');
  MD.ClearSelection;

  Lines[0].Select(true);
  MD.AddDimension(-(ra + 10) / 1000, 0, 0);
  (MD.Parameter('D1@Ёскиз1') as IDimension).SystemValue := qwerty[1]*2 / 1000;
  MD.ClearSelection;
  MD.FeatureManager.FeatureExtrusion2(true, false, false, 0, 0, b / 1000, 0,
    false, false, false, false, 0.0, 0.0, false, false, false, false, true,
    false, true, 0, 0, true);


 //Ёвольвента дл€ ¬торого зубчатого колеса сателлита
 MD.Extension.SelectByID2('', 'FACE', 1.72133936480918E-02, 4.47299188073771E-02, -9.99999999993406E-03, False, 0, Nil, 0) ;
  MD.InsertSketch;
  MD.CreateSpline(A2);
  MD.ClearSelection;

  if MD.SelectByID('Point1', 'SKETCHPOINT', qwerty[0] / 1000, qwerty[1] / 1000, 0) then
    Points[2] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;
  if MD.SelectByID('Point'+IntToStr(Length(qwerty)-1), 'SKETCHPOINT', qwerty[Length(qwerty)-3] / 1000, qwerty[Length(qwerty)-2] / 1000, 0) then
    Points[3] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;

  Lines[1] := MD.ICreateLine2(qwerty[0] / 1000, qwerty[1] / 1000, 0,
    qwerty[Length(qwerty)-3] / 1000, qwerty[Length(qwerty)-2] / 1000, 0);
  MD.ClearSelection;
  if MD.SelectByID('Point'+IntToStr(Length(qwerty)), 'SKETCHPOINT', qwerty[0] / 1000, qwerty[1] / 1000, 0) then
    Points[0] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;
  if MD.SelectByID('Point'+IntToStr(Length(qwerty)+1), 'SKETCHPOINT', qwerty[Length(qwerty)-3] / 1000, qwerty[Length(qwerty)-2] / 1000, 0) then
    Points[1] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;

  Points[0].Select(true);
  Points[2].Select(true);
  MD.SketchAddConstraints('sgMERGEPOINTS');
  MD.ClearSelection;

  Points[1].Select(true);
  Points[3].Select(true);
  MD.SketchAddConstraints('sgMERGEPOINTS');
  MD.ClearSelection;

  Zub:=MD.FeatureManager.FeatureCut3(true, false, false, 0, 0, b / 1000, 0.1, false,
    false, false, false, 1.74532925199433E-02, 1.74532925199433E-02, false,
    false, false, false, false, true, true, true, true, false, 0, 0, false);
  MD.ClearSelection;

  // руговой массив дл€  ¬торого зубчатого колеса сателлита

  pd:= md as IPartDoc;
  bodies:= pd.getbodies(swSolidBody);
  body:= IDispatch(bodies[0]) as IBody2;
  Face :=body.IGetFirstFace;
  while face <> nil do
  begin
    if face.IGetSurface.IsCylinder then
    begin
      break;
    end;
    face:= face.IGetNextFace;
  end;
  (face as IEntity).SelectByMark(false, 1);
  Zub.SelectByMark(true, 4);
   md.FeatureManager.FeatureCircularPattern4(z2, 6.3, False, 'NULL', False, True, False);

end;

procedure TForm1.Button1Click(Sender: TObject);
var
  z: integer;
  m, b, x, angle: extended;
begin
  m := StrToFloat(Edit2.Text);
  b := StrToFloat(Edit3.Text);
  x := StrToFloat(Edit4.Text);
  z1 := StrToInt(Edit1.Text);
  z2 := StrToInt(Edit5.Text);
  ma := formuls(m,x,z1);
  ma2 := formuls(m,x,z2);
  SetLength(qwerty,Length(ma)*3);
  SetLength(qwerty2,Length(ma2)*3);
  for I := 0 to Length(ma)-1 do
  begin
    qwerty[i*3]:=ma[i,0];
    qwerty[i*3+1]:=ma[i,1];
    qwerty[i*3+2]:=0;
  end;
  for I := 0 to Length(ma2)-1 do
  begin
    qwerty[i*3]:=ma[i,0];
    qwerty[i*3+1]:=ma[i,1];
    qwerty[i*3+2]:=-9.99999999993406E-03;
  end;
  A1 := VarArrayCreate([0, Length(qwerty)-1], varDouble);
  A2 := VarArrayCreate([0, Length(qwerty)-1], varDouble);
  for I := 0 to Length(qwerty)-1 do
  begin
    A1[i]:=qwerty[i]/1000;
  end;
  for I := 0 to Length(qwerty)-1 do
  begin
    A2[i]:=qwerty[i]/1000;
  end;
    for I := 0 to Length(ma)-1 do
  begin

    A2[i*3+2]:=10/1000 ;
  end;
  ShowMessage('q');
  DrawKol(m, x, b, z1);
end;

end.
