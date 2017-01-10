program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp,mysql55conn,IdHTTP,IdComponent,sqldb,db,IBConnection
  { you can add units after this };

type
  { TMyApplication }

  TMyApplication = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

 const
   DBHostname='192.168.87.71';
   DBuser='root';
   DBpass='toor';
 var
   mSql:TMySQL55Connection;
   query:TSQLQuery;
   transaction:TSQLTransaction;
{ TMyApplication }

function GetHttp(AURL: string): string;
var
  IdHttp: TIdHTTP;
  resultdat: TStringList;
begin
  resultdat := TStringList.Create;
  Result := EmptyStr;
  IdHTTP := TIdHTTP.Create(nil);
  try
   resultdat.Delimiter:='|';
    Result := IdHttp.Get(AURL);
    resultdat.DelimitedText:=Result;
    WriteLn('Scann Result : '+resultdat[0]+' ['+resultdat[1]+']');
  finally
    IdHttp.Free;
  end;
end;

function QueryCheck(QueryString, DBName: string): string;
var
  S: String;
  cnt:LongInt;
begin
  mSql := TMySql55Connection.Create(nil);
   query := TSQLQuery.Create(nil);
   transaction := TSQLTransaction.Create(nil);
  try
    mSql.DatabaseName := DBName;
    mSql.Hostname := DBHostname;
    mSql.UserName := DBuser;
    mSql.Password := DBpass;
    msql.Transaction:=transaction;
    query.DataBase:=mSql;
    try
      mSql.Connected := true;
      writeln('Query ',mSql.Connected);
      cnt:=0;
      cnt:=cnt+1;
      //writeln('Start ',cnt);
      query.SQL.Text:=QueryString;
      query.Open;
      query.Last;
      query.First;
      while not query.EOF do
        begin
          S := S + query.FieldByName('bus_id').AsString + #13#10;
          //GetHttp('http://192.168.87.71/centreon/include/Mumsys/Toolkits/manual_hwscan.php?busid='+query.FieldByName('bus_id').AsString+'&busip='+query.FieldByName('ipaddress').AsString+'&hgroup='+query.FieldByName('group_id').AsString);
          query.Next;
        end;
          WriteLn(S);
          //WriteLn(query.RecordCount);
      sleep(3000);
    except
      on E : Exception do
      writeln('connection failed'+E.Message);
    end;
  finally
    mSql.Connected := False;
    mSql.Free;
  end;
end;

function QueryCheck(QueryString, DBName: string): string;
var
  S: String;
  cnt:LongInt;
begin
  mSql := TMySql55Connection.Create(nil);
   query := TSQLQuery.Create(nil);
   transaction := TSQLTransaction.Create(nil);
  try
    mSql.DatabaseName := DBName;
    mSql.Hostname := DBHostname;
    mSql.UserName := DBuser;
    mSql.Password := DBpass;
    msql.Transaction:=transaction;
    query.DataBase:=mSql;
    try
      mSql.Connected := true;
      writeln('Query ',mSql.Connected);
      cnt:=0;
      cnt:=cnt+1;
      //writeln('Start ',cnt);
      query.SQL.Text:=QueryString;
      query.Open;
      query.Last;
      query.First;
      while not query.EOF do
        begin
          S := S + query.FieldByName('bus_id').AsString + #13#10;
          //GetHttp('http://192.168.87.71/centreon/include/Mumsys/Toolkits/manual_hwscan.php?busid='+query.FieldByName('bus_id').AsString+'&busip='+query.FieldByName('ipaddress').AsString+'&hgroup='+query.FieldByName('group_id').AsString);
          query.Next;
        end;
          WriteLn(S);
          //WriteLn(query.RecordCount);
      sleep(3000);
    except
      on E : Exception do
      writeln('connection failed'+E.Message);
    end;
  finally
    mSql.Connected := False;
    mSql.Free;
  end;
end;

procedure TMyApplication.DoRun;
var
  ErrorMsg: String;
begin
  // quick check parameters
  ErrorMsg:=CheckOptions('h', 'help');
  if ErrorMsg<>'' then begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;

  // parse parameters
  if HasOption('h', 'help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  { add your program here }
   WriteLn('Running');
   while true do
     begin
       QueryCheck('SELECT bus_id,group_id,ipaddress FROM queue_hardware_scanner WHERE `isrun`='+'0'+' LIMIT 3','mnp_rack');
     end;

  Terminate;
end;


constructor TMyApplication.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TMyApplication.Destroy;
begin
  inherited Destroy;
end;

procedure TMyApplication.WriteHelp;
begin
  { add your help code here }
  writeln('Usage: ', ExeName, ' -h');
end;

var
  Application: TMyApplication;
begin
  Application:=TMyApplication.Create(nil);
  Application.Title:='My Application';
  Application.Run;
  Application.Free;
end.

