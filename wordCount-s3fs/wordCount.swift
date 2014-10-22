type file;

file wc_script <"wordCount.py">;
file m_script <"merge.py">;

app (file outfile) wordCount (file infile, file wc_script)
{
    python @wc_script @infile stdout=@outfile;
}

app (file outfile) merge (file[] infiles, file m_script)
{
    python @m_script @filenames(infiles) stdout=@outfile;
}

file infile[] <filesys_mapper;pattern="split-*", location="/s3/wordCount-s3fs/input">;
file wcfile[] <simple_mapper;prefix="wcfile",suffix=".txt", padding=4, location="/s3/wordCount-s3fs/output">; 
file wclog[] <simple_mapper;prefix="wclog",suffix=".txt", padding=4, location="/s3/wordCount-s3fs/output">;

tracef("test\n");
foreach f,i in infile {
//    tracef("%s\n",@f);
    wcfile[i]=wordCount(f,wc_script);
}

file mfile <"/s3/wordCount-s3fs/output/result.txt">;
file mlog <"/s3/wordCount-s3fs/output/mlog.txt">;

mfile=merge(wcfile,m_script);
