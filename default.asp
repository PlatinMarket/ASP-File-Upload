<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><head>
<link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css">
<link rel="stylesheet" href="css/style.css">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-9" />
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<title>ASP File Uploader</title>
<script type="text/javascript" src="js/jquery.min.js"></script>
<script type="text/javascript" src="js/PlatinUploader.js"></script>

</head>

<body>

<form style="margin:0;padding:0;" method="post" enctype="multipart/form-data" action="uploader.asp?islem=kaydet" onsubmit="document.getElementById('resim_gonder_btn').disabled='disabled';" autocomplete="off">
	<input type="file" name="resim_kaynak" id="resim_kaynak" style="padding:4px;width:300px;" />
</form>
<script>
$("#resim_kaynak").platinForm();
</script>
</body>

</html>
