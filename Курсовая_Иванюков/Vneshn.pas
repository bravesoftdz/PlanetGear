unit Vneshn;

interface

Uses math, SldWorks_TLB, SwConst_TLB,
  ComObj, SysUtils, Variants;

type
  Wheels = array of array of Double;
  procedure DrawKol(m, x, b: extended; z: integer; MyDIR: string);

var
  ma: Wheels;
  A1: OleVariant;
  qwerty: array of Double;
  x0, y0, delx, dely: integer;
  mashtab: integer;
  koleso, koleso1, koleso0, koleso10: Wheels;
  I, z1, z2: integer;
  m, x: extended;
  alfa: extended;
  J: integer;
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
  S1: extended;
  S2: extended;
  S3: extended;
  S4: extended;

implementation

function d(t1, m, alfa: extended): extended;
begin
  Result := r * t1 - Pi * m / 4;
end;

function p(t1, m, alfa: extended): extended;
begin
  Result := d(t1, m, alfa) * Cos(DegToRad(alfa)) + eps * Sin(DegToRad(alfa));
end;

function b(t2, m, alfa: extended): extended;
begin
  Result := r * t2 - Pi * m / 4 + h * Tan(DegToRad(alfa)) + ro *
    (1 - Sin(DegToRad(alfa))) / Cos(DegToRad(alfa));
end;

function b1(t2, m, alfa: extended): extended;
begin
  Result := Sqrt(Sqr(a) + Sqr(b(t2, m, alfa)));
end;

function xe(t1, m, alfa: extended): extended;
begin
  Result := r * Sin(t1) - p(t1, m, alfa) * Cos(t1 + DegToRad(alfa));
end;

function ye(t1, m, alfa: extended): extended;
begin
  Result := r * Cos(t1) + p(t1, m, alfa) * Sin(t1 + DegToRad(alfa));
end;

function xv(t2, m, alfa: extended): extended;
begin
  Result := r * Sin(t2) + ((1 + ro / b1(t2, m, alfa)) * (a * Sin(t2) - b(t2, m,
    alfa) * Cos(t2)));
end;

function yv(t2, m, alfa: extended): extended;
begin
  Result := r * Cos(t2) + ((1 + ro / b1(t2, m, alfa)) * (a * Cos(t2) + b(t2, m,
    alfa) * Sin(t2)));
end;

function formuls(m, x: extended; z: integer): Wheels;
var
  count: integer;
  t1, t2: extended;
  masx, masy, masx0, masy0, masx1, masy1, masx10, masy10: array of extended;
  masx2, masy2, masx22, masy22: array of array of extended;
  MasPolygon: Wheels;
  I: integer;
  J, c: integer;
  Mas: Wheels;
