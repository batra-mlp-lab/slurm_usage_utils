#!/bin/awk -f
@include "/nethome/mxu87/slurm_usage_utils/mycolors.awk"

BEGIN {
    FS="[ :|=,]";
}
{
    if ($1 == "G>") {
        # for overcap jobs, assign lab arbitrarily
        if ($14 == "overcap") {
            lab=user_to_lab[$2]
        }
        else {
            lab=$13
        }
        
        # $8 : # of nodes
        # $15: gpu or N/A. if N/A grab the # of GPUs from tres-alloc
        # $16: #GPU per nodes
        # $17+: list of nodes

        if ($15 == "N/A") {
            num_gpus = $12;
            node_name = $16;
            
            if (node_name in node_to_type) {
                node_type = node_to_type[node_name];
            } else {
                node_type="";
            }

            if (node_type!="") {
                # GPU Counts
                gpu_counts[lab][$2][node_type][$3]+=num_gpus;
                gpu_counts[lab][$2][node_type][$3,$4]+=num_gpus;

                lab_gpu_totals[lab][node_type][$3]+=num_gpus;
                lab_gpu_totals[lab][node_type][$3,$4]+=num_gpus;
            }
        
        } else {
        
            i = 17;
            i_max = i + $8;
            while (i < i_max) {
                num_gpus = $16;
                node_name = $i;
                
                if (node_name in node_to_type) {
                    node_type = node_to_type[node_name];
                } else {
                    node_type="";
                }

                if (node_type!="") {
                    # GPU Counts
                    gpu_counts[lab][$2][node_type][$3]+=num_gpus;
                    gpu_counts[lab][$2][node_type][$3,$4]+=num_gpus;

                    lab_gpu_totals[lab][node_type][$3]+=num_gpus;
                    lab_gpu_totals[lab][node_type][$3,$4]+=num_gpus;
                }
            
                i=i+1;
            }
        }
        
        for (t in all_types) {
            gpu_counts[lab][$2][t]["R"]+=0;
            gpu_counts[lab][$2][t]["PD"]+=0;
            gpu_counts[lab][$2][t]["CG"]+=0;

            gpu_counts[lab][$2][t]["R","normal"]+=0;
            gpu_counts[lab][$2][t]["PD","normal"]+=0;
            gpu_counts[lab][$2][t]["CG","normal"]+=0;
            gpu_counts[lab][$2][t]["R","overcap"]+=0;
            gpu_counts[lab][$2][t]["PD","overcap"]+=0;
            gpu_counts[lab][$2][t]["CG","overcap"]+=0;
            
            lab_gpu_totals[lab][t]["R"]+=0;
            lab_gpu_totals[lab][t]["PD"]+=0;
            lab_gpu_totals[lab][t]["CG"]+=0;
            
            lab_gpu_totals[lab][t]["R","normal"]+=0;
            lab_gpu_totals[lab][t]["PD","normal"]+=0;
            lab_gpu_totals[lab][t]["CG","normal"]+=0;
            lab_gpu_totals[lab][t]["R","overcap"]+=0;
            lab_gpu_totals[lab][t]["PD","overcap"]+=0;
            lab_gpu_totals[lab][t]["CG","overcap"]+=0;
 
        }

        labs_to_gpus[lab]=0;
    
    } else {
        if (($1 != "AVAIL_FEATURES") && ($1 != "(null)")) {
            all_types[$1] = 0;
            node_to_type[$2] = $1;
        }
    }
}
END {
    printf("| %14s |","Username");
    printf(" %52s | |","Normal");
    printf(" %52s | |","Overcap");
    printf(" %52s |","ALL");
    printf(" |");
    printf("\n");
    
    printf("| %14s |","--------------");
    for (i=0; i<3; i++){
        for (type in all_types) {
            printf(" %8s |", type);
        }
        printf(" |");
    }
    printf("\n");
    
    printf("| %14s |","--------------");
    for (i=0; i<3; i++){
        for (type in all_types) {
            printf("  %s %s %s |", "R", "PD", "CG");
        }
        printf(" |");
    }
    printf("\n");

    printf("| %14s |","--------------");
    for (i=0; i<3; i++){
        for (type in all_types) {
            printf("  %s %s %s |", "-", "--", "--");
        }
        printf(" |");
    }
    printf("\n");
    
    for (lab in labs_to_gpus) {
        if (lab == "guest-lab") {
            continue;
        }
        if (lab == "") {
            continue;
        }
        
        printf("| %14s == %167s |\n", lab, "----------------------------------------------------------------------------------------------------------------------------------------------------------------------");

        if (lab in gpu_counts) {
            for (name in gpu_counts[lab]) {
                printf("| %14s |",name);
                for (type in gpu_counts[lab][name]) {
                    printf("%s",colour_int(gpu_counts[lab][name][type]["R","normal"]));
                    printf("%s",colour_int_blue(gpu_counts[lab][name][type]["PD","normal"]));
                    printf("%s",colour_int_red(gpu_counts[lab][name][type]["CG","normal"]));
                    printf(" |");
                }
                printf(" |");

                for (type in gpu_counts[lab][name]) {
                    printf("%s",colour_int(gpu_counts[lab][name][type]["R","overcap"]));
                    printf("%s",colour_int_blue(gpu_counts[lab][name][type]["PD","overcap"]));
                    printf("%s",colour_int_red(gpu_counts[lab][name][type]["CG","overcap"]));
                    printf(" |");
                }
                printf(" |");

                for (type in gpu_counts[lab][name]) {
                    printf("%s",colour_int(gpu_counts[lab][name][type]["R"]));
                    printf("%s",colour_int_blue(gpu_counts[lab][name][type]["PD"]));
                    printf("%s",colour_int_red(gpu_counts[lab][name][type]["CG"]));
                    printf(" |");
                }
                printf(" |");

                printf("\n");
            }
        }
        printf("| %14s |","--------------");
        for (i=0; i<3; i++){
            for (type in all_types) {
                printf("  %s %s %s |", "-", "--", "--");
            }
            printf(" |");
        }
        printf("\n");
 

        printf("| %14s :","totals");
        for (type in all_types) {
            printf("%s",  colour_int_custom(lab_gpu_totals[lab][type]["R","normal"], colour("Green"),3));
            printf("%s",  colour_int_custom(lab_gpu_totals[lab][type]["PD","normal"], colour("Blue"),3));
            printf("%s |",colour_int_custom(lab_gpu_totals[lab][type]["CG","normal"], colour("Red"),3));
        }
        printf(" |");
        for (type in all_types) {
            printf("%s",  colour_int_custom(lab_gpu_totals[lab][type]["R","overcap"], colour("Green"),3));
            printf("%s",  colour_int_custom(lab_gpu_totals[lab][type]["PD","overcap"], colour("Blue"),3));
            printf("%s |",colour_int_custom(lab_gpu_totals[lab][type]["CG","overcap"], colour("Red"),3));
        }
        printf(" |");
        for (type in all_types) {
            printf("%s",  colour_int_custom(lab_gpu_totals[lab][type]["R"], colour("Green"),3));
            printf("%s",  colour_int_custom(lab_gpu_totals[lab][type]["PD"], colour("Blue"),3));
            printf("%s |",colour_int_custom(lab_gpu_totals[lab][type]["CG"], colour("Red"),3));
        }
        printf(" |");
        printf("\n");

        printf("| %14s |","--------------");
        for (i=0; i<3; i++){
            for (type in all_types) {
                printf("  %s %s %s |", "-", "--", "--");
            }
            printf(" |");
        }
        printf("\n");

    }


}
