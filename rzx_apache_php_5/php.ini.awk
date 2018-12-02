BEGIN {
        skip = 0;
}

/^upload_max_filesize = / {
        print "upload_max_filesize = 64M";
        skip = 1;
}

/^zlib.output_compression = / {
        print "zlib.output_compression = On";
        skip = 1;
}

/^post_max_size = / {
        print "post_max_size = 64M"
        skip = 1;
}

/^;extension=php_bz2.dll / {
        print "extension=php_bz2.dll"
        skip = 1;
}

/^;extension=php_gd2.dll / {
        print "extension=php_gd2.dll"
        skip = 1;
}

/^;extension=php_mbstring.dll / {
        print "extension=php_mbstring.dll"
        skip = 1;
}

/^;extension=php_xsl.dll / {
        print "extension=php_xsl.dll"
        skip = 1;
}


/.*/ {
        if (skip)
                skip = 0;
        else
                print $0;
}
