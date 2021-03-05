use <__comm__/_str_hash.scad>;
use <_impl/_hashset_impl.scad>;
use <../util/slice.scad>;
use <../util/some.scad>;

// public functions: hashset, hashset_has, hashset_add, hashset_del, hashset_list

df_hash = function(e) _str_hash(e);
df_eq = function(e1, e2) e1 == e2;
	
function hashset(lt, eq = df_eq, hash = df_hash, bucket_numbers = 16) =
    let(
	    lt_undef = is_undef(lt),
	    size = lt_undef ? bucket_numbers : len(lt),
	    buckets = [for(i = [0:bucket_numbers - 1]) []]
	)
	lt_undef ? buckets :
	_hashset(lt, len(lt), buckets, eq, hash);

function hashset_has(set, elem, eq = df_eq, hash = df_hash) =
    some(set[hash(elem) % len(set)], function(e) eq(e, elem));
	
function hashset_add(set, elem, eq = df_eq, hash = df_hash) =
    _hashset_add(set, elem, eq, hash);
	
function hashset_del(set, elem, eq = df_eq, hash = df_hash) =
    let(
	    bidx = hash(elem) % len(set),
		bucket = set[bidx],
		leng = len(bucket)
	)
	leng == 0 ? set :
	let(i = _find(bucket, elem, eq, leng))
	i == -1 ? set : 
	concat(
	    slice(set, 0, bidx), 
		[concat(slice(bucket, 0, i), slice(bucket, i + 1))],
		slice(set, bidx + 1)
	);

function hashset_list(set) = [
    for(bucket = set) 
        for(elem = bucket)
            elem		
];