unit Planet_Gear_2KH;

interface

Uses Materials, SysUtils, Math, Constants;

Type
  TInput = record // Файл входных параметров
    ih: extended; // Передаточное отношение передачи
    ih_1:extended; // Передаточное отношение первой ступени
    ih_2:extended; // Передаточное отношение второй ступени
    Nw: byte; // Количество сателлитов
    P: extended; // Мощность на валу шестерни
    N: integer; // Частота вращения шестерни
    Wikr_1, // Обработка выкружки шестерни
    Wikr_2, // Обработка выкружки сателлита
    Wikr_3: integer; // Обработка выкружки колеса

    Zagotowka_1, // Обработка заготовки шестерни
    Zagotowka_2, // Обработка заготовки сателлита
    Zagotowka_3: integer; // Обработка заготовки колеса

    Termobr_Material_1, // Термообработка и материал колеса
    Termobr_Material_2, // Термообработка и материал сателлита
    Termobr_Material_3: string; // Термообработка и материал колеса

    Ra_1, // Шероховатость шестерни
    Ra_2, // Шероховатость сателлита
    Ra_3: integer; // Шероховатость колеса

    pe: extended; // Длина перешейка сателлита
    Lh: integer; // Ресурс передачи
  end;

  TOutput = record
    Material_1, // Марка стали шестерни
    Material_2, // Марка стали саттелита
    Material_3: string; // Марка стали колеса

    termobr_1, // Термообработка шестерни
    termobr_2, // Термообработка сателлита
    termobr_3: string; // Термообработка колеса

    Nv: integer; // Частота вращения водила
    T_1, // Момент на валу шестерни
    T_h, // Вращающий момент на валу водила
    Tp_12, // Расчетный вращающий момент между шестерней и сателлитом
    Tp_13, // Расчетный вращающий момент между шестерней и колесом
    m: extended; // Модуль
    z_1, // Количество зубьев шестерни
    z_2, // Количество зубьев сателлита
    z_3, // Количество зубьев колеса
    z_4: extended; // Количество зубьев сателлита 2

    aw, // Межосевое расстояние
    u_12: extended; // Передаточное отношение между шестерней и сателлитом
    u_23, // Передаточное отношение между сателлитом и колесом
    u_45, // Передаточное отношение между сателлитом и колесом
    B_1, // ширина венца шестерни
    b_2, // ширина венца сателлита
    b_3, // ширина венца колеса
    b_4, // ширина венца сателлита 2

    Da_1, // Диаметр окружности вершин шестерни
    Da_2, // Диаметр окружности вершин сателлита
    Da_3, // Диаметр окружности вершин колеса
    Da_4, // Диаметр окружности вершин сателлита 2

    d_1, // Делительный диаметр шестерни
    d_2, // Делительный диаметр сателлита
    d_3, // Делительный диаметр колеса
    d_4, // Делительный диаметр сателлита 2

    Ft, // Окружное усилие в зацеплении
    Sigma_H_12, // Контактное напряжение между сателлитом и шестерней
    Sigma_H_23, // Контактное напряжение между сателлитом и колесом
    Sigma_H_45, // Контактное напряжение между сателлитом и колесом
    Sigma_F_1, // Напряжения изгиба в зубе шестерни
    Sigma_F_2, // Напряжения изгиба в зубе сателлита
    Sigma_F_4, // Напряжения изгиба в зубе сателлита
    Sigma_Hp_min, // Минимальное допускаемое контактное напряжение
    Sigma_Fp_min: extended; // Минимальное допускаемое напряжение изгиба
  end;

  TPlanet_Gear_2KH = class // Класс расчета планетарной передачи 3K
  private
    Fih: extended; // Передаточное отношение передачи
    Fih_1:extended; // Передаточное отношение первой ступени
    Fih_2:extended; // Передаточное отношение второй ступени
    Fpe: extended; // Длина перешейка сателлита
    FLh: integer; // Ресурс передачи
    FNw: byte; // Количество сателлитов
    FP: extended; // Мощность на валу шестерни
    FN: integer; // Частота вращения шестерни
    FNv: integer; // Частота вращения водила
    FWikr_1, // Обработка выкружки шестерни
    FWikr_2, // Обработка выкружки сателлита
    FWikr_3: integer; // Обработка выкружки колеса

    FZagotowka_1, // Обработка заготовки шестерни
    FZagotowka_2, // Обработка заготовки сателлита
    FZagotowka_3: integer; // Обработка заготовки колеса

    FTermobr_Material_1, // Термообработка и материал шестерни
    FTermobr_Material_2, // Термообработка и материал сателлита
    FTermobr_Material_3: string; // Термообработка и материал колеса

    FRa_1, // шероховатость шестерни
    FRa_2, // шероховатость сателлита
    FRa_3: integer; // шероховатость колеса

    FMaterial_1, // Марка стали шестерни
    FMaterial_2, // Марка стали саттелита
    FMaterial_3: string; // Марка стали колеса

    Ftermobr_1, // Термообработка шестерни
    Ftermobr_2, // Термообработка сателлита
    Ftermobr_3: byte; // Термообработка колеса

    FT_1, // Момент на валу шестерни
    FT_h, // Вращающий момент на валу водила
    FTp_12, // Расчетный вращающий момент между шестерней и сателлитом
    FTp_13, // Расчетный вращающий момент между шестерней и колесом
    Fm: extended; // Модуль
    Fz_1, // Количество зубьев шестерни
    Fz_2, // Количество зубьев сателлита
    Fz_3, // Количество зубьев колеса
    Fz_4: extended; // Количество зубьев сателлита 2

    Faw, // Межосевое расстояние
    Fu_12: extended; // Передаточное отношение между шестерней и сателлитом
    Fu_23, // Передаточное отношение между сателлитом и колесом
     Fu_45, // Передаточное отношение между сателлитом и колесом
    FB_1, // ширина венца шестерни
    Fb_2, // ширина венца сателлита
    Fb_3, // ширина венца колеса
    Fb_4, // ширина венца сателлита 2

    FDa_1, // Диаметр окружности вершин шестерни
    FDa_2, // Диаметр окружности вершин сателлита
    FDa_3, // Диаметр окружности вершин колеса
    FDa_4, // Диаметр окружности вершин сателлита 2

    Fd_1, // Делительный диаметр шестерни
    Fd_2, // Делительный диаметр сателлита
    Fd_3, // Делительный диаметр колеса
    Fd_4, // Делительный диаметр сателлита 2

    FFt, // Окружное усилие в зацеплении
    FSigma_H_12, // Контактное напряжение между сателлитом и шестерней
    FSigma_H_23, // Контактное напряжение между сателлитом и колесом
    FSigma_H_45, // Контактное напряжение между сателлитом и колесом
    FSigma_F_1, // Напряжения изгиба в зубе шестерни
    FSigma_F_2, // Напряжения изгиба в зубе сателлита
    FSigma_F_4, // Напряжения изгиба в зубе сателлита
    FSigma_Hp_1, // Допускаемое контактное напряжение шестерни
    FSigma_Hp_2, // Допускаемое контактное напряжение сателлита
    FSigma_Hp_3, // Допускаемое контактное напряжение колеса
    FSigma_Hp_4, // Допускаемое контактное напряжение сателлита
    FSigma_Hp_5, // Допускаемое контактное напряжение колеса
    FSigma_Hp_min, // Минимальное допускаемое контактное напряжение
    FSigma_Fp_1, // Допускаемые напряжения изгиба шестерни
    FSigma_Fp_2, // Допускаемые напряжения изгиба сателлита
    FSigma_Fp_3, // Допускаемые напряжения изгиба колеса
    FSigma_Fp_4, // Допускаемые напряжения изгиба сателлита
    FSigma_Fp_5, // Допускаемые напряжения изгиба колеса
    FSigma_Fp_min: extended; // Минимальное допускаемое напряжение изгиба
    function GetIh: extended;
    procedure SetIh(const Value: extended);
    procedure SetPe(const Value: extended);
    procedure Setp(const Value: extended);
    function GetP: extended;
    function GetPE: extended;
  public
    FOutputs: array of TOutput;
    constructor create(Input: TInput);
    procedure prop_material(); // Задание свойств колес по их материалу и термообработке
    procedure razdel_term_and_material();  // Разделение материала и термообработки в отдельные свойства
    procedure PrSigFp(S_f, Yd, Yg: extended; Lh, N: integer;  // Расчет допускаемых напряжений изгиба
      H_HBp, Sigma_Flim0: extended; Termobr, Zagotowka, Wikrugka, Nw: byte;
      var Sigma_Fp: extended);
    procedure PrSigHp(H_HBp, H_HRcp, H_HVp, Ra: extended; Lh, N: integer;  // Расчет допускаемых контактных напряжений
      Termobr, Nw: byte; var Sigma_Hp: extended);
    procedure raschet();   // Процедура расчета
    procedure record_Output(Var Output: TOutput);  // Запись вычисленных данных в выходной поток
    procedure Collection();  // Процедура создания коллекции передач (доделать)
    property ih_1: extended read GetIh write SetIh;
    property ih_2: extended read GetIh write SetIh;
    property pe: extended read GetPe write SetPe;
    property P: extended read GetP write Setp;
  end;

