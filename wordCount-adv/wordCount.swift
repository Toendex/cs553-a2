type file;

file wc_script <"wordCount.py">;
file m_script <"merge.py">;

app (file outfile) wordCount (file infile, file wc_script)
{
    python @wc_script @infile stdout=@outfile;
}

app (file outfile) merge (file[] infiles, file m_py)
{
    m_script @filenames(infiles) stdout=@outfile;
}

file infile[] <filesys_mapper;pattern="split-*", location="input">;
file wcfile[];
file wclog[] <simple_mapper;prefix="wclog",suffix=".txt", padding=4, location="output">;

tracef("test\n");
foreach f,i in infile {
//    tracef("%s\n",@f);
    wcfile[i]=wordCount(f,wc_script);
}

file mfile <"output/result.txt">;
file mlog <"output/mlog.txt">;

mfile=merge(wcfile,m_script);
