unit libBotao; {$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Controls, ExtCtrls, Graphics, LMessages, LCLIntf, LResources, ImgList, Types, LCLType, Forms;

type

  { TBotao }

  TBotao = class(TCustomPanel)
  private
    FCorDisabled: TColor;
    FCorNormal: TColor;
    FCorHover: TColor;
    FCorClick: TColor;
    FCorFocus: TColor;
    FCorBordaFoco: TColor;
    FFontCorDisabled: TColor;
    FFontCorNormal: TColor;
    FFontCorHover: TColor;
    FFontCorClick: TColor;
    FFontCorFocus: TColor;
    FImageIndex: TImageIndex;
    FImages: TCustomImageList;
    FMouseSobre: boolean;
    FSpacing: integer;
    FProcessandoClique: boolean;
    FUltimoClique: QWord;
    FIntervaloClique: integer;
    FTextoAguarde: string;
    FCursorAnterior: TCursor;
    procedure CMMouseEnter(var Message: TLMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TLMessage); message CM_MOUSELEAVE;
    procedure SetCorNormal(AValue: TColor);
    procedure SetImageIndex(AValue: TImageIndex);
    procedure SetImages(AValue: TCustomImageList);
    procedure SetSpacing(AValue: integer);
    procedure AppOcioso(Sender: TObject; var Done: boolean);
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure CMEnabledChanged(var Message: TLMessage); message CM_ENABLEDCHANGED;
    procedure KeyDown(var Key: word; Shift: TShiftState); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Click; override;
  published
    property CorNormal: TColor read FCorNormal write SetCorNormal default $00D27619;
    property CorHover: TColor read FCorHover write FCorHover default $00F5A542;
    property CorClick: TColor read FCorClick write FCorClick default $00A1470D;
    property CorFocus: TColor read FCorFocus write FCorFocus default $00D27619;
    property CorBordaFoco: TColor read FCorBordaFoco write FCorBordaFoco default $00F9CA90;
    property CorDisabled: TColor read FCorDisabled write FCorDisabled default clSilver;

    property FontCorNormal: TColor read FFontCorNormal write FFontCorNormal default clWhite;
    property FontCorHover: TColor read FFontCorHover write FFontCorHover default clWhite;
    property FontCorClick: TColor read FFontCorClick write FFontCorClick default clNavy;
    property FontCorFocus: TColor read FFontCorFocus write FFontCorFocus default clWhite;
    property FontCorDisabled: TColor read FFontCorDisabled write FFontCorDisabled default clGray;

    property Images: TCustomImageList read FImages write SetImages;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex default -1;
    property Spacing: integer read FSpacing write SetSpacing default 4;

    // Janela anti-duplo-clique em milissegundos (0 desliga a proteção).
    property IntervaloClique: integer read FIntervaloClique write FIntervaloClique default 700;
    // Texto exibido enquanto o OnClick processa. Vazio = mantém o Caption normal.
    property TextoAguarde: string read FTextoAguarde write FTextoAguarde;

    //Propriedades herdadas
    property Caption;
    property Font;
    property TabStop default True;
    property TabOrder;
    property OnClick;
    property Align;
    property Anchors;
    property Cursor default crHandPoint;
    property VerticalAlignment;
    property BorderSpacing;
    property Enabled;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('RibaSoft', [TBotao]);
end;

//==================================================== CREATE ========================================================\\
constructor TBotao.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  BevelOuter := bvNone;
  BevelInner := bvNone;
  //Alignment := taCenter;
  Cursor := crHandPoint;
  Width := 120;
  Height := 34;
  TabStop := True;
  ControlStyle := ControlStyle - [csAcceptsControls];
  ShowHint := True;

  //Anti-duplo-clique + aguarde
  FIntervaloClique := 700;
  FUltimoClique := 0;
  FProcessandoClique := False;
  FTextoAguarde := 'Aguarde...';

  //Fundo
  Self.Color := $00D27619;
  FCorNormal := $00D27619;
  FCorHover := $00F5A542;
  FCorClick := $00A1470D;
  FCorFocus := $00D27619;
  FCorBordaFoco := $00F9CA90;
  FCorDisabled := clSilver;

  // Font
  Font.Color := clWhite;
  Font.Name := 'Segoe UI';
  ParentFont := False;
  Font.Size := 12;
  FFontCorNormal := clWhite;
  FFontCorHover := clWhite;
  FFontCorClick := clNavy;
  FFontCorFocus := clWhite;
  FFontCorDisabled := clGray;

  //Icone
  FImageIndex := -1;
  FSpacing := 4;
end;

//==================================================== SET COR NORMAL ================================================\\
procedure TBotao.SetCorNormal(AValue: TColor);
begin
  if FCorNormal = AValue then Exit;
  FCorNormal := AValue;

  if not FMouseSobre then
    Color := FCorNormal;

  Invalidate;
end;

//================================================= SET IMAGE INDEX ==================================================\\
procedure TBotao.SetImageIndex(AValue: TImageIndex);
begin
  if FImageIndex <> AValue then
  begin
    FImageIndex := AValue;
    Invalidate;
  end;
end;

//================================================== SET IMAGES ======================================================\\
procedure TBotao.SetImages(AValue: TCustomImageList);
begin
  if FImages <> AValue then
  begin
    FImages := AValue;
    Invalidate;
  end;
end;

//================================================== SET SPACING =====================================================\\
procedure TBotao.SetSpacing(AValue: integer);
begin
  if FSpacing <> AValue then
  begin
    FSpacing := AValue;
    Invalidate;
  end;
end;

//==================================================== MOUSE ENTER ===================================================\\
{$HINTS OFF}
procedure TBotao.CMMouseEnter(var Message: TLMessage);
begin
  FMouseSobre := True;
  Color := FCorHover;
  Font.Color := FFontCorHover;
  Invalidate;
end;

//===================================================== MOUSE LEAVE ==================================================\\
procedure TBotao.CMMouseLeave(var Message: TLMessage);
begin
  FMouseSobre := False;
  Color := FCorNormal;
  Font.Color := FFontCorNormal;
  Invalidate;
end;

{$HINTS ON}

//====================================================== MOUSE DOWN ==================================================\\
procedure TBotao.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  inherited;
  Color := FCorClick;
  Font.Color := FFontCorClick;
  Invalidate;
end;

//======================================================== MOUSE UP ==================================================\\
procedure TBotao.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  inherited;
  if FMouseSobre then
  begin
    Color := FCorHover;
    Font.Color := FFontCorHover;
  end
  else
  begin
    Color := FCorNormal;
    Font.Color := FFontCorNormal;
  end;
  Invalidate;
end;

//====================================================== EFEITO DO CLICK =============================================\\
// Anti-duplo-clique. Duas travas combinadas:
//  - FProcessandoClique: barra reentrancia enquanto o OnClick roda (inclusive
//    parado num dialogo modal, que roda o loop de mensagens).
//  - FUltimoClique: carimbo de tempo gravado NA CONCLUSAO, para barrar o 2o
//    clique que ficou na fila durante um OnClick sincrono demorado (PC lento).
// IntervaloClique = 0 desliga a protecao (botoes que precisam de clique repetido).
procedure TBotao.Click;
begin
  if FProcessandoClique then Exit;

  if (FIntervaloClique > 0) and (FUltimoClique <> 0) and
     (GetTickCount64 - FUltimoClique < QWord(FIntervaloClique)) then
    Exit;

  FProcessandoClique := True;
  FCursorAnterior := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  Application.AddOnIdleHandler(@AppOcioso);   // devolve o cursor se o clique parar pra esperar o usuario
  Repaint;                       // pinta "Aguarde..." ANTES do processamento (inclusive sincrono)
  try
    inherited Click;
  finally
    Application.RemoveOnIdleHandler(@AppOcioso);
    Screen.Cursor := FCursorAnterior;
    FProcessandoClique := False;
    FUltimoClique := GetTickCount64;
    if not (csDestroying in ComponentState) then
      Repaint;                   // restaura o visual normal
  end;
end;

//================================================== APP OCIOSO ======================================================\\
// O OnClick pode abrir uma janela (ShowModal). Enquanto ela fica aberta, o laco
// do ShowModal chama Application.Idle a cada volta: o programa NAO esta
// processando, esta parado esperando o usuario clicar. Nessa hora a ampulheta
// engana - o cliente fica esperando o cursor mudar pra poder clicar.
// Entao devolvemos o cursor normal. Quem sinaliza o processamento continua
// sendo o "Aguarde..." escrito no proprio botao.
// Trabalho sincrono (relatorio, impressao) nunca fica ocioso: la a ampulheta fica.
{$HINTS OFF}
procedure TBotao.AppOcioso(Sender: TObject; var Done: boolean);
begin
  if Screen.Cursor = crHourGlass then
    Screen.Cursor := FCursorAnterior;
  // Done NAO e alterado de proposito: mexer nele poe o app pra girar em laco.
end;
{$HINTS ON}

//==================================================== QUANDO EM FOCO ================================================\\
procedure TBotao.DoEnter;
begin
  inherited DoEnter;
  Invalidate;
end;

//==================================================== SAINDO DO FOCO ================================================\\
procedure TBotao.DoExit;
begin
  inherited DoExit;
  Color := FCorNormal;
  Font.Color := FFontCorNormal;
  Invalidate;
end;

//=================================================== NOTIFICATION ===================================================\\
procedure TBotao.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FImages) then
    FImages := nil;
