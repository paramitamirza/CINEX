import sys

crfout = sys.argv[1]
lstmout = sys.argv[2]
crf = open(crfout, "r")
lstm = open(lstmout, "r")
#combined_out = open(crfout.replace(".out", ".lstm.out"), "w")

crflines = crf.readlines()
lstmlines = lstm.readlines()

for i in range(len(crflines)):
    crfline = crflines[i].strip()
    lstmline = lstmlines[i].strip()

    cols = crfline.split('\t')
    if len(cols) == 1:
        #combined_out.write(lstmline + '\n')
        print(lstmline)
    else:
        #combined_out.write('\t'.join(cols[:9]) + '\t' + lstmline + '\n')
        tags = lstmline.split('\t')
        labels = ["O", "_COMP_", "_YES_"]
        lstmtags = ["", "", ""]
        for tag in tags:
            lblStr = tag.split("/")[0]
            lblScr = tag.split("/")[1]
            lstmtags[labels.index(lblStr)] = tag

        print('\t'.join(cols[:9]) + '\t' + tags[0] + '\t' + '\t'.join(lstmtags))