begin // процедура расчета контура колеса
  count := 0;
  eps := x * m;
  h := 1.25 * m;
  r := z * m / 2;
  ro := 0.38 * m;
  alfa := 20;
  rb := r * Cos(DegToRad(alfa));
  rf := r - h + eps;
  ra := r + m + eps;
  a := eps - h + ro;
  t00 := (Pi * m / 4 - (r + eps) * Tan(DegToRad(alfa))) / r;
  t01 := (Pi * m / 4 - h * Tan(DegToRad(alfa)) - ro * (1 - Sin(DegToRad(alfa)))
    / Cos(DegToRad(alfa))) / r;
  t02 := (Pi * m / 4 - (h - eps * Sqr(Cos(DegToRad(alfa))) - ro *
    (1 - Sin(DegToRad(alfa)))) / (Cos(DegToRad(alfa)) *
    Sin(DegToRad(alfa)))) / r;
  t03 := (Pi * m / 4 - (r - eps) * Tan(DegToRad(alfa)) +
    Sqrt(Sqr(ra) - Sqr(r) * Sqr(Cos(DegToRad(alfa)))) /
    Cos(DegToRad(alfa))) / r;
  t04 := a * Sin(xe(t03, m, alfa) / ra);
  t05 := 2 * Pi / 2 - t04;
  S1 := 2 * t01 / 10;
  S2 := (t05 - t04) / 10;
  S3 := (t01 - t02) / 10;
  S4 := (t03 - t02) / 10;

  t1 := t02;
  t2 := t02;

  while t1 < (t03 + 0.001) do
  begin
    SetLength(masx, count + 1);
    SetLength(masy, count + 1);
    masx[count] := xe(t1, m, alfa);
    masy[count] := ye(t1, m, alfa);
    count := count + 1;
    t1 := t1 + S4;
  end;
  count := 0;
  while t2 < (t01 + 0.001) do
  begin
    SetLength(masx1, count + 1);
    SetLength(masy1, count + 1);
    masx1[count] := xv(t2, m, alfa);
    masy1[count] := yv(t2, m, alfa);
    count := count + 1;
    t2 := t2 + S3;
  end;

  SetLength(masx2, length(masy), z);
  SetLength(masy2, length(masy), z);
  SetLength(masx22, length(masy), z);
  SetLength(masy22, length(masy), z);
  SetLength(masx10, length(masx1));
  SetLength(masy10, length(masx1));
  SetLength(Mas, length(masy) + length(masy) + length(masx1) +
    length(masx1), 2);
  I := 0;
  count := 0;
  for J := length(masx2) - 1 downto 0 do
  begin
    masx2[J, I] := masx[J] * Cos(DegToRad((360 / z) * I)) - masy[J] *
      Sin(DegToRad((360 / z) * I));
    masy2[J, I] := masx[J] * Sin(DegToRad((360 / z) * I)) + masy[J] *
      Cos(DegToRad((360 / z) * I));
    Mas[count, 0] := masx2[J, I];
    Mas[count, 1] := masy2[J, I];
    count := count + 1;
  end;
  for J := 0 to length(masx10) - 1 do
  begin
    masx10[J] := masx1[J] * Cos(DegToRad((360 / z) * I)) - masy1[J] *
      Sin(DegToRad((360 / z) * I));
    masy10[J] := masx1[J] * Sin(DegToRad((360 / z) * I)) + masy1[J] *
      Cos(DegToRad((360 / z) * I));
    Mas[count, 0] := masx10[J];
    Mas[count, 1] := masy10[J];
    count := count + 1;
  end;
  for J := length(masx10) - 1 downto 0 do
  begin
    masx10[J] := -masx1[J] * Cos(DegToRad((360 / z) * I)) - masy1[J] *
      Sin(DegToRad((360 / z) * I));
    masy10[J] := -masx1[J] * Sin(DegToRad((360 / z) * I)) + masy1[J] *
      Cos(DegToRad((360 / z) * I));
    Mas[count, 0] := masx10[J];
    Mas[count, 1] := masy10[J];
    count := count + 1;
  end;
  for J := 0 to length(masx2) - 1 do
  begin
    masx22[J, I] := -masx[J] * Cos(DegToRad((360 / z) * I)) - masy[J] *
      Sin(DegToRad((360 / z) * I));
    masy22[J, I] := -masx[J] * Sin(DegToRad((360 / z) * I)) + masy[J] *
      Cos(DegToRad((360 / z) * I));
    Mas[count, 0] := masx22[J, I];
    Mas[count, 1] := masy22[J, I];
    count := count + 1;
  end;
  Result := Mas;
end;

