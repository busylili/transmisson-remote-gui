{*************************************************************************************
  This file is part of Transmission Remote GUI.
  Copyright (c) 2008-2009 by Yury Sidorov.

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

unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, zstream, LResources, Forms, Controls, Graphics, Dialogs, ComCtrls, Menus, ActnList,
  httpsend, IniFiles, StdCtrls, fpjson, jsonparser, ExtCtrls, rpc, syncobjs, variants, varlist, IpResolver,
  zipper, ResTranslator, VarGrid, StrUtils, LCLProc, Grids;

const
  AppName = 'Transmission Remote GUI';
  AppVersion = '1.5';

resourcestring
  sShowApp = 'Show';
  sHideApp = 'Hide';
  sAll = 'All';
  sWaiting = 'Waiting';
  sVerifying = 'Verifying';
  sDownloading = 'Downloading';
  sSeeding = 'Seeding';
  sFinished = 'Finished';
  sStopped = 'Stopped';
  sUnknown = 'Unknown';
  sCompleted = 'Completed';
  sConnected = 'connected';
  sActive = 'Active';
  sInactive = 'Inactive';
  sUpdating = 'Updating...';
  sFinishedDownload = '''%s'' has finished downloading';
  sDownloadComplete = 'Download complete';
  sUpdateComplete = 'Update complete.';
  sTorrentVerification = 'Torrent verification may take a long time.' + LineEnding + 'Are you sure to start verification of torrent ''%s''?';
  sReconnect = 'Reconnect in %d seconds.';
  sDisconnected = 'Disconnected';
  sConnectingToDaemon = 'Connecting to daemon...';
  sSec = '%ds';
  sMinSec = '%dm, %ds';
  sHourMin = '%dh, %dm';
  sDayHour = '%dd, %dh';
  sDownloadingSeeding = '%s%s%d downloading, %d seeding%s%s, %s';
  sDownSpeed = 'D: %s/s';
  sUpSpeed = 'U: %s/s';
  sNoPathMapping = 'Unable to find path mapping.'+LineEnding+'Use program''s options to setup path mappings.';
  sGeoIPConfirm = 'Geo IP database is needed to resolve country by IP address.' + LineEnding + 'Download this database now?';
  sFlagArchiveConfirm = 'Flag images archive is needed to display country flags.' + LineEnding + 'Download this archive now?';
  sInSwarm = 'in swarm';
  sHashfails = '%s (%d hashfails)';
  sDone = '%s (%s done)';
  sHave = '%d x %s (have %d)';
  sUnableExtractFlag = 'Unable to extract flag image.';
  sTrackerWorking = 'Working';
  sTrackerUpdating = 'Updating';
  sRestartRequired = 'You should restart the application to apply changes.';
  sRemoveTorrentData = 'Are you sure to remove torrent ''%s'' and all associated DATA?';
  sRemoveTorrentDataMulti = 'Are you sure to remove %d selected torrents and all their associated DATA?';
  sRemoveTorrent = 'Are you sure to remove torrent ''%s''?';
  sRemoveTorrentMulti = 'Are you sure to remove %d selected torrents?';
  sUnableGetFilesList = 'Unable to get files list';
  sTrackerError = 'Tracker';
  sSkip = 'skip';
  sLow = 'low';
  sNormal = 'normal';
  sHigh = 'high';
  sByte = 'b';
  sKByte = 'KB';
  sMByte = 'MB';
  sGByte = 'GB';
  sTByte = 'TB';
  sPerSecond = '/s';
  sOf = 'of';
  sNoTracker = 'No tracker';
  sTorrents = 'Torrents';

type

  { TMainForm }

  TMainForm = class(TForm)
    acConnect: TAction;
    acAddTorrent: TAction;
    acStopTorrent: TAction;
    acRemoveTorrent: TAction;
    acStartTorrent: TAction;
    acSetHighPriority: TAction;
    acSetNormalPriority: TAction;
    acSetLowPriority: TAction;
    acSetNotDownload: TAction;
    acOptions: TAction;
    acDaemonOptions: TAction;
    acStartAllTorrents: TAction;
    acStopAllTorrents: TAction;
    acExit: TAction;
    acResolveHost: TAction;
    acResolveCountry: TAction;
    acShowCountryFlag: TAction;
    acSetupColumns: TAction;
    acRemoveTorrentAndData: TAction;
    acOpenFile: TAction;
    acOpenContainingFolder: TAction;
    acAddLink: TAction;
    acReannounceTorrent: TAction;
    acUpdateGeoIP: TAction;
    acTorrentProps: TAction;
    acVerifyTorrent: TAction;
    ActionList: TActionList;
    ApplicationProperties: TApplicationProperties;
    edSearch: TEdit;
    imgSearch: TImage;
    imgFlags: TImageList;
    ImageList16: TImageList;
    FilterTimer: TTimer;
    lvFilter: TVarGrid;
    lvTrackers: TVarGrid;
    MenuItem25: TMenuItem;
    MenuItem40: TMenuItem;
    MenuItem41: TMenuItem;
    MenuItem42: TMenuItem;
    MenuItem43: TMenuItem;
    MenuItem44: TMenuItem;
    MenuItem45: TMenuItem;
    MenuItem46: TMenuItem;
    MenuItem47: TMenuItem;
    MenuItem48: TMenuItem;
    MenuItem49: TMenuItem;
    MenuItem50: TMenuItem;
    MenuItem51: TMenuItem;
    pbDownloaded: TPaintBox;
    pmTrackers: TPopupMenu;
    tabTrackers: TTabSheet;
    ToolButton9: TToolButton;
    txConnErrorLabel: TLabel;
    panSearch: TPanel;
    panFilter: TPanel;
    panReconnectFrame: TShape;
    txReconnectSecs: TLabel;
    txConnError: TLabel;
    MenuItem38: TMenuItem;
    MenuItem39: TMenuItem;
    panReconnect: TPanel;
    txLastActive: TLabel;
    txLastActiveLabel: TLabel;
    txTracker: TLabel;
    txTrackerLabel: TLabel;
    txCompletedOn: TLabel;
    txCompletedOnLabel: TLabel;
    txAddedOn: TLabel;
    txAddedOnLabel: TLabel;
    MenuItem19: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    miTSep1: TMenuItem;
    MenuItem26: TMenuItem;
    MenuItem27: TMenuItem;
    MenuItem28: TMenuItem;
    MenuItem29: TMenuItem;
    MenuItem30: TMenuItem;
    MenuItem31: TMenuItem;
    MenuItem32: TMenuItem;
    MenuItem33: TMenuItem;
    MenuItem34: TMenuItem;
    MenuItem35: TMenuItem;
    MenuItem36: TMenuItem;
    MenuItem37: TMenuItem;
    miToggleApp: TMenuItem;
    miAbout: TMenuItem;
    miHelp: TMenuItem;
    panTop: TPanel;
    pmTray: TPopupMenu;
    HSplitter: TSplitter;
    pmPeers: TPopupMenu;
    TrayIcon: TTrayIcon;
    txCreated: TLabel;
    txCreatedLabel: TLabel;
    txTorrentHeader: TPanel;
    txTorrentName: TLabel;
    txTorrentNameLabel: TLabel;
    txDownProgress: TLabel;
    txDownProgressLabel: TLabel;
    panProgress: TPanel;
    txMaxPeers: TLabel;
    txMaxPeersLabel: TLabel;
    txPeers: TLabel;
    txPeersLabel: TLabel;
    txSeeds: TLabel;
    txSeedsLabel: TLabel;
    txDummy2: TLabel;
    txTrackerUpdate: TLabel;
    txDummy1: TLabel;
    txRemaining: TLabel;
    txRemainingLabel: TLabel;
    txStatus: TLabel;
    txStatusLabel: TLabel;
    txRatio: TLabel;
    txRatioLabel: TLabel;
    txDownLimit: TLabel;
    txDownLimitLabel: TLabel;
    txTrackerUpdateLabel: TLabel;
    txTransferHeader: TPanel;
    txUpSpeed: TLabel;
    txUpLimit: TLabel;
    txUpSpeedLabel: TLabel;
    txDownSpeed: TLabel;
    txDownSpeedLabel: TLabel;
    txUploaded: TLabel;
    txUploadedLabel: TLabel;
    txDownloaded: TLabel;
    txDownloadedLabel: TLabel;
    txUpLimitLabel: TLabel;
    txWasted: TLabel;
    txWastedLabel: TLabel;
    miCopyLabel: TMenuItem;
    pmLabels: TPopupMenu;
    txError: TLabel;
    txErrorLabel: TLabel;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    miTools: TMenuItem;
    TickTimer: TTimer;
    MainToolBar: TToolBar;
    panTransfer: TPanel;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    txComment: TLabel;
    txCommentLabel: TLabel;
    txHash: TLabel;
    txHashLabel: TLabel;
    panGeneralInfo: TPanel;
    lvFiles: TVarGrid;
    lvPeers: TVarGrid;
    MainMenu: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    miConnect: TMenuItem;
    miExit: TMenuItem;
    miTorrent: TMenuItem;
    OpenTorrentDlg: TOpenDialog;
    PageInfo: TPageControl;
    pmTorrents: TPopupMenu;
    pmFiles: TPopupMenu;
    sbGenInfo: TScrollBox;
    txPieces: TLabel;
    txPiecesLabel: TLabel;
    txTotalSize: TLabel;
    txTotalSizeLabel: TLabel;
    gTorrents: TVarGrid;
    VSplitter: TSplitter;
    StatusBar: TStatusBar;
    tabPeers: TTabSheet;
    tabGeneral: TTabSheet;
    TorrentsListTimer: TTimer;
    tabFiles: TTabSheet;
    procedure acAddLinkExecute(Sender: TObject);
    procedure acAddTorrentExecute(Sender: TObject);
    procedure acConnectExecute(Sender: TObject);
    procedure acOpenContainingFolderExecute(Sender: TObject);
    procedure acOpenFileExecute(Sender: TObject);
    procedure acOptionsExecute(Sender: TObject);
    procedure acDisconnectExecute(Sender: TObject);
    procedure acExitExecute(Sender: TObject);
    procedure acDaemonOptionsExecute(Sender: TObject);
    procedure acReannounceTorrentExecute(Sender: TObject);
    procedure acRemoveTorrentAndDataExecute(Sender: TObject);
    procedure acRemoveTorrentExecute(Sender: TObject);
    procedure acResolveCountryExecute(Sender: TObject);
    procedure acResolveHostExecute(Sender: TObject);
    procedure acSetHighPriorityExecute(Sender: TObject);
    procedure acSetLowPriorityExecute(Sender: TObject);
    procedure acSetNormalPriorityExecute(Sender: TObject);
    procedure acSetNotDownloadExecute(Sender: TObject);
    procedure acSetupColumnsExecute(Sender: TObject);
    procedure acShowCountryFlagExecute(Sender: TObject);
    procedure acStartAllTorrentsExecute(Sender: TObject);
    procedure acStartTorrentExecute(Sender: TObject);
    procedure acStopAllTorrentsExecute(Sender: TObject);
    procedure acStopTorrentExecute(Sender: TObject);
    procedure acTorrentPropsExecute(Sender: TObject);
    procedure acUpdateGeoIPExecute(Sender: TObject);
    procedure acVerifyTorrentExecute(Sender: TObject);
    procedure ApplicationPropertiesException(Sender: TObject; E: Exception);
    procedure ApplicationPropertiesIdle(Sender: TObject; var Done: Boolean);
    procedure ApplicationPropertiesMinimize(Sender: TObject);
    procedure ApplicationPropertiesRestore(Sender: TObject);
    procedure edSearchChange(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of String);
    procedure gTorrentsCellAttributes(Sender: TVarGrid; ACol, ARow, ADataCol: integer; AState: TGridDrawState; var CellAttribs: TCellAttributes);
    procedure gTorrentsClick(Sender: TObject);
    procedure gTorrentsDblClick(Sender: TObject);
    procedure gTorrentsDrawCell(Sender: TVarGrid; ACol, ARow, ADataCol: integer; AState: TGridDrawState; const R: TRect; var ADefaultDrawing: boolean);
    procedure gTorrentsResize(Sender: TObject);
    procedure gTorrentsSortColumn(Sender: TVarGrid; var ASortCol: integer);
    procedure lvFilesCellAttributes(Sender: TVarGrid; ACol, ARow, ADataCol: integer; AState: TGridDrawState; var CellAttribs: TCellAttributes);
    procedure lvFilesDblClick(Sender: TObject);
    procedure lvFilesDrawCell(Sender: TVarGrid; ACol, ARow, ADataCol: integer; AState: TGridDrawState; const R: TRect; var ADefaultDrawing: boolean);
    procedure lvFilesKeyPress(Sender: TObject; var Key: char);
    procedure lvFilterCellAttributes(Sender: TVarGrid; ACol, ARow, ADataCol: integer; AState: TGridDrawState; var CellAttribs: TCellAttributes);
    procedure lvFilterClick(Sender: TObject);
    procedure lvPeersCellAttributes(Sender: TVarGrid; ACol, ARow, ADataCol: integer; AState: TGridDrawState; var CellAttribs: TCellAttributes);
    procedure lvTrackersCellAttributes(Sender: TVarGrid; ACol, ARow, ADataCol: integer; AState: TGridDrawState; var CellAttribs: TCellAttributes);
    procedure panReconnectResize(Sender: TObject);
    procedure pbDownloadedPaint(Sender: TObject);
    procedure pbDownloadedResize(Sender: TObject);
    procedure TickTimerTimer(Sender: TObject);
    procedure FilterTimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lvFilterCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lvFilterResize(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure miCopyLabelClick(Sender: TObject);
    procedure miToggleAppClick(Sender: TObject);
    procedure PageInfoChange(Sender: TObject);
    procedure TorrentsListTimerTimer(Sender: TObject);
    procedure pmFilesPopup(Sender: TObject);
    procedure pmTorrentsPopup(Sender: TObject);
    procedure sbGenInfoResize(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
  private
    FStarted: boolean;
    FTorrents: TVarList;
    FFiles: TVarList;
    FTrackers: TStringList;
    FResolver: TIpResolver;
    FUnZip: TUnZipper;
    FReconnectWaitStart: TDateTime;
    FReconnectTimeOut: integer;
    FDoneColumnIdx: integer;
    FTorrentProgress: TBitmap;
    FLastPieces: string;
    FLastPieceCount: integer;
    FLastDone: double;
    FIni: TIniFile;
    FCurHost: string;
    FPathMap: TStringList;

    procedure DoConnect;
    procedure DoDisconnect;
    procedure UpdateUI;
    function ShowConnOptions: boolean;
    procedure SaveColumns(LV: TVarGrid; const AName: string; FullInfo: boolean = True);
    procedure LoadColumns(LV: TVarGrid; const AName: string; FullInfo: boolean = True);
    function GetTorrentError(t: TJSONObject): string;
    function SecondsToString(j: integer): string;
    procedure DoAddTorrent(const FileName: Utf8String);
    procedure UpdateTray;
    procedure HideApp;
    procedure ShowApp;
    procedure DownloadFinished(const TorrentName: string);
    function GetFlagImage(const CountryCode: string): integer;
    procedure BeforeCloseApp;
    function GetGeoIpDatabase: string;
    function GetFlagsArchive: string;
    function DownloadGeoIpDatabase(AUpdate: boolean): boolean;
    procedure TorrentColumnsChanged;
    function EtaToString(ETA: integer): string;
    function GetTorrentStatus(TorrentIdx: integer): string;
    function GetSeedsText(Seeds, SeedsTotal: integer): string;
    function GetPeersText(Peers, PeersTotal, Leechers: integer): string;
    function RatioToString(Ratio: double): string;
    function TorrentDateTimeToString(d: Int64): string;
    procedure DoRefresh(All: boolean = False);
    function GetFilesCommonPath(files: TJSONArray): string;
    procedure InternalRemoveTorrent(const Msg, MsgMulti: string; RemoveLocalData: boolean);
    function IncludeProperTrailingPathDelimiter(const s: string): string;
    procedure UrlLabelClick(Sender: TObject);
    procedure CenterReconnectWindow;
    procedure DrawProgressCell(Sender: TVarGrid; ACol, ARow, ADataCol: integer; AState: TGridDrawState; const ACellRect: TRect);
    procedure ProcessPieces(const Pieces: string; PieceCount: integer; const Done: double);
    function ExecRemoteFile(const FileName: string): boolean;
    function GetSelectedTorrents: variant;
  public
    procedure FillTorrentsList(list: TJSONArray);
    procedure FillPeersList(list: TJSONArray);
    procedure FillFilesList(list, priorities, wanted: TJSONArray; const DownloadDir: WideString);
    procedure FillGeneralInfo(t: TJSONObject);
    procedure FillTrackersList(TrackersData: TJSONObject);
    procedure CheckStatus(Fatal: boolean = True);
    function TorrentAction(const TorrentIds: variant; const AAction: string; args: TJSONObject = nil): boolean;
    function SetFilePriority(TorrentId: integer; const Files: array of integer; const APriority: string): boolean;
    function SetCurrentFilePriority(const APriority: string): boolean;
    procedure ClearDetailsInfo;
    property Ini: TIniFile read FIni;
  end;

function CheckAppParams: boolean;
function GetHumanSize(sz: double; RoundTo: integer = 0): string;

var
  MainForm: TMainForm;
  RpcObj: TRpc;
  FTranslationFileName: string;
  FTranslationLanguage: string;
  FAlterColor: TColor;

const
  // Torrents list
  idxName = 0;
  idxSize = 1;
  idxDone = 2;
  idxStatus = 3;
  idxSeeds = 4;
  idxPeers = 5;
  idxDownSpeed = 6;
  idxUpSpeed = 7;
  idxETA = 8;
  idxRatio = 9;
  idxDownloaded = 10;
  idxUploaded = 11;
  idxTracker = 12;
  idxTrackerStatus = 13;
  idxAddedOn = 14;
  idxCompletedOn = 15;
  idxLastActive = 16;
  idxPath = 17;

  idxTorrentId = -1;
  idxTag = -2;
  idxSeedsTotal = -3;
  idxLeechers = -4;
  idxPeersTotal = -5;
  idxStateImg = -6;
  TorrentsExtraColumns = 6;

  // Peers list
  idxPeerHost = 0;
  idxPeerPort = 1;
  idxPeerCountry = 2;
  idxPeerClient = 3;
  idxPeerFlags = 4;
  idxPeerDone = 5;
  idxPeerUpSpeed = 6;
  idxPeerDownSpeed = 7;
  idxPeerTag = -1;
  idxPeerIP = -2;
  idxPeerCountryImage = -3;
  PeersExtraColumns = 3;

  // Files list
  idxFileName = 0;
  idxFileSize = 1;
  idxFileDone = 2;
  idxFileProgress = 3;
  idxFilePriority = 4;
  idxFileId = -1;
  idxFileTag = -2;
  idxFileFullPath = -3;
  FilesExtraColumns = 3;

  // Trackers list
  idxTrackersListName = 0;
  idxTrackersListStatus = 1;
  idxTrackersListUpdateIn = 2;
  idxTrackersListSeeds = 3;
  idxTrackerTag = -1;
  idxTrackerID = -2;
  TrackersExtraColumns = 2;

  // Filter idices
  fltAll      = 0;
  fltDown     = 1;
  fltDone     = 2;
  fltActive   = 3;
  fltInactive = 4;

  // Status images
  imgDown      = 9;
  imgSeed      = 10;
  imgDownError = 11;
  imgSeedError = 12;
  imgError     = 13;
  imgDone      = 14;
  imgStopped   = 15;
  imgDownQueue = 16;
  imgSeedQueue = 17;
  imgAll       = 19;
  imgActive    = 20;

  StatusFiltersCount = 5;

  TorrentFieldsMap: array[idxName..idxLastActive] of string =
    ('', 'totalSize', '', 'status', 'peersSendingToUs,seeders',
     'peersGettingFromUs,leechers,peersKnown', 'rateDownload', 'rateUpload', 'eta', 'uploadRatio',
     'downloadedEver', 'uploadedEver', '', '', 'addedDate', 'doneDate', 'activityDate');

implementation

uses
  AddTorrent, synacode, ConnOptions, clipbrd, DateUtils, utils, TorrProps, DaemonOptions, About,
  ToolWin, download, ColSetup, types, AddLink;

const
  TR_STATUS_CHECK_WAIT   = ( 1 shl 0 ); // Waiting in queue to check files
  TR_STATUS_CHECK        = ( 1 shl 1 ); // Checking files
  TR_STATUS_DOWNLOAD     = ( 1 shl 2 ); // Downloading
  TR_STATUS_SEED         = ( 1 shl 3 ); // Seeding
  TR_STATUS_STOPPED      = ( 1 shl 4 ); // Torrent is stopped
  TR_STATUS_FINISHED     = ( 1 shl 8 ); // Torrent is finished (pseudo status)

  TR_SPEEDLIMIT_GLOBAL    = 0;    // only follow the overall speed limit
  TR_SPEEDLIMIT_SINGLE    = 1;    // only follow the per-torrent limit
  TR_SPEEDLIMIT_UNLIMITED = 2;    // no limits at all

  TR_PRI_SKIP   = -1000;  // psedudo priority
  TR_PRI_LOW    = -1;
  TR_PRI_NORMAL =  0;
  TR_PRI_HIGH   =  1;

const
  SizeNames: array[1..5] of string = (sByte, sKByte, sMByte, sGByte, sTByte);

function GetHumanSize(sz: double; RoundTo: integer = 0): string;
var
  i: integer;
begin
  i:=Low(SizeNames);
  if RoundTo > 0 then begin
    Inc(i);
    sz:=sz/1024;
  end;
  while i <= High(SizeNames) do begin
    if sz < 1024 then
      break;
    sz:=sz/1024;
    Inc(i);
  end;
  if (RoundTo = 0) and (i > 3) then
    RoundTo:=i - 2;
  Result:=Format('%.' + IntToStr(RoundTo) + 'f %s', [sz, SizeNames[i]]);
end;

function AddToChannel(Clr: TColor; Value: integer; Position: byte): TColor;
var i: integer;

begin
     i:=(Clr shr (Position*8)) and $FF;
     i:=i + Value;
     if i < 0 then i:=0;
     if i > $FF then i:=$FF;
     Result:=Clr and (not (Cardinal($FF) shl (Position*8))) or (Cardinal(i) shl (Position*8));
end;

function AddToColor(Color: TColor; R, G, B: integer): TColor;
begin
     Result:=ColorToRGB(Color);
     Result:=AddToChannel(Result, R, 0);
     Result:=AddToChannel(Result, G, 1);
     Result:=AddToChannel(Result, B, 2);
end;

function GetLikeColor(Color: TColor; Delta: integer): TColor;
var i, j: integer;

begin
    Result:=ColorToRGB(Color);
    j:=Result and $FF;               //red
    i:=(Result shr 8) and $FF;       // green
    if i > j then
      j:=i;
    i:=((Result shr 16) and $FF) shr 1;      // blue
    if i > j then
      j:=i;
    if j < $80 then
      i:=(($80 - j) div $20 + 1)*Delta
    else
      i:=Delta;
    if (i + j > 255) or (i + j < 0) then
      i:=-Delta;

    Result:=AddToColor(Result, i, i, i);
end;

function LocateFile(const FileName: string; const Paths: array of string): string;
var
  i: integer;
begin
  for i:=Low(Paths) to High(Paths) do begin
    Result:=IncludeTrailingPathDelimiter(Paths[i]) + FileName;
    if FileExists(Result) then
      exit;
  end;
  Result:='';
end;

procedure OnTranslate(Sender: TResTranslator; const ResourceName: AnsiString; var Accept: boolean);
const
  IgnoreUnits: array[0..10] of string =
      ('fpjson','jsonparser','jsonscanner','lclstrconsts','math',
       'rtlconsts','sysconst','variants','zbase','zipper','zstream');

  IgnoreControls: array[0..2] of string =
    ('AboutForm.txAuthor', 'AboutForm.txHomePage', 'MainForm.miLn');

var
  i: integer;
begin
  Accept := not AnsiMatchText(Copy2Symb(ResourceName, '.'), IgnoreUnits)
             or AnsiStartsText('lclstrconsts.rsMb', ResourceName)  //<-- dialog buttons
             or AnsiStartsText('lclstrconsts.rsMt', ResourceName); //<-- dialog message
  if Accept then
    for i:=Low(IgnoreControls) to High(IgnoreControls) do
      if AnsiStartsText(IgnoreControls[i], ResourceName) then begin
        Accept:=False;
        exit;
      end;
end;

var
  FHomeDir: string;
  FIPCFileName: string;
  FRunFileName: string;

procedure AddTorrentFile(const FileName: string);
var
  h: THandle;
begin
  if FileExistsUTF8(FileName) then begin
    h:=FileCreate(FIPCFileName, fmCreate);
    if h <> THandle(-1) then begin
      FileWrite(h, FileName[1], Length(FileName));
      FileClose(h);
    end;
  end;
end;

procedure LoadTranslation;
var
  aIni: TIniFile;
begin
  aIni:=TIniFile.Create(FHomeDir + ChangeFileExt(ExtractFileName(ParamStr(0)), '.ini'));
  try
    FTranslationFileName := aIni.ReadString('Interface', 'TranslationFile', '');
    if FTranslationFileName = '' then
      FTranslationLanguage := LoadDefaultTranslationFile(@OnTranslate)
    else
      if FTranslationFileName <> '-' then
        FTranslationLanguage := LoadTranslationFile(DefaultLangDir + FTranslationFileName, @OnTranslate);
    if FTranslationLanguage = '' then
      FTranslationLanguage := 'English'
  finally
    aIni.Free;
  end;
end;

function CheckAppParams: boolean;
var
  i: integer;
begin
  Application.Title:=AppName;
  if FileExists(ChangeFileExt(ParamStr(0), '.ini')) then
    FHomeDir:=ExtractFilePath(ParamStr(0)) // Portable mode
  else begin
    FHomeDir:=IncludeTrailingPathDelimiter(GetAppConfigDir(False));
    ForceDirectories(FHomeDir);
  end;
  FIPCFileName:=FHomeDir + 'ipc.txt';
  FRunFileName:=FHomeDir + 'run';

  if ParamCount > 0 then
    AddTorrentFile(ParamStrUTF8(1));

  if FileExists(FRunFileName) then begin
    if not FileExists(FIPCFileName) then
      FileClose(FileCreate(FIPCFileName, fmCreate));
    for i:=1 to 10 do
      if not FileExists(FIPCFileName) then begin
        Result:=False;
        exit;
      end
      else
        Sleep(200);
  end
  else
    FileClose(FileCreate(FRunFileName, fmCreate));

  LoadTranslation;

  SizeNames[1]:=sByte;
  SizeNames[2]:=sKByte;
  SizeNames[3]:=sMByte;
  SizeNames[4]:=sGByte;
  SizeNames[5]:=sTByte;

  Result:=True;
end;

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
var
  ws: TWindowState;
{$ifdef darwin}
  s: string;
  pic: TPicture;
{$endif darwin}
begin
{$ifdef darwin}
  // Load better icon if possible
  s:=ExtractFilePath(ParamStr(0)) + '..' + DirectorySeparator + 'Resources'
     + DirectorySeparator + ChangeFileExt(ExtractFileName(ParamStr(0)), '.icns');
  if FileExists(s) then begin
    pic:=TPicture.Create;
    try
      pic.LoadFromFile(s);
      try
        Application.Icon.Assign(pic.Graphic);
      except
      end;
    finally
      pic.Free;
    end;
  end;
{$endif darwin}
  Application.Title:=AppName;
  Caption:=Application.Title;
  TrayIcon.Icon.Assign(Application.Icon);
  RpcObj:=TRpc.Create;
  FTorrents:=TVarList.Create(gTorrents.Columns.Count, 0);
  FTorrents.ExtraColumns:=TorrentsExtraColumns;
  gTorrents.Items.ExtraColumns:=TorrentsExtraColumns;
  lvFiles.Items.ExtraColumns:=FilesExtraColumns;
  FFiles:=lvFiles.Items;
  lvPeers.Items.ExtraColumns:=PeersExtraColumns;
  lvTrackers.Items.ExtraColumns:=TrackersExtraColumns;
  FIni:=TIniFile.Create(FHomeDir+ChangeFileExt(ExtractFileName(ParamStr(0)), '.ini'));
  FTrackers:=TStringList.Create;
  FReconnectTimeOut:=-1;
  FAlterColor:=GetLikeColor(gTorrents.Color, -$10);
  lvFilter.FixedRows:=0;
  gTorrents.AlternateColor:=FAlterColor;
  lvFiles.AlternateColor:=FAlterColor;
  lvPeers.AlternateColor:=FAlterColor;
  lvTrackers.AlternateColor:=FAlterColor;

  DoDisconnect;
  PageInfo.ActivePageIndex:=0;
  PageInfoChange(nil);
{$ifdef LCLgtk2}
  with MainToolBar do begin
    EdgeBorders:=[ebLeft, ebTop, ebRight, ebBottom];
    EdgeInner:=esNone;
    EdgeOuter:=esRaised;
    Flat:=True;
  end;
{$endif}
  txTransferHeader.Color:=GetLikeColor(clBtnFace, -15);
  txTorrentHeader.Color:=txTransferHeader.Color;
  txTransferHeader.Caption:=' ' + txTransferHeader.Caption;
  txTorrentHeader.Caption:=' ' + txTorrentHeader.Caption;

  if FIni.ReadInteger('MainForm', 'State', -1) = -1 then
    Position:=poScreenCenter
  else begin
    ws:=TWindowState(FIni.ReadInteger('MainForm', 'State', integer(WindowState)));
    Left:=FIni.ReadInteger('MainForm', 'Left', Left);
    Top:=FIni.ReadInteger('MainForm', 'Top', Top);
    Width:=FIni.ReadInteger('MainForm', 'Width', Width);
    Height:=FIni.ReadInteger('MainForm', 'Height', Height);
    if ws = wsMaximized then
      WindowState:=wsMaximized;
  end;

  LoadColumns(gTorrents, 'TorrentsList');
  TorrentColumnsChanged;
  LoadColumns(lvFiles, 'FilesList');
  LoadColumns(lvPeers, 'PeerList');
  LoadColumns(lvTrackers, 'TrackersList');

  acResolveHost.Checked:=FIni.ReadBool('PeersList', 'ResolveHost', True);
  acResolveCountry.Checked:=FIni.ReadBool('PeersList', 'ResolveCountry', True) and (GetGeoIpDatabase <> '');
  acShowCountryFlag.Checked:=FIni.ReadBool('PeersList', 'ShowCountryFlag', True) and (GetFlagsArchive <> '');
  acShowCountryFlag.Enabled:=acResolveCountry.Checked;
  FCurHost:=FIni.ReadString('Hosts', 'CurHost', '');
  if FCurHost = '' then
    FCurHost:=FIni.ReadString('Connection', 'Host', '');
  FPathMap:=TStringList.Create;
{$ifndef windows}
  miToggleApp.Visible:=False;
  miTSep1.Visible:=False;
{$endif windows}
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  DeleteFile(FRunFileName);
  FResolver.Free;
  FIni.Free;
  FTrackers.Free;
  FUnZip.Free;
  RpcObj.Free;
  FTorrentProgress.Free;
  FPathMap.Free;
  FTorrents.Free;
  if Application.HasOption('updatelang') then
    SupplementTranslationFiles;
  if Application.HasOption('makelang') then
    MakeTranslationFile;
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  if panReconnect.Visible then
    CenterReconnectWindow;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  if not FStarted then begin
    VSplitter.SetSplitterPosition(FIni.ReadInteger('MainForm', 'VSplitter', VSplitter.GetSplitterPosition));
    HSplitter.SetSplitterPosition(FIni.ReadInteger('MainForm', 'HSplitter', HSplitter.GetSplitterPosition));
    TickTimer.Enabled:=True;
  end;
  UpdateTray;
end;

procedure TMainForm.lvFilterCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  i: integer;
  R: TRect;
begin
  DefaultDraw:=Item.Data = nil;
  if DefaultDraw then exit;

  with lvFilter.Canvas do begin
    Brush.Color:=lvFilter.Color;
    R:=Item.DisplayRect(drBounds);
    FillRect(R);
    i:=(R.Bottom + R.Top) div 2;
    Brush.Color:=clBtnFace;
    FillRect(Rect(4, i - 1, Sender.ClientWidth - 4, i + 1));
  end;
end;

procedure TMainForm.lvFilterResize(Sender: TObject);
begin
  lvFilter.Columns[0].Width:=lvFilter.ClientWidth;
end;

procedure TMainForm.miAboutClick(Sender: TObject);
begin
  with TAboutForm.Create(Self) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TMainForm.miCopyLabelClick(Sender: TObject);
begin
  with TLabel(pmLabels.PopupComponent) do
    if (Length(Name) > 5) and (Copy(Name, Length(Name) - 4, 5) = 'Label') then
      Clipboard.AsText:=TLabel(Parent.FindChildControl(Copy(Name, 1, Length(Name) - 5))).Caption
    else
      Clipboard.AsText:=Caption;
end;

procedure TMainForm.acConnectExecute(Sender: TObject);
begin
  if RpcObj.Connected or (FCurHost = '') then
    ShowConnOptions
  else
    DoConnect;
end;

procedure TMainForm.acOpenContainingFolderExecute(Sender: TObject);
var
  i: integer;
begin
  if gTorrents.Items.Count = 0 then
    exit;
  i:=gTorrents.Row;
  if VarIsEmpty(gTorrents.Items[idxPath, i]) then
    exit;
  ExecRemoteFile(gTorrents.Items[idxPath, i]);
end;

procedure TMainForm.acOpenFileExecute(Sender: TObject);
begin
  if lvFiles.Items.Count = 0 then exit;
  ExecRemoteFile(FFiles[idxFileFullPath, lvFiles.Row]);
end;

procedure TMainForm.acOptionsExecute(Sender: TObject);
begin
  ShowConnOptions;
end;

procedure TMainForm.acAddTorrentExecute(Sender: TObject);
begin
  if not OpenTorrentDlg.Execute then exit;
  DoAddTorrent(OpenTorrentDlg.FileName);
end;

procedure TMainForm.acAddLinkExecute(Sender: TObject);
begin
  AppBusy;
  with TAddLinkForm.Create(Self) do
  try
    AppNormal;
    if ShowModal = mrOk then
      DoAddTorrent(edLink.Text);
  finally
    Free;
  end;
end;

procedure TMainForm.DoAddTorrent(const FileName: Utf8String);
var
  torrent: string;

  function _AddTorrent(args: TJSONObject): integer;
  var
    req: TJSONObject;
  begin
    Result:=0;
    req:=TJSONObject.Create;
    try
      req.Add('method', 'torrent-add');
      if torrent = '-' then
        args.Add('filename', TJSONString.Create(FileName))
      else
        args.Add('metainfo', TJSONString.Create(torrent));
      req.Add('arguments', args);
      args:=RpcObj.SendRequest(req);
      if args <> nil then
      try
        Result:=args.Objects['torrent-added'].Integers['id'];
      finally
        args.Free;
      end;
    finally
      req.Free;
    end;

    if Result = 0 then
      CheckStatus(False);
  end;

const
  Protocols: array [1..2] of string =
    ('http:', 'magnet:');

var
  req, res, args: TJSONObject;
  id: integer;
  t, files: TJSONArray;
  i, j: integer;
  fs: TFileStream;
  s, OldDownloadDir, IniSec, path: string;
  tt: TDateTime;
  ok: boolean;
begin
  AppBusy;
  id:=0;
  s:=AnsiLowerCase(FileName);
  for i:=Low(Protocols) to High(Protocols) do
    if Copy(s, 1, Length(Protocols[i])) = Protocols[i] then begin
      torrent:='-';
      break;
    end;

  if torrent <> '-' then begin
    fs:=TFileStream.Create(UTF8ToSys(FileName), fmOpenRead or fmShareDenyNone);
    try
      SetLength(torrent, fs.Size);
      fs.ReadBuffer(PChar(torrent)^, Length(torrent));
    finally
      fs.Free;
    end;
    torrent:=EncodeBase64(torrent);
  end;
  try
    with TAddTorrentForm.Create(Self) do
    try
      IniSec:='AddTorrent.' + RpcObj.Http.TargetHost;
      j:=FIni.ReadInteger(IniSec, 'FolderCount', 0);
      for i:=0 to j - 1 do begin
        s:=FIni.ReadString(IniSec, Format('Folder%d', [i]), '');
        if s <> '' then
          cbDestFolder.Items.Add(s);
      end;
      if cbDestFolder.Items.Count > 0 then
        cbDestFolder.ItemIndex:=0;

      if cbDestFolder.Text = '' then begin
        req:=TJSONObject.Create;
        try
          req.Add('method', 'session-get');
          args:=RpcObj.SendRequest(req);
          if args = nil then begin
            CheckStatus(False);
            exit;
          end;
          cbDestFolder.Items.Add(UTF8Encode(args.Strings['download-dir']));
          cbDestFolder.ItemIndex:=0;
          args.Free;
        finally
          req.Free;
        end;
      end;

      lvFilter.Row:=0;

      args:=TJSONObject.Create;
      args.Add('paused', TJSONIntegerNumber.Create(1));
      i:=FIni.ReadInteger(IniSec, 'PeerLimit', 0);
      if i <> 0 then
        args.Add('peer-limit', TJSONIntegerNumber.Create(i));
      args.Add('download-dir', TJSONString.Create(UTF8Decode(cbDestFolder.Text)));
      id:=_AddTorrent(args);
      if id = 0 then
        exit;

      DoRefresh(True);

      args:=RpcObj.RequestInfo(id, ['files', 'maxConnectedPeers']);
      if args = nil then begin
        CheckStatus(False);
        exit;
      end;
      try
        t:=args.Arrays['torrents'];
        if t.Count = 0 then
          raise Exception.Create(sUnableGetFilesList);
        edPeerLimit.Value:=t.Objects[0].Integers['maxConnectedPeers'];
        files:=t.Objects[0].Arrays['files'];
        path:=GetFilesCommonPath(files);
        lvFiles.Items.RowCnt:=files.Count;
        for i:=0 to files.Count - 1 do begin
          res:=files.Objects[i];
          s:=UTF8Encode(res.Strings['name']);
          if (path <> '') and (Copy(s, 1, Length(path)) = path) then
            s:=Copy(s, Length(path) + 1, MaxInt);
          lvFiles.Items[1, i]:=s;
          lvFiles.Items[2, i]:=res.Floats['length'];
          lvFiles.Items[-1, i]:=i;
        end;
      finally
        args.Free;
      end;

      OldDownloadDir:=cbDestFolder.Text;
      AppNormal;

      ok:=not FIni.ReadBool('Interface', 'ShowAddTorrentWindow', True);
      if ok then
        btSelectAllClick(nil)
      else
        ok:=ShowModal = mrOk;

      if ok then begin
        AppBusy;
        Self.Update;

        if OldDownloadDir <> cbDestFolder.Text then begin
          TorrentAction(VarArrayOf([id]), 'remove');
          id:=0;
          args:=TJSONObject.Create;
          args.Add('paused', TJSONIntegerNumber.Create(1));
          args.Add('peer-limit', TJSONIntegerNumber.Create(edPeerLimit.Value));
          args.Add('download-dir', TJSONString.Create(UTF8Decode(cbDestFolder.Text)));
          id:=_AddTorrent(args);
          if id = 0 then
            exit;
          DoRefresh(True);
          Application.ProcessMessages;
        end;

        req:=TJSONObject.Create;
        try
          req.Add('method', 'torrent-set');
          args:=TJSONObject.Create;
          args.Add('ids', TJSONArray.Create([id]));
          args.Add('peer-limit', TJSONIntegerNumber.Create(edPeerLimit.Value));

          files:=TJSONArray.Create;
          for i:=0 to lvFiles.Items.Count - 1 do
            if string(lvFiles.Items[0, i]) <> '0' then
              files.Add(integer(lvFiles.Items[-1, i]));
          if files.Count > 0 then
            args.Add('files-wanted', files)
          else
            files.Free;

          files:=TJSONArray.Create;
          for i:=0 to lvFiles.Items.Count - 1 do
            if string(lvFiles.Items[0, i]) = '0' then
              files.Add(integer(lvFiles.Items[-1, i]));
          if files.Count > 0 then
            args.Add('files-unwanted', files)
          else
            files.Free;

          req.Add('arguments', args);
          args:=nil;
          args:=RpcObj.SendRequest(req, False);
          if args = nil then begin
            CheckStatus(False);
            exit;
          end;
          args.Free;
        finally
          req.Free;
        end;

        if cbStartTorrent.Checked then
          TorrentAction(VarArrayOf([id]), 'start');

        tt:=Now;
        while (Now - tt < 2/SecsPerDay) and (id <> 0) do begin
          Application.ProcessMessages;
          i:=gTorrents.Items.IndexOf(idxTorrentId, id);
          if i >= 0 then begin
            gTorrents.Row:=i;
            RpcObj.CurTorrentId:=id;
            gTorrents.SetFocus;
            break;
          end;
          Sleep(100);
        end;

        id:=0;

        FIni.WriteInteger(IniSec, 'PeerLimit', edPeerLimit.Value);
        i:=cbDestFolder.Items.IndexOf(cbDestFolder.Text);
        if i >= 0 then
          cbDestFolder.Items.Move(i, 0)
        else
          cbDestFolder.Items.Insert(0, cbDestFolder.Text);
        i:=FIni.ReadInteger('Interface', 'MaxFoldersHistory', 10);
        while cbDestFolder.Items.Count > i do
          cbDestFolder.Items.Delete(cbDestFolder.Items.Count - 1);
        FIni.WriteInteger(IniSec, 'FolderCount', cbDestFolder.Items.Count);
        for i:=0 to cbDestFolder.Items.Count - 1 do
          FIni.WriteString(IniSec, Format('Folder%d', [i]), cbDestFolder.Items[i]);
        AppNormal;
      end;
    finally
      Free;
    end;
  finally
    if id <> 0 then
      TorrentAction(VarArrayOf([id]), 'remove');
  end;
end;

procedure TMainForm.UpdateTray;
begin
  TrayIcon.Visible:=not Self.Visible or (WindowState = wsMinimized) or FIni.ReadBool('Interface', 'TrayIconAlways', True);
  if Visible and (WindowState <> wsMinimized) then
    miToggleApp.Caption:=SHideApp
  else
    miToggleApp.Caption:=SShowApp;
end;

procedure TMainForm.HideApp;
begin
  if WindowState <> wsMinimized then
    Hide;
  HideTaskbarButton;
end;

procedure TMainForm.ShowApp;
begin
  ShowTaskbarButton;
  if WindowState = wsMinimized then
    Application.Restore;
  Show;
  Application.BringToFront;
  BringToFront;
end;

procedure TMainForm.DownloadFinished(const TorrentName: string);
begin
  if not TrayIcon.Visible then exit;
  TrayIcon.BalloonHint:=Format(sFinishedDownload, [TorrentName]);
  TrayIcon.BalloonTitle:=sDownloadComplete;
  TrayIcon.ShowBalloonHint;
end;

function TMainForm.GetFlagImage(const CountryCode: string): integer;
var
  s, FlagsPath, ImageName: string;
  pic: TPicture;
begin
  Result:=0;
  if CountryCode = '' then exit;
  try
    ImageName:=CountryCode + '.png';
    FlagsPath:=FHomeDir + 'flags' + DirectorySeparator;
    if not FileExists(FlagsPath + ImageName) then begin
      // Unzipping flag image
      if FUnZip = nil then begin
        s:=GetFlagsArchive;
        if s <> '' then begin
          ForceDirectories(FlagsPath);
          FUnZip:=TUnZipper.Create;
          FUnZip.OutputPath:=FlagsPath;
          FUnZip.FileName:=s;
        end
        else
          exit;
      end;

      FUnZip.Files.Clear;
      FUnZip.Files.Add(ImageName);
      try
        FUnZip.UnZipAllFiles;
      except
        FreeAndNil(FUnZip);
        DeleteFile(GetFlagsArchive);
        acShowCountryFlag.Checked:=False;
        MessageDlg(sUnableExtractFlag + LineEnding + Exception(ExceptObject).Message, mtError, [mbOK], 0);
        exit;
      end;
      if not FileExists(FlagsPath + ImageName) then exit;
    end;

    pic:=TPicture.Create;
    try
      pic.LoadFromFile(UTF8Encode(FlagsPath + ImageName));
      if imgFlags.Count = 1 then begin
        imgFlags.Width:=pic.Width;
        imgFlags.Height:=pic.Height;
      end;
      Result:=imgFlags.AddMasked(pic.Bitmap, clNone);
    finally
      pic.Free;
    end;
  except
  end;
end;

procedure TMainForm.BeforeCloseApp;
begin
  if WindowState = wsNormal then begin
    FIni.WriteInteger('MainForm', 'Left', Left);
    FIni.WriteInteger('MainForm', 'Top', Top);
    FIni.WriteInteger('MainForm', 'Width', Width);
    FIni.WriteInteger('MainForm', 'Height', Height);
  end;
  if WindowState <> wsMinimized then
    FIni.WriteInteger('MainForm', 'State', integer(WindowState));

  FIni.WriteInteger('MainForm', 'VSplitter', VSplitter.GetSplitterPosition);
  FIni.WriteInteger('MainForm', 'HSplitter', HSplitter.GetSplitterPosition);

  SaveColumns(gTorrents, 'TorrentsList');
  SaveColumns(lvFiles, 'FilesList');
  SaveColumns(lvPeers, 'PeerList');
  SaveColumns(lvTrackers, 'TrackersList');

  FIni.WriteBool('PeersList', 'ResolveHost', acResolveHost.Checked);
  FIni.WriteBool('PeersList', 'ResolveCountry', acResolveCountry.Checked);
  FIni.WriteBool('PeersList', 'ShowCountryFlag', acShowCountryFlag.Checked);

  DoDisconnect;
  Application.ProcessMessages;
end;

function TMainForm.GetGeoIpDatabase: string;
begin
  Result:=LocateFile('GeoIP.dat', [FHomeDir, ExtractFilePath(ParamStr(0))]);
end;

function TMainForm.GetFlagsArchive: string;
begin
  Result:=LocateFile('flags.zip', [FHomeDir, ExtractFilePath(ParamStr(0))]);
end;

function TMainForm.DownloadGeoIpDatabase(AUpdate: boolean): boolean;
const
  GeoLiteURL = 'http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz';
var
  tmp: string;
  gz: TGZFileStream;
  fs: TFileStream;
begin
  Result:=False;
  tmp:=FHomeDir + 'GeoIP.dat.gz';
  if not FileExists(tmp) or AUpdate then begin
    if MessageDlg('', sGeoIPConfirm, mtConfirmation, mbYesNo, 0, mbYes) <> mrYes then
      exit;
    if not DownloadFile(GeoLiteURL, ExtractFilePath(tmp), ExtractFileName(tmp)) then
      exit;
  end;
  try
    FreeAndNil(FResolver);
    gz:=TGZFileStream.Create(tmp, gzopenread);
    try
      fs:=TFileStream.Create(FHomeDir + 'GeoIP.dat', fmCreate);
      try
        while fs.CopyFrom(gz, 64*1024) = 64*1024 do
          ;
      finally
        fs.Free;
      end;
    finally
      gz.Free;
    end;
    DeleteFile(tmp);
  except
    DeleteFile(FHomeDir + 'GeoIP.dat');
    DeleteFile(tmp);
    raise;
  end;
  Result:=True;
end;

procedure TMainForm.TorrentColumnsChanged;
var
  i: integer;
  s: string;
begin
  FDoneColumnIdx:=-1;
  s:='';
  for i:=0 to gTorrents.Columns.Count - 1 do
    with gTorrents.Columns[i] do
      if Visible and (Width > 0) then begin
        if s <> '' then
          s:=s + ',';
        s:=s + TorrentFieldsMap[ID];
        if ID = idxDone then
          FDoneColumnIdx:=Index;
      end;
  RpcObj.TorrentFields:=s;
  DoRefresh(True);
end;

function TMainForm.EtaToString(ETA: integer): string;
begin
  if ETA = -1 then
    Result:=''
  else
  if ETA = -2 then
    Result:=''
  else
    Result:=SecondsToString(ETA);
end;

function TMainForm.GetTorrentStatus(TorrentIdx: integer): string;
begin
  case integer(gTorrents.Items[idxStatus, TorrentIdx]) of
    TR_STATUS_CHECK_WAIT:
      Result:=sWaiting;
    TR_STATUS_CHECK:
      Result:=sVerifying;
    TR_STATUS_DOWNLOAD:
      Result:=sDownloading;
    TR_STATUS_SEED:
      Result:=sSeeding;
    TR_STATUS_STOPPED:
      Result:=sStopped;
    TR_STATUS_FINISHED:
      Result:=sFinished;
    else
      Result:=sUnknown;
  end;
end;

function TMainForm.GetSeedsText(Seeds, SeedsTotal: integer): string;
begin
  if SeedsTotal <> -1 then
    Result:=Format('%d/%d', [Seeds, SeedsTotal])
  else
    Result:=Format('%d', [Seeds]);
end;

function TMainForm.GetPeersText(Peers, PeersTotal, Leechers: integer): string;
begin
  Result:=Format('%d', [Peers]);
  if Leechers <> -1 then
    Result:=Format('%s/%d', [Result, Leechers]);
  Dec(PeersTotal);
  if PeersTotal >= 0 then
    Result:=Format('%s (%d)', [Result, PeersTotal]);
end;

function TMainForm.RatioToString(Ratio: double): string;
begin
  if (Ratio = MaxInt) or (Ratio = -2) then
    Result:=Utf8Encode(WideString(WideChar($221E)))
  else
    if Ratio = -1 then
      Result:=''
    else
      Result:=Format('%.3f', [Ratio]);
end;

function TMainForm.TorrentDateTimeToString(d: Int64): string;
begin
  if d = 0 then
    Result:=''
  else
    Result:=DateTimeToStr(UnixToDateTime(d) + GetTimeZoneDelta);
end;

procedure TMainForm.DoRefresh(All: boolean);
begin
  if All then
    RpcObj.RefreshNow:=rtAll
  else
    if RpcObj.RefreshNow <> rtAll then
      RpcObj.RefreshNow:=rtDetails;
end;

procedure TMainForm.acDisconnectExecute(Sender: TObject);
begin
  DoDisconnect;
end;

procedure TMainForm.acExitExecute(Sender: TObject);
begin
  BeforeCloseApp;
  Application.Terminate;
end;

procedure TMainForm.acDaemonOptionsExecute(Sender: TObject);
var
  req, args: TJSONObject;
  s: string;
begin
  with TDaemonOptionsForm.Create(Self) do
  try
    AppBusy;
    req:=TJSONObject.Create;
    try
      req.Add('method', 'session-get');
      args:=RpcObj.SendRequest(req);
      if args <> nil then
        try
          edDownloadDir.Text:=UTF8Encode(args.Strings['download-dir']);
          if RpcObj.RPCVersion >= 5 then begin
            // RPC version 5
            edPort.Value:=args.Integers['peer-port'];
            cbPEX.Checked:=args.Integers['pex-enabled'] <> 0;
            edMaxPeers.Value:=args.Integers['peer-limit-global'];
            cbRandomPort.Checked:=args.Integers['peer-port-random-on-start'] <> 0;
            cbDHT.Checked:=args.Integers['dht-enabled'] <> 0;
            cbSeedRatio.Checked:=args.Integers['seedRatioLimited'] <> 0;
            edSeedRatio.Value:=args.Floats['seedRatioLimit'];
          end
          else begin
            // RPC versions prior to v5
            edPort.Value:=args.Integers['port'];
            cbPEX.Checked:=args.Integers['pex-allowed'] <> 0;
            edMaxPeers.Value:=args.Integers['peer-limit'];
            cbRandomPort.Enabled:=False;
            cbDHT.Enabled:=False;
            cbSeedRatio.Enabled:=False;
            edSeedRatio.Enabled:=False;
            btTestPort.Enabled:=False;
          end;

          cbPortForwarding.Checked:=args.Integers['port-forwarding-enabled'] <> 0;

          s:=args.Strings['encryption'];
          if s = 'preferred' then
            cbEncryption.ItemIndex:=1
          else
          if s = 'required' then
            cbEncryption.ItemIndex:=2
          else
            cbEncryption.ItemIndex:=0;

          cbMaxDown.Checked:=args.Integers['speed-limit-down-enabled'] <> 0;
          edMaxDown.Value:=args.Integers['speed-limit-down'];
          cbMaxUp.Checked:=args.Integers['speed-limit-up-enabled'] <> 0;
          edMaxUp.Value:=args.Integers['speed-limit-up'];
        finally
          args.Free;
        end
      else begin
        CheckStatus(False);
        exit;
      end;
    finally
      req.Free;
    end;
    cbMaxDownClick(nil);
    cbMaxUpClick(nil);
    cbRandomPortClick(nil);
    cbSeedRatioClick(nil);
    AppNormal;

    if ShowModal = mrOK then begin
      AppBusy;
      Self.Update;
      req:=TJSONObject.Create;
      try
        req.Add('method', 'session-set');
        args:=TJSONObject.Create;
        args.Add('download-dir', TJSONString.Create(UTF8Decode(edDownloadDir.Text)));
        args.Add('port-forwarding-enabled', TJSONIntegerNumber.Create(integer(cbPortForwarding.Checked) and 1));
        case cbEncryption.ItemIndex of
          1: s:='preferred';
          2: s:='required';
          else s:='tolerated';
        end;
        args.Add('encryption', TJSONString.Create(s));
        args.Add('speed-limit-down-enabled', TJSONIntegerNumber.Create(integer(cbMaxDown.Checked) and 1));
        if cbMaxDown.Checked then
          args.Add('speed-limit-down', TJSONIntegerNumber.Create(edMaxDown.Value));
        args.Add('speed-limit-up-enabled', TJSONIntegerNumber.Create(integer(cbMaxUp.Checked) and 1));
        if cbMaxUp.Checked then
          args.Add('speed-limit-up', TJSONIntegerNumber.Create(edMaxUp.Value));
        if RpcObj.RPCVersion >= 5 then begin
          args.Add('peer-limit-global', TJSONIntegerNumber.Create(edMaxPeers.Value));
          args.Add('peer-port', TJSONIntegerNumber.Create(edPort.Value));
          args.Add('pex-enabled', TJSONIntegerNumber.Create(integer(cbPEX.Checked) and 1));
          args.Add('peer-port-random-on-start', TJSONIntegerNumber.Create(integer(cbRandomPort.Checked) and 1));
          args.Add('dht-enabled', TJSONIntegerNumber.Create(integer(cbDHT.Checked) and 1));
          args.Add('seedRatioLimited', TJSONIntegerNumber.Create(integer(cbSeedRatio.Checked) and 1));
          args.Add('seedRatioLimit', TJSONFloatNumber.Create(edSeedRatio.Value));
        end
        else begin
          args.Add('peer-limit', TJSONIntegerNumber.Create(edMaxPeers.Value));
          args.Add('port', TJSONIntegerNumber.Create(edPort.Value));
          args.Add('pex-allowed', TJSONIntegerNumber.Create(integer(cbPEX.Checked) and 1));
        end;
        req.Add('arguments', args);
        args:=RpcObj.SendRequest(req, False);
        if args = nil then begin
          CheckStatus(False);
          exit;
        end;
        args.Free;
      finally
        req.Free;
      end;
      AppNormal;
    end;
  finally
    Free;
  end;
end;

procedure TMainForm.acReannounceTorrentExecute(Sender: TObject);
begin
  TorrentAction(GetSelectedTorrents, 'reannounce');
end;

procedure TMainForm.acRemoveTorrentAndDataExecute(Sender: TObject);
begin
  InternalRemoveTorrent(sRemoveTorrentData, sRemoveTorrentDataMulti, True);
end;

procedure TMainForm.acRemoveTorrentExecute(Sender: TObject);
begin
  InternalRemoveTorrent(sRemoveTorrent, sRemoveTorrentMulti, False);
end;

procedure TMainForm.acResolveCountryExecute(Sender: TObject);
begin
  if not acResolveCountry.Checked then
    if GetGeoIpDatabase = '' then
      if not DownloadGeoIpDatabase(False) then
        exit;

  acResolveCountry.Checked:=not acResolveCountry.Checked;
  FreeAndNil(FResolver);
  DoRefresh;
  acShowCountryFlag.Enabled:=acResolveCountry.Checked;
end;

procedure TMainForm.acResolveHostExecute(Sender: TObject);
begin
  acResolveHost.Checked:=not acResolveHost.Checked;
  FreeAndNil(FResolver);
  DoRefresh;
end;

procedure TMainForm.acSetHighPriorityExecute(Sender: TObject);
begin
  SetCurrentFilePriority('high');
end;

procedure TMainForm.acSetLowPriorityExecute(Sender: TObject);
begin
  SetCurrentFilePriority('low');
end;

procedure TMainForm.acSetNormalPriorityExecute(Sender: TObject);
begin
  SetCurrentFilePriority('normal');
end;

procedure TMainForm.acSetNotDownloadExecute(Sender: TObject);
begin
  SetCurrentFilePriority('skip');
end;

procedure TMainForm.acSetupColumnsExecute(Sender: TObject);
var
  g: TVarGrid;
  s: string;
begin
  Application.ProcessMessages;
  if lvTrackers.Focused then
    g:=lvTrackers
  else
  if lvPeers.Focused then
    g:=lvPeers
  else
  if lvFiles.Focused then
    g:=lvFiles
  else
    g:=gTorrents;
  if g = gTorrents then
    s:=sTorrents
  else
    s:=PageInfo.ActivePage.Caption;
  if not SetupColumns(g, 0, s) then exit;
  if g = gTorrents then
    TorrentColumnsChanged;
end;

procedure TMainForm.acShowCountryFlagExecute(Sender: TObject);
const
  FlagsURL = 'http://transmisson-remote-gui.googlecode.com/files/flags.zip';
begin
  if not acShowCountryFlag.Checked then
    if GetFlagsArchive = '' then begin
      if MessageDlg('', sFlagArchiveConfirm, mtConfirmation, mbYesNo, 0, mbYes) <> mrYes then
        exit;
      if not DownloadFile(FlagsURL, FHomeDir) then
        exit;
    end;
  acShowCountryFlag.Checked:=not acShowCountryFlag.Checked;
  DoRefresh;
end;

procedure TMainForm.acStartAllTorrentsExecute(Sender: TObject);
begin
  TorrentAction(NULL, 'start');
end;

procedure TMainForm.acStartTorrentExecute(Sender: TObject);
begin
  if gTorrents.Items.Count = 0 then exit;
  TorrentAction(GetSelectedTorrents, 'start');
end;

procedure TMainForm.acStopAllTorrentsExecute(Sender: TObject);
begin
  TorrentAction(NULL, 'stop');
end;

procedure TMainForm.acStopTorrentExecute(Sender: TObject);
begin
  if gTorrents.Items.Count = 0 then exit;
  TorrentAction(GetSelectedTorrents, 'stop');
end;

procedure TMainForm.acTorrentPropsExecute(Sender: TObject);
var
  req, args, t: TJSONObject;
  i, j, id: integer;
begin
  gTorrents.RemoveSelection;
  gTorrentsClick(nil);
  id:=RpcObj.CurTorrentId;
  if id = 0 then exit;
  AppBusy;
  with TTorrPropsForm.Create(Self) do
  try
    args:=RpcObj.RequestInfo(id, ['downloadLimit', 'downloadLimitMode', 'downloadLimited',
                                  'uploadLimit', 'uploadLimitMode', 'uploadLimited',
                                  'name', 'maxConnectedPeers']);
    if args = nil then begin
      CheckStatus(False);
      exit;
    end;
    try
      t:=args.Arrays['torrents'].Objects[0];

      txName.Caption:=txName.Caption + ' ' + UTF8Encode(t.Strings['name']);
      if RpcObj.RPCVersion<5 then
      begin
        // RPC versions prior to v5
        j:=t.Integers['downloadLimitMode'];
        cbMaxDown.Checked:=j = TR_SPEEDLIMIT_SINGLE;
        i:=t.Integers['downloadLimit'];
        if (i < 0) or (j = TR_SPEEDLIMIT_UNLIMITED) then
          edMaxDown.ValueEmpty:=True
        else
          edMaxDown.Value:=i;

        j:=t.Integers['uploadLimitMode'];
        cbMaxUp.Checked:=j = TR_SPEEDLIMIT_SINGLE;
        i:=t.Integers['uploadLimit'];
        if (i < 0) or (j = TR_SPEEDLIMIT_UNLIMITED) then
          edMaxUp.ValueEmpty:=True
        else
          edMaxUp.Value:=i;
      end else begin
        // RPC version 5
        cbMaxDown.Checked:=t.Booleans['downloadLimited'];
        i:=t.Integers['downloadLimit'];
        if i < 0 then
          edMaxDown.ValueEmpty:=True
        else
          edMaxDown.Value:=i;

        cbMaxUp.Checked:=t.Booleans['uploadLimited'];
        i:=t.Integers['uploadLimit'];
        if i < 0 then
          edMaxUp.ValueEmpty:=True
        else
          edMaxUp.Value:=i;
      end;
      edPeerLimit.Value:=t.Integers['maxConnectedPeers'];
    finally
      args.Free;
    end;
    cbMaxDownClick(nil);
    cbMaxUpClick(nil);
    AppNormal;
    if ShowModal = mrOk then begin
      AppBusy;
      Self.Update;
      req:=TJSONObject.Create;
      try
        req.Add('method', 'torrent-set');
        args:=TJSONObject.Create;
        args.Add('ids', TJSONArray.Create([id]));

        if RpcObj.RPCVersion < 5 then
        begin
          // RPC versions prior to v5
          args.Add('speed-limit-down-enabled', TJSONIntegerNumber.Create(integer(cbMaxDown.Checked) and 1));
          args.Add('speed-limit-up-enabled', TJSONIntegerNumber.Create(integer(cbMaxUp.Checked) and 1));
          if cbMaxDown.Checked then
            args.Add('speed-limit-down', TJSONIntegerNumber.Create(edMaxDown.Value));
          if cbMaxUp.Checked then
            args.Add('speed-limit-up', TJSONIntegerNumber.Create(edMaxUp.Value));
        end else begin
          // RPC version 5
          args.Add('downloadLimited', TJSONIntegerNumber.Create(integer(cbMaxDown.Checked) and 1));
          args.Add('uploadLimited', TJSONIntegerNumber.Create(integer(cbMaxUp.Checked) and 1));
          if cbMaxDown.Checked then
            args.Add('downloadLimit', TJSONIntegerNumber.Create(edMaxDown.Value));
          if cbMaxUp.Checked then
            args.Add('uploadLimit', TJSONIntegerNumber.Create(edMaxUp.Value));
        end;
        args.Add('peer-limit', TJSONIntegerNumber.Create(edPeerLimit.Value));
        req.Add('arguments', args);
        args:=nil;
        args:=RpcObj.SendRequest(req, False);
        if args = nil then begin
          CheckStatus(False);
          exit;
        end;
        args.Free;
      finally
        req.Free;
      end;
      DoRefresh;
      AppNormal;
    end;
  finally
    Free;
  end;
end;

procedure TMainForm.acUpdateGeoIPExecute(Sender: TObject);
begin
  if DownloadGeoIpDatabase(True) then
    MessageDlg(sUpdateComplete, mtInformation, [mbOK], 0);
end;

procedure TMainForm.acVerifyTorrentExecute(Sender: TObject);
var
  id: integer;
begin
  if gTorrents.Items.Count = 0 then exit;
  gTorrents.RemoveSelection;
  id:=gTorrents.Items[idxTorrentId, gTorrents.Row];
  if MessageDlg('', Format(sTorrentVerification, [UTF8Encode(widestring(gTorrents.Items[idxName, gTorrents.Row]))]), mtConfirmation, mbYesNo, 0, mbNo) <> mrYes then exit;
  TorrentAction(VarArrayOf([id]), 'verify');
end;

procedure TMainForm.ApplicationPropertiesException(Sender: TObject; E: Exception);
begin
  ForceAppNormal;
  MessageDlg(E.Message, mtError, [mbOK], 0);
end;

procedure TMainForm.ApplicationPropertiesIdle(Sender: TObject; var Done: Boolean);
begin
  UpdateUI;
{$ifdef LCLcarbon}
  CheckSynchronize;
{$endif LCLcarbon}
  Done:=True;
end;

procedure TMainForm.ApplicationPropertiesMinimize(Sender: TObject);
begin
{$ifdef windows}
  if FIni.ReadBool('Interface', 'TrayMinimize', True) then
    HideApp;
{$endif windows}
  UpdateTray;
end;

procedure TMainForm.ApplicationPropertiesRestore(Sender: TObject);
begin
  UpdateTray;
end;

procedure TMainForm.edSearchChange(Sender: TObject);
begin
  DoRefresh(True);
end;

procedure TMainForm.FormDropFiles(Sender: TObject; const FileNames: array of String);
begin
  AddTorrentFile(FileNames[0]);
end;

procedure TMainForm.gTorrentsCellAttributes(Sender: TVarGrid; ACol, ARow, ADataCol: integer; AState: TGridDrawState;
                                            var CellAttribs: TCellAttributes);
var
  j: integer;
begin
  if ARow < 0 then exit;
  with CellAttribs do begin
    if ACol = 0 then
      ImageIndex:=integer(Sender.Items[idxStateImg, ARow]);
    if Text = '' then exit;
    case ADataCol of
      idxStatus:
        Text:=GetTorrentStatus(ARow);
      idxSize, idxDownloaded, idxUploaded:
        Text:=GetHumanSize(Sender.Items[ADataCol, ARow]);
      idxDone:
        Text:=Format('%.1f%%', [double(Sender.Items[idxDone, ARow])]);
      idxSeeds:
        if not VarIsNull(Sender.Items[idxSeedsTotal, ARow]) then
          Text:=GetSeedsText(Sender.Items[idxSeeds, ARow], Sender.Items[idxSeedsTotal, ARow]);
      idxPeers:
        Text:=GetPeersText(Sender.Items[idxPeers, ARow], Sender.Items[idxPeersTotal, ARow], Sender.Items[idxLeechers, ARow]);
      idxDownSpeed, idxUpSpeed:
        begin
          j:=Sender.Items[ADataCol, ARow];
          if j > 0 then
            Text:=GetHumanSize(j, 1) + sPerSecond
          else
            Text:='';
        end;
      idxETA:
        Text:=EtaToString(Sender.Items[idxETA, ARow]);
      idxRatio:
        Text:=RatioToString(Sender.Items[idxRatio, ARow]);
      idxAddedOn, idxCompletedOn, idxLastActive:
        Text:=TorrentDateTimeToString(Sender.Items[ADataCol, ARow]);
    end;
  end;
end;

procedure TMainForm.gTorrentsClick(Sender: TObject);
var
  i: integer;
begin
  RpcObj.Lock;
  try
    if gTorrents.Items.Count > 0 then
      i:=gTorrents.Items[idxTorrentId, gTorrents.Row]
    else
      i:=0;
    if RpcObj.CurTorrentId = i then
      exit;
    RpcObj.CurTorrentId:=i;
  finally
    RpcObj.Unlock;
  end;

  ClearDetailsInfo;

  TorrentsListTimer.Enabled:=False;
  TorrentsListTimer.Enabled:=True;
end;

procedure TMainForm.gTorrentsDblClick(Sender: TObject);
begin
  acTorrentProps.Execute;
end;

procedure TMainForm.gTorrentsDrawCell(Sender: TVarGrid; ACol, ARow, ADataCol: integer; AState: TGridDrawState; const R: TRect; var ADefaultDrawing: boolean);
begin
  if ARow < 0 then exit;
  if ADataCol = idxDone then begin
    ADefaultDrawing:=False;
    DrawProgressCell(Sender, ACol, ARow, ADataCol, AState, R);
  end;
end;

procedure TMainForm.gTorrentsResize(Sender: TObject);
begin
  if not FStarted then begin
    VSplitter.SetSplitterPosition(FIni.ReadInteger('MainForm', 'VSplitter', VSplitter.GetSplitterPosition));
    HSplitter.SetSplitterPosition(FIni.ReadInteger('MainForm', 'HSplitter', HSplitter.GetSplitterPosition));
  end;
end;

procedure TMainForm.gTorrentsSortColumn(Sender: TVarGrid; var ASortCol: integer);
begin
  if ASortCol = idxSeeds then
    ASortCol:=idxSeedsTotal;
  if ASortCol = idxPeers then
    ASortCol:=idxPeersTotal;
end;

procedure TMainForm.lvFilesCellAttributes(Sender: TVarGrid; ACol, ARow, ADataCol: integer; AState: TGridDrawState; var CellAttribs: TCellAttributes);
begin
  if ARow < 0 then exit;
  with CellAttribs do begin
    if Text = '' then exit;
    case ADataCol of
      idxFilePriority:
        case integer(FFiles[idxFilePriority, ARow]) of
          TR_PRI_SKIP:   Text:=sSkip;
          TR_PRI_LOW:    Text:=sLow;
          TR_PRI_NORMAL: Text:=sNormal;
          TR_PRI_HIGH:   Text:=sHigh;
          else           Text:='???';
        end;
      idxFileSize, idxFileDone:
        Text:=GetHumanSize(FFiles[ADataCol, ARow]);
      idxFileProgress:
        Text:=Format('%.1f%%', [double(FFiles[ADataCol, ARow])]);
    end;
  end;
end;

procedure TMainForm.lvFilesDblClick(Sender: TObject);
begin
  acOpenFile.Execute;
end;

procedure TMainForm.lvFilesDrawCell(Sender: TVarGrid; ACol, ARow, ADataCol: integer; AState: TGridDrawState; const R: TRect;
  var ADefaultDrawing: boolean);
begin
  if ARow < 0 then exit;
  if ADataCol = idxFileProgress then begin
    ADefaultDrawing:=False;
    DrawProgressCell(Sender, ACol, ARow, ADataCol, AState, R);
  end;
end;

procedure TMainForm.lvFilesKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
    acOpenFile.Execute;
end;

procedure TMainForm.lvFilterCellAttributes(Sender: TVarGrid; ACol, ARow, ADataCol: integer; AState: TGridDrawState; var CellAttribs: TCellAttributes);
begin
  if ARow < 0 then exit;
  with CellAttribs do begin
    case ARow of
      0: ImageIndex:=imgAll;
      1: ImageIndex:=imgDown;
      2: ImageIndex:=imgSeed;
      3: ImageIndex:=imgActive;
      4: ImageIndex:=imgStopped;
      else
        if Text <> '' then
          ImageIndex:=5;
    end;
  end;
end;

procedure TMainForm.lvFilterClick(Sender: TObject);
begin
  if VarIsNull(lvFilter.Items[0, lvFilter.Row]) then
    lvFilter.Row:=lvFilter.Row - 1;
  FilterTimer.Enabled:=False;
  FilterTimer.Enabled:=True;
end;

procedure TMainForm.lvPeersCellAttributes(Sender: TVarGrid; ACol, ARow, ADataCol: integer; AState: TGridDrawState; var CellAttribs: TCellAttributes);
var
  i: integer;
begin
  if ARow < 0 then exit;
  with CellAttribs do begin
    if Text = '' then exit;
    if ACol = 0 then begin
      ImageIndex:=Sender.Items[idxPeerCountryImage, ARow];
      if ImageIndex = 0 then
        ImageIndex:=-1;
    end;
    case ADataCol of
      idxPeerDone:
        Text:=Format('%.1f%%', [double(Sender.Items[ADataCol, ARow])*100.0]);
      idxPeerDownSpeed, idxPeerUpSpeed:
        begin
          i:=Sender.Items[ADataCol, ARow];
          if i > 0 then
            Text:=GetHumanSize(i, 1) + sPerSecond
          else
            Text:='';
        end;
    end;
  end;
end;

procedure TMainForm.lvTrackersCellAttributes(Sender: TVarGrid; ACol, ARow, ADataCol: integer; AState: TGridDrawState; var CellAttribs: TCellAttributes);
var
  f: double;
begin
  if ARow < 0 then exit;
  with CellAttribs do begin
    if Text = '' then exit;
    case ADataCol of
      idxTrackersListSeeds:
        if lvTrackers.Items[ADataCol, ARow] < 0 then
          Text:='';
      idxTrackersListUpdateIn:
        begin
          f:=double(lvTrackers.Items[ADataCol, ARow]);
          if f = 0 then
            Text:='-'
          else
          if f = 1 then
            Text:=sUpdating
          else
            Text:=SecondsToString(Trunc(f));
        end;
    end;
  end;
end;

procedure TMainForm.panReconnectResize(Sender: TObject);
begin
  panReconnectFrame.BoundsRect:=panReconnect.ClientRect;
end;

procedure TMainForm.pbDownloadedPaint(Sender: TObject);
begin
  if FTorrentProgress <> nil then
    pbDownloaded.Canvas.StretchDraw(pbDownloaded.ClientRect, FTorrentProgress);
end;

procedure TMainForm.pbDownloadedResize(Sender: TObject);
begin
  ProcessPieces(FLastPieces, FLastPieceCount, FLastDone);
end;

{$ifdef LCLcarbon}
type
  THackApplication = class(TApplication)
  end;
{$endif LCLcarbon}

procedure TMainForm.TickTimerTimer(Sender: TObject);
var
  s: string;
begin
  TickTimer.Enabled:=False;
  try
    if not FStarted then begin
      Application.ProcessMessages;
      FStarted:=True;
      acConnect.Execute;
      Application.ProcessMessages;
      panTransfer.ChildSizing.Layout:=cclLeftToRightThenTopToBottom;
      panGeneralInfo.ChildSizing.Layout:=cclLeftToRightThenTopToBottom;
      panTransfer.ChildSizing.Layout:=cclNone;
      panGeneralInfo.ChildSizing.Layout:=cclNone;
      with panTransfer do
        ClientHeight:=Controls[ControlCount - 1].BoundsRect.Bottom + ChildSizing.TopBottomSpacing;
      with panGeneralInfo do
        ClientHeight:=Controls[ControlCount - 1].BoundsRect.Bottom + ChildSizing.TopBottomSpacing;

      if FIni.ReadBool('MainForm', 'FirstRun', True) then begin
        if not acResolveCountry.Checked then
          acResolveCountry.Execute;
        if acResolveCountry.Checked and not acShowCountryFlag.Checked then
          acShowCountryFlag.Execute;
        FIni.WriteBool('MainForm', 'FirstRun', False);
      end;
      panSearch.AutoSize:=False;
    end;

    if FileExists(FIPCFileName) then begin
      s:=ReadFileToString(UTF8Encode(FIPCFileName));
      DeleteFile(FIPCFileName);
      ShowApp;

      if s = '' then
        exit;

      if FileExistsUTF8(s) then begin
        TickTimer.Enabled:=True;
        DoAddTorrent(s);
      end;
    end;

    if RpcObj.Connected then
      FReconnectTimeOut:=0
    else
      if panReconnect.Visible then
        if Now - FReconnectWaitStart >= FReconnectTimeOut/SecsPerDay then
          DoConnect
        else
          txReconnectSecs.Caption:=Format(sReconnect, [FReconnectTimeOut - Round(SecsPerDay*(Now - FReconnectWaitStart))]);
{$ifdef LCLcarbon}
     THackApplication(Application).ProcessAsyncCallQueue;
{$endif LCLcarbon}
  finally
    TickTimer.Enabled:=True;
  end;
end;

procedure TMainForm.FilterTimerTimer(Sender: TObject);
begin
  FilterTimer.Enabled:=False;
  DoRefresh(True);
end;

procedure TMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
{$ifdef mswindows}
  if FIni.ReadBool('Interface', 'TrayClose', False) then begin
    CloseAction:=caHide;
    HideApp;
    UpdateTray;
    exit;
  end;
{$endif mswindows}
  BeforeCloseApp;
end;

procedure TMainForm.miToggleAppClick(Sender: TObject);
begin
  if miToggleApp.Caption = SHideApp then
    HideApp
  else
    ShowApp;
  UpdateTray;
end;

procedure TMainForm.PageInfoChange(Sender: TObject);
begin
  RpcObj.Lock;
  try
    if PageInfo.ActivePage = tabGeneral then
      RpcObj.AdvInfo:=aiGeneral
    else
    if PageInfo.ActivePage = tabPeers then
      RpcObj.AdvInfo:=aiPeers
    else
    if PageInfo.ActivePage = tabFiles then
      RpcObj.AdvInfo:=aiFiles
    else
    if PageInfo.ActivePage = tabTrackers then
      RpcObj.AdvInfo:=aiTrackers;
    DoRefresh;
  finally
    RpcObj.Unlock;
  end;
end;

procedure TMainForm.TorrentsListTimerTimer(Sender: TObject);
begin
  TorrentsListTimer.Enabled:=False;
  DoRefresh;
end;

procedure TMainForm.pmFilesPopup(Sender: TObject);
begin
  UpdateUI;
end;

procedure TMainForm.pmTorrentsPopup(Sender: TObject);
begin
  UpdateUI;
end;

procedure TMainForm.sbGenInfoResize(Sender: TObject);
begin
  sbGenInfo.HorzScrollBar.Visible:=False;
end;

procedure TMainForm.TrayIconDblClick(Sender: TObject);
begin
  miToggleApp.Click;
end;

procedure TMainForm.UrlLabelClick(Sender: TObject);
begin
  AppBusy;
  OpenURL((Sender as TLabel).Caption);
  AppNormal;
end;

procedure TMainForm.CenterReconnectWindow;
begin
  panReconnect.Left:=(ClientWidth - panReconnect.Width) div 2;
  panReconnect.Top:=(ClientHeight - panReconnect.Height) div 2;
end;

procedure TMainForm.DrawProgressCell(Sender: TVarGrid; ACol, ARow, ADataCol: integer; AState: TGridDrawState; const ACellRect: TRect);
var
  R, RR: TRect;
  i, j, h: integer;
  s: string;
  cl: TColor;
  Progress: double;
  sz: TSize;
  ts: TTextStyle;
begin
  Progress:=double(Sender.Items[ADataCol, ARow]);
  with Sender.Canvas do begin
    R:=ACellRect;
    Pen.Color:=Brush.Color;
    Rectangle(R);
    InflateRect(R, -1, -1);

    s:=Format('%.1f%%', [Progress]);
    sz:=TextExtent(s);
    if sz.cy < R.Bottom - R.Top - 1 then begin
      Rectangle(R);
      InflateRect(R, -1, -1);
    end;
    Pen.Color:=clBtnFace;
    Rectangle(R);
    InflateRect(R, -1, -1);

    i:=R.Left + Round(Progress*(R.Right - R.Left)/100.0);
    j:=(R.Top + R.Bottom) div 2;
    h:=TextHeight(s);
    h:=(R.Top + R.Bottom - h) div 2;
    cl:=GetLikeColor(clHighlight, 70);
    GradientFill(Rect(R.Left, R.Top, i, j), cl, clHighlight, gdVertical);
    GradientFill(Rect(R.Left, j, i, R.Bottom), clHighlight, cl, gdVertical);

    ts:=TextStyle;
    ts.Layout:=tlTop;
    ts.Alignment:=taLeftJustify;
    TextStyle:=ts;
    j:=(R.Left + R.Right - sz.cx) div 2;
    if i > R.Left then begin
      RR:=Rect(R.Left, R.Top, i, R.Bottom);
      Font.Color:=clHighlightText;
      TextRect(RR, j, h, s);
    end;
    if i < R.Right then begin
      RR:=Rect(i, R.Top, R.Right, R.Bottom);
      Brush.Color:=Sender.Color;
      FillRect(RR);
      Font.Color:=clWindowText;
      TextRect(RR, j, h, s);
    end;
  end;
end;

procedure TMainForm.DoConnect;
var
  Sec: string;
begin
  panReconnect.Hide;
  DoDisconnect;
  Sec:='Connection.' + FCurHost;
  if not FIni.SectionExists(Sec) then
    Sec:='Connection';
  RpcObj.Http.UserName:=FIni.ReadString(Sec, 'UserName', '');
  RpcObj.Http.Password:=DecodeBase64(FIni.ReadString(Sec, 'Password', ''));
  if FIni.ReadBool(Sec, 'UseProxy', False) then begin
    RpcObj.Http.ProxyHost:=FIni.ReadString(Sec, 'ProxyHost', '');
    RpcObj.Http.ProxyPort:=IntToStr(FIni.ReadInteger(Sec, 'ProxyPort', 8080));
    RpcObj.Http.ProxyUser:=FIni.ReadString(Sec, 'ProxyUser', '');
    RpcObj.Http.ProxyPass:=DecodeBase64(FIni.ReadString(Sec, 'ProxyPass', ''));
  end
  else begin
    RpcObj.Http.ProxyHost:='';
    RpcObj.Http.ProxyPort:='';
    RpcObj.Http.ProxyUser:='';
    RpcObj.Http.ProxyPass:='';
  end;
  RpcObj.Url:=Format('http://%s:%d/transmission/rpc', [FCurHost, FIni.ReadInteger(Sec, 'Port', 9091)]);

  RpcObj.RefreshInterval:=FIni.ReadInteger('Interface', 'RefreshInterval', 5);
  if RpcObj.RefreshInterval < 1 then
    RpcObj.RefreshInterval:=1;
  RpcObj.RefreshInterval:=RpcObj.RefreshInterval/SecsPerDay;
  RpcObj.InfoStatus:=sConnectingToDaemon;
  CheckStatus;
  TrayIcon.Hint:=RpcObj.InfoStatus;
  RpcObj.Connect;
  FPathMap.Text:=StringReplace(Ini.ReadString(Sec, 'PathMap', ''), '|', LineEnding, [rfReplaceAll]);
end;

procedure TMainForm.DoDisconnect;

begin
  TorrentsListTimer.Enabled:=False;
  FilterTimer.Enabled:=False;
  ClearDetailsInfo;
  gTorrents.Items.Clear;
  gTorrents.Enabled:=False;
  gTorrents.Color:=Self.Color;
  lvPeers.Enabled:=False;
  lvPeers.Color:=Self.Color;
  lvFiles.Enabled:=False;
  lvFiles.Color:=Self.Color;
  lvTrackers.Enabled:=False;
  lvTrackers.Color:=Self.Color;

  lvFilter.Enabled:=False;
  lvFilter.Color:=Self.Color;
  with lvFilter do begin
    Items[0, 0]:=UTF8Decode(SAll);
    Items[0, 1]:=UTF8Decode(SDownloading);
    Items[0, 2]:=UTF8Decode(SCompleted);
    Items[0, 3]:=UTF8Decode(SActive);
    Items[0, 4]:=UTF8Decode(SInactive);
  end;
  edSearch.Enabled:=False;
  edSearch.Color:=Self.Color;
  edSearch.Text:='';

  RpcObj.Disconnect;

  RpcObj.InfoStatus:=sDisconnected;
  CheckStatus;
  UpdateUI;
  TrayIcon.Hint:=RpcObj.InfoStatus;
  gTorrents.Items.RowCnt:=0;
  FTorrents.RowCnt:=0;
  lvFilter.Row:=0;
  lvFilter.Items.RowCnt:=StatusFiltersCount;
  TorrentsListTimer.Enabled:=False;
  FilterTimer.Enabled:=False;
end;

procedure TMainForm.ClearDetailsInfo;

  procedure ClearChildren(AParent: TPanel);
  var
    i: integer;
  begin
    AParent.AutoSize:=False;
    AParent.ChildSizing.Layout:=cclNone;
    for i:=0 to AParent.ControlCount - 1 do begin
      if AParent.Controls[i] is TLabel then
        with AParent.Controls[i] as TLabel do begin
          if (Length(Name) < 5) or (Copy(Name, Length(Name) - 4, 5) <> 'Label') then
            Caption:='';
          PopupMenu:=pmLabels;
        end;
    end;
  end;

begin
  FFiles.Clear;
  lvPeers.Items.Clear;
  lvTrackers.Items.Clear;
  ClearChildren(panGeneralInfo);
  ClearChildren(panTransfer);
  ProcessPieces('', 0, 0);
  txDownProgress.AutoSize:=False;
  txDownProgress.Caption:='';
end;

procedure TMainForm.UpdateUI;
begin
  acAddTorrent.Enabled:=RpcObj.Connected;
  acAddLink.Enabled:=RpcObj.Connected;
  acDaemonOptions.Enabled:=RpcObj.Connected;
  acStartAllTorrents.Enabled:=RpcObj.Connected and (gTorrents.Items.Count > 0);
  acStopAllTorrents.Enabled:=acStartAllTorrents.Enabled;
  acStartTorrent.Enabled:=RpcObj.Connected and (gTorrents.Items.Count > 0);
  acStopTorrent.Enabled:=RpcObj.Connected and (gTorrents.Items.Count > 0);
  acVerifyTorrent.Enabled:=RpcObj.Connected and (gTorrents.Items.Count > 0);
  acReannounceTorrent.Enabled:=acVerifyTorrent.Enabled;
  acRemoveTorrent.Enabled:=RpcObj.Connected and (gTorrents.Items.Count > 0);
  acRemoveTorrentAndData.Enabled:=acRemoveTorrent.Enabled and (RpcObj.RPCVersion >= 4);
  acTorrentProps.Enabled:=acRemoveTorrent.Enabled;
  acOpenContainingFolder.Enabled:=acTorrentProps.Enabled;
  acSetHighPriority.Enabled:=RpcObj.Connected and (gTorrents.Items.Count > 0) and
                      (lvFiles.Items.Count > 0) and (PageInfo.ActivePage = tabFiles);
  acSetNormalPriority.Enabled:=acSetHighPriority.Enabled;
  acSetLowPriority.Enabled:=acSetHighPriority.Enabled;
  acOpenFile.Enabled:=acSetHighPriority.Enabled and (lvFiles.SelCount < 2);
  acSetNotDownload.Enabled:=acSetHighPriority.Enabled;
  acSetupColumns.Enabled:=RpcObj.Connected;
end;

function TMainForm.ShowConnOptions: boolean;
var
  i, cnt, OldRefreshInterval: integer;
  s: string;
begin
  Result:=False;
  with TOptionsForm.Create(Self) do
  try
    cnt:=Ini.ReadInteger('Hosts', 'Count', 0);
    for i:=1 to cnt do begin
      s:=Ini.ReadString('Hosts', Format('Host%d', [i]), '');
      if s <> '' then
        cbHost.Items.Add(s);
    end;
    cbHost.ItemIndex:=cbHost.Items.IndexOf(FCurHost);
    cbHost.Text:=FCurHost;
    LoadHostSettings(FCurHost);

    edRefreshInterval.Value:=FIni.ReadInteger('Interface', 'RefreshInterval', 5);
{$ifdef windows}
    cbTrayClose.Checked:=FIni.ReadBool('Interface', 'TrayClose', False);
    cbTrayMinimize.Checked:=FIni.ReadBool('Interface', 'TrayMinimize', True);
{$else}
    cbTrayClose.Enabled:=False;
    cbTrayMinimize.Enabled:=False;
{$endif}
    cbTrayIconAlways.Checked:=FIni.ReadBool('Interface', 'TrayIconAlways', True);

    cbShowAddTorrentWindow.Checked:=FIni.ReadBool('Interface', 'ShowAddTorrentWindow', True);

    OldRefreshInterval:=edRefreshInterval.Value;

    if ShowModal = mrOK then begin
      if (FCurHost <> cbHost.Text) or IsHostSettingsChanged(FCurHost) or (OldRefreshInterval <> edRefreshInterval.Value) then begin
        DoDisconnect;
        FReconnectTimeOut:=-1;
      end;
      FCurHost:=cbHost.Text;
      SaveHostSettings(FCurHost);
      FPathMap.Text:=edPaths.Lines.Text;

      Ini.WriteString('Hosts', 'CurHost', FCurHost);
      Ini.WriteInteger('Hosts', 'Count', cbHost.Items.Count);
      for i:=0 to cbHost.Items.Count - 1 do
        Ini.WriteString('Hosts', Format('Host%d', [i + 1]), cbHost.Items[i]);

      FIni.WriteInteger('Interface', 'RefreshInterval', edRefreshInterval.Value);
{$ifdef windows}
      FIni.WriteBool('Interface', 'TrayClose', cbTrayClose.Checked);
      FIni.WriteBool('Interface', 'TrayMinimize', cbTrayMinimize.Checked);
{$endif}
      FIni.WriteBool('Interface', 'TrayIconAlways', cbTrayIconAlways.Checked);

      FIni.WriteBool('Interface', 'ShowAddTorrentWindow', cbShowAddTorrentWindow.Checked);

      if not RpcObj.Connected then
        DoConnect;

      UpdateTray;
      Result:=True;
    end;
  finally
    Free;
  end;
end;

procedure TMainForm.SaveColumns(LV: TVarGrid; const AName: string; FullInfo: boolean);
var
  i: integer;
begin
  for i:=0 to LV.Columns.Count - 1 do
    with LV.Columns[i] do begin
      FIni.WriteInteger(AName, Format('Id%d', [i]), ID - 1);
      FIni.WriteInteger(AName, Format('Width%d', [i]), Width);
      if FullInfo then begin
        FIni.WriteInteger(AName, Format('Index%d', [i]), Index);
        FIni.WriteBool(AName, Format('Visible%d', [i]), Visible);
      end;
    end;
  if LV.SortColumn >= 0 then begin
    FIni.WriteInteger(AName, 'SortColumn', LV.SortColumn);
    FIni.WriteInteger(AName, 'SortOrder', integer(LV.SortOrder));
  end;
end;

procedure TMainForm.LoadColumns(LV: TVarGrid; const AName: string; FullInfo: boolean);
var
  i, j, ColId: integer;
begin
  LV.Columns.BeginUpdate;
  try
    for i:=0 to LV.Columns.Count - 1 do begin
      ColId:=FIni.ReadInteger(AName, Format('Id%d', [i]), -1);
      if ColId = -1 then continue;
      for j:=0 to LV.Columns.Count - 1 do
        with LV.Columns[j] do
          if ID - 1 = ColId then begin
            if FullInfo then begin
              Index:=FIni.ReadInteger(AName, Format('Index%d', [i]), Index);
              Visible:=FIni.ReadBool(AName, Format('Visible%d', [i]), Visible);
            end;
            Width:=FIni.ReadInteger(AName, Format('Width%d', [i]), Width);
            break;
          end;
    end;
  finally
    LV.Columns.EndUpdate;
  end;
  LV.SortColumn:=FIni.ReadInteger(AName, 'SortColumn', LV.SortColumn);
  LV.SortOrder:=TSortOrder(FIni.ReadInteger(AName, 'SortOrder', integer(LV.SortOrder)));
end;

function TMainForm.GetTorrentError(t: TJSONObject): string;
var
  i: integer;
  stats: TJSONArray;
  err, gerr: widestring;
  NoTrackerError: boolean;
begin
  Result:='';
  gerr:=t.Strings['errorString'];
  if RpcObj.RPCVersion >= 7 then begin
    NoTrackerError:=False;
    stats:=t.Arrays['trackerStats'];
    for i:=0 to stats.Count - 1 do
      with stats.Objects[i] do begin
        err:='';
        if Booleans['hasAnnounced'] and not Booleans['lastAnnounceSucceeded'] then
          err:=Strings['lastAnnounceResult'];
        if err = 'Success' then
          err:='';
        if err = '' then begin
          // If at least one tracker is working, then report no error
          NoTrackerError:=True;
          Result:='';
        end
        else begin
          if not NoTrackerError and (Result = '') then
            Result:=sTrackerError + ': ' + UTF8Encode(err);
          // Workaround for transmission bug
          // If the global error string is equal to some tracker error string,
          // then igonore the global error string
          if gerr = err then
            gerr:='';
        end;
      end;
  end
  else begin
    Result:=UTF8Encode(t.Strings['announceResponse']);
    if Result = 'Success' then
      Result:=''
    else
      if Result <> '' then begin
        i:=Pos('(', Result);
        if i <> 0 then
          if Copy(Result, i, 5) = '(200)' then
            Result:=''
          else
            Result:=sTrackerError + ': ' + Copy(Result, 1, i - 1);
      end;
  end;

  if Result = '' then
    Result:=UTF8Encode(gerr);
end;

function TMainForm.SecondsToString(j: integer): string;
begin
  if j < 60 then
    Result:=Format(sSec, [j])
  else
  if j < 60*60 then
    Result:=Format(sMinSec, [j div 60, j mod 60])
  else begin
    j:=(j + 30) div 60;
    if j < 60*24 then
      Result:=Format(sHourMin, [j div 60, j mod 60])
    else begin
      j:=(j + 30) div 60;
      Result:=Format(sDayHour, [j div 24, j mod 24])
    end;
  end;

end;

procedure TMainForm.FillTorrentsList(list: TJSONArray);
var
  i, j, row, id, StateImg: integer;
  t: TJSONObject;
  f: double;
  ExistingRow: boolean;
  s, ss: string;

  function GetTorrentValue(AIndex: integer; const AName: string; AType: integer): boolean;
  var
    res: variant;
  begin
    Result:=t.IndexOfName(AName) >= 0;
    if Result then
      case AType of
        vtInteger:
          res:=t.Integers[AName];
        vtExtended:
          res:=t.Floats[AName];
        else
          res:=t.Strings[AName];
      end
    else
      res:=NULL;

    FTorrents[AIndex, row]:=res;
  end;

var
  FilterIdx, OldId: integer;
  TrackerFilter: string;
  UpSpeed, DownSpeed: double;
  DownCnt, SeedCnt, CompletedCnt, ActiveCnt: integer;
  IsActive: boolean;
begin
  if gTorrents.Tag <> 0 then exit;
  acRemoveTorrentAndData.Visible:=RpcObj.RPCVersion >= 4;
  acReannounceTorrent.Visible:=RpcObj.RPCVersion >= 5;
  if list = nil then begin
    ClearDetailsInfo;
    exit;
  end;

  OldId:=RpcObj.CurTorrentId;
  IsActive:=gTorrents.Enabled;
  gTorrents.Enabled:=True;
  lvFilter.Enabled:=True;
  gTorrents.Color:=clWindow;
  lvFilter.Color:=clWindow;
  edSearch.Enabled:=True;
  edSearch.Color:=clWindow;
  if not IsActive then
    ActiveControl:=gTorrents;

  for i:=0 to FTrackers.Count - 1 do
    FTrackers.Objects[i]:=nil;

  UpSpeed:=0;
  DownSpeed:=0;
  DownCnt:=0;
  SeedCnt:=0;
  CompletedCnt:=0;
  ActiveCnt:=0;

  FilterIdx:=lvFilter.Row;
  if FilterIdx >= StatusFiltersCount then begin
    TrackerFilter:=lvFilter.Items[0, FilterIdx];
    FilterIdx:=fltAll;
    i:=RPos('(', TrackerFilter);
    if i > 0 then
      TrackerFilter:=Trim(Copy(TrackerFilter, 1, i - 1));
  end;

  for i:=0 to FTorrents.Count - 1 do
    FTorrents[idxTag, i]:=0;

  for i:=0 to list.Count - 1 do begin
    StateImg:=-1;

    t:=list[i] as TJSONObject;
    id:=t.Integers['id'];
    row:=FTorrents.Count;
    j:=FTorrents.IndexOf(idxTorrentId, id);
    ExistingRow:=j >= 0;
    if ExistingRow then
      row:=j;

    FTorrents[idxTorrentId, row]:=t.Integers['id'];

    if t.IndexOfName('name') >= 0 then
      FTorrents[idxName, row]:=t.Strings['name'];

    j:=t.Integers['status'];
    if ExistingRow and (j = TR_STATUS_SEED) and (FTorrents[idxStatus, row] = TR_STATUS_DOWNLOAD) then
      DownloadFinished(UTF8Encode(widestring(FTorrents[idxName, row])));
    FTorrents[idxStatus, row]:=j;
    case j of
      TR_STATUS_CHECK_WAIT: StateImg:=imgDownQueue;
      TR_STATUS_CHECK:      StateImg:=imgDownQueue;
      TR_STATUS_DOWNLOAD:   StateImg:=imgDown;
      TR_STATUS_SEED:       StateImg:=imgSeed;
      TR_STATUS_STOPPED:    StateImg:=imgDone;
    end;

    if RpcObj.RPCVersion >= 7 then begin
      if t.Arrays['trackerStats'].Count > 0 then
        with t.Arrays['trackerStats'].Objects[0] do begin
          s:='';
          if integer(Integers['announceState']) in [2, 3] then
            s:=sTrackerUpdating
          else
            if Booleans['hasAnnounced'] then
              if Booleans['lastAnnounceSucceeded'] then
                s:=sTrackerWorking
              else
                s:=TranslateString(UTF8Encode(Strings['lastAnnounceResult']));

          if s = 'Success' then
            s:=sTrackerWorking;
          FTorrents[idxTrackerStatus, row]:=UTF8Decode(s);
        end
      else
        FTorrents[idxTrackerStatus, row]:='';
    end
    else
      FTorrents[idxTrackerStatus, row]:=t.Strings['announceResponse'];
    if (FTorrents[idxStatus, row] <> TR_STATUS_STOPPED) and (GetTorrentError(t) <> '') then
      if t.Strings['errorString'] <> '' then
        StateImg:=imgError
      else
        if StateImg in [imgDown,imgSeed] then
          Inc(StateImg, 2);

    if FTorrents[idxStatus, row] = TR_STATUS_CHECK then
      f:=t.Floats['recheckProgress']*100.0
    else begin
      f:=t.Floats['sizeWhenDone'];
      if f <> 0 then
        f:=(f - t.Floats['leftUntilDone'])*100.0/f;
      if StateImg = imgDone then
        if (t.Floats['leftUntilDone'] <> 0) or (t.Floats['sizeWhenDone'] = 0) then
          StateImg:=imgStopped
        else
          FTorrents[idxStatus, row]:=TR_STATUS_FINISHED;
    end;
    if f < 0 then
      f:=0;
    FTorrents[idxDone, row]:=Int(f*10.0)/10.0;
    FTorrents[idxStateImg, row]:=StateImg;
    GetTorrentValue(idxDownSpeed, 'rateDownload', vtInteger);
    GetTorrentValue(idxUpSpeed, 'rateUpload', vtInteger);

    GetTorrentValue(idxSize, 'totalSize', vtExtended);
    GetTorrentValue(idxSeeds, 'peersSendingToUs', vtInteger);
    GetTorrentValue(idxPeers, 'peersGettingFromUs', vtInteger);
    GetTorrentValue(idxPeersTotal, 'peersKnown', vtInteger);
    GetTorrentValue(idxETA, 'eta', vtInteger);
    GetTorrentValue(idxDownloaded, 'downloadedEver', vtExtended);
    GetTorrentValue(idxUploaded, 'uploadedEver', vtExtended);
    GetTorrentValue(idxAddedOn, 'addedDate', vtExtended);
    GetTorrentValue(idxCompletedOn, 'doneDate', vtExtended);
    GetTorrentValue(idxLastActive, 'activityDate', vtExtended);

    if RpcObj.RPCVersion >= 7 then begin
      if t.Arrays['trackerStats'].Count > 0 then
        with t.Arrays['trackerStats'].Objects[0] do begin
          FTorrents[idxSeedsTotal, row]:=Integers['seederCount'];
          FTorrents[idxLeechers, row]:=Integers['leecherCount'];
        end
      else begin
        FTorrents[idxSeedsTotal, row]:=-1;
        FTorrents[idxLeechers, row]:=-1;
      end;
    end
    else begin
      GetTorrentValue(idxSeedsTotal, 'seeders', vtInteger);
      GetTorrentValue(idxLeechers, 'leechers', vtInteger);
    end;
    if t.IndexOfName('uploadRatio') >= 0 then begin
      f:=t.Floats['uploadRatio'];
      if f = -2 then
        f:=MaxInt;
      FTorrents[idxRatio, row]:=f;
    end
    else
      FTorrents[idxRatio, row]:=NULL;

    if RpcObj.RPCVersion >= 7 then begin
      if t.Arrays['trackerStats'].Count > 0 then
        s:=t.Arrays['trackerStats'].Objects[0].Strings['announce']
      else
        s:=sNoTracker;
    end
    else
      if t.IndexOfName('trackers') >= 0 then
        s:=UTF8Encode(t.Arrays['trackers'].Objects[0].Strings['announce'])
      else begin
        s:='';
        if VarIsEmpty(FTorrents[idxTracker, row]) then
          RpcObj.RequestFullInfo:=True;
      end;

    if s <> '' then begin
      j:=Pos('://', s);
      if j > 0 then
        s:=Copy(s, j + 3, MaxInt);
      j:=Pos('/', s);
      if j > 0 then
        s:=Copy(s, 1, j - 1);
      j:=Pos('.', s);
      if j > 0 then begin
        ss:=Copy(s, 1, j - 1);
        if AnsiCompareText(ss, 'bt') = 0 then
          System.Delete(s, 1, 3)
        else
          if (Length(ss) = 3) and (AnsiCompareText(Copy(ss, 1, 2), 'bt') = 0) and (ss[3] in ['1'..'9']) then
            System.Delete(s, 1, 4);
      end;
      j:=Pos(':', s);
      if j > 0 then
        System.Delete(s, j, MaxInt);
      FTorrents[idxTracker, row]:=UTF8Decode(s);
    end;

    if t.IndexOfName('downloadDir') >= 0 then
      FTorrents[idxPath, row]:=t.Strings['downloadDir']
    else
      if VarIsEmpty(FTorrents[idxPath, row]) then
        RpcObj.RequestFullInfo:=True;

    DownSpeed:=DownSpeed + FTorrents[idxDownSpeed, row];
    UpSpeed:=UpSpeed + FTorrents[idxUpSpeed, row];

    FTorrents[idxTag, row]:=1;
  end;

  i:=0;
  while i < FTorrents.Count do
    if FTorrents[idxTag, i] = 0 then
      FTorrents.Delete(i)
    else
      Inc(i);

  gTorrents.BeginUpdate;
  try
    for i:=0 to gTorrents.Items.Count - 1 do
      gTorrents.Items[idxTag, i]:=0;

    for i:=0 to FTorrents.Count - 1 do begin
      IsActive:=(FTorrents[idxDownSpeed, i] <> 0) or (FTorrents[idxUpSpeed, i] <> 0);
      if IsActive then
        Inc(ActiveCnt);

      case integer(FTorrents[idxStatus, i]) of
        TR_STATUS_DOWNLOAD:
          Inc(DownCnt);
        TR_STATUS_SEED:
          begin
            Inc(SeedCnt);
            Inc(CompletedCnt);
          end;
        TR_STATUS_FINISHED:
          Inc(CompletedCnt);
      end;

      if not VarIsEmpty(FTorrents[idxTracker, i]) then begin
        s:=FTorrents[idxTracker, i];
        j:=FTrackers.IndexOf(s);
        if j < 0 then
          j:=FTrackers.Add(s);
        FTrackers.Objects[j]:=TObject(ptruint(FTrackers.Objects[j]) + 1);
        if (TrackerFilter <> '') and (TrackerFilter <> s) then
          continue;
      end;

      case FilterIdx of
        fltActive:
          if not IsActive then
            continue;
        fltInactive:
          if IsActive then
            continue;
        fltDown:
          if FTorrents[idxStatus, i] <> TR_STATUS_DOWNLOAD then
            continue;
        fltDone:
          if (FTorrents[idxStateImg, i] <> imgDone) and (FTorrents[idxStatus, i] <> TR_STATUS_SEED) then
            continue;
      end;

      if edSearch.Text <> '' then
        if UTF8Pos(UTF8UpperCase(edSearch.Text), UTF8UpperCase(UTF8Encode(widestring(FTorrents[idxName, i])))) = 0 then
          continue;

      row:=gTorrents.Items.IndexOf(idxTorrentId, FTorrents[idxTorrentId, i]);
      if row < 0 then
        row:=gTorrents.Items.Count;
      for j:=-TorrentsExtraColumns to FTorrents.ColCnt - 1 do
        gTorrents.Items[j, row]:=FTorrents[j, i];
      gTorrents.Items[idxTag, row]:=1;
    end;

    i:=0;
    while i < gTorrents.Items.Count do
      if gTorrents.Items[idxTag, i] = 0 then
        gTorrents.Items.Delete(i)
      else
        Inc(i);
  finally
    gTorrents.EndUpdate;
  end;

  gTorrents.Sort;
  if (gTorrents.Items.Count > 0) and (OldId = 0) then
    gTorrents.Row:=0;

  if OldId <> 0 then begin
    i:=gTorrents.Items.IndexOf(idxTorrentId, OldId);
    if i >= 0 then
      gTorrents.Row:=i;
  end;
  gTorrentsClick(nil);

  lvFilter.Items.BeginUpdate;
  try
    lvFilter.Items[0, 0]:=UTF8Decode(Format('%s (%d)', [SAll, list.Count]));
    lvFilter.Items[0, 1]:=UTF8Decode(Format('%s (%d)', [SDownloading, DownCnt]));
    lvFilter.Items[0, 2]:=UTF8Decode(Format('%s (%d)', [SCompleted, CompletedCnt]));
    lvFilter.Items[0, 3]:=UTF8Decode(Format('%s (%d)', [SActive, ActiveCnt]));
    lvFilter.Items[0, 4]:=UTF8Decode(Format('%s (%d)', [SInactive, FTorrents.Count - ActiveCnt]));

    lvFilter.Items[0, StatusFiltersCount]:=NULL;

    i:=0;
    while i < FTrackers.Count do begin
      j:=ptruint(FTrackers.Objects[i]);
      if j > 0 then begin
        lvFilter.Items[0, i + StatusFiltersCount + 1]:=Format('%s (%d)', [FTrackers[i], j]);
        if FTrackers[i] = TrackerFilter then
          lvFilter.Row:=i + StatusFiltersCount + 1;
        Inc(i);
      end
      else
        FTrackers.Delete(i);
    end;
    lvFilter.Items.RowCnt:=StatusFiltersCount + 1 + FTrackers.Count;
  finally
    lvFilter.Items.EndUpdate;
  end;

  CheckStatus;

  StatusBar.Panels[1].Text:=Format(sDownSpeed, [GetHumanSize(DownSpeed, 1)]);
  StatusBar.Panels[2].Text:=Format(sUpSpeed, [GetHumanSize(UpSpeed, 1)]);

  TrayIcon.Hint:=Format(sDownloadingSeeding,
        [RpcObj.InfoStatus, LineEnding, DownCnt, SeedCnt, LineEnding, StatusBar.Panels[1].Text, StatusBar.Panels[2].Text]);
end;

procedure TMainForm.FillPeersList(list: TJSONArray);
var
  i, j, row: integer;
  port: integer;
  d: TJSONData;
  p: TJSONObject;
  ip: string;
  hostinfo: PHostEntry;
  opt: TResolverOptions;
  WasEmpty: boolean;
begin
  if list = nil then begin
    ClearDetailsInfo;
    exit;
  end;
  WasEmpty:=lvPeers.Items.Count = 0;
  lvPeers.Items.BeginUpdate;
  try
    lvPeers.Enabled:=True;
    lvPeers.Color:=clWindow;
    if FResolver = nil then begin
      opt:=[];
      if acResolveHost.Checked then
        Include(opt, roResolveIP);
      if acResolveCountry.Checked then
        Include(opt, roResolveCountry);
      if opt <> [] then
        FResolver:=TIpResolver.Create(GetGeoIpDatabase, opt);
    end;

    for i:=0 to lvPeers.Items.Count - 1 do
      lvPeers.Items[idxPeerTag, i]:=0;

    for i:=0 to list.Count - 1 do begin
      d:=list[i];
      if not (d is TJSONObject) then continue;
      p:=d as TJSONObject;
      ip:=p.Strings['address'];
      if p.IndexOfName('port') >= 0 then
        port:=p.Integers['port']
      else
        port:=0;

      row:=lvPeers.Items.Count;
      for j:=0 to lvPeers.Items.Count - 1 do
        if (ip = lvPeers.Items[idxPeerIP, j]) and (port = lvPeers.Items[idxPeerPort, j]) then begin
          row:=j;
          break;
        end;

      lvPeers.Items[idxPeerIP, row]:=ip;
      lvPeers.Items[idxPeerPort, row]:=port;

      if FResolver <> nil then
        hostinfo:=FResolver.Resolve(ip)
      else
        hostinfo:=nil;
      if hostinfo <> nil then
        lvPeers.Items[idxPeerHost, row]:=hostinfo^.HostName
      else
        lvPeers.Items[idxPeerHost, row]:=ip;

      if hostinfo <> nil then
        lvPeers.Items[idxPeerCountry, row]:=hostinfo^.CountryName
      else
        lvPeers.Items[idxPeerCountry, row]:='';

      if acShowCountryFlag.Checked and (hostinfo <> nil) then begin
        if hostinfo^.ImageIndex = 0 then
          hostinfo^.ImageIndex:=GetFlagImage(hostinfo^.CountryCode);
        j:=hostinfo^.ImageIndex
      end
      else
        j:=0;
      lvPeers.Items[idxPeerCountryImage, row]:=j;
      lvPeers.Items[idxPeerClient, row]:=p.Strings['clientName'];
      lvPeers.Items[idxPeerFlags, row]:=p.Strings['flagStr'];
      lvPeers.Items[idxPeerDone, row]:=p.Floats['progress'];

      if p.IndexOfName('rateToClient') >= 0 then
        lvPeers.Items[idxPeerDownSpeed, row]:=p.Integers['rateToClient'];
      if p.IndexOfName('rateToPeer') >= 0 then
        lvPeers.Items[idxPeerUpSpeed, row]:=p.Integers['rateToPeer'];

      lvPeers.Items[idxPeerTag, row]:=1;
    end;

    i:=0;
    while i < lvPeers.Items.Count do
      if lvPeers.Items[idxPeerTag, row] = 0 then
        lvPeers.Items.Delete(i)
      else
        Inc(i);
  finally
    lvPeers.Items.EndUpdate;
  end;
  lvPeers.Sort;
  if WasEmpty and (lvPeers.Items.Count > 0) then
    lvPeers.Row:=0;
end;

function TMainForm.GetFilesCommonPath(files: TJSONArray): string;
var
  i: integer;
  d: TJSONData;
  f: TJSONObject;
  s: string;
begin
  Result:='';
  for i:=0 to files.Count - 1 do begin
    d:=files[i];
    if not (d is TJSONObject) then continue;
    f:=d as TJSONObject;
    s:=UTF8Encode(f.Strings['name']);
    if i = 0 then
      Result:=ExtractFilePath(s)
    else begin
      while True do begin
        if Result = '' then
          exit;
        if Copy(s, 1, Length(Result)) <> Result then begin
          SetLength(Result, Length(Result) - 1);
          Result:=ExtractFilePath(Result);
        end
        else
          break;
      end;
    end;
  end;
end;

procedure TMainForm.InternalRemoveTorrent(const Msg, MsgMulti: string; RemoveLocalData: boolean);
var
  args: TJSONObject;
  ids: variant;
  s: string;
begin
  if gTorrents.Items.Count = 0 then exit;
  gTorrents.Tag:=1;
  try
    ids:=GetSelectedTorrents;
    if gTorrents.SelCount < 2 then
      s:=Format(Msg, [UTF8Encode(widestring(gTorrents.Items[idxName, gTorrents.Items.IndexOf(idxTorrentId, ids[0])]))])
    else
      s:=Format(MsgMulti, [gTorrents.SelCount]);
    if MessageDlg('', s, mtConfirmation, mbYesNo, 0, mbNo) <> mrYes then exit;
  finally
    gTorrents.Tag:=0;
  end;
  args:=TJSONObject.Create;
  if RemoveLocalData then
    args.Add('delete-local-data', TJSONIntegerNumber.Create(1));
  TorrentAction(ids, 'remove', args);
end;

function TMainForm.IncludeProperTrailingPathDelimiter(const s: string): string;
var
  i: integer;
  d: char;
begin
  Result:=s;
  if Result = '' then exit;
  d:='/';
  for i:=1 to Length(Result) do
    if Result[i] in ['/','\',':'] then begin
      d:=Result[i];
      break;
    end;

  if Result[Length(Result)] <> d then
    Result:=Result + d;
end;

procedure TMainForm.FillFilesList(list, priorities, wanted: TJSONArray; const DownloadDir: WideString);
var
  i, row: integer;
  d: TJSONData;
  f: TJSONObject;
  s, path, dir: string;
  ff: double;
  WasEmpty: boolean;
begin
  if (list = nil) or (priorities = nil) or (wanted = nil) then begin
    ClearDetailsInfo;
    exit;
  end;

  lvFiles.Enabled:=True;
  lvFiles.Color:=clWindow;
  dir:=UTF8Encode(DownloadDir);
  path:=GetFilesCommonPath(list);
  WasEmpty:=FFiles.Count = 0;

  FFiles.BeginUpdate;
  try
    for i:=0 to FFiles.Count - 1 do
      FFiles[idxFileTag, i]:=0;

    for i:=0 to list.Count - 1 do begin
      d:=list[i];
      f:=d as TJSONObject;
      row:=FFiles.IndexOf(idxFileId, i);
      if row < 0 then
        row:=FFiles.Count;
      FFiles[idxFileTag, row]:=1;
      FFiles[idxFileId, row]:=i;

      s:=UTF8Encode(f.Strings['name']);
      FFiles[idxFileFullPath, row]:=IncludeProperTrailingPathDelimiter(dir) + s;
      if (path <> '') and (Copy(s, 1, Length(path)) = path) then
        s:=Copy(s, Length(path) + 1, MaxInt);

      FFiles[idxFileName, row]:=UTF8Decode(s);
      ff:=f.Floats['length'];
      FFiles[idxFileSize, row]:=ff;
      FFiles[idxFileDone, row]:=f.Floats['bytesCompleted'];
      if ff <> 0 then
        ff:=double(FFiles[idxFileDone, row])*100.0/ff;
      FFiles[idxFileProgress, row]:=Int(ff*10.0)/10.0;

      if wanted.Integers[i] = 0 then
        FFiles[idxFilePriority, row]:=TR_PRI_SKIP
      else
        FFiles[idxFilePriority, row]:=priorities.Integers[i];
    end;

    i:=0;
    while i < FFiles.Count do
      if FFiles[idxFileTag, i] = 0 then
        FFiles.Delete(i)
      else
        Inc(i);
  finally
    FFiles.EndUpdate;
  end;
  lvFiles.Sort;
  if WasEmpty and (FFiles.Count > 0) then
    lvFiles.Row:=0;
end;

procedure TMainForm.FillGeneralInfo(t: TJSONObject);
var
  i, j, idx: integer;
  s: string;
  f: double;
begin
  if (gTorrents.Items.Count = 0) or (t = nil) then begin
    ClearDetailsInfo;
    exit;
  end;
  idx:=gTorrents.Items.IndexOf(idxTorrentId, t.Integers['id']);
  if idx = -1 then begin
    ClearDetailsInfo;
    exit;
  end;

  txDownProgress.Caption:=Format('%.1f%%', [double(gTorrents.Items[idxDone, idx])]);
  txDownProgress.AutoSize:=True;
  if RpcObj.RPCVersion >= 5 then
    s:=t.Strings['pieces']
  else
    s:='';
  ProcessPieces(s, t.Integers['pieceCount'], gTorrents.Items[idxDone, idx]);

  panTransfer.ChildSizing.Layout:=cclNone;
  txStatus.Caption:=GetTorrentStatus(idx);
  txError.Caption:=GetTorrentError(t);
  txRemaining.Caption:=EtaToString(t.Integers['eta']);
  txDownloaded.Caption:=GetHumanSize(t.Floats['downloadedEver']);
  txUploaded.Caption:=GetHumanSize(t.Floats['uploadedEver']);
  f:=t.Floats['pieceSize'];
  if f > 0 then
    i:=Round(t.Floats['corruptEver']/f)
  else
    i:=0;
  txWasted.Caption:=Format(sHashfails, [GetHumanSize(t.Floats['corruptEver']), i]);
  txDownSpeed.Caption:=GetHumanSize(gTorrents.Items[idxDownSpeed, idx], 1)+sPerSecond;
  txUpSpeed.Caption:=GetHumanSize(gTorrents.Items[idxUpSpeed, idx], 1)+sPerSecond;
  txRatio.Caption:=RatioToString(t.Floats['uploadRatio']);

  if RpcObj.RPCVersion < 5 then
  begin
    // RPC versions prior to v5
    j:=t.Integers['downloadLimitMode'];
    if j = TR_SPEEDLIMIT_GLOBAL then
      s:='-'
    else begin
      i:=t.Integers['downloadLimit'];
      if (i < 0) or (j = TR_SPEEDLIMIT_UNLIMITED) then
        s:=Utf8Encode(WideString(WideChar($221E)))
      else
        s:=GetHumanSize(i*1024)+sPerSecond;
    end;
    txDownLimit.Caption:=s;
    j:=t.Integers['uploadLimitMode'];
    if j = TR_SPEEDLIMIT_GLOBAL then
      s:='-'
    else begin
      i:=t.Integers['uploadLimit'];
      if (i < 0) or (j = TR_SPEEDLIMIT_UNLIMITED) then
        s:=Utf8Encode(WideString(WideChar($221E)))
      else
        s:=GetHumanSize(i*1024)+sPerSecond;
    end;
    txUpLimit.Caption:=s;
  end else begin
    // RPC version 5
    if t.Booleans['downloadLimited'] then
    begin
      i:=t.Integers['downloadLimit'];
      if i < 0 then
        s:=Utf8Encode(WideString(WideChar($221E)))
      else
        s:=GetHumanSize(i*1024)+sPerSecond;
    end else s:='-';
    txDownLimit.Caption:=s;

    if t.Booleans['uploadLimited'] then
    begin
      i:=t.Integers['uploadLimit'];
      if i < 0 then
        s:=Utf8Encode(WideString(WideChar($221E)))
      else
        s:=GetHumanSize(i*1024)+sPerSecond;
    end else s:='-';
    txUpLimit.Caption:=s;
  end;

  if RpcObj.RPCVersion >= 7 then
    with t.Arrays['trackerStats'] do begin
      if Count > 0 then begin
        if integer(Objects[0].Integers['announceState']) in [2, 3] then
          f:=1
        else
          f:=Objects[0].Floats['nextAnnounceTime'];
      end
      else
        f:=0;
    end
  else
    f:=t.Floats['nextAnnounceTime'];
  if f = 0 then
    s:='-'
  else
  if f = 1 then
    s:=sUpdating
  else
    s:=DateTimeToStr(UnixToDateTime(Trunc(f)) + GetTimeZoneDelta);
  txTrackerUpdate.Caption:=s;
  txTracker.Caption:=UTF8Encode(widestring(gTorrents.Items[idxTracker, idx]));
  if RpcObj.RPCVersion >= 7 then
    if t.Arrays['trackerStats'].Count > 0 then
      i:=t.Arrays['trackerStats'].Objects[0].Integers['seederCount']
    else
      i:=-1
  else
    i:=t.Integers['seeders'];
  s:=GetSeedsText(t.Integers['peersSendingToUs'], i);
  txSeeds.Caption:=StringReplace(s, '/', ' ' + sOf + ' ', []) + ' '+ sConnected;
  if RpcObj.RPCVersion >= 7 then
    if t.Arrays['trackerStats'].Count > 0 then
      i:=t.Arrays['trackerStats'].Objects[0].Integers['leecherCount']
    else
      i:=-1
  else
    i:=t.Integers['leechers'];
  s:=GetPeersText(t.Integers['peersGettingFromUs'], t.Integers['peersKnown'], i);
  s:=StringReplace(s, ' ', ' '+ sConnected +' ', []);
  s:=StringReplace(s, '/', ' ' + sOf + ' ', []);
  txPeers.Caption:=StringReplace(s, ')', ' '+ sInSwarm+ ')', []);
  txMaxPeers.Caption:=t.Strings['maxConnectedPeers'];
  txLastActive.Caption:=TorrentDateTimeToString(Trunc(t.Floats['activityDate']));
  panTransfer.ChildSizing.Layout:=cclLeftToRightThenTopToBottom;

  panGeneralInfo.ChildSizing.Layout:=cclNone;

  s:=UTF8Encode(widestring(gTorrents.Items[idxName, idx]));
  if RpcObj.RPCVersion >= 4 then
    s:=IncludeProperTrailingPathDelimiter(UTF8Encode(t.Strings['downloadDir'])) + s;
  txTorrentName.Caption:=s;
  txCreated.Caption:=Format('%s by %s', [TorrentDateTimeToString(Trunc(t.Floats['dateCreated'])), UTF8Encode(t.Strings['creator'])]);
  txTotalSize.Caption:=Format(sDone, [GetHumanSize(t.Floats['totalSize']), GetHumanSize(t.Floats['sizeWhenDone'] - t.Floats['leftUntilDone'])]);
  if t.Floats['totalSize'] = t.Floats['haveValid'] then
    i:=t.Integers['pieceCount']
  else
    i:=Trunc(t.Floats['haveValid']/t.Floats['pieceSize']);
  txPieces.Caption:=Format(sHave, [t.Integers['pieceCount'], GetHumanSize(t.Floats['pieceSize']), i]);

  txHash.Caption:=t.Strings['hashString'];
  txComment.Caption:=UTF8Encode(t.Strings['comment']);
  if (AnsiCompareText(Copy(txComment.Caption, 1, 7), 'http://') = 0)
     or (AnsiCompareText(Copy(txComment.Caption, 1, 8), 'https://') = 0)
  then begin
    if not Assigned(txComment.OnClick) then begin
      txComment.OnClick:=@UrlLabelClick;
      txComment.Cursor:=crHandPoint;
      txComment.Font.Color:=clBlue;
      txComment.Font.Style:=[fsUnderline];
    end;
  end
  else begin
    if Assigned(txComment.OnClick) then begin
      txComment.OnClick:=nil;
      txComment.Cursor:=crDefault;
      txComment.ParentFont:=True;
    end;
  end;
  txAddedOn.Caption:=TorrentDateTimeToString(Trunc(t.Floats['addedDate']));
  txCompletedOn.Caption:=TorrentDateTimeToString(Trunc(t.Floats['doneDate']));
  panGeneralInfo.ChildSizing.Layout:=cclLeftToRightThenTopToBottom;
end;

procedure TMainForm.FillTrackersList(TrackersData: TJSONObject);
var
  i, tidx, row: integer;
  id: integer;
  d: TJSONData;
  t: TJSONObject;
  f: double;
  s: string;
  Trackers, TrackerStats: TJSONArray;
  WasEmpty: boolean;
begin
  if TrackersData = nil then begin
    ClearDetailsInfo;
    exit;
  end;
  Trackers:=TrackersData.Arrays['trackers'];
  if RpcObj.RPCVersion >= 7 then
    TrackerStats:=TrackersData.Arrays['trackerStats']
  else
    TrackerStats:=nil;
  tidx:=gTorrents.Items.IndexOf(idxTorrentId, TrackersData.Integers['id']);
  if tidx = -1 then begin
    ClearDetailsInfo;
    exit;
  end;
  WasEmpty:=lvTrackers.Items.Count = 0;
  lvTrackers.Items.BeginUpdate;
  try
    lvTrackers.Enabled:=True;
    lvTrackers.Color:=clWindow;
    for i:=0 to lvTrackers.Items.Count - 1 do
      lvTrackers.Items[idxTrackerTag, i]:=0;

    for i:=0 to Trackers.Count - 1 do begin
      d:=Trackers[i];
      if not (d is TJSONObject) then continue;
      t:=d as TJSONObject;
      if t.IndexOfName('id') >= 0 then
        id:=t.Integers['id'] + 1
      else
        id:=i + 1;
      row:=lvTrackers.Items.IndexOf(idxTrackerID, id);
      if row < 0 then
        row:=lvTrackers.Items.Count;
      lvTrackers.Items[idxTrackerID, row]:=id;

      lvTrackers.Items[idxTrackersListName, row]:=t.Strings['announce'];
      if TrackerStats <> nil then begin
        f:=0;
        if i < TrackerStats.Count then
          with TrackerStats.Objects[i] do begin
            s:='';
            if integer(Integers['announceState']) in [2, 3] then
              s:=sTrackerUpdating
            else
              if Booleans['hasAnnounced'] then
                if Booleans['lastAnnounceSucceeded'] then
                  s:=sTrackerWorking
                else
                  s:=TranslateString(UTF8Encode(Strings['lastAnnounceResult']));

            if s = 'Success' then
              s:=sTrackerWorking;

            lvTrackers.Items[idxTrackersListStatus, row]:=UTF8Decode(s);
            lvTrackers.Items[idxTrackersListSeeds, row]:=Integers['seederCount'];

            if integer(Integers['announceState']) in [2, 3] then
              f:=1
            else
              f:=Floats['nextAnnounceTime'];
          end;
      end
      else begin
        if i = 0 then begin
          lvTrackers.Items[idxTrackersListStatus, row]:=gTorrents.Items[idxTrackerStatus, tidx];
          lvTrackers.Items[idxTrackersListSeeds, row]:=gTorrents.Items[idxSeedsTotal, tidx];
        end;
        f:=TrackersData.Floats['nextAnnounceTime'];
      end;

      if f > 1 then begin
        f:=(UnixToDateTime(Trunc(f)) + GetTimeZoneDelta - Now)*SecsPerDay;
        if f < 0 then
          f:=0;
      end;
      if (TrackerStats <> nil) or (i = 0) then
        lvTrackers.Items[idxTrackersListUpdateIn, row]:=f;

      lvTrackers.Items[idxTrackerTag, row]:=1;
    end;

    i:=0;
    while i < lvTrackers.Items.Count do
      if lvTrackers.Items[idxTrackerTag, i] = 0 then
        lvTrackers.Items.Delete(i)
      else
        Inc(i);
  finally
    lvTrackers.Items.EndUpdate;
  end;
  lvTrackers.Sort;
  if WasEmpty and (lvTrackers.Items.Count > 0) then
    lvTrackers.Row:=0;
end;

procedure TMainForm.CheckStatus(Fatal: boolean);
var
  s: string;
  i: integer;
begin
  with MainForm do begin
    s:=RpcObj.Status;
    if s <> '' then begin
      RpcObj.Status:='';
      if Fatal then
        DoDisconnect;
      ForceAppNormal;
      if Fatal and not RpcObj.Connected and RpcObj.ReconnectAllowed and (FReconnectTimeOut <> -1) then begin
        FReconnectWaitStart:=Now;
        if FReconnectTimeOut < 60 then
          if FReconnectTimeOut < 10 then
            Inc(FReconnectTimeOut, 5)
          else
            Inc(FReconnectTimeOut, 10);
        txConnError.Caption:=s;
        panReconnectFrame.Hide;
        panReconnect.AutoSize:=True;
        CenterReconnectWindow;
        panReconnect.Show;
        panReconnect.BringToFront;
        TickTimerTimer(nil);
        panReconnect.AutoSize:=False;
        panReconnectFrame.Show;
        CenterReconnectWindow;
      end
      else
        MessageDlg(s, mtError, [mbOK], 0);
    end;

    if StatusBar.Panels[0].Text <> RpcObj.InfoStatus then begin
      StatusBar.Panels[0].Text:=RpcObj.InfoStatus;
      TrayIcon.Hint:=RpcObj.InfoStatus;
    end;
    if not RpcObj.Connected then
      for i:=1 to StatusBar.Panels.Count - 1 do
        StatusBar.Panels[i].Text:='';
  end;
end;

function TMainForm.TorrentAction(const TorrentIds: variant; const AAction: string; args: TJSONObject): boolean;
var
  req: TJSONObject;
  ids: TJSONArray;
  i: integer;
begin
  Application.ProcessMessages;
  AppBusy;
  req:=TJSONObject.Create;
  try
    req.Add('method', 'torrent-' + AAction);
    if args = nil then
      args:=TJSONObject.Create;
    if not VarIsNull(TorrentIds) then begin
      ids:=TJSONArray.Create;
      for i:=VarArrayLowBound(TorrentIds, 1) to VarArrayHighBound(TorrentIds, 1) do
        ids.Add(integer(TorrentIds[i]));
      args.Add('ids', ids);
    end;
    req.Add('arguments', args);
    args:=RpcObj.SendRequest(req, False);
    Result:=args <> nil;
    args.Free;
  finally
    req.Free;
  end;
  if not Result then
    CheckStatus(False)
  else
    DoRefresh(True);
  AppNormal;
end;

function TMainForm.SetFilePriority(TorrentId: integer; const Files: array of integer; const APriority: string): boolean;

  function CreateFilesArray: TJSONArray;
  var
    i: integer;
  begin
    Result:=TJSONArray.Create;
    for i:=Low(Files) to High(Files) do
      Result.Add(Files[i]);
  end;

var
  req, args: TJSONObject;
begin
  AppBusy;
  req:=TJSONObject.Create;
  try
    req.Add('method', 'torrent-set');
    args:=TJSONObject.Create;
    if TorrentId <> 0 then
      args.Add('ids', TJSONArray.Create([TorrentId]));
    if APriority = 'skip' then
      args.Add('files-unwanted', CreateFilesArray)
    else begin
      args.Add('files-wanted', CreateFilesArray);
      args.Add('priority-' + APriority, CreateFilesArray);
    end;
    req.Add('arguments', args);
    args:=RpcObj.SendRequest(req, False);
    Result:=args<> nil;
    args.Free;
  finally
    req.Free;
  end;
  if not Result then
    CheckStatus(False)
  else
    DoRefresh;
  AppNormal;
end;

function TMainForm.SetCurrentFilePriority(const APriority: string): boolean;
var
  Files: array of integer;
  i, j: integer;
begin
  if (gTorrents.Items.Count = 0) or (PageInfo.ActivePage <> tabFiles) then exit;
  if lvFiles.SelCount = 0 then
    lvFiles.RowSelected[lvFiles.Row]:=True;
  SetLength(Files, lvFiles.Items.Count);
  j:=0;
  for i:=0 to lvFiles.Items.Count - 1 do
    if lvFiles.RowSelected[i] then begin
      Files[j]:=FFiles[idxFileId, i];
      Inc(j);
    end;
  if j = 0 then exit;
  SetLength(Files, j);
  Result:=SetFilePriority(RpcObj.CurTorrentId, Files, APriority);
end;

procedure TMainForm.ProcessPieces(const Pieces: string; PieceCount: integer; const Done: double);
const
  MaxPieces = 4000;
var
  i, j, k, x, xx: integer;
  s: string;
  R: TRect;
  bmp: TBitmap;
  c: double;
begin
  FLastPieces:=Pieces;
  FLastPieceCount:=PieceCount;
  FLastDone:=Done;
  bmp:=nil;
  try
    if FTorrentProgress = nil then
      FTorrentProgress:=TBitmap.Create;
    if RpcObj.RPCVersion >= 5 then begin
      bmp:=TBitmap.Create;
      if PieceCount > MaxPieces then begin
        bmp.Width:=MaxPieces;
        c:=MaxPieces/PieceCount;
      end
      else begin
        bmp.Width:=PieceCount;
        c:=1;
      end;
      bmp.Height:=12;
      bmp.Canvas.Brush.Color:=clWindow;
      bmp.Canvas.FillRect(0, 0, bmp.Width, bmp.Height);
      bmp.Canvas.Brush.Color:=clHighlight;
      x:=0;
      s:=DecodeBase64(Pieces);
      for i:=1 to Length(s) do begin
        j:=byte(s[i]);
        for k:=1 to 8 do begin
          if PieceCount = 0 then
            break;
          if j and $80 <> 0 then begin
            xx:=Trunc(x*c);
            bmp.Canvas.FillRect(xx, 0, xx + 1, bmp.Height);
          end;
          Inc(x);
          j:=j shl 1;
          Dec(PieceCount);
        end;
      end;
    end;

    with FTorrentProgress.Canvas do begin
      FTorrentProgress.Width:=pbDownloaded.ClientWidth;
      if bmp <> nil then begin
        i:=bmp.Height div 3;
        FTorrentProgress.Height:=bmp.Height + 5 + i;
        Brush.Color:=clWindow;
        FillRect(0, 0, FTorrentProgress.Width, FTorrentProgress.Height);
        Brush.Color:=clBtnShadow;
        R:=Rect(0, i + 3, FTorrentProgress.Width, FTorrentProgress.Height);
        FillRect(R);
        InflateRect(R, -1, -1);
        if bmp.Width > 0 then
          StretchDraw(R, bmp)
        else begin
          Brush.Color:=clWindow;
          FillRect(R);
        end;
        R:=Rect(0, 0, FTorrentProgress.Width, i + 2);
      end
      else begin
        FTorrentProgress.Height:=14;
        R:=Rect(0, 0, FTorrentProgress.Width, FTorrentProgress.Height);
      end;
      Brush.Color:=clBtnShadow;
      FillRect(R);
      InflateRect(R, -1, -1);
      x:=R.Left + Round((R.Right - R.Left)*Done/100.0);
      Brush.Color:=clHighlight;
      FillRect(R.Left, R.Top, x, R.Bottom);
      Brush.Color:=clWindow;
      FillRect(x, R.Top, R.Right, R.Bottom);
    end;
    if pbDownloaded.Height <> FTorrentProgress.Height then begin
      pbDownloaded.Height:=FTorrentProgress.Height;
      panProgress.AutoSize:=True;
      panProgress.AutoSize:=False;
    end;
    pbDownloaded.Invalidate;
  finally
    bmp.Free;
  end;
end;

function TMainForm.ExecRemoteFile(const FileName: string): boolean;
var
  i, j: integer;
  s, ss: string;
begin
  for i:=0 to FPathMap.Count - 1 do begin
    s:=FPathMap[i];
    j:=Pos('=', s);
    if j > 0 then begin
      ss:=Copy(s, 1, j - 1);
      if (ss = FileName) or (Pos(IncludeProperTrailingPathDelimiter(ss), FileName) = 1) then begin
        if ss = FileName then
          ss:=Copy(s, j + 1, MaxInt)
        else begin
          ss:=IncludeProperTrailingPathDelimiter(ss);
          ss:=IncludeTrailingPathDelimiter(Copy(s, j + 1, MaxInt)) + Copy(FileName, Length(ss) + 1, MaxInt);
        end;
        ss:=StringReplace(ss, '/', DirectorySeparator, [rfReplaceAll]);
        ss:=StringReplace(ss, '\', DirectorySeparator, [rfReplaceAll]);
        Result:=OpenURL(ss);
        exit;
      end;
    end;
  end;

  if FileExistsUTF8(FileName) or DirectoryExistsUTF8(FileName) then begin
    Result:=OpenURL(FileName);
    exit;
  end;

  MessageDlg(sNoPathMapping, mtInformation, [mbOK], 0);
end;

function TMainForm.GetSelectedTorrents: variant;
var
  i, j: integer;
begin
  with gTorrents do begin
    if SelCount = 0 then
      Result:=VarArrayOf([Items[idxTorrentId, Row]])
    else begin
      Result:=VarArrayCreate([0, SelCount - 1], varinteger);
      j:=0;
      for i:=0 to gTorrents.Items.Count - 1 do
        if gTorrents.RowSelected[i] then begin
          Result[j]:=Items[idxTorrentId, i];
          Inc(j);
        end;
    end;
  end;
end;

initialization
  {$I main.lrs}

end.
