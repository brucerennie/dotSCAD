function count(lt, test) = len([for(elem = lt) if(test(elem)) undef]);