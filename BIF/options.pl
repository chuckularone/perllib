($options) = 
{
'sfile' =>
        {
        'type'      => '=s',
        'env'       => '-',
        'default'   => '',
        'verbose'   => 'Path and file name of file to be converted.',
        'order'     => 1,
        'required'     => 1,
        },
'tfile' =>
        {
        'type'      => '=s',
        'env'       => '-',
        'default'   => '',
        'verbose'   => 'Path and file name of output file.',
        'order'     => 2,
        'required'     => 0,
        },
'landscape' =>
        {
        'type'      => '=s',
        'env'       => '-',
        'default'   => '',
        'verbose'   => 'Set to 1 for landscape.',
        'order'     => 3,
        'required'     => 0,
        },
'fontsize' =>
        {
        'type'      => '=s',
        'env'       => '-',
        'default'   => '10',
        'verbose'   => 'Set to 10 for smaller font.',
        'order'     => 4,
        'required'     => 0,
        },
'font' =>
        {
        'type'      => '=s',
        'env'       => '-',
        'default'   => 'C',
        'verbose'   => 'set font',
        'order'     => 5,
        'required'     => 0,
        },
'doctitle' =>
        {
        'type'      => '=s',
        'env'       => '-',
        'default'   => 'Programmatically Converted Text',
        'verbose'   => 'Title of this document',
        'order'     => 6,
        'required'     => 0,
        },
'docauthor' =>
        {
        'type'      => '=s',
        'env'       => '-',
        'default'   => 'Cloverleaf',
        'verbose'   => 'Author of this document',
        'order'     => 7,
        'required'     => 0,
        },
'debug' =>
        {
        'type'      => '=s',
        'env'       => '-',
        'default'   => '0',
        'verbose'   => 'debug: Turn on debug mode',
        'order'     => 8,
        'required'     => 0,
        },
};        

Title
