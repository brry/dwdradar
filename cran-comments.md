The package was archived according to your email titled  
"CRAN packages using integer(kind=) or real(kind=) with numerical values."

I am sorry about responding too slowly.  
I have fixed the issue by using  
integer(KIND=SELECTED_INT_KIND(4)) instead of integer(KIND=2) and  
KIND=SELECTED_INT_KIND(2) instead of KIND=1.  

I based this on two resources:  
https://comp.lang.fortran.narkive.com/dY1o52Qs/declaration-to-get-8-bit-or-16-bit-integer  
https://stackoverflow.com/a/3170438

This works for all tested files and so I hope it is an acceptable way to do this.  
If not, a pointer to ressources would be appreciated, because I know little about Fortran

Thanks for all your efforts!
Berry
