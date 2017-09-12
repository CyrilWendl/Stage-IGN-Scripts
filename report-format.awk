BEGIN{
FS=" ";
	
}
NR==1{
	print $0
}
NR>1{
	printf("%s & ",$1) 
	for ( i=2 ; i <=NF-1 ; i++ ) {
		printf("%.1f & ",$i*100)
    }
    printf("%.1f ",$NF*100)
    print "\\\\"
}
