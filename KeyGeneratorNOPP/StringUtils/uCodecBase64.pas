unit uCodecBase64;

{*_* * * * * * * * * * * * * * * * * * * * * * * ** * * * * * * * * * * * *


Author:       François PIETTE
Object:       Mime support routines (RFC2045).
Creation:     May 03, 2003  (Extracted from SmtpProt unit)
Version:      1.06
EMail:        francois.piette@overbyte.be   http://www.overbyte.be
Support:      Use the mailing list twsocket@elists.org
              Follow "support" link at http://www.overbyte.be for subscription.
Legal issues: Copyright (C) 1997-2007 by François PIETTE
              Rue de Grady 24, 4053 Embourg, Belgium. Fax: +32-4-365.74.56
              <francois.piette@overbyte.be>

              This software is provided 'as-is', without any express or
              implied warranty.  In no event will the author be held liable
              for any  damages arising from the use of this software.

              Permission is granted to anyone to use this software for any
              purpose, including commercial applications, and to alter it
              and redistribute it freely, subject to the following
              restrictions:

              1. The origin of this software must not be misrepresented,
                 you must not claim that you wrote the original software.
                 If you use this software in a product, an acknowledgment
                 in the product documentation would be appreciated but is
                 not required.

              2. Altered source versions must be plainly marked as such, and
                 must not be misrepresented as being the original software.

              3. This notice may not be removed or altered from any source
                 distribution.

              4. You must register this software by sending a picture postcard
                 to the author. Use a nice stamp and mention your name, street
                 address, EMail address and any comment you like to say.

History:
May 03, 2003  V1.00 Initial release
Jun 19, 2003  V1.01 Fixed SplitQuotedPrintableString. Thanks to Arno Garrels
                    <arno.garrels@gmx.de>
Jan 12, 2004  V1.02 Marc HUBAUT <mhu@wanadoo.fr> fixed DoFileEncBase64 in case
                    of file size is a multple of 3.
May 31, 2004  V1.03 Used ICSDEFS.INC, added const with version and copyright
May 28, 2005  V1.04 Piotr Hellrayzer Dalek <enigmatical@interia.pl>
              added a fast quoted-printable encoder. Arno Garrels
              <arno.garrels@gmx.de> added some routines and fixed a bug in
              func. SplitQuotedPrintableString.
Jan 28, 2006  V1.05 Gerhard Rattinger fixed TSysCharSet for Delphi 3
Dec 14, 2006  V1.06 Updated Base64Decode to ignore CR and LF


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}


interface

  function Base64Encode(Input : String) : String;
  function Base64Decode(Input : String) : String;

implementation

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
const
    Base64Out: array [0..64] of Char = (
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
        'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
        'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
        'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/', '='
    );
    Base64In: array[0..127] of Byte = (
        255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255,  62, 255, 255, 255,  63,  52,  53,  54,  55,
         56,  57,  58,  59,  60,  61, 255, 255, 255,  64, 255, 255, 255,
          0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,
         13,  14,  15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,
        255, 255, 255, 255, 255, 255,  26,  27,  28,  29,  30,  31,  32,
         33,  34,  35,  36,  37,  38,  39,  40,  41,  42,  43,  44,  45,
         46,  47,  48,  49,  50,  51, 255, 255, 255, 255, 255
    );


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

function Base64Encode(Input : String) : String;
var
    Final : String;
    Count : Integer;
    Len   : Integer;
begin
    Final := '';
    Count := 1;
    Len   := Length(Input);
    while Count <= Len do begin
        Final := Final + Base64Out[(Byte(Input[Count]) and $FC) shr 2];
        if (Count + 1) <= Len then begin
            Final := Final + Base64Out[((Byte(Input[Count]) and $03) shl 4) +
                                       ((Byte(Input[Count+1]) and $F0) shr 4)];
            if (Count+2) <= Len then begin
                Final := Final + Base64Out[((Byte(Input[Count+1]) and $0F) shl 2) +
                                           ((Byte(Input[Count+2]) and $C0) shr 6)];
                Final := Final + Base64Out[(Byte(Input[Count+2]) and $3F)];
            end
            else begin
                Final := Final + Base64Out[(Byte(Input[Count+1]) and $0F) shl 2];
                Final := Final + '=';
            end
        end
        else begin
            Final := Final + Base64Out[(Byte(Input[Count]) and $03) shl 4];
            Final := Final + '==';
        end;
        Count := Count + 3;
    end;
    Result := Final;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Base64Decode(Input : String) : String;
var
    Final   : String;
    Count   : Integer;
    Len     : Integer;
    DataIn0 : Byte;
    DataIn1 : Byte;
    DataIn2 : Byte;
    DataIn3 : Byte;
begin
    Final := '';
    Count := 1;
    Len   := Length(Input);
    while Count <= Len do begin
        if Input[Count] in [#13, #10] then
            Inc(Count)
        else begin
            DataIn0 := Base64In[Byte(Input[Count])];
            DataIn1 := Base64In[Byte(Input[Count+1])];
            DataIn2 := Base64In[Byte(Input[Count+2])];
            DataIn3 := Base64In[Byte(Input[Count+3])];

            Final := Final + Char(((DataIn0 and $3F) shl 2) +
                                  ((DataIn1 and $30) shr 4));
            if DataIn2 <> $40 then begin
                Final := Final + Char(((DataIn1 and $0F) shl 4) +
                                      ((DataIn2 and $3C) shr 2));
                if DataIn3 <> $40 then
                    Final := Final + Char(((DataIn2 and $03) shl 6) +
                                          (DataIn3 and $3F));
            end;
            Count := Count + 4;
        end;
    end;
    Result := Final;
end;

end.
