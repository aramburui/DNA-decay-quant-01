macro "Batch Split_color_adjustment" { //the curly braces notation will indicate when the macro starts and finishes
	format=".tif";
	showMessage("Select Input Directory"); //pops-up
	inputDirectory=getDirectory("Choose input Directory"); //inputDirectory will hold the location of the directory where the files are opened from
	print("Input:" + inputDirectory);
	fileList=getFileList(inputDirectory);// it returns a list of files in a directort (without a filter)
// filelist is a variable that contains a list (called arrays)
	nFiles=fileList.length ;
	print("Number of files:" + nFiles);
	showMessage("Select output Directory");
	outputDir=getDirectory("Choose output Directory"); //inputDirectory will hold the location of the directory where the files are opened from
	print("Output:" + outputDir);
	//setBatchMode(true); //it will supress graphical output, goes into batchmode
	for (fileIndex = 0; fileIndex < nFiles; fileIndex++){
		fullFileName=inputDirectory +File.separator+ fileList[fileIndex]; //File separator will include a fileseparator in the printed name
		if(endsWith(fullFileName, format)){
			print(fullFileName +" is a valid file.");
					//imageTitle=getTitle() //imageTitle will now correspond with the title of your opened fil
						run("TIFF Virtual Stack...", "open=["+ fullFileName +"]");
						//run("Bio-Formats Importer", "open=["+ fullFileName +"]");//the commas here avid the concatenation of the string. Opensa the image with Bio-Format
						//If a stack opens which means 3 channels intertwined you need to run the command below stack to hyperstack and change the number of frames
						//run("Stack to Hyperstack...", "order=xyczt(default) channels=3 slices=1 frames=44 display=Color");
						imageTitle=getTitle();
						run("Set Scale...", "distance=6.1462 known=1 unit=µm");
	//run("Stack to Hyperstack...", "order=xyczt(default) channels=3 slices=1 frames=80 display=Color");
						run("Split Channels");
						Ch1="C1-"+imageTitle; //this is the sytox channel
						Ch2="C2-"+imageTitle; //This belongs to the DAPI channel
						Ch3="C3-"+imageTitle; //this is the BF channel
						Merge_title=imageTitle;	
	//selectWindow("C3-"+imageTitle);		
	//close();		

						selectWindow("C2-"+imageTitle);
						setSlice(5);
						run("Duplicate...", "title=[total_nuclei]");
						run("Enhance Contrast", "saturated=0.35");
						run("Convert to Mask", "method=Otsu background=Dark");
						run("Fill Holes");
						saveAs("Tiff", ""+outputDir+"Mask_totNucl_"+Merge_title+"");
						selectWindow("Mask_totNucl_"+Merge_title+"");
						run("Set Measurements...", "mean stack display redirect=None decimal=2");
						run("Analyze Particles...", "size=10-200 show=Outlines display exclude include add");
						saveAs("Tiff", ""+outputDir+"drawing_"+imageTitle+"");
						run("Clear Results");
						roiManager("save", ""+outputDir+"Roi_"+imageTitle+".zip");
						selectWindow(Ch1);
						roiManager("deselect")
						roiManager("multi measure")
						saveAs("Results", ""+outputDir+"Results_sytox"+imageTitle+".csv");
						run("Clear Results");
						selectWindow(Ch2);
						roiManager("deselect")
						roiManager("multi measure")
						saveAs("Results", ""+outputDir+"Results_dapi"+imageTitle+".csv");
						roiManager("delete")
						print(Merge_title+"_Done!");
						close();
						close("*");
					}else {
		print(fullFileName +" is not a valid file.");
		}
	}
	print("Images analyzed!!");
	close("*");
}
	//close();
