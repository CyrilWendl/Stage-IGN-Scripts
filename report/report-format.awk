BEGIN{
	FS=" ";
	print "\\begin{table}[H]"
	print "\t\\centering"
	print "\t\\begin{tabular}{p{1.8cm}llllll}\\toprule"
}
NR==1{
	printf("\t\t\\multicolumn{2}{c}{\\textbf{Classification}}& \\textbf{Kappa} [\\%] & \\textbf{OA} [\\%] & \textbf{AA}[\\%] & \\textbf{Fm} [\\%] & \textbf{Fb} [\\%]\\\\hline")
	for ( i=1 ; i <=NF-1 ; i++ ) {
		printf("%s & ",$i)
    }
    printf("%s ",$NF)
    print "\\\\"
}
NR==2{
	printf("\t\t")
	printf("\\multirow{2}{*}{Direct} ")
}

NR==4{
	printf("\t\t")
	printf("\\multirow{20}{*}{Fusion weighted} ")
}

NR==24{
	printf("\t\t")
	printf("\\multirow{3}{*}{\\parbox{1.8cm}{Fusion by classification}} ")
}

NR==27{
	printf("\t\t")
	printf("\\multirow{2}{*}{Regularization} ")
}

NR>1{
	printf("\t\t& %s & ",$1) 
	for ( i=2 ; i <=NF-1 ; i++ ) {
		printf("%.1f & ",$i*100)
    }
    printf("%.1f ",$NF*100)
    print "\\\\"
}
END{
	print "\t\\bottomrule"
	print "\t\\end{tabular}"
	print "\t\\caption{}"
	print "\t\\label{table:eval}"
 	print "\\end{table}"
}
