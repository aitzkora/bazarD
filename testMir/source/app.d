import std.stdio;
import mir.internal.utility;
import mir.ndslice.internal;
import mir.ndslice.concatenation;
import mir.primitives;
import mir.ndslice.iterator;
import mir.ndslice.field;
import mir.utility;


int main()
{
    import mir.ndslice;

    auto matrix = slice!double(3, 4);
    matrix[] = 0;
    matrix[0..2, 0..2] = 1;
    writeln(matrix);
    auto z =  2 *  matrix;
    return 0;
}
