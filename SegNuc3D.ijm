// The default input and output folder
inputDir = "/dockershare/667/in/";
outputDir = "/dockershare/667/out/";

// Functional parameters
rad = 2;
thr = 10;
erod = 1;

arg = getArgument();
parts = split(arg, ",");

setBatchMode(true);
for(i=0; i<parts.length; i++) {
	nameAndValue = split(parts[i], "=");
	if (indexOf(nameAndValue[0], "input")>-1) inputDir=nameAndValue[1];
	if (indexOf(nameAndValue[0], "output")>-1) outputDir=nameAndValue[1];
	if (indexOf(nameAndValue[0], "rad")>-1) rad=nameAndValue[1];
	if (indexOf(nameAndValue[0], "thr")>-1) thr=nameAndValue[1];
	if (indexOf(nameAndValue[0], "erod")>-1) erod=nameAndValue[1];
}

images = getFileList(inputDir);

for(i=0; i<images.length; i++) {
	image = images[i];
	if (endsWith(image, ".tif")) {
		// Open image
		open(inputDir + "/" + image);
		// Workflow
		run("Gaussian Blur...", "sigma="+d2s(rad,0)+" stack");
		setThreshold(thr, 255);
		setOption("BlackBackground", false);
		run("Convert to Mask", "background=Dark");
		run("Fill Holes", "stack");
		run("Watershed", "stack");
		run("Minimum...", "radius="+d2s(erod,0)+" stack");
		save(outputDir + "/" + image);
		// Cleanup
		run("Close All");
	}
}
run("Quit");