const
  ms: array [1 .. 41] of extended = (1.0, 1.125, 1.25, 1.375, 1.5, 1.75, 2.0,
    2.25, 2.5, 2.75, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 7.0, 8.0, 9.0, 10.0,
    11.0, 12.0, 14.0, 16.0, 18.0, 20.0, 22.0, 25.0, 28.0, 32.0, 36.0, 40.0,
    45.0, 50.0, 55.0, 60.0, 70.0, 80.0, 90.0, 100.0);
Var
  H_HRcs1, // Твердость сердцевины зуба шестерни по Роквеллу
  H_HRcs2, // Твердость сердцевины зуба сателлита по Роквеллу
  H_HRcs3, // Твердость сердцевины зуба колеса по Роквеллу

  H_HRcp1, // Твердость поверхности зуба шестерни по Роквеллу
  H_HRcp2, // Твердость поверхности зуба сателлита по Роквеллу
  H_HRcp3, // Твердость поверхности зуба колеса по Роквеллу

  H_HBs1, // Твердость сердцевины зуба шестерни по Бринелю
  H_HBs2, // Твердость сердцевины зуба сателлита по Бринелю
  H_HBs3, // Твердость сердцевины зуба колеса по Бринелю

  H_HBp1, // Твердость поверхности зуба шестерни по Бринелю
  H_HBp2, // Твердость поверхности зуба сателлита по Бринелю
  H_HBp3, // Твердость поверхности зуба колеса по Бринелю

  H_HVs1, // Твердость сердцевины зуба шестерни по Виккерсу
  H_HVs2, // Твердость сердцевины зуба сателлита по Виккерсу
  H_HVs3, // Твердость сердцевины зуба колеса по Виккерсу

  H_HVp1, // Твердость поверхности зуба шестерни по Виккерсу
  H_HVp2, // Твердость поверхности зуба сателлита по Виккерсу
  H_HVp3: integer; // Твердость поверхности зуба колеса по Виккерсу

  S_f1, // Коэффициент выносливости по изгибу для шестерни
  S_f2, // Коэффициент выносливости по изгибу для сателлита
  S_f3, // Коэффициент выносливости по изгибу для колеса

  Y_d1, // Коэффициент деформационного упрочнения для шестерни
  Y_d2, // Коэффициент деформационного упрочнения для сателлита
  Y_d3, // Коэффициент деформационного упрочнения для колеса

  Y_g1, // Коэффициент, учитывающий шлифование  для шестерни
  Y_g2, // Коэффициент, учитывающий шлифование  для сателлита
  Y_g3: extended; // Коэффициент, учитывающий шлифование  для колеса

  Sigma_t1, // Предел текучести материала шестерни
  Sigma_t2, // Предел текучести материала сателлита
  Sigma_t3, // Предел текучести материала колеса

  Sigma_Flim01, // Предел выносливости по изгибу для шестерни
  Sigma_Flim02, // Предел выносливости по изгибу для сателлита
  Sigma_Flim03, // Предел выносливости по изгибу для колеса

  Sigma_Fst01, // Предельное напряжение для шестерни
  Sigma_Fst02, // Предельное напряжение для сателлита
  Sigma_Fst03: extended; // Предельное напряжение для колеса


