unit Satellit;

interface

Uses math, SldWorks_TLB, SwConst_TLB,
  ComObj, SysUtils, Variants;

type
  Wheels = array of array of Double;
  procedure DrawKolS(m, x, b, m02, x02, b02, pe: extended; z, z02: integer; MyDIR: string);

var
ma,ma2: Wheels;
  A1, A2: OleVariant;
  qwerty,qwerty2: array of double;
  x0, y0, delx, dely: integer;
  mashtab: Integer;
  koleso, koleso1, koleso0, koleso10: Wheels;
  I, z1, z2: Integer;
  m, x: extended;
  alfa:extended;
  J: Integer;
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

implementation

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

procedure DrawKolS(m, x, b, m02, x02, b02, pe: extended; z, z02: integer; MyDIR: string);
var
  D_val,
  b_ven, D_val2,
  b_ven2: extended;

  razmer:extended;

  e,count: integer;
  d, da, ra, r, da2: extended;
  SW: ISldWorks;
  ID: IDispatch;
  IF1, IF2: IFeature;
  MD: IModelDoc2;
  CP: ISketchPoint;
  Points: array [0 .. 40] of ISketchPoint;
  Lines: array [0 .. 25] of ISketchSegment;
  SelMgr: ISelectionMgr;
  pd: IPartDoc;
    body1: IBody2;
    face1: IFace2;
    bodies: Variant;
begin
ma := formuls(m,x,z);
  SetLength(qwerty,Length(ma)*3);
  for I := 0 to Length(ma)-1 do
  begin
    qwerty[i*3]:=ma[i,0];
    qwerty[i*3+1]:=ma[i,1];
    qwerty[i*3+2]:=0;
  end;
  A1 := VarArrayCreate([0, Length(qwerty)-1], varDouble);
  for I := 0 to Length(qwerty)-1 do
  begin
    A1[i]:=qwerty[i]/1000;
  end;

