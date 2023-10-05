#!/bin/awk -f
@include "mycolors.awk"

BEGIN {
    FS="[ :|=,]";
    printf("| %14s |","Username");
    printf(" %3s | %3s | %3s |", "N-R", "O-R", "R");
    printf("\n");

    printf("| %14s |","--------------");
    printf(" %3s + %3s + %3s |", "---", "---", "---");
    printf("\n");
}
{
    if ($1 == "G>") {
        # for overcap jobs, assign lab arbitrarily
        if ($14 == "overcap"){
            lab=user_to_lab[$2]
        }
        else{
            lab=$13
        }
        gpu_counts[lab][$2][$3]+=$12;
        gpu_counts[lab][$2][$3,$4]+=$12;

        gpu_counts[lab][$2]["R"]+=0;
        gpu_counts[lab][$2]["R","normal"]+=0;
        gpu_counts[lab][$2]["R","overcap"]+=0;

        labs_to_gpus_used[lab][$3]+=$12;
        lab_totals[lab][$3]+=$12;
        lab_totals[lab][$3,$4]+=$12;
    } else {
        if ($5 == "gres/gpu") {
            labs_to_gpus[$1] += $12;
            labs_to_cpus[$1] += $4;
        } else {
            if ($1 != "overcap") {
                user_to_lab[$2]=$1;
            }
        }
    }
}
END {
    for (lab in labs_to_gpus) {
        if (lab == "guest-lab") {
            continue;
        }
        if (length(labfilter) != 0) {
            if (substr(lab, 0, length(lab)-4) != substr(labfilter,3)) {
                continue;
            }
        }
        print_str = sprintf("[ %d/%d/%d ]", labs_to_gpus_used[lab]["R"], labs_to_gpus_used[lab]["PD"], labs_to_gpus[lab])
        printf("| %14s | %-15s |\n", lab, print_str);
        if (lab in gpu_counts) {
            for (name in gpu_counts[lab]){
                printf("| %14s |",name);

                # printf(" %3d |",gpu_counts[name]["R","normal"]);
                # printf(" %3d |",gpu_counts[name]["R","overcap"]);
                # printf(" %3d |",gpu_counts[name]["R"]);

                # Colorized
                printf(" %s |",colour_int(gpu_counts[lab][name]["R","normal"]));
                printf(" %s |",colour_int(gpu_counts[lab][name]["R","overcap"]));
                printf(" %s |",colour_int(gpu_counts[lab][name]["R"]));

                printf("\n");
            }
        }
        printf("| %14s |","");
        printf(" %3s + %3s + %3s |", "---", "---", "---");
        printf("\n");

        printf("| %14s :","totals");
        printf(" %3d |",lab_totals[lab]["R","normal"]);
        printf(" %3d |",lab_totals[lab]["R","overcap"]);
        printf(" %3d |",lab_totals[lab]["R"]);
        printf("\n");

        printf("| %14s |","--------------");
        printf(" %3s + %3s + %3s |", "---", "---", "---");
        printf("\n");
    }
}
