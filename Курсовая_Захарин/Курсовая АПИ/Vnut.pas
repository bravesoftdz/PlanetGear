unit Vnut;

interface

Uses math, SldWorks_TLB, SwConst_TLB,
  ComObj, SysUtils, Variants;

type
  Wheels = array of array of Double;
  procedure DrawKolVnut(m, x, b: extended; z: integer; MyDIR: string);

var
  ma: Wheels;
  A12: OleVariant;
  qwerty: array of Double;
  z0, z2: integer;
  m, alfa, x0, x2, eps0, eps2, r0, r2, A, B, a1, ra2, p33, d23, t23,
    s3: extended;

implementation

function d2(t2: extended): extended;
begin
  Result := -r2 * t2 + r0 * (ArcCos(A) - alfa) + Pi * m / 4;
end;

function p3(t2: extended): extended;
begin
  Result := d2(t2) * cos(alfa) + (r0 + eps0) * sin(alfa);
end;

function xe2p(t2: extended): extended;
begin
  Result := (a1 + B * p3(t2) + r0 * A * cos(alfa)) * sin(t2) +
    (A * p3(t2) - r0 * B * cos(alfa)) * cos(t2);
end;

function ye2p(t2: extended): extended;
begin
  Result := (a1 + B * p3(t2) + r0 * A * cos(alfa)) * cos(t2) -
    (A * p3(t2) - r0 * B * cos(alfa)) * sin(t2);
end;

function formuls(m1, x: extended; z: integer): Wheels;
var
  t1: extended;
  count: integer;
  masx, masy, masx0, masy0, masx1, masy1, masx10, masy10: array of extended;
  masx2, masy2, masx22, masy22: array of array of extended;
  I, j: integer;
  Mas: Wheels;
  b1, b2: extended;
  m: extended;
begin
  alfa := degtorad(20);
  z0 := 48;
  z2 := z;
  x0 := 0.16;
  x2 := 0;
  m := 5;
  eps0 := m * x0;
  eps2 := m * x2;
  r0 := z0 * m / 2;
  r2 := z2 * m / 2;
  A := cos(alfa) * (r2 - r0) / (r2 - r0 + eps2);
  B := Sqrt(1 - Sqr(A));
  a1 := r2 - r0 + eps2;
  ra2 := r2 - 1.25 * m;
  p33 := -a1 * B + Sqrt(Sqr(ra2) - Sqr(r2) * Sqr(cos(alfa)));
  d23 := (p33 - (r0 + eps0) * sin(alfa)) / cos(alfa);
  t23 := (-d23 + r0 * (ArcCos(A) - alfa) + Pi * m / 4) / r2;

  s3 := t23 / 10;

  t1 := 0;

  count := 0;
  while t1 < (t23 + 0.001) do
  begin
    SetLength(masx, count + 1);
    SetLength(masy, count + 1);
    masx[count] := xe2p((t1))+m/2.1;
    masy[count] := ye2p((t1))-3*m;
    count := count + 1;
    t1 := t1 + s3;
  end;

  SetLength(masx2, length(masy), z2);
  SetLength(masy2, length(masy), z2);
  SetLength(masx22, length(masy), z2);
  SetLength(masy22, length(masy), z2);
  SetLength(masx10, length(masx1));
  SetLength(masy10, length(masx1));
  SetLength(Mas, length(masy) + length(masy) + length(masx1) +
    length(masx1), 2);
  I := 0;
  count := 0;
  for j := length(masx2) - 1 downto 0 do
  begin
    masx2[j, I] := masx[j] * cos(degtorad((360 / z2) * I)) - masy[j] *
      sin(degtorad((360 / z2) * I));
    masy2[j, I] := masx[j] * sin(degtorad((360 / z2) * I)) + masy[j] *
      cos(degtorad((360 / z2) * I));
    Mas[count, 0] := masx2[j, I];
    Mas[count, 1] := masy2[j, I];
    count := count + 1;
  end;
  for j := 0 to length(masx10) - 1 do
  begin
    masx10[j] := masx1[j] * cos(degtorad((360 / z2) * I)) - masy1[j] *
      sin(degtorad((360 / z2) * I));
    masy10[j] := masx1[j] * sin(degtorad((360 / z2) * I)) + masy1[j] *
      cos(degtorad((360 / z2) * I));
    Mas[count, 0] := masx10[j];
    Mas[count, 1] := masy10[j];
    count := count + 1;
  end;
  for j := length(masx10) - 1 downto 0 do
  begin
    masx10[j] := -masx1[j] * cos(degtorad((360 / z2) * I)) - masy1[j] *
      sin(degtorad((360 / z2) * I));
    masy10[j] := -masx1[j] * sin(degtorad((360 / z2) * I)) + masy1[j] *
      cos(degtorad((360 / z2) * I));
    Mas[count, 0] := masx10[j];
    Mas[count, 1] := masy10[j];
    count := count + 1;
  end;
  for j := 0 to length(masx2) - 1 do
  begin
    masx22[j, I] := -masx[j] * cos(degtorad((360 / z2) * I)) - masy[j] *
      sin(degtorad((360 / z2) * I));
    masy22[j, I] := -masx[j] * sin(degtorad((360 / z2) * I)) + masy[j] *
      cos(degtorad((360 / z2) * I));
    Mas[count, 0] := masx22[j, I];
    Mas[count, 1] := masy22[j, I];
    count := count + 1;
  end;
  Result := Mas;
