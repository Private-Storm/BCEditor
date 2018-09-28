﻿unit BCEditor.Locale;

interface {********************************************************************}

function BCEditorStr(const Id: Integer): string; overload;
function BCEditorStr(const Id: Integer; const AArgs: array of const): string; overload;

implementation {***************************************************************}

uses
  Windows,
  Classes, SysUtils;

function GetUserPreferredUILanguages(
  dwFlags: DWORD;
  pulNumLanguages: PULONG;
  pwszLanguagesBuffer: Pointer;
  pcchLanguagesBuffer: PULONG): BOOL; stdcall;
  external Kernel32 name 'GetUserPreferredUILanguages';

const
  MUI_LANGUAGE_ID = 4;
  MUI_LANGUAGE_NAME = 8;

const
  Translations: array [0 .. 2] of record
    LanguageId: Integer;
    Strings: array [0 .. 17] of PChar;
  end =
    (
      ( // English
        LanguageId: $0409;
        Strings: (
          'Confirmation',
          'Error',
          'Information',
          'Warning',
          'Ok',
          'Cancel',
          '%d Lines',
          'Line: %d',
          'Pattern is empty',
          'Pattern contains word break character',
          'Replace this occurrence of "%s"?',
          'Search string "%s" not found',
          'Search match not found',
          'Restart search from the beginning of the file?',
          'Restart search from the ending of the file?',
          'Terminated by user',
          'Go to line Number',
          'New line number'
        );
      ),
      ( // German
        LanguageId: $0407;
        Strings: (
          'Bestätigung',
          'Fehler',
          'Information',
          'Warnung',
          'Ok',
          'Abbruch',
          '%d Zeilen',
          'Zeile: %d',
          'Kein Suchtext',
          'Suchtext enthält Wort-Trennzeichen',
          'Diese Vorkommen von "%s" ersetzten?',
          'Suchtext "%s" nicht gefunden',
          'Suchergebnis nicht gefunden',
          'Suche am Anfang der Datei wiederholen?',
          'Suche am Ende der Datei wiederholen?',
          'Vom Anwender abgebrochen',
          'Zu Zeilennummer gehen',
          'Neue Zeilennummer'
        );
      ),
      ( // Polish
        LanguageId: $0415;
        Strings: (
        'Potwierdzenie',
        'Błąd',
        'Informacja',
        'Ostrzeżenie',
        'Ok',
        'Anuluj',
        '%d Linii',
        'Linia: %d',
        'Wzorzec jest pusty',
        'Wzorzec zawiera znak łamania tekstu',
        'Zamienić to wystąpienie "%s"?',
        'Szukany łańcuch "%s" nie został znaleziony',
        'Nie znaleziono dopasowania',
        'Rozpocząć szukanie od początku pliku?',
        'Rozpocząć szukanie od końca pliku?',
        'Przerwane przez użytkownika',
        'Idź do linii',
        'Numer nowej linii'
        );
      )
    );

var
  GEnglish: Integer;
  GTranslation: Integer;

function BCEditorStr(const Id: Integer): string;
begin
  Result := BCEditorStr(Id, []);
end;

function BCEditorStr(const Id: Integer; const AArgs: array of const): string;
begin
  if (Translations[GTranslation].Strings[Id] = '') then
    Result := Format(StrPas(Translations[GEnglish].Strings[Id]), AArgs)
  else
    Result := Format(StrPas(Translations[GTranslation].Strings[Id]), AArgs);
end;

var
  LBuffer: array [0 .. 40 - 1] of Char;
  LCount: ULONG;
  LHex: array [0 .. 4 - 1] of Char;
  LIndex: Integer;
  LLanguageIndex: Integer;
  LLanguageId: Integer;
  LLen: ULONG;
begin
  GEnglish := 0;
  for LIndex := 0 to Length(Translations) - 1 do
    if (Translations[LIndex].LanguageId = $0409) then
      GEnglish := LIndex;

  GTranslation := 0;

  LLen := Length(LBuffer);
  if (GetUserPreferredUILanguages(MUI_LANGUAGE_ID, @LCount, @LBuffer[0], @LLen)) then
  begin
    for LLanguageIndex := LCount - 1 downto 0 do
    begin
      LHex[0] := LBuffer[LLanguageIndex * 4  + 2];
      LHex[1] := LBuffer[LLanguageIndex * 4  + 3];
      LHex[2] := LBuffer[LLanguageIndex * 4  + 0];
      LHex[3] := LBuffer[LLanguageIndex * 4  + 1];
      HexToBin(PChar(@LHex), LLanguageId, SizeOf(LLanguageId));

      for LIndex := 0 to Length(Translations) - 1 do
        if (Translations[LIndex].LanguageId = LLanguageId) then
          GTranslation := LIndex;
    end;
  end;
end.
