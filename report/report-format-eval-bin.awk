BEGIN{
FS=" ";
	
}
NR==1{
	for ( i=1 ; i <=NF; i++ ) {
		printf("%s & ",$i)
    }
    print "\\\\"
}
NR>1{
	printf("%s & ",$1)
	printf("%s & ",$2) 
	for ( i=3 ; i <=NF-1 ; i++ ) {
		printf("%.1f & ",$i*100)
    }
    printf("%.1f ",$NF*100)
    print "\\\\"
}
