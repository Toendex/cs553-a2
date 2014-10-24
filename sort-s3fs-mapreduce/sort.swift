type file;

app (file outfile) findCutPoint (int partNum, file[] infiles)
{
    python "/s3/sort-s3fs-mapreduce/findCutPoint.py" partNum @filenames(infiles) stdout=@outfile;
}

app (file outfile[]) sort (file infile, int index, file cutPointsFile)
{
    python "/s3/sort-s3fs-mapreduce/sort.py" index @cutPointsFile @infile;
}

app (file outfile) merge (file[] infiles)
{
    python "/s3/sort-s3fs-mapreduce/merge.py" @filenames(infiles) stdout=@outfile;
}

app (file outfile) final (file[] infiles)
{
    cat @filenames(infiles) stdout=@outfile;
}

int reduceNum = toInt(arg("reduceNum",   "5"));

file infiles[] <filesys_mapper;pattern="split-*", location="/s3/sort-s3fs-mapreduce/input">;
file cutPointsFile <"/s3/sort-s3fs-mapreduce/output/cutPoints">;

cutPointsFile=findCutPoint(reduceNum,infiles);

file reduceinfiles[][];

foreach f,i in infiles {
//    tracef("%s\n",@f);
    string loc="/s3/sort-s3fs-mapreduce/output/"+toString(i);
//    tracef("infile location=%s\n",loc);
    file interfiles[] <filesys_mapper; pattern="*.txt", location=loc>;
    interfiles=sort(f,i,cutPointsFile);
    foreach ff in interfiles {
        reduceinfiles[toInt(strcut(@ff,"([0-9]+)\\.txt"))][i]=ff;
    }
}

file finalinputs[];

foreach i in [0:reduceNum-1] {
    string ofn="/s3/sort-s3fs-mapreduce/output/sorted-"+toString(i)+".txt";
//    tracef("reduceNum ofn=%s\n",ofn);
    file mfile <single_file_mapper;file=ofn>;
    file rfs[]=reduceinfiles[i];
//    foreach fff in rfs {
//	tracef("reduceinfiles:%d:file:%s\n",i,@fff);
//    }
    mfile=merge(rfs);
    finalinputs[i]=mfile;
}

file ffile <"/s3/sort-s3fs-mapreduce/output/sorted.txt">;

ffile=final(finalinputs);
