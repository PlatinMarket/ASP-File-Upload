$.fn.platinForm = function (options){

        var settings = $.extend({
			hiddenInput: "display: none; visibility: hidden; position: absolute; top:-100px; left:-100px",
            createInput: "<input type='file' name='files[]' multiple>",
            createSelect: "<span class='btn btn-success fileinput-button'><i class='glyphicon glyphicon-plus'></i><span>Dosya Seç...</span></span>",
			progressContainer: "<div class='container progress_container'></div>",
			createFileProgress: "<div class='col-xs-2 progress_col'><div class='uploaded-name'></div><div class='uploaded-img'></div><div class='progress'><div class='progress-bar' role='progressbar' style='width:0%;'>0%</div></div></div>",
			createDragArea: "<div class='dragArea'>Görsellerinizi Buraya Sürükleyin</div>"
        }, options );
		
/*	var hiddenInput = {'display': "none", 'visibility': "hidden", 'position': "absolute", 'top':"-100px", 'left':"-100px"};
	var createInput = "<input type='file' name='files[]' multiple>";
	var createSelect = "<span class='btn btn-success fileinput-button'><i class='glyphicon glyphicon-plus'></i><span>Dosya Seç...</span></span>";
	var progressContainer = "<div class='container progress_container'></div>"
	var createFileProgress = "<div class='col-xs-2 progress_col'><div class='uploaded-name'></div><div class='uploaded-img'></div><div class='progress'><div class='progress-bar' role='progressbar' style='width:0%;'>0%</div></div></div>"
	var createDragArea = "<div class='dragArea'>Kaydýr Býrak bak ne olacak!</div>"
*/
	if ($(this).length > 0) {
		
		$.each(this, function(index, element) {
			if (this.nodeName != 'INPUT' && $(this).attr("type") != 'file')  {
				console.log('elin boþ gelmiþin');
				var firstInput = $(settings.createInput);
				$(element).after(firstInput);
				element = firstInput[0];
			} else {
				console.log('çok doðru gelmiþin');
			}
			
			
			$(element).on('change', prepareUpload);
			$(element).attr("style",settings.hiddenInput);
			var newInput = $(settings.createSelect);
			$(element).after(newInput);
			var progCont = $(settings.progressContainer)
			newInput.after(progCont);
			newInput.click(function(){
				return $(this).prev("input").click();
			});
			
			var dragArea = $(settings.createDragArea)[0];
			newInput.after(dragArea); /* drag and drop bölgesini oluþturalým */
			
			/* drag and drop start */

			dragArea.ondragover = function () { this.className = 'dragArea hover'; return false; };
			dragArea.ondragleave = function () { this.className = 'dragArea'; return false; };
			dragArea.ondrop = prepareDropUpload;
			/* drag and drop end */
		});	
	} else {
		console.log("Ýstenen nesne bir dosya yükleyici deðil");
	}
	
	function prepareDropUpload(event){
		for (var index in event.dataTransfer.files) {event.dataTransfer.files[index]["base"] = $(event.target).next();}
		$.each(event.dataTransfer.files, uploadMe);
		event.stopPropagation();
		event.preventDefault(); 
	};
	
	function prepareUpload(event){

		//console.log(event.target.files);
		//$(event.target).val('');
		for (var index in event.target.files) {event.target.files[index]["base"] = $(event.target).next().next().next();}
		$.each(event.target.files, uploadMe);
		event.stopPropagation();
		event.preventDefault(); 
		$(event.target).off('change').css(settings.hiddenInput);
		var newInput = $(settings.createInput);
		newInput.attr("style",settings.hiddenInput);
		newInput.on('change', prepareUpload);
		$(event.target).after(newInput);
	};
	function uploadMe(){
		//console.log(this.base);
		console.log(this.type);
		var fileProgress = $(settings.createFileProgress);
		
		this.base.append(fileProgress);
		
		
		
		/* file reader */
		$(fileProgress).find(".uploaded-name").append(this.name);
		
		var reader = new FileReader();
		reader.onloadend = function(e) {
		console.log(e.target);
			var image = $('<img height=50>').attr('src', e.target.result);
			fileProgress.find(".uploaded-img").append(image);
		};
		if (this.type.toString().indexOf('image') >-1) {
			reader.readAsDataURL(this);
		} else {
		
		}


		/* file reader end*/
		
		
		var data = new FormData();
		data.append(0, this);

		
		var ajaxObj = $.ajax({
			xhr: function() {
				var xhr = new window.XMLHttpRequest();
				xhr.upload.addEventListener("progress", function(evt) {
					if (evt.lengthComputable) {
						var percentComplete = (evt.loaded / evt.total) * 100;
						console.log(percentComplete);
						fileProgress.addClass("in");
						fileProgress.find(".progress-bar").css("width", Math.round(percentComplete.toString()) + "%");
						fileProgress.find(".progress-bar").html(Math.round(percentComplete.toString()) + "%");
					}
			   }, false);

			   xhr.addEventListener("progress", function(evt) {
				   if (evt.lengthComputable) {
					   var percentComplete = evt.loaded / evt.total;
					   console.log("evet:" + percentComplete.toString() + "%");
					   //Do something with download progress
				   }
			   }, false);

			   return xhr;
			},
			url: 'uploader.asp?islem=kaydet',
			type: 'POST',
			data: data,
			cache: false,
			dataType: 'html',
			progress: function(){
				console.log(arguments);
			},
			processData: false, // Don't process the files
			contentType: false, // Set content type to false as jQuery will tell the server its a query string request
			success: function(data, textStatus, jqXHR)
			{
				if(typeof data.error === 'undefined')
				{
					// Success so call function to process the form
					console.log("baþarýlý");
					console.log(data);
					console.log(jqXHR.status);
					$(".fileupload-progress .progress").removeClass("active");
					$(".fileupload-progress .progress div").removeClass("progress-bar-info");
					$(".fileupload-progress .progress div").addClass("progress-bar-success");
				}
				else
				{
					// Handle errors here
					console.log('ERRORS: ' + data.error);
					$(".fileupload-progress .progress").removeClass("active");
					$(".fileupload-progress .progress div").removeClass("progress-bar-info");
					$(".fileupload-progress .progress div").addClass("progress-bar-danger");
				}
			},
			error: function(jqXHR, textStatus, errorThrown)
			{
				// Handle errors here
				console.log('ERRORS: ' + textStatus);

				
			}
		});
	};	
}