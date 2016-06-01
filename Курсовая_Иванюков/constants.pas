unit constants;

interface

const
  PatternProcess: array [0 .. 3] of string[9] = ('�������', '���������',
    '������', '�������');
  Finish: array [0 .. 2] of string[12] = ('������������', '����������',
    '�����������');
  ToolStr: array [0 .. 2] of string[13] = ('�����', '������ �����',
    '������ ������');
  HandleStr: array [0 .. 5] of string[16] = ('���������',
    '������������', '�������� �������', '������� ���', '����������', // 5
    '���������������');
  roughness: array [0 .. 2] of string = ('Ra1.6', 'Ra3.2', 'Ra6.3');
  marca1: array [0 .. 24] of string[22] = ('12��2 ���� 4543-71',
    '12��3� ���� 4543-71', '12�2�4� ���� 4543-71', '15����� ���� 4543-71',
    '18��� ���� 4543-71', '18�2�4�� ���� 4543-71', '20� ���� 4543-71',
    '20�� ���� 4543-71', '20��2� ���� 4543-71', '20��3� ���� 4543-71',
    '20�2�4� ���� 4543-71', '20��� ���� 4543-71', '25����� ���� 4543-7',
    '30��� ���� 4543-71', '25��� ���� 4543-71', '25��� ���� 4543-71',
    '30��� ���� 4543-71', '35�� ���� 4543-71', '40 ���� 1050-74',
    '40� ���� 4543-71', '40�� ���� 4543-71', '40��� ���� 4543-71',
    '40��2�� ���� 4543-71', '45 ���� 1050-74', '50�� ���� 1050-74');
  ihmin: extended = 3;
  ihmax: extended = 14;
  pemin: extended = 0.0001;
  pemax: extended = 0.05;
  KPD: Extended = 0.96;
  pmax: Extended = 200;
  pmin: Extended = 0.1;
  nmax: integer = 10000;
  nmin: integer = 10;
  nwmax: byte = 3;
  nwmin: byte = 3;
implementation

end.