implementation

{ TPlanet_Gear_2KH }

Function min4(a, b, c: extended): extended;
var
  m: extended;
Begin
  m := a;
  if (m > b) Then
    m := b;
  if (m > c) Then
    m := c;
  min4 := m;
End;

procedure TPlanet_Gear_2KH.Collection;
var
  I, J, K: Integer;
begin

end;

constructor TPlanet_Gear_2KH.create(Input: TInput);
begin
 // ih := Input.ih;
  Fih_1 := Input.ih_1;
  Fih_2 := Input.ih_2;
  pe := Input.pe;
  FNw := Input.Nw;
  P := Input.P;
  FN := Input.N;
  FWikr_1 := Input.Wikr_1;
  FWikr_2 := Input.Wikr_2;
  FWikr_3 := Input.Wikr_3;

  FZagotowka_1 := Input.Zagotowka_1;
  FZagotowka_2 := Input.Zagotowka_2;
  FZagotowka_3 := Input.Zagotowka_3;

  FTermobr_Material_1 := Input.Termobr_Material_1;
  FTermobr_Material_2 := Input.Termobr_Material_2;
  FTermobr_Material_3 := Input.Termobr_Material_3;

  FRa_1 := Input.Ra_1;
  FRa_2 := Input.Ra_2;
  FRa_3 := Input.Ra_3;

  FLh:=Input.Lh;
