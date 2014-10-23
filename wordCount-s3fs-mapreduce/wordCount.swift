type file;

file wc_script <"wordCount.py">;
file m_script <"merge.py">;
file f_script <"final.py">;

app (file outfile[]) wordCount (file infile, int index, int reduceNum)
{
    python "/s3/wordCount-s3fs-mapreduce/wordCount.py" index reduceNum @infile;
}

app (file outfile) merge (file[] infiles)
{
    python "/s3/wordCount-s3fs-mapreduce/merge.py" @filenames(infiles) stdout=@outfile;
}

app (file outfile) final (file[] infiles)
{
    python "/s3/wordCount-s3fs-mapreduce/final.py" @filenames(infiles) stdout=@outfile;
}

int reduceNum = toInt(arg("reduceNum",   "16"));

file infile[] <filesys_mapper;pattern="split-*", location="/s3/wordCount-s3fs-mapreduce/input">;

file reduceinfiles[][];

foreach f,i in infile {
//    tracef("%s\n",@f);
    string loc="/s3/wordCount-s3fs-mapreduce/output/"+toString(i);
//    tracef("infile location=%s\n",loc);
    file interfiles[] <filesys_mapper; pattern="*.txt", location=loc>;
    interfiles=wordCount(f,i,reduceNum);
    foreach ff in interfiles {
        reduceinfiles[toInt(strcut(@ff,"([0-9]+)\\.txt"))][i]=ff;
    }
}

file finalinputs[];

foreach i in [0:reduceNum] {
    string ofn="/s3/wordCount-s3fs-mapreduce/output/result-"+toString(i)+".txt";
//    tracef("reduceNum ofn=%s\n",ofn);
    file mfile <single_file_mapper;file=ofn>;
    file rfs[]=reduceinfiles[i];
//    foreach fff in rfs {
//	tracef("reduceinfiles:%d:file:%s\n",i,@fff);
//    }
    mfile=merge(rfs);
    finalinputs[i]=mfile;
}

file ffile <"/s3/wordCount-s3fs-mapreduce/output/finalresult.txt">;

ffile=merge(finalinputs);
