unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, SldWorks_TLB, SwConst_TLB,
  ComObj, Common_Unit, math;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SW: ISldWorks;
  ID: IDispatch;
  MD: IModelDoc2;
  Di: IDimension;
  CP, P1,P2,P01,P02,P03,P04,P3,P4: ISketchPoint;
  Seg: array [0 .. 10] of ISketchSegment;
  SelMgr: ISelectionMgr;
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  Z,e: integer;
  m, d: extended;
begin
  z:=StrToInt(Edit1.Text);
  m:=StrToFloat(Edit2.Text);
  d:=m*z;
  SW := CreateOleObject('SldWorks.Application') as ISldWorks;
  if SW = nil then
    hr := E_OutOfMemory;
  If SW.Visible = false then
    SW.Visible := true;
  ID := SW.NewDocument('C:\ProgramData\SolidWorks\SOLIDWORKS 2016\templates\gost-part.prtdot', 0, 0, 0);
  ID := SW.ActivateDoc2('ƒеталь1', false, e);
  ID := SW.ActiveDoc;
  MD := SW.NewPart as IModelDoc2;
  SelMgr := MD.ISelectionManager;
  if MD.SelectByID('', 'EXTSKETCHPOINT', 0, 0, 0) then
    CP := SelMgr.IGetSelectedObject(1) as ISketchPoint;

  MD.InsertSketch;
  Seg[0] := MD.ICreateCircle2(0, 0, 0, d/1000, 0, 0);
  Seg[0].Select(false);
  CP.Select(true);
  MD.SketchAddConstraints('sgCONCENTRIC');
  MD.ClearSelection;
  md.FeatureManager.FeatureExtrusion2(true,false,false, 0, 0, 0.01, 0, false,false,false,false,0.0,0.0,false,false,
                                            false,false,true,false,true,0,0, true);

  MD.SelectByID('', 'FACE', -2.71257167111116E-03, 3.03658857427536E-03, 0);
  MD.InsertSketch;
  MD.CreateCenterLineVB(0, 0, 0, 0, 2*d/1000, 0);
  MD.SketchAddConstraints('sgVERTICAL2D');
  CP.Select(true);
  MD.SketchAddConstraints('sgCOINCIDENT');
  MD.ClearSelection;

  Seg[0] := MD.ICreateLine2(-0.003, 0.088, 0, 0.003, 0.0088, 0);
  Seg[0].Select(false);

  MD.DeSelectByID('Line2', 'SKETCHSEGMENT', 2.70167903778429E-04, 0.08, 0);
  if MD.SelectByID('Point5', 'SKETCHPOINT', 0, 0, 0) then
    P01 := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  if MD.SelectByID('Point4', 'SKETCHPOINT', 0, 0, 0) then
    P02 := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.SelectByID('Line1', 'SKETCHSEGMENT', -1.68198146378806E-04, 6.23077946326589E-03, 0);
  P01.Select(true);
  P02.Select(true);
  MD.SketchAddConstraints('sgSYMMETRIC');
  MD.ClearSelection;

  MD.SelectByID('Line2', 'SKETCHSEGMENT', -2.88606888726339E-04, 8.08917435515205E-03, 1.66592500305743E-03);
  CP.Select(true);
  MD.AddDimension(2.48517948832117E-03, 3.93406950185948E-03, 0);
  (MD.Parameter('D1@Ёскиз2') as IDimension).SystemValue:=0.088;
  MD.ClearSelection;

  MD.SelectByID('Line2', 'SKETCHSEGMENT', -2.88606888726339E-04, 8.08917435515205E-03, 1.66592500305743E-03);
  MD.AddDimension(1.48517948832117E-03, 5.93406950185948E-03, 0);
  (MD.Parameter('D2@Ёскиз2') as IDimension).SystemValue:=0.006;
  MD.ClearSelection;

  MD.ICreateLine2(0.004, 0.088, 0, 0.007, 0.12, 0);
  MD.ClearSelection;
  MD.ICreateLine2(-0.004, 0.088, 0, -0.007, 0.12, 0);
  MD.ClearSelection;
  MD.ICreateLine2(0.008, 0.12, 0, -0.008, 0.12, 0);
  MD.ClearSelection;

  if MD.SelectByID('Point6', 'SKETCHPOINT', 0, 0, 0) then
    P1 := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  if MD.SelectByID('Point7', 'SKETCHPOINT', 0, 0, 0) then
    P2 := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  if MD.SelectByID('Point8', 'SKETCHPOINT', 0, 0, 0) then
    P3 := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  if MD.SelectByID('Point9', 'SKETCHPOINT', 0, 0, 0) then
    P4 := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  if MD.SelectByID('Point10', 'SKETCHPOINT', 0, 0, 0) then
    P03 := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  if MD.SelectByID('Point11', 'SKETCHPOINT', 0, 0, 0) then
    P04 := SelMgr.IGetSelectedObject(1) as ISketchPoint;
  MD.ClearSelection;

  P1.Select(true);
  P01.Select(true);
  MD.SketchAddConstraints('sgMERGEPOINTS');
  MD.ClearSelection;

  P3.Select(true);
  P02.Select(true);
  MD.SketchAddConstraints('sgMERGEPOINTS');
  MD.ClearSelection;

  P2.Select(true);
  P03.Select(true);
  MD.SketchAddConstraints('sgMERGEPOINTS');
  MD.ClearSelection;

  P4.Select(true);
  P04.Select(true);
  MD.SketchAddConstraints('sgMERGEPOINTS');
  MD.ClearSelection;

  MD.DeSelectByID('Line3', 'SKETCHSEGMENT', 0.004, 0.088, 0);
  MD.DeSelectByID('Line4', 'SKETCHSEGMENT', -0.004, 0.088, 0);
  MD.SketchAddConstraints('sgSAMELENGTH');
  MD.ClearSelection;

  MD.SelectByID('Line1', 'SKETCHSEGMENT', 0, 0.2, 0);
  MD.DeSelectByID('Line3', 'SKETCHSEGMENT', 0.004, 0.088, 0);
  MD.DeSelectByID('Line4', 'SKETCHSEGMENT', -0.004, 0.088, 0);
  MD.SketchAddConstraints('sgSYMMETRIC');
  MD.ClearSelection;

  MD.DeSelectByID('Line3', 'SKETCHSEGMENT', 0.007, 0.12, 0);
  MD.DeSelectByID('Line4', 'SKETCHSEGMENT', -0.007, 0.12, 0);
  MD.AddDimension(2.48517948832117E-03, 10.93406950185948E-03, 0);
  (MD.Parameter('D3@Ёскиз2') as IDimension).SystemValue:=DegToRad(180-50);
  MD.ClearSelection;

  MD.DeSelectByID('Point9', 'SKETCHPOINT', -0.007, 0.12, 0);
  MD.DeSelectByID('Point10', 'SKETCHPOINT', -0.007, 0.12, 0);
  MD.SketchAddConstraints('sgMERGEPOINTS');
  MD.ClearSelection;

  MD.FeatureManager.FeatureCut3(True, False, False, 0, 0, 0.1, 0.1, False, False, False, False, 1.74532925199433E-02, 1.74532925199433E-02, False, False, False, False, False, True, True, True, True, False, 0, 0, False);
  MD.ClearSelection;

  MD.Extension.SelectByID2('', 'FACE', 0, 0.1, 0, False, 0, nil, 0);
  MD.Extension.SelectByID2('', 'EDGE', d/1000, 0, 0, True, 0, nil, 0);
  MD.ActivateSelectedFeature;
  MD.ClearSelection2(True);
  MD.Extension.SelectByID2('¬ырез-¬ыт€нуть1', 'BODYFEATURE', 0, 0.1, 0, False, 4, nil, 0);
  MD.Extension.SelectByID2('', 'EDGE', d/1000, 0, 0, True, 1, nil, 0);
  MD.FeatureManager.FeatureCircularPattern4(27, 6.3, False, 'NULL', False, True, False);
end;

end.
