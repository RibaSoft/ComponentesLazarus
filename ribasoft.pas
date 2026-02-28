{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit ribasoft;

{$warn 5023 off : no warning about unused units}
interface

uses
  libBotao, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('libBotao', @libBotao.Register);
end;

initialization
  RegisterPackage('ribasoft', @Register);
end.