end;

function TPlanet_Gear_2KH.GetIh: extended;
begin

end;

function TPlanet_Gear_2KH.GetP: extended;
begin

end;

function TPlanet_Gear_2KH.GetPe: extended;
begin

end;

procedure TPlanet_Gear_2KH.prop_material;
var
  i: integer;
begin
  for i := 1 to 38 do
    if (FTermobr_Material_1 = marka_termobr[i]) then
    begin
      H_HRcp1 := H_HB[i];
      H_HRcs1 := Si[i];
      Sigma_t1 := Sigma_t[i];
      Sigma_Flim01 := Sigma_Flim0[i];
      Sigma_Fst01 := Sigma_Fst0[i];
      S_f1 := S_f[i];
      Y_g1 := Y_g[i];
      Y_d1 := Y_d[i];
    end;
  for i := 1 to 38 do
    if (FTermobr_Material_2 = marka_termobr[i]) then
    begin
      H_HRcp2 := H_HB[i];
      H_HRcs2 := Si[i];
      Sigma_t2 := Sigma_t[i];
      Sigma_Flim02 := Sigma_Flim0[i];
      Sigma_Fst02 := Sigma_Fst0[i];
      S_f2 := S_f[i];
      Y_g2 := Y_g[i];
      Y_d2 := Y_d[i];
    end;
  for i := 1 to 38 do
    if (FTermobr_Material_3 = marka_termobr[i]) then
    begin
      H_HRcp3 := H_HB[i];
      H_HRcs3 := Si[i];
      Sigma_t3 := Sigma_t[i];
      Sigma_Flim03 := Sigma_Flim0[i];
      Sigma_Fst03 := Sigma_Fst0[i];
      S_f3 := S_f[i];
      Y_g3 := Y_g[i];
      Y_d3 := Y_d[i];
    end;


  if H_HRcp1 > 100 then
  begin
    H_HBp1 := H_HRcp1;
    H_HRcp1 := 0;
  end;
  if H_HRcp2 > 100 then
  begin
    H_HBp2 := H_HRcp2;
    H_HRcp2 := 0;
  end;
  if H_HRcp3 > 100 then
  begin
    H_HBp3 := H_HRcp3;
    H_HRcp3 := 0;
  end;

  if H_HRcs1 > 100 then
  begin
    H_HBs1 := H_HRcs1;
    H_HRcs1 := 0;
  end;
  if H_HRcs2 > 100 then
  begin
    H_HBs2 := H_HRcs2;
    H_HRcs2 := 0;
  end;
  if H_HRcs3 > 100 then
  begin
    H_HBs3 := H_HRcs3;
    H_HRcs3 := 0;
  end;

  { Перевод твердостей }
  { Из  HRc  в  HB }
  If (H_HRcs1 <= 30) and (H_HRcs1 > 0) then
    H_HBs1 := Round(220 * Exp(0.665 * Ln(H_HRcs1 / 20)))
  else if H_HRcs1 > 30 then
    H_HBs1 := Round(300 * Exp(0.96 * Ln(H_HRcs1 / 32.5)));
  If (H_HRcs2 <= 30) and (H_HRcs2 > 0) then
    H_HBs2 := Round(220 * Exp(0.665 * Ln(H_HRcs2 / 20)))
  else if H_HRcs2 > 30 then
    H_HBs2 := Round(300 * Exp(0.96 * Ln(H_HRcs2 / 32.5)));
  If (H_HRcs3 <= 30) and (H_HRcs3 > 0) then
    H_HBs3 := Round(220 * Exp(0.665 * Ln(H_HRcs3 / 20)))
  else if H_HRcs3 > 30 then
    H_HBs3 := Round(300 * Exp(0.96 * Ln(H_HRcs3 / 32.5)));


  If (H_HRcp1 <= 30) and (H_HRcp1 > 0) then
    H_HBp1 := Round(220 * Exp(0.665 * Ln(H_HRcp1 / 20)))
  else if H_HRcp1 > 30 then
    H_HBp1 := Round(300 * Exp(0.96 * Ln(H_HRcp1 / 32.5)));
  If (H_HRcp2 <= 30) and (H_HRcp2 > 0) then
    H_HBp2 := Round(220 * Exp(0.665 * Ln(H_HRcp2 / 20)))
  else if H_HRcp2 > 30 then
    H_HBp2 := Round(300 * Exp(0.96 * Ln(H_HRcp2 / 32.5)));
  If (H_HRcp3 <= 30) and (H_HRcp3 > 0) then
    H_HBp3 := Round(220 * Exp(0.665 * Ln(H_HRcp3 / 20)))
  else if H_HRcp3 > 30 then
    H_HBp3 := Round(300 * Exp(0.96 * Ln(H_HRcp3 / 32.5)));


  { Из HB в HV }
  If H_HBp1 < 100 then
    H_HVp1 := Round(0.13 * sqr(H_HBp1));
  If H_HBp2 < 100 then
    H_HVp2 := Round(0.13 * sqr(H_HBp2));
  If H_HBp3 < 100 then
    H_HVp3 := Round(0.13 * sqr(H_HBp3));

  if (H_HBp1 > 100) and (H_HBp1 < 350) then
    H_HVp1 := H_HBp1;
  if (H_HBp2 > 100) and (H_HBp2 < 350) then
    H_HVp2 := H_HBp2;
  if (H_HBp3 > 100) and (H_HBp3 < 350) then
    H_HVp3 := H_HBp3;

  if (H_HBp1 >= 350) and (H_HBp1 < 450) then
    H_HVp1 := Round(350 + (H_HBp1 - 350) * 1.4);
  if (H_HBp2 >= 350) and (H_HBp2 < 450) then
    H_HVp2 := Round(350 + (H_HBp2 - 350) * 1.4);
  if (H_HBp3 >= 350) and (H_HBp3 < 450) then
    H_HVp3 := Round(350 + (H_HBp3 - 350) * 1.4);

  if H_HBp1 > 450 then
    H_HVp1 := Round(450 + (H_HBp1 - 450) * 1.6);
  if H_HBp2 > 450 then
    H_HVp2 := Round(450 + (H_HBp2 - 450) * 1.6);
  if H_HBp3 > 450 then
    H_HVp3 := Round(450 + (H_HBp3 - 450) * 1.6);
 
