type file;

file wc_script <"wordCount.py">;
file m_script <"merge.py">;
file f_py <"final.py">

app (file outfile[]) wordCount (file infile, int index, int reduceNum, file wc_script)
{
    python @wc_script index reduceNum @infile;
}

app (file outfile) merge (file[] infiles, file m_script)
{
    python @m_script @filenames(infiles) stdout=@outfile;
}

app (file outfile) final (file[] infiles, file f_py)
{
    f_script @filenames(infiles) stdout=@outfile;
}

int reduceNum = toInt(arg("reduceNum",   "16"));

file infile[] <filesys_mapper;pattern="split-*", location="input">;

tracef("test\n");
foreach f,i in infile {
//    tracef("%s\n",@f);
    string pf="countInter-"+@toString(i)+"-";
    tracef("%s\n",pf);
    file interfiles[] <filesys_mapper; prefix=pf, location="output">;
    interfiles=wordCount(f,i,reduceNum,wc_script);
}

file finalinputs[];

foreach i in [0:reduceNum] {
    string pf="countInter-";
    string sf="-"+@toString(i);
    string ofn="output/result-"+@toString(i);
    file reduceinfiles[] <filesys_mapper; prefix=pf, suffix=sf, location="output">;
    file mfile <ofn>;
    mfile=merge(reduceinfiles,m_script);
    finalinputs[i]=mfile;
}

file ffile <"output/finalresult.txt">;

ffile=merge(finalinputs, f_py);