procedure DrawKol(m, x, b: extended; z: integer; MyDIR: string);
var
  D_val,
  b_ven: extended;
  e,count: integer;
  d, da, ra, r: extended;
  SW: ISldWorks;
  ID: IDispatch;
  IF1, IF2: IFeature;
  MD: IModelDoc2;
  CP: ISketchPoint;
  Points: array [0 .. 20] of ISketchPoint;
  Lines: array [0 .. 10] of ISketchSegment;
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
  d := m * z;
  r := d / 2;
  da := qwerty[1]/1000;
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

  Lines[0] := MD.ICreateLine2( 0, D_val/2, 0, b_ven/2, D_val/2, 0);
  MD.AddDimension((b/4)/ 1000,0,0);
  MD.ClearSelection;
  Md.SelectByID('Line2', 'SKETCHSEGMENT', 0, 0, 0);
  Lines[0].Select(true);
  MD.AddDimension(-(b/4)/ 1000,-(b)/ 1000,0);
  Points[0]:=(lines[0] as ISketchLine).GetStartPoint2 as ISketchPoint;
  Points[1]:=(lines[0] as ISketchLine).GetEndPoint2 as ISketchPoint;
  Md.SelectByID('Line1', 'SKETCHSEGMENT', 0, 0, 0);
  Points[0].Select(true);
  MD.SketchAddConstraints('sgCOINCIDENT');
  MD.ClearSelection;

  Lines[1] := MD.ICreateLine2( b_ven/2, D_val/2, 0, b_ven/2, D_val/2+D_val/4, 0);
  MD.SketchAddConstraints('sgVERTICAL2D');
  MD.AddDimension((b/4)/ 1000,0,0);
  MD.ClearSelection;
  Points[2]:=(lines[1] as ISketchLine).GetStartPoint2 as ISketchPoint;
  Points[3]:=(lines[1] as ISketchLine).GetEndPoint2 as ISketchPoint;
  MD.ClearSelection;
  Points[1].Select(true);
  Points[2].Select(true);
  MD.SketchAddConstraints('sgMERGEPOINTS');

  Lines[2] := MD.ICreateLine2( b_ven/2, D_val/2+D_val/4, 0, b_ven/2-b_ven/8, D_val/2+D_val/4+b_ven/8, 0);
  MD.AddDimension((b/4)/ 1000,0,0);
  MD.ClearSelection;
  Points[4]:=(lines[2] as ISketchLine).GetStartPoint2 as ISketchPoint;
  Points[5]:=(lines[2] as ISketchLine).GetEndPoint2 as ISketchPoint;
  MD.ClearSelection;
  Md.SelectByID('Line2', 'SKETCHSEGMENT', 0, 0, 0);
  Lines[2].Select(true);
  MD.AddDimension(-(b/4)/ 1000,-(b)/ 1000,0);

  Lines[3] := MD.ICreateLine2( b_ven/2-b_ven/8, D_val/2+D_val/4+b_ven/8, 0, b_ven/2-b_ven/8, da-(3*D_val/16+b_ven/8+2.5*m/1000), 0);
  MD.SketchAddConstraints('sgVERTICAL2D');
  MD.AddDimension((b/4)/ 1000,0,0);
  MD.ClearSelection;
  Points[6]:=(lines[3] as ISketchLine).GetStartPoint2 as ISketchPoint;
  Points[7]:=(lines[3] as ISketchLine).GetEndPoint2 as ISketchPoint;
  MD.ClearSelection;

  Lines[4] := MD.ICreateLine2(b_ven/2-b_ven/8, da-(3*D_val/16+b_ven/8+2.5*m/1000), 0,  b_ven/2, da-(3*D_val/16+b_ven/8+2.5*m/1000), 0);
  MD.SketchAddConstraints('sgHORIZONTAL2D');
  MD.AddDimension((b/4)/ 1000,0,0);
  MD.ClearSelection;
  Points[8]:=(lines[4] as ISketchLine).GetStartPoint2 as ISketchPoint;
  Points[9]:=(lines[4] as ISketchLine).GetEndPoint2 as ISketchPoint;
  MD.ClearSelection;

  Lines[5] := MD.ICreateLine2(b_ven/2, da-(3*D_val/16+b_ven/8+2.5*m/1000), 0,b_ven/2, da, 0);
  MD.AddDimension((b/4)/ 1000,0,0);
  MD.ClearSelection;
  Points[10]:=(lines[5] as ISketchLine).GetStartPoint2 as ISketchPoint;
  Points[11]:=(lines[5] as ISketchLine).GetEndPoint2 as ISketchPoint;
  MD.ClearSelection;

  Lines[6] := MD.ICreateLine2(b_ven/2, da, 0, 0, da, 0);
  MD.AddDimension((b/4)/ 1000,0,0);
  MD.ClearSelection;
  Points[12]:=(lines[6] as ISketchLine).GetStartPoint2 as ISketchPoint;
  Points[13]:=(lines[6] as ISketchLine).GetEndPoint2 as ISketchPoint;
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

  Md.SelectByID('Line2', 'SKETCHSEGMENT', 0.001, 0, 0);
  IF2:=MD.FeatureManager.FeatureRevolve2(True, True, False, False, False, False, 0, 0, 6.2831853071796, 0, False, False, 0.01, 0.01, 0, 0, 0, True, True, True);

  MD.Extension.SelectByID2('Справа', 'PLANE', 0, 0, 0, False, 0, nil, 0);
  MD.InsertSketch;
  MD.CreateSpline(A1);
  MD.ClearSelection;

  if MD.SelectByID('Point1', 'SKETCHPOINT', qwerty[0] / 1000, qwerty[1] / 1000, 0) then
    Points[14] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;
  if MD.SelectByID('Point'+IntToStr(Length(qwerty)-1), 'SKETCHPOINT', qwerty[Length(qwerty)-3] / 1000, qwerty[Length(qwerty)-2] / 1000, 0) then
    Points[15] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;

  Lines[7] := MD.ICreateLine2(qwerty[0] / 1000, qwerty[1] / 1000, 0,
    qwerty[Length(qwerty)-3] / 1000, qwerty[Length(qwerty)-2] / 1000, 0);
  MD.ClearSelection;
  if MD.SelectByID('Point'+IntToStr(Length(qwerty)), 'SKETCHPOINT', qwerty[0] / 1000, qwerty[1] / 1000, 0) then
    Points[16] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;
  if MD.SelectByID('Point'+IntToStr(Length(qwerty)+1), 'SKETCHPOINT', qwerty[Length(qwerty)-3] / 1000, qwerty[Length(qwerty)-2] / 1000, 0) then
    Points[17] := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;

  Points[14].Select(true);
  Points[16].Select(true);
  MD.SketchAddConstraints('sgMERGEPOINTS');
  MD.ClearSelection;

  Points[15].Select(true);
  Points[17].Select(true);
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
  MD.Extension.SelectByID2('Ось1', 'AXIS', 0, 0, 0, True, 1, nil, 0);
  MD.FeatureManager.FeatureCircularPattern4(z, 6.2831853071796, False, 'NULL', False, True, False);
end;

end.