end;

procedure TPlanet_Gear_2KH.PrSigFp(S_f, Yd, Yg: extended; Lh, N: integer;
  H_HBp, Sigma_Flim0: extended; Termobr, Zagotowka, Wikrugka, Nw: byte;
  var Sigma_Fp: extended);
var
  Yx, Yr, Yn, Y_delta, Yz, N_sum, N_Fe, Sigma_Flim, Ya, q_F: extended;
BEGIN
  if Wikrugka = 0 then
    Yr := 1
  else
    case Termobr of
      1 .. 3:
        Yr := 1.2;
      4 .. 7:
        Yr := 1.05;
    end;
  N_sum := 60 * N * Lh * Nw;
  N_Fe := N_sum;
  if (Wikrugka = 0) and (H_HBp > 350) then
    q_F := 9
  else
    q_F := 6;
  If N_Fe > 4E6 then
    Yn := 1
  else
    Yn := Exp(q_F * Ln(4E6 / N_Fe));
  if ((q_F = 6) and (Yn > 4)) then
    Yn := 4;
  if ((q_F = 9) and (Yn > 2.5)) then
    Yn := 2.5;
  Ya := 1;
  Case Zagotowka of
    0, 1:
      Yz := 1;
    2:
      Yz := 0.9;
    3:
      Yz := 0.8
  end;
  Sigma_Fp := 0.4 * Sigma_Flim0 * Yn * Ya;
end;

procedure TPlanet_Gear_2KH.PrSigHp(H_HBp, H_HRcp, H_HVp, Ra: extended;
  Lh, N: integer; Termobr, Nw: byte; var Sigma_Hp: extended);
var
  Zx, Zv, Zr, Sh, N_Hlim, N_sum, N_He, Zn, Sigma_Hlim: extended;
