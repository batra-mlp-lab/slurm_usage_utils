function isnumeric(x)
{
    return ( x == x+0 );
}

function name_to_number(name, predefined)
{
    if (isnumeric(name))
        return name;

    if (name in predefined)
        return predefined[name];

    return name;
}

function colour(v1, v2, v3)
{
    if (v3 == "" && v2 == "" && v1 == "")
        return;

    if (v3 == "" && v2 == "")
        return sprintf("%c[%dm", 27, name_to_number(v1, fgcolours));
    else if (v3 == "")
        return sprintf("%c[%d;%dm", 27, name_to_number(v1, bgcolours), name_to_number(v2, fgcolours));
    else
        return sprintf("%c[%d;%d;%dm", 27, name_to_number(v1, attributes), name_to_number(v2, bgcolours), name_to_number(v3, fgcolours));
}