ma2 := formuls(m02,x02,z02);
  SetLength(qwerty2,Length(ma2)*3);
  for I := 0 to Length(ma2)-1 do
  begin
    qwerty2[i*3]:=ma2[i,0];
    qwerty2[i*3+1]:=ma2[i,1];
    qwerty2[i*3+2]:=0;
  end;
  A2 := VarArrayCreate([0, Length(qwerty2)-1], varDouble);
  for I := 0 to Length(qwerty2)-1 do
  begin
    A2[i]:=qwerty2[i]/1000;
  end;

  d := m * z;
  r := d / 2;
  da := qwerty[1]/1000;
  da2 := qwerty2[1]/1000;
  ra := da / 2;
  SW := CreateOleObject('SldWorks.Application') as ISldWorks;
  If SW.Visible = false then
    SW.Visible := true;
  ID := SW.NewDocument
    (MyDIR+'\gost-part.prtdot', 0,
    0, 0);
  MD := SW.NewPart as IModelDoc2;
  SelMgr := MD.ISelectionManager;

  if MD.SelectByID('', 'EXTSKETCHPOINT', 0, 0, 0) then
    CP := SelMgr.IGetSelectedObject(1) as ISketchPoint;

  MD.InsertSketch;
  MD.CreateCenterLineVB(0, 0, 0, 0, qwerty[1] / 500, 0);
  MD.SelectByName(0,'Line1');
  MD.SketchAddConstraints('sgVERTICAL2D');
  cp.Select(true);
  MD.SketchAddConstraints('sgCOINCIDENT');
  MD.ClearSelection;

  MD.CreateCenterLineVB(0, 0, 0, qwerty[1] / 500, 0, 0);
  MD.SelectByName(0,'Line2');
  MD.SketchAddConstraints('sgHORIZONTAL2D');
  cp.Select(true);
  MD.SketchAddConstraints('sgCOINCIDENT');
  MD.ClearSelection;

  D_val:=(qwerty[1]/2) / 1000;
  b_ven:=b / 1000;
  D_val2:=(qwerty[1]/2) / 1000;
  b_ven2:=b02 / 1000;

  Lines[0] := MD.ICreateLine2( 0, D_val/2, 0, b_ven/2, D_val/2, 0);
  MD.AddDimension((b/4)/ 1000,0,0);
  MD.ClearSelection;
  Md.SelectByID('Line2', 'SKETCHSEGMENT', 0, 0, 0);
  Lines[0].Select(true);
  MD.AddDimension(-(b/4)/ 1000,-(b)/ 1000,0);
  if MD.SelectByID('Point1', 'SKETCHPOINT', 0, D_val/2, 0) then
    Points[0] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;
  if MD.SelectByID('Point2', 'SKETCHPOINT', b_ven/2, D_val/2, 0) then
    Points[1] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;
  Md.SelectByID('Line1', 'SKETCHSEGMENT', 0, 0, 0);
  Points[0].Select(true);
  MD.SketchAddConstraints('sgCOINCIDENT');
  MD.ClearSelection;

  Lines[1] := MD.ICreateLine2( b_ven/2, D_val/2, 0, b_ven/2, D_val/2+D_val/4, 0);
  MD.SketchAddConstraints('sgVERTICAL2D');
  MD.AddDimension((b/4)/ 1000,0,0);
  MD.ClearSelection;
  if MD.SelectByID('Point3', 'SKETCHPOINT', b_ven/2, D_val/2, 0) then
    Points[2] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;
  if MD.SelectByID('Point4', 'SKETCHPOINT', b_ven/2, D_val/2+D_val/4, 0) then
    Points[3] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;
  Points[1].Select(true);
  Points[2].Select(true);
  MD.SketchAddConstraints('sgMERGEPOINTS');

  Lines[2] := MD.ICreateLine2( b_ven/2, D_val/2+D_val/4, 0, b_ven/2-b_ven/8, D_val/2+D_val/4+b_ven/8, 0);
  MD.AddDimension((b/4)/ 1000,0,0);
  MD.ClearSelection;
  if MD.SelectByID('Point5', 'SKETCHPOINT',b_ven/2, D_val/2+D_val/4, 0) then
    Points[4] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;
  if MD.SelectByID('Point6', 'SKETCHPOINT',  b_ven/2-b_ven/8, D_val/2+D_val/4+b_ven/8, 0) then
    Points[5] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;
  Md.SelectByID('Line2', 'SKETCHSEGMENT', 0, 0, 0);
  Lines[2].Select(true);
  MD.AddDimension(-(b/4)/ 1000,-(b)/ 1000,0);

  Lines[3] := MD.ICreateLine2( b_ven/2-b_ven/8, D_val/2+D_val/4+b_ven/8, 0, b_ven/2-b_ven/8, da-(3*D_val/16+b_ven/8+2.5*m/1000), 0);
  MD.SketchAddConstraints('sgVERTICAL2D');
  MD.AddDimension((b/4)/ 1000,0,0);
  MD.ClearSelection;
  if MD.SelectByID('Point7', 'SKETCHPOINT', b_ven/2-b_ven/8, D_val/2+D_val/4+b_ven/8, 0) then
    Points[6] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;
  if MD.SelectByID('Point8', 'SKETCHPOINT', b_ven/2-b_ven/8, da-(3*D_val/16+b_ven/8+2.5*m/1000), 0) then
    Points[7] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;

  Lines[4] := MD.ICreateLine2(b_ven/2-b_ven/8, da-(3*D_val/16+b_ven/8+2.5*m/1000), 0,  b_ven/2, da-(3*D_val/16+b_ven/8+2.5*m/1000), 0);
  MD.SketchAddConstraints('sgHORIZONTAL2D');
  MD.AddDimension((b/4)/ 1000,0,0);
  MD.ClearSelection;
  if MD.SelectByID('Point9', 'SKETCHPOINT', b_ven/2-b_ven/8, da-(3*D_val/16+b_ven/8+2.5*m/1000), 0) then
    Points[8] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;
  if MD.SelectByID('Point10', 'SKETCHPOINT', b_ven/2, da-(3*D_val/16+b_ven/8+2.5*m/1000), 0) then
    Points[9] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;

  Lines[5] := MD.ICreateLine2(b_ven/2, da-(3*D_val/16+b_ven/8+2.5*m/1000), 0,b_ven/2, da, 0);
  MD.AddDimension((b/4)/ 1000,0,0);
  MD.ClearSelection;
  if MD.SelectByID('Point11', 'SKETCHPOINT', b_ven/2, da-(3*D_val/16+b_ven/8+2.5*m/1000), 0) then
    Points[10] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;
  if MD.SelectByID('Point12', 'SKETCHPOINT', b_ven/2, da, 0) then
    Points[11] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;

  Lines[6] := MD.ICreateLine2(b_ven/2, da, 0, 0, da, 0);
  MD.AddDimension((b/4)/ 1000,0,0);
  MD.ClearSelection;
  if MD.SelectByID('Point13', 'SKETCHPOINT', b_ven/2, da, 0) then
    Points[12] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;
  if MD.SelectByID('Point14', 'SKETCHPOINT',0, da, 0) then
    Points[13] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;
  Md.SelectByID('Line1', 'SKETCHSEGMENT', 0, 0, 0);
  Points[13].Select(true);
  MD.SketchAddConstraints('sgCOINCIDENT');
  MD.ClearSelection;
  Md.SelectByID('Line1', 'SKETCHSEGMENT', -4.43630136986284E-04, 1.92239726027397E-02, 0);
  for I := 0 to 6 do
    Lines[i].Select(true);
  MD.SketchMirror;
  MD.ClearSelection;

   //перешеек
   Md.SelectByID('Line4', 'SKETCHSEGMENT', 1.01054875185534E-02, 1.62960791327966E-02,0);
   md.EditDelete;

   lines[11]:=md.iCreateLine2(b_ven/2, D_val/2+D_val/4, 0, b_ven/2+pe, D_val/2+D_val/4, 0);
   MD.AddDimension((b/4)/ 1000,0,0);
  MD.ClearSelection;

  lines[12]:=md.iCreateLine2(b_ven/2, D_val/2, 0, b_ven/2+pe, D_val/2, 0);

  MD.ClearSelection;

  {lines[13]:=md.iCreateLine2(0.026501, 0.020151, 0, 0.026501, 0.013434, 0);
   MD.AddDimension((b/4)/ 1000,0,0);
  MD.ClearSelection;}