BEGIN
  If Ra = 0 then
    Zr := 1
  else if Ra = 1 then
    Zr := 0.95
  else
    Zr := 0.9;

  Case Termobr of
    1, 2, 3:
      Sh := 1.1;
    4, 5, 6, 7:
      Sh := 1.2
  end;
  Case Termobr of
    1, 2:
      Sigma_Hlim := 2 * H_HBp + 70;
    3:
      Sigma_Hlim := 1.8 * H_HBp + 150;
    4:
      Sigma_Hlim := 1.7 * H_HBp + 200;
    5, 6:
      Sigma_Hlim := 2.3 * H_HBp;
    7:
      Sigma_Hlim := 1050;
  End;
  N_Hlim := 30 * Exp(2.4 * Ln(H_HBp));
  if N_Hlim > 12E7 then
    N_Hlim := 12E7;
  N_sum := 60 * N * Lh * Nw;
  N_He := N_sum;
  If N_He <= N_Hlim then
  begin
    Zn := Exp(0.167 * Ln(N_Hlim / N_He));
    if Termobr <= 3 then
      if Zn > 2.6 then
        Zn := 2.6
      else if Zn > 1.8 then
        Zn := 1.8;
  end
  Else
  begin
    Zn := Exp(0.05 * Ln(N_Hlim / N_He));
    if Zn < 0.75 then
      Zn := 0.75;
  end;
  Sigma_Hp := Sigma_Hlim * Zn * 0.9 / Sh;
end;

procedure TPlanet_Gear_2KH.raschet;
var
  i, za_2: integer;
begin
  Fz_1 := 18;
  Fz_3 := Fz_1 * (Fih_1 - 1);
  Fz_2 := (Fz_3 - Fz_1) / 2;

  while true do
  begin
    Fz_3 := Fz_1 * (Fih_1 - 1);
    Fz_2 := (Fz_3 - Fz_1) / 2;
    if Round(Fz_2) = Fz_2 then
      if (Fz_1 + Fz_3) / FNw = Round((Fz_1 + Fz_3) / FNw) then
        if (Fz_1 + Fz_2) * sin(Pi / FNw) - Fz_2 > 2 then
          break;
    if Fz_1 > 100 then
      break;
    Fz_1 := Fz_1 + 1;
  end;

   za_2 := 18;
  Fz_4 := (((za_2 * (Fih_2 - 1))) - za_2) / 2;

  while true do
  begin
    Fz_4 := ((za_2 * (Fih_2 - 1)) - za_2) / 2;
    if Round(Fz_4) = Fz_4 then
        if (za_2 + Fz_4) * sin(Pi / FNw) - Fz_4 > 2 then
          break;
    if za_2 > 100 then
      break;
    za_2 := za_2 + 1;
  end;

  Fu_12 := Fz_2 / Fz_1;
  Fu_23 := Fz_3 / Fz_2;

  FT_1 := 9950 * FP / FN;
  razdel_term_and_material;
  prop_material;

  PrSigHp(H_HBp1, H_HRcp1, H_HVp1, FRa_1, FLh, FN, Ftermobr_1, FNw,
    FSigma_Hp_1);
  PrSigHp(H_HBp2, H_HRcp2, H_HVp2, FRa_2, FLh, FN, Ftermobr_2, FNw,
    FSigma_Hp_2);
  PrSigHp(H_HBp3, H_HRcp3, H_HVp3, FRa_3, FLh, FN, Ftermobr_3, FNw,
    FSigma_Hp_3);


  PrSigFp(S_f1, Y_d1, Y_g1, FLh, FN, H_HBp1, Sigma_Flim01, Ftermobr_1,
    FZagotowka_1, FWikr_1, FNw, FSigma_Fp_1);
  PrSigFp(S_f2, Y_d2, Y_g2, FLh, FN, H_HBp2, Sigma_Flim02, Ftermobr_2,
    FZagotowka_2, FWikr_2, FNw, FSigma_Fp_2);
  PrSigFp(S_f3, Y_d3, Y_g3, FLh, FN, H_HBp3, Sigma_Flim03, Ftermobr_3,
    FZagotowka_3, FWikr_3, FNw, FSigma_Fp_3);


  FSigma_Hp_min := min4(FSigma_Hp_1, FSigma_Hp_2, FSigma_Hp_3);
  FSigma_Fp_min := min4(FSigma_Fp_1, FSigma_Fp_2, FSigma_Fp_3);

  Faw := 495 * (Fu_12 + 1) * Power((1.15 * 1.11 * FT_1) /
    (FNw * 0.4 * Fu_12 * sqr(FSigma_Hp_min)), 1 / 3);
  Fm := Faw * 2 / (Fz_2 + Fz_1);
  for i := 1 to 41 do
    if Fm < ms[i] then
    begin
      Fm := ms[i];
      break;
    end;
  FNv:=round(FN/Fih_1);
  FB_1:=Faw * 0.25;
  FB_2:=Faw * 0.25;
  FB_3:=Faw * 0.25;
  FB_4:=Faw * 0.25;

  Faw := Fm * (Fz_1 + Fz_2) / 2;
  Fd_1 := Fm * Fz_1;
  Fd_2 := Fm * Fz_2;
  Fd_3:=Fm*Fz_3;
  Fd_4 := Fm * Fz_4;

  FDa_1 := Fm * (Fz_1 + 2);
  FDa_2 := Fm * (Fz_2 + 2);
  FDa_3 := Fm * (Fz_3 - 2);
  FDa_4 := Fm * (Fz_4 + 2);

  FT_h := FT_1 * Fih_1 * KPD;
  FTp_12 := FT_1 * Fz_2 * KPD / (Fz_1 * FNw);
  FTp_13 := FT_h * Fz_3 * KPD / (Fz_1 * FNw);
  FSigma_H_12 := 315 / (Faw * Fu_12) *
    Sqrt((FTp_12 * 1000 * 1.04 * 1.05 * Power(Fu_12 + 1, 3)) / (Faw * 0.25));
  FSigma_H_23 := 315 / (Faw * Fu_23) *
    Sqrt((FTp_13 * 1000 * 1.04 * 1.05 * Power(Fu_23 - 1, 3)) / (Faw * 0.25));

  FFt := 2 * FT_1 * 1000 / (Fd_1 * FNw);
  FSigma_F_1 := (3.4 * FFt * 1.05) / (Faw * 0.25 * Fm);
  FSigma_F_2 := (3.68 * FFt * 1.05) / (Faw * 0.25 * Fm);
  FSigma_F_4 := (3.68 * FFt * 1.05) / (Faw * 0.25 * Fm);
