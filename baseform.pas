{*************************************************************************************
  This file is part of Transmission Remote GUI.
  Copyright (c) 2008-2011 by Yury Sidorov.

  Transmission Remote GUI is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  Transmission Remote GUI is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with Transmission Remote GUI; if not, write to the Free Software
  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*************************************************************************************}

unit BaseForm;

{$mode objfpc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics;

type

  { TBaseForm }

  TBaseForm = class(TForm)
  private
    FNeedAutoSize: boolean;
    procedure DoScale(C: TControl);
  protected
    procedure DoCreate; override;
  public
    constructor Create(TheOwner: TComponent); override;
  end;

procedure AutoSizeForm(Form: TCustomForm);

implementation

uses LCLType, ButtonPanel, VarGrid;

var
  ScaleM, ScaleD: integer;

procedure InitScale;
var
  i: integer;
begin
  if ScaleD <> 0 then exit;
  i:=Screen.SystemFont.Height;
  if i = 0 then
    i:=-11;
  ScaleM:=Abs(i);
  ScaleD:=11;
end;

function ScaleInt(i: integer): integer;
begin
  Result:=i*ScaleM div ScaleD;
end;

type THackControl = class(TControl) end;

procedure AutoSizeForm(Form: TCustomForm);
var
  i, ht, w, h: integer;
  C: TControl;
begin
  ht:=0;
  for i:=0 to Form.ControlCount - 1 do begin
    C:=Form.Controls[i];
    with C do begin
      if C is TButtonPanel then begin
        TButtonPanel(C).HandleNeeded;
        w:=0;
        h:=0;
        THackControl(C).CalculatePreferredSize(w, h, True);
      end
      else
        h:=Height;
{$ifdef LCLcarbon}
      if C is TPageControl then
        Inc(h, 10);
{$endif LCLcarbon}
      Inc(ht, h + BorderSpacing.Top + BorderSpacing.Bottom + BorderSpacing.Around*2);
    end;

  end;
  ht:=ht + 2*Form.BorderWidth;

  Form.ClientHeight:=ht;
  if Form.ClientHeight <> ht then begin
    Form.Constraints.MinHeight:=0;
    Form.ClientHeight:=ht;
    Form.Constraints.MinHeight:=Form.Height;
  end;
  if Form.BorderStyle = bsDialog then begin
    Form.Constraints.MinHeight:=Form.Height;
    Form.Constraints.MinWidth:=Form.Width;
  end;
end;

{ TBaseForm }

procedure TBaseForm.DoScale(C: TControl);
var
  i: integer;
  R: TRect;
begin
  if ScaleM = ScaleD then exit;
  with C do begin
    if C is TWinControl then
      TWinControl(C).DisableAlign;
    try
      ScaleConstraints(ScaleM, ScaleD);
      R := BaseBounds;
      R.Left := ScaleInt(R.Left);
      R.Top := ScaleInt(R.Top);
      R.Right := ScaleInt(R.Right);
      R.Bottom := ScaleInt(R.Bottom);
      BoundsRect := R;
      with BorderSpacing do begin
        Top:=ScaleInt(Top);
        Left:=ScaleInt(Left);
        Bottom:=ScaleInt(Bottom);
        Right:=ScaleInt(Right);
        Around:=ScaleInt(Around);
        InnerBorder:=ScaleInt(InnerBorder);
      end;

      if C is TButtonPanel then
        TButtonPanel(C).Spacing:=ScaleInt(TButtonPanel(C).Spacing);

      if C is TVarGrid then
        with TVarGrid(C).Columns do
          for i:=0 to Count - 1 do
             Items[i].Width:=ScaleInt(Items[i].Width);

      if C is TWinControl then
        with TWinControl(C) do
          for i:=0 to ControlCount - 1 do
            DoScale(Controls[i]);
    finally
      if C is TWinControl then
        TWinControl(C).EnableAlign;
    end;
  end;
end;

constructor TBaseForm.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FNeedAutoSize:=AutoSize;
  AutoSize:=False;
end;

procedure TBaseForm.DoCreate;
begin
  if FNeedAutoSize then
    AutoSizeForm(Self);
  Font.Height:=ScaleInt(-11);
  HandleNeeded;
  DoScale(Self);
  inherited DoCreate;
end;

initialization
  {$I baseform.lrs}
  InitScale;

end.

