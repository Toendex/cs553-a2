type file;

file wc_script <"wordCount.py">;
file m_script <"merge.py">;
file f_py <"final.py">;

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

file reduceinfiles[][];

foreach f,i in infile {
//    tracef("%s\n",@f);
    string loc="output/"+toString(i);
//    tracef("infile location=%s\n",loc);
    file interfiles[] <filesys_mapper; pattern="*.txt", location=loc>;
    interfiles=wordCount(f,i,reduceNum,wc_script);
    foreach ff in interfiles {
        reduceinfiles[toInt(strcut(@ff,"([0-9]+).txt"))][i]=ff;
	tracef("%d:%s\n",toInt(strcut(@ff,"([0-9]+).txt")),@reduceinfiles[toInt(strcut(@ff,"([0-9]+).txt"))][i]);
    }
}

file finalinputs[];

foreach i in [0:reduceNum] {
    string ofn="output/result-"+toString(i)+".txt";
    tracef("reduceNum ofn=%s\n",ofn);
    file mfile <single_file_mapper;file=ofn>;
    foreach fff in reduceinfiles[i] {
	tracef("reduceinfiles:%d:file:%s\n",i,@fff);
    }
    mfile=merge(reduceinfiles[i],m_script);
    finalinputs[i]=mfile;
}

file ffile <"output/finalresult.txt">;

ffile=merge(finalinputs, f_py);
