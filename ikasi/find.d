import std.stdio;
import std.file;

int main(string[] argv)
{
    string path;
    if (argv.length < 2)
    {
        path = ".";
    }
    else
    {
        path = argv[1];
    }
    foreach(DirEntry e; dirEntries(path,SpanMode.depth))
    {
        writeln(e.name);
    }
    return 0;
}
