import sys

filename = sys.argv[1]
train = open(filename, "r")
#train_out = open(filename.replace(".data", ".txt"), "w")

for line in train.readlines():
    if line.strip() == "":
        #train_out.write("\n")
        print("")
    else:
        cols = line.strip().split('\t')
        if cols[3] == "-LRB-":
            #train_out.write("(" + " " + cols[8] + "\n")
            print("(" + " " + cols[8])
        elif cols[3] == "-RRB-":
            #train_out.write(")" + " " + cols[8] + "\n")
            print(")" + " " + cols[8])
        elif cols[3] == "-LCB-":
            #train_out.write("{" + " " + cols[8] + "\n")
            print("{" + " " + cols[8])
        elif cols[3] == "-RCB-":
            #train_out.write("}" + " " + cols[8] + "\n")
            print("}" + " " + cols[8])
        elif cols[3] == "-LSB-":
            #train_out.write("[" + " " + cols[8] + "\n")
            print("[" + " " + cols[8])
        elif cols[3] == "-RSB-":
            #train_out.write("]" + " " + cols[8] + "\n")
            print("]" + " " + cols[8])
        elif cols[4] == "_num_":
            #train_out.write("NUM" + " " + cols[8] + "\n")
            print("NUM" + " " + cols[8])
        elif cols[4] == "_ord_":
            #train_out.write("NUM" + " " + cols[8] + "\n")
            print("ORD" + " " + cols[8])	
        elif "LatinGreek_" in cols[3]:
            word = cols[3].split("_")[1]    #LatinGreek_trilogy_3
            #train_out.write("NUM" + " " + cols[8] + "\n")
            print(word + " " + cols[8])
        #elif cols[4] == "_propernoun_":
            #train_out.write("ENT" + " " + cols[8] + "\n")
            #print("$ENT$" + " " + cols[8])
        else:
            #train_out.write(cols[3] + " " + cols[8] + "\n")
            print(cols[3] + " " + cols[8])