end;

procedure DrawKolVnut(m, x, B: extended; z: integer; MyDIR: string);
var
  D_val, b_ven: extended;

  e, count, I: integer;
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
  ma := formuls(m, 0, z);
  SetLength(qwerty, length(ma) * 3);
  for I := 0 to length(ma) - 1 do
  begin
    qwerty[I * 3] := ma[I, 0];
    qwerty[I * 3 + 1] := ma[I, 1];
    qwerty[I * 3 + 2] := 0;
  end;
  A12 := VarArrayCreate([0, length(qwerty) - 1], varDouble);
  for I := 0 to length(qwerty) - 1 do
  begin
    A12[I] := qwerty[I] / 1000;
  end;
  SW := CreateOleObject('SldWorks.Application') as ISldWorks;
  if SW = nil then
  If SW.Visible = false then
    SW.Visible := true;
     SW.SetUserPreferenceToggle(swSketchInference, false);
  ID := SW.NewDocument
    (MyDIR+'\gost-part.prtdot', 0,
    0, 0);
  MD := SW.NewPart as IModelDoc2;
  SelMgr := MD.ISelectionManager;

  if MD.SelectByID('', 'EXTSKETCHPOINT', 0, 0, 0) then
    CP := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;

  MD.ICreateCircle2(0, 0, 0, 0, qwerty[1] / 1000+0.001,0);
  MD.ICreateCircle2(0, 0, 0, 0, qwerty[1] / 1000 + m * 12 / 1000, 0);
  MD.FeatureManager.FeatureExtrusion2(true, false, false, 0, 0, b/1000, b/1000,
    false, false, false, false, 1.74532925199433E-02, 1.74532925199433E-02,
    false, false, false, false, true, true, true, 0, 0, false);

   MD.InsertSketch;
   MD.CreateSpline(A12);
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
  Points[16]:=(lines[7] as ISketchLine).GetStartPoint2 as ISketchPoint;
  Points[17]:=(lines[7] as ISketchLine).GetEndPoint2 as ISketchPoint;
  MD.ClearSelection;

   Points[14].Select(true);
   Points[17].Select(true);
   MD.SketchAddConstraints('sgMERGEPOINTS');
   MD.ClearSelection;

   Points[15].Select(true);
   Points[16].Select(true);
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
   MD.Extension.SelectByID2('Îñü1', 'AXIS', 0, 0, 0, True, 1, nil, 0);
   MD.FeatureManager.FeatureCircularPattern4(z2, 6.2831853071796, False, 'NULL', False, True, False);
   SW.SetUserPreferenceToggle(swSketchInference, true);
end;

end.
