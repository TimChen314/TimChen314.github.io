#!/usr/bin/awk -f
{
    if(/^title:/&&!/font/) {
        for(i=1;i<=NF;++i) {
            printf $i" ";
            if(i==1)
                printf " <font size=6><b>";
            else if(i==NF)
                printf "</b></font>\n" ;
        }
    }
    else
        print $0;
}