end;

procedure TPlanet_Gear_2KH.razdel_term_and_material;
var
  i: integer;
begin
  for i := 1 to 38 do
    if AnsiPos(marka[i], FTermobr_Material_1) <> 0 then
      FMaterial_1 := marka[i];
  for i := 1 to 38 do
    if AnsiPos(marka[i], FTermobr_Material_2) <> 0 then
      FMaterial_2 := marka[i];
  for i := 1 to 38 do
    if AnsiPos(marka[i], FTermobr_Material_3) <> 0 then
      FMaterial_3 := marka[i];

  if FTermobr_Material_1[1] = 'У' then
    Ftermobr_1 := 1;
  if (FTermobr_Material_1[1] = 'Н') and (FTermobr_Material_1[2] = 'о') then
    Ftermobr_1 := 2;
  if FTermobr_Material_1[1] = 'О' then
    Ftermobr_1 := 3;
  if FTermobr_Material_1[1] = 'З' then
    Ftermobr_1 := 4;
  if FTermobr_Material_1[1] = 'Ц' then
    Ftermobr_1 := 5;
  if (FTermobr_Material_1[1] = 'Н') and (FTermobr_Material_1[2] = 'и') then
    Ftermobr_1 := 6;

  if FTermobr_Material_2[1] = 'У' then
    Ftermobr_2 := 1;
  if (FTermobr_Material_2[1] = 'Н') and (FTermobr_Material_2[2] = 'о') then
    Ftermobr_2 := 2;
  if FTermobr_Material_2[1] = 'О' then
    Ftermobr_2 := 3;
  if FTermobr_Material_2[1] = 'З' then
    Ftermobr_2 := 4;
  if FTermobr_Material_2[1] = 'Ц' then
    Ftermobr_2 := 5;
  if (FTermobr_Material_2[1] = 'Н') and (FTermobr_Material_2[2] = 'и') then
    Ftermobr_2 := 6;

  if FTermobr_Material_3[1] = 'У' then
    Ftermobr_3 := 1;
  if (FTermobr_Material_3[1] = 'Н') and (FTermobr_Material_3[2] = 'о') then
    Ftermobr_3 := 2;
  if FTermobr_Material_3[1] = 'О' then
    Ftermobr_3 := 3;
  if FTermobr_Material_3[1] = 'З' then
    Ftermobr_3 := 4;
  if FTermobr_Material_3[1] = 'Ц' then
    Ftermobr_3 := 5;
  if (FTermobr_Material_3[1] = 'Н') and (FTermobr_Material_3[2] = 'и') then
    Ftermobr_3 := 6;


end;

