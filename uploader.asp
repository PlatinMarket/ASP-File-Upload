<%
If Request.QueryString("islem") = "kaydet" Then

	Server.ScriptTimeOut = 5000

	Function TR2ENG(gelenveri)

		gelenveri = Trim(LCase(gelenveri))
		If Len(gelenveri) = 0 Then Exit Function

			 gelenveri = Replace(gelenveri ,Chr(32),"_",1,-1,0) ' space
			 gelenveri = Replace(gelenveri ,Chr(208),"g",1,-1,0)
			 gelenveri = Replace(gelenveri ,Chr(240),"g",1,-1,0)
			 gelenveri = Replace(gelenveri ,Chr(222),"s",1,-1,0)
			 gelenveri = Replace(gelenveri ,Chr(254),"s",1,-1,0)
			 gelenveri = Replace(gelenveri ,Chr(199),"c",1,-1,0)
			 gelenveri = Replace(gelenveri ,Chr(231),"c",1,-1,0)
			 gelenveri = Replace(gelenveri ,Chr(221),"i",1,-1,0)
			 gelenveri = Replace(gelenveri ,Chr(236),"i",1,-1,0)
			 gelenveri = Replace(gelenveri ,Chr(253),"i",1,-1,0)
			 gelenveri = Replace(gelenveri ,Chr(237),"i",1,-1,0)
			 gelenveri = Replace(gelenveri ,Chr(214),"o",1,-1,0)
			 gelenveri = Replace(gelenveri ,Chr(246),"o",1,-1,0)
			 gelenveri = Replace(gelenveri ,Chr(252),"u",1,-1,0)
			 gelenveri = Replace(gelenveri ,Chr(220),"u",1,-1,0)

		Set objReg = New RegExp
			With objReg
				.Global = True
				.IgnoreCase = True
				.Pattern = "[^a-zA-Z0-9_.]"
			End With
		gelenveri = objReg.Replace(gelenveri,"")
		RegReplace = gelenveri

		Set objReg = Nothing

		TR2ENG = gelenveri 

	End Function

	Set DosyaYukle = Server.CreateObject("Persits.Upload")

	DosyaYukle.SetMaxSize 1000000, False
	DosyaYukle.OverwriteFiles = False

	On Error Resume Next

	DosyaYukle.Save(Server.Mappath("/tempo/"))

	If Err.Number = 8 Then
		Response.Write "<script>alert('Dosya boyutu en fazla 1 Mb olmalý.');window.location.href='urun_resim_gonder.asp';</script>"	
	Else
		If Err <> 0 Then
			Response.Write "<script>alert('Hata algýlandý.');</script>"	
		Else
			Set ResimDosyam = DosyaYukle.Files(1)
			resim_isim_on_ek = Year(Date)&Month(Date)&Day(Date)&Hour(Time)&Minute(Time)&Second(Time)
			resim_ismim_eski = ResimDosyam.FileName
			resim_ext = "["&LCASE(ResimDosyam.Ext)&"]"
			uzantilarim = "[.jpg][.jpeg][.jpe][.gif][.bmp][.png]"
			resim_ismim = TR2ENG(ResimDosyam.FileName)
			
			If ResimDosyam.ImageType = "UNKNOWN" Or Instr(uzantilarim,resim_ext) = 0 Then
				ResimDosyam.Delete
				Response.Write "<script>alert('Dosya resim olmalý.');window.location.href='urun_resim_gonder.asp';</script>"	
			Else
				ResimDosyam.SaveAs Server.Mappath("/pictures/"&resim_isim_on_ek&"_"&resim_ismim)

				Set Jpeg = Server.CreateObject("Persits.Jpeg")
				Jpeg.Open(Server.Mappath("/pictures/"&resim_isim_on_ek&"_"&resim_ismim))
				
				'/////////// 200 px
				genislik_200 = application("urun_resmi_orta_genislik")+0
				if genislik_200 > 1000 or genislik_200 < 200 then genislik_200 = 200
				yukseklik_200 = application("urun_resmi_orta_yukseklik")+0
				if yukseklik_200 > 1000 or yukseklik_200 < 200 then yukseklik_200 = 200

				
				Jpeg.PreserveAspectRatio = True

				DesiredWidth = genislik_200
				DesiredHeight = yukseklik_200

				If Jpeg.OriginalWidth / DesiredWidth > Jpeg.OriginalHeight / DesiredHeight Then
					Jpeg.Width = DesiredWidth
					dy = (DesiredHeight - Jpeg.Height) / 2
					dy1 = DesiredHeight - Jpeg.Height - dy
					dx = 0
					dx1 = 0
				Else
					Jpeg.Height = DesiredHeight
					dx = (DesiredWidth - Jpeg.Width) / 2
					dx1 = DesiredWidth - Jpeg.Width - dx
					dy = 0
					dy1 = 0
				End If

				' Apply negative cropping with white background
				Jpeg.Canvas.Brush.Color = &HFFFFFF
				Jpeg.Crop -dx, -dy, Jpeg.Width + dx1, Jpeg.Height + dy1
				Jpeg.Sharpen 1,120
				Jpeg.Quality = 80
				Jpeg.Save Server.Mappath("/pictures/200X-"&resim_isim_on_ek&"_"&resim_ismim)
				
				

				'///////// 100 pX
				genislik_100 = application("urun_resmi_kucuk_genislik")+0
				if genislik_100 > 500 or genislik_100 < 100 then genislik_100 = 100
				yukseklik_100 = application("urun_resmi_kucuk_yukseklik")+0
				if yukseklik_100 > 500 or yukseklik_100 < 100 then yukseklik_100 = 100
				Jpeg.PreserveAspectRatio = True

				DesiredWidth = genislik_100
				DesiredHeight = yukseklik_100

				If Jpeg.OriginalWidth / DesiredWidth > Jpeg.OriginalHeight / DesiredHeight Then
					Jpeg.Width = DesiredWidth
					dy = (DesiredHeight - Jpeg.Height) / 2
					dy1 = DesiredHeight - Jpeg.Height - dy
					dx = 0
					dx1 = 0
				Else
					Jpeg.Height = DesiredHeight
					dx = (DesiredWidth - Jpeg.Width) / 2
					dx1 = DesiredWidth - Jpeg.Width - dx
					dy = 0
					dy1 = 0
				End If

				' Apply negative cropping with white background
				Jpeg.Canvas.Brush.Color = &HFFFFFF
				Jpeg.Crop -dx, -dy, Jpeg.Width + dx1, Jpeg.Height + dy1
				Jpeg.Sharpen 1,120
				Jpeg.Quality = 80
				Jpeg.Save Server.Mappath("/pictures/100X-"&resim_isim_on_ek&"_"&resim_ismim)
				
				Jpeg.Close
				Set Jpeg = Nothing

				Set DosyaSil = Server.CreateObject("scripting.filesystemobject")
				DosyaSil.DeleteFile(Server.Mappath("/tempo/"&resim_ismim_eski))
				Set DosyaSil = Nothing
				
				Response.Write "<script>parent.resim_ekle('"&resim_isim_on_ek&"_"&resim_ismim&"',1);alert('Resim baþarýyla gönderildi.');window.location.href='urun_resim_gonder.asp';</script>"	
								
			End If
			Set ResimDosyam = Nothing
	   End If
	End If
	
	Set DosyaYukle = Nothing
End If
%>