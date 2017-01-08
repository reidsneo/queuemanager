program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp,mysql57conn,IdHTTP,IdComponent,sqldb,db,IBConnection
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

 var
   mSql:TMySQL57Connection;
   query:TSQLQuery;
   transaction:TSQLTransaction;
{ TMyApplication }

function GetHttp(AURL: string): string;
var
  IdHttp: TIdHTTP;
begin
  Result := EmptyStr;
  IdHTTP := TIdHTTP.Create(nil);
  try
    Result := IdHttp.Get(AURL);
    WriteLn(Result);
  finally
    IdHttp.Free;
  end;
end;

procedure TMyApplication.DoRun;
var
  ErrorMsg: String;
  S: String;
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
   mSql := TMySql57Connection.Create(nil);
   query := TSQLQuery.Create(nil);
   transaction := TSQLTransaction.Create(nil);
  try
    mSql.DatabaseName := 'mysql';
    mSql.Hostname := '127.0.0.1';
    mSql.UserName := 'root';
    mSql.Password := '123456';
    msql.Transaction:=transaction;
    query.DataBase:=mSql;
    query.SQL.Text:='select * from user;';
    query.Open;
    query.Last;
    S:=IntToStr(query.RecordCount) + #13#10;
    query.First;
    while not query.EOF do
      begin
        S := S + query.FieldByName('Host').AsString + #13#10;
        query.Next;
        WriteLn(S);
      end;

    try
      mSql.Connected := true;  // can also use connect method
      // work with the database
      writeln('Query ',mSql.Connected);
      //GetHttp('http://example.com');
    except
      writeln('connection failed');  // there is a host of appropiate exception handlers.
    end;
  finally
    mSql.Connected := False;
    mSql.Free;
  end;



  // stop program loop
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