procedure TPlanet_Gear_2KH.record_Output(Var Output: TOutput);
begin
  Output.Material_1 := FMaterial_1;
  Output.Material_2 := FMaterial_2;
  Output.Material_3 := FMaterial_3;

  if Ftermobr_1 = 1 then
    Output.termobr_1 := 'Улучшение';
  if Ftermobr_1 = 2 then
    Output.termobr_1 := 'Нормализация';
  if Ftermobr_1 = 3 then
    Output.termobr_1 := 'Объемная закалка';
  if Ftermobr_1 = 4 then
    Output.termobr_1 := 'Закалка ТВЧ';
  if Ftermobr_1 = 5 then
    Output.termobr_1 := 'Цементация';
  if Ftermobr_1 = 6 then
    Output.termobr_1 := 'Нитроцементация';

if Ftermobr_2 = 1 then
    Output.termobr_2 := 'Улучшение';
  if Ftermobr_2 = 2 then
    Output.termobr_2 := 'Нормализация';
  if Ftermobr_2 = 3 then
    Output.termobr_2 := 'Объемная закалка';
  if Ftermobr_2 = 4 then
    Output.termobr_2 := 'Закалка ТВЧ';
  if Ftermobr_2 = 5 then
    Output.termobr_2 := 'Цементация';
  if Ftermobr_2 = 6 then
    Output.termobr_2 := 'Нитроцементация';

    if Ftermobr_3 = 1 then
    Output.termobr_3 := 'Улучшение';
  if Ftermobr_3 = 2 then
    Output.termobr_3 := 'Нормализация';
  if Ftermobr_3 = 3 then
    Output.termobr_3 := 'Объемная закалка';
  if Ftermobr_3 = 4 then
    Output.termobr_3 := 'Закалка ТВЧ';
  if Ftermobr_3 = 5 then
    Output.termobr_3 := 'Цементация';
  if Ftermobr_3 = 6 then
    Output.termobr_3 := 'Нитроцементация';



  Output.Nv:=FNv;
  Output.T_1 := FT_1;
  Output.T_h := FT_h;
  Output.Tp_12 := FTp_12;
  Output.Tp_13 := FTp_13;
  Output.m := Fm;
  Output.z_1 := Fz_1;
  Output.z_2 := Fz_2;
  Output.z_3 := Fz_3;
  Output.z_4 := Fz_4;

  Output.aw := Faw;
  Output.u_12 := Fu_12;
  Output.u_23 := Fu_23;

  Output.B_1 := FB_1;
  Output.b_2 := Fb_2;
  Output.b_3 := Fb_3;
  Output.b_4 := Fb_4;

  Output.Da_1 := FDa_1;
  Output.Da_2 := FDa_2;
  Output.Da_3 := FDa_3;
  Output.Da_4 := FDa_4;

  Output.d_1 := Fd_1;
  Output.d_2 := Fd_2;
  Output.d_3 := Fd_3;
  Output.d_4 := Fd_4;

  Output.Ft := FFt;
  Output.Sigma_H_12 := FSigma_H_12;
  Output.Sigma_H_23 := FSigma_H_23;

  Output.Sigma_F_1 := FSigma_F_1;
  Output.Sigma_F_2 := FSigma_F_2;
  Output.Sigma_F_4 := FSigma_F_4;
  Output.Sigma_Hp_min := FSigma_Hp_min;
  Output.Sigma_Fp_min := FSigma_Fp_min;
end;

procedure TPlanet_Gear_2KH.SetIh(const Value: extended);
begin
    if (Value < ihmin) or (Value > ihmax) then
    raise ERangeError.CreateFmt
      ('[CalculateCWheel.SetIh] Передаточное отношение не может быть равно %g, допустимый диапазон от %g до %g',
      [Value, ihmin, ihmax])
  else
  begin
    Fih_1 := Value;
    Fih_2 := Value;
  end;
end;

procedure TPlanet_Gear_2KH.SetPe(const Value: extended);
begin
    if (Value < pemin) or (Value > pemax) then
    raise ERangeError.CreateFmt
      ('[CalculateCWheel.SetPe] Длина перешейка не может быть равна %g, допустимый диапазон от %g до %g',
      [Value, pemin, pemax])
  else
    Fpe := Value;
end;

procedure TPlanet_Gear_2KH.Setp(const Value: extended);
begin
    if (Value < pmin) or (Value > pmax) then
    raise ERangeError.CreateFmt
      ('[CalculateCWheel.SetP] Мощность на входном валу не может быть равна %g, допустимый диапазон от %g до %g, кВт',
      [Value, pmin, pmax])
  else
    FP := Value;
end;

end.
