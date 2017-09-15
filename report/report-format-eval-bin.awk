	BEGIN{
FS=" ";
	
}

NR==1{
	print "\\begin{table}[H]"
	print "\t\\centering"
	print "\t\\begin{tabular}{llp{1.5cm}llp{1.5cm}}"
	print "\t\t\\toprule"
	printf("\t\t\\textbf{Classification} & \\textbf{Ground Truth} & \\textbf{F-Score Buildings} & \\textbf{Kappa} & \\textbf{OA} & \\textbf{IoU buildings}")
}

NR==2{
	printf("\t\t\\multirow{3}{*}{Binary Regularization Input}")
}

NR==5{
	printf("\t\t\\multirow{3}{*}{Binary Sentinel-2 Input}")
}

NR==8{
	printf("\t\t\\multirow{3}{*}{Fusion Min}")
}



NR==11{
	printf("\t\t\\multirow{3}{*}{Regularization}")
}

NR==14{
	printf("\t\t\\multirow{3}{*}{Segmentation (cut=8)}")
}

(NR + 1) % 3 != 0{
	printf("\t\t")
}

NR>1{
	gsub("train_","",$2)
	printf("& %s & ",toupper($2)) 
	for ( i=3 ; i <=NF-1 ; i++ ) {
		printf("%.1f & ",$i*100)
    }
    printf("%.1f ",$NF*100)
}

(NR-1) % 3 == 0{
	print "\\\\\\hline"
}

(NR-1) % 3 != 0{
	print "\\\\"
}


END{
	print "\t\t\\bottomrule"
	print "\t\\end{tabular}"
	print "\t\\caption{Accuracy measures for Artificialized Area: F-Score for the buildings class, Kappa, Overall Accuracy (OA) and Intersection over Union (IoU) for the buildings class.}"
	print "\t\\label{table:accuracy-bin\\region}"
	print "\\end{table}"
}
