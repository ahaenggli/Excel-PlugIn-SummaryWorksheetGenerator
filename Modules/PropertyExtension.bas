Attribute VB_Name = "PropertyExtension"
Option Explicit

' list of all used properties in sheet
Private Sub ListAllCustomProps(Optional ws As Worksheet)
    Dim xx As CustomProperty
    If ws Is Nothing Then Set ws = Application.ActiveSheet
    For Each xx In ws.CustomProperties
        MsgBox xx.Name & vbTab & xx.Value
    Next xx
End Sub
Private Sub lstAllProps()
    ListAllCustomProps ThisWorkbook.Worksheets(1)
End Sub

' delete all properties in ActiveSheet
Private Sub DeleteAllCustomProps(Optional ws As Worksheet)
 Dim xx As CustomProperty
 If ws Is Nothing Then Set ws = Application.ActiveSheet
    For Each xx In ws.CustomProperties
        xx.Delete
    Next xx
End Sub
Private Sub delAllProps()
    DeleteAllCustomProps ThisWorkbook.Worksheets(1)
    ThisWorkbook.RemovePersonalInformation = True
End Sub

' get id of custom property by name
Private Function getPropId(Optional ws As Worksheet, Optional propName As String) As Integer
Dim id, tmp As Integer
Dim xx As CustomProperty

    If ws Is Nothing Or propName = "" Then
      getPropId = 0
      Exit Function
    End If
 
id = 0
For Each xx In ws.CustomProperties
    tmp = tmp + 1
    If LCase(xx.Name) = LCase(propName) Then
        id = tmp
        Exit For
    End If
Next xx

getPropId = id
End Function

'rename and overwrite property
Public Sub propertyRename(WB As Workbook, propNameOld As String, propNameNew As String)
    Dim ws As Worksheet
    For Each ws In WB.Worksheets
        Call setProperty(ws, propNameNew, getProperty(ws, propNameOld))
        Call setProperty(ws, propNameOld, "")
    Next ws
End Sub

' get value of custom property by name, default propName is "Tag"
Public Function getProperty(Optional ws As Worksheet, Optional propName As String) As String
Dim propId As Integer

 If ws Is Nothing Or propName = "" Then
    getProperty = ""
    Exit Function
 End If
 
 propId = getPropId(ws, propName)
 
 If propId > 0 Then
    With ws.CustomProperties.Item(propId)
       getProperty = .Value
    End With
 Else
    getProperty = ""
 End If
End Function

'set value of custom propery by name, default propName is "Tag"
Public Sub setProperty(Optional ws As Worksheet, Optional propName As String, Optional propVal As String)
Dim propId As Integer
    
    If ws Is Nothing Or propName = "" Then
        Exit Sub
    End If
    
    propId = getPropId(ws, propName)

    'delete if exists
    If propId > 0 Then
        ws.CustomProperties.Item(propId).Delete
    End If

    ' Add metadata to worksheet.
    If propVal <> "" Then ws.CustomProperties.Add Name:=propName, Value:=propVal
 
End Sub

'Open PropertyExtensionForm to edit or add properties on a sheet
Public Sub ShowPropEditForm()
    PropertyExtensionForm.setSheet ActiveWorkbook.ActiveSheet
    PropertyExtensionForm.Show
End Sub