end;

//================================================ CMENABLED CHANGED =================================================\\
procedure TBotao.CMEnabledChanged(var Message: TLMessage);
begin
  inherited;
  Invalidate;
end;

//==================================================== KEY DOWN ======================================================\\
procedure TBotao.KeyDown(var Key: word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);

  if (key = VK_RETURN) or (Key = VK_SPACE) then
  begin
    Click;
    Key := 0;
  end;
end;

//====================================================== PAINT =======================================================\\
procedure TBotao.Paint;
var
  CorFundo, CorFonte: TColor;
  IconWidth, IconHeight, TextW, TextH, TotalWidth: integer;
  StartX, IconY, TextY: integer;
  HasIcon: boolean;
  R: TRect;
  TextStyle: TTextStyle;
  auxTexto: string;
begin
  //1 Determina cores
  if FProcessandoClique then          // estado "Aguarde..."
  begin
    CorFundo := FCorClick;
    CorFonte := FFontCorClick;
  end
  else if not Enabled then
  begin
    CorFundo := FCorDisabled;
    CorFonte := FFontCorDisabled;
  end
  else if (Color = FCorClick) then
  begin
    CorFundo := FCorClick;
    CorFonte := FFontCorClick;
  end
  else if FMouseSobre then
  begin
    CorFundo := FCorHover;
    CorFonte := FFontCorHover;
  end
  else if Focused or (FMouseSobre and (csDesigning in ComponentState)) then
  begin
    CorFundo := FCorFocus;
    CorFonte := FFontCorFocus;
  end
  else
  begin
    CorFundo := FCorNormal;
    CorFonte := FFontCorNormal;
  end;

  //2 Desenha o Fundo
  Canvas.Brush.Color := CorFundo;
  Canvas.FillRect(ClientRect);

  //3 Prepara icone e texto
  // Durante o "Aguarde..." esconde o icone e usa o texto de espera.
  HasIcon := Assigned(FImages) and (FImageIndex >= 0) and (FImageIndex < FImages.Count) and (not FProcessandoClique);

  if FProcessandoClique and (FTextoAguarde <> '') then
    auxTexto := FTextoAguarde
  else
    auxTexto := Caption;

  Canvas.Font.Assign(Font);
  Canvas.Font.Color := CorFonte;

  IconWidth := 0;
  IconHeight := 0;

  if HasIcon then
  begin
    IconWidth := FImages.Width;
    IconHeight := FImages.Height;
  end;

  TextW := Canvas.TextWidth(StringReplace(auxTexto, '&', '', [rfReplaceAll]));
  TextH := Canvas.TextHeight(auxTexto);

  TotalWidth := TextW;
  if HasIcon then
    TotalWidth := TotalWidth + IconWidth + FSpacing;

  StartX := (Width - TotalWidth) div 2;
  if StartX < 2 then StartX := 2;

  // 4. Desenha o Ícone
  if HasIcon then
  begin
    IconY := (Height - IconHeight) div 2;
    FImages.Draw(Canvas, StartX, IconY, FImageIndex, Enabled);
    Inc(StartX, IconWidth + FSpacing);
  end;

  // 5. Desenha o Texto
  if auxTexto <> '' then
  begin
    TextY := (Height - TextH) div 2;
    TextStyle := Canvas.TextStyle;
    TextStyle.Alignment := taLeftJustify;
    TextStyle.Layout := tlCenter;
    TextStyle.ShowPrefix := True;

    R := ClientRect;
    R.Left := StartX;
    Canvas.TextRect(R, R.Left, TextY, auxTexto, TextStyle);
  end;

  //Desenha borda quando focado
  if Focused or (FMouseSobre and (csDesigning in ComponentState)) then
  begin
    Canvas.Brush.Style := bsClear;
    Canvas.Pen.Color := FCorBordaFoco;
    Canvas.Pen.Style := psSolid;
    Canvas.Pen.Width := 2;
    Canvas.Rectangle(1, 1, Width, Height);
  end;
end;

initialization
  {$I libBotao.lrs}

  //====================================================================================================================\\
end.