//¬торое колесо

  lines[14]:=md.iCreateLine2( b_ven/2+pe, D_val2/2, 0, b_ven/2+pe+b_ven2, D_val2/2, 0);
   MD.AddDimension((b02/4)/ 1000,0,0);
  MD.ClearSelection;
  if MD.SelectByID('Point1', 'SKETCHPOINT', b_ven/2+pe, D_val2/2, 0) then
    Points[15] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;
  if MD.SelectByID('Point1', 'SKETCHPOINT', b_ven/2+pe+b_ven2, D_val2/2, 0) then
    Points[16] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;


  lines[15]:=md.iCreateLine2( b_ven/2+pe+b_ven2, D_val2/2, 0, b_ven/2+pe+b_ven2, D_val2/2+D_val2/4, 0);
   MD.AddDimension((b02/4)/ 1000,0,0);
  MD.ClearSelection;
   if MD.SelectByID('Point1', 'SKETCHPOINT', b_ven/2+pe+b_ven2, D_val2/2, 0) then
    Points[17] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;
  if MD.SelectByID('Point1', 'SKETCHPOINT',b_ven/2+pe+b_ven2, D_val2/2+D_val2/4, 0) then
    Points[18] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;

  lines[16]:=md.iCreateLine2( b_ven/2+pe+b_ven2, D_val2/2+D_val2/4, 0, b_ven/2+pe+b_ven2-b_ven2/8, D_val2/2+D_val2/4+b_ven2/8, 0);
   MD.AddDimension((b02/4)/ 1000,0,0);
  MD.ClearSelection;
   if MD.SelectByID('Point1', 'SKETCHPOINT', b_ven/2+pe+b_ven2, D_val2/2+D_val2/4, 0) then
    Points[19] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;
  if MD.SelectByID('Point1', 'SKETCHPOINT',  b_ven/2+pe+b_ven2-b_ven2/8, D_val2/2+D_val2/4+b_ven2/8, 0) then
    Points[20] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;

  lines[17]:=md.iCreateLine2( b_ven/2+pe+b_ven2-b_ven2/8, D_val2/2+D_val2/4+b_ven2/8, 0, b_ven/2+pe+b_ven2-b_ven2/8, da2-(3*D_val2/16+b_ven2/8+2.5*m02/1000), 0);
   MD.AddDimension((b02/4)/ 1000,0,0);
  MD.ClearSelection;
   if MD.SelectByID('Point1', 'SKETCHPOINT', b_ven/2+pe+b_ven2-b_ven2/8, D_val2/2+D_val2/4+b_ven2/8, 0) then
    Points[21] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;
  if MD.SelectByID('Point1', 'SKETCHPOINT', b_ven/2+pe+b_ven2-b_ven2/8, da2-(3*D_val2/16+b_ven2/8+2.5*m02/1000), 0) then
    Points[22] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;


   lines[18]:=md.iCreateLine2(b_ven/2+pe+b_ven2-b_ven2/8, da2-(3*D_val2/16+b_ven2/8+2.5*m02/1000), 0,  b_ven/2+pe+b_ven2, da2-(3*D_val2/16+b_ven2/8+2.5*m02/1000), 0);
   MD.AddDimension((b02/4)/ 1000,0,0);
  MD.ClearSelection;
   if MD.SelectByID('Point1', 'SKETCHPOINT', b_ven/2+pe+b_ven2-b_ven2/8, da2-(3*D_val2/16+b_ven2/8+2.5*m02/1000), 0) then
    Points[23] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;
  if MD.SelectByID('Point1', 'SKETCHPOINT',  b_ven/2+pe+b_ven2, da2-(3*D_val2/16+b_ven2/8+2.5*m02/1000), 0) then
    Points[24] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;


   lines[19]:=md.iCreateLine2(b_ven/2+pe+b_ven2, da2-(3*D_val2/16+b_ven2/8+2.5*m02/1000), 0,b_ven/2+pe+b_ven2, da2, 0);
   MD.AddDimension((b02/4)/ 1000,0,0);
  MD.ClearSelection;
  if MD.SelectByID('Point1', 'SKETCHPOINT',b_ven/2+pe+b_ven2, da2-(3*D_val2/16+b_ven2/8+2.5*m02/1000),0) then
    Points[25] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;
  if MD.SelectByID('Point1', 'SKETCHPOINT', b_ven/2+pe+b_ven2, da2, 0) then
    Points[26] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;


   lines[20]:=md.iCreateLine2(b_ven/2+pe+b_ven2, da2, 0, b_ven/2+pe+b_ven2/2, da2, 0);
   MD.AddDimension((b02/4)/ 1000,0,0);
  MD.ClearSelection;
   if MD.SelectByID('Point1', 'SKETCHPOINT',b_ven/2+pe+b_ven2, da2, 0) then
    Points[27] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;
  if MD.SelectByID('Point1', 'SKETCHPOINT',  b_ven/2+pe+b_ven2/2, da2, 0) then
    Points[28] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;

  Md.CreateCenterLineVB(b_ven/2+pe+b_ven2/2, 0, 0, b_ven/2+pe+b_ven2/2, qwerty2[1] / 500, 0);
   if MD.SelectByID('Point1', 'SKETCHPOINT',b_ven/2+pe+b_ven2/2, 0, 0) then
    Points[29] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;
  if MD.SelectByID('Point1', 'SKETCHPOINT',  b_ven/2+pe+b_ven2/2, qwerty2[1] / 500, 0) then
    Points[30] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;


  Md.SelectByID('Line26', 'SKETCHSEGMENT', b_ven/2+pe+b_ven2/2, 0, 0);
  Points[30].Select(true);
  MD.SketchAddConstraints('sgCOINCIDENT');
  MD.ClearSelection;
  Md.SelectByID('Line26', 'SKETCHSEGMENT', b_ven/2+pe+b_ven2/2, qwerty2[1] / 500, 0);
  for I := 16 to 20 do
    Lines[i].Select(true);
  MD.SketchMirror;
  MD.ClearSelection;


  //Ёвольвента 1 колесо

  Md.SelectByID('Line2', 'SKETCHSEGMENT', 0.001, 0, 0);
  IF2:=MD.FeatureManager.FeatureRevolve2(True, True, False, False, False, False, 0, 0, 6.2831853071796, 0, False, False, 0.01, 0.01, 0, 0, 0, True, True, True);

  MD.Extension.SelectByID2('—права', 'PLANE', 0, 0, 0, False, 0, nil, 0);
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

  IF1:=MD.FeatureManager.FeatureCut3(False, False, False, 0, 0, b/1000, b/1000, False, False, False, False, 1.74532925199433E-02, 1.74532925199433E-02, False, False, False, False, False, True, True, True, True, False, 0, 0, False);
  MD.ClearSelection;
  IF1.Select(true);
  MD.ClearSelection;

  pd:= md as IPartDoc;
  bodies:= pd.getbodies(swSolidBody);
  body1:= IDispatch(bodies[0]) as IBody2;
  face1:= body1.IGetFirstFace;
  while face1 <> nil do
  begin
    if face1.IGetSurface.IsCylinder then
    begin
      break;
    end;
    face1:= face1.IGetNextFace;
  end;
  (face1 as IEntity).SelectByMark(false, 1);
  MD.InsertAxis2(true);
  IF1.SelectByMark(False,4);
  MD.Extension.SelectByID2('ќсь1', 'AXIS', 0, 0, 0, True, 1, nil, 0);
  MD.FeatureManager.FeatureCircularPattern4(z, 6.2831853071796, False, 'NULL', False, True, False);


 //Ёвольвента 2 колесо

  MD.Extension.SelectByID2('—права', 'PLANE', 0, 0, 0, True, 0, nil, 0);
  MD.FeatureManager.InsertRefPlane(8, (b_ven/2+pe+b_ven2/2), 0, 0, 0, 0);
  MD.Extension.SelectByID2('ѕлоскость4', 'PLANE', 0, 0, 0, False, 0, nil, 0);

  MD.InsertSketch;
  MD.CreateSpline(A2);
  MD.ClearSelection;

  if MD.SelectByID('Point1', 'SKETCHPOINT', qwerty2[0] / 1000, qwerty2[1] / 1000, 0) then
    Points[2] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;
  if MD.SelectByID('Point'+IntToStr(Length(qwerty2)-1), 'SKETCHPOINT', qwerty2[Length(qwerty2)-3] / 1000, qwerty2[Length(qwerty2)-2] / 1000, 0) then
    Points[3] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;

  Lines[1] := MD.ICreateLine2(qwerty2[0] / 1000, qwerty2[1] / 1000, 0,
    qwerty2[Length(qwerty2)-3] / 1000, qwerty2[Length(qwerty2)-2] / 1000, 0);
  MD.ClearSelection;
  if MD.SelectByID('Point'+IntToStr(Length(qwerty)), 'SKETCHPOINT', qwerty2[0] / 1000, qwerty2[1] / 1000, 0) then
    Points[0] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;
  if MD.SelectByID('Point'+IntToStr(Length(qwerty)+1), 'SKETCHPOINT', qwerty2[Length(qwerty2)-3] / 1000, qwerty2[Length(qwerty2)-2] / 1000, 0) then
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

  IF1:=MD.FeatureManager.FeatureCut3(False, False, False, 0, 0, b02/1000, b02/1000, False, False, False, False, 1.74532925199433E-02, 1.74532925199433E-02, False, False, False, False, False, True, True, True, True, False, 0, 0, False);
  MD.ClearSelection;
  IF1.Select(true);
  MD.ClearSelection;

  pd:= md as IPartDoc;
  bodies:= pd.getbodies(swSolidBody);
  body1:= IDispatch(bodies[0]) as IBody2;
  face1:= body1.IGetFirstFace;
  while face1 <> nil do
  begin
    if face1.IGetSurface.IsCylinder then
    begin
      break;
    end;
    face1:= face1.IGetNextFace;
  end;
  (face1 as IEntity).SelectByMark(false, 1);
  MD.InsertAxis2(true);
  IF1.SelectByMark(False,4);
  MD.Extension.SelectByID2('ќсь1', 'AXIS', 0, 0, 0, True, 1, nil, 0);
  MD.FeatureManager.FeatureCircularPattern4(z02, 6.2831853071796, False, 'NULL', False, True, False);
//



end;

end.

