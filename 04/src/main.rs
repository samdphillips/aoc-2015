
extern crate md5;

fn is_adventcoin(d: md5::Digest) -> bool {
    let a = d[0];
    let b = d[1];
    let c = d[2];
    (a == 0) && (b == 0) && (c >> 4 == 0)
}

fn is_adventcoin2(d: md5::Digest) -> bool {
    let a = d[0];
    let b = d[1];
    let c = d[2];
    (a == 0) && (b == 0) && (c == 0)
}

fn check_adventcoin(k: &str, i: i32) -> bool {
    let s = format!("{}{}", k, i);
    is_adventcoin2(md5::compute(s.as_bytes()))
}

fn main() {
    let k = "yzbqklnj";
    let mut i = 1;
    while !check_adventcoin(k, i) {
        i = i + 1
    }
    println!("{}", i)
}

#[test]
fn test_predicate() {
    assert!(is_adventcoin(md5::compute("abcdef609043".as_bytes())));
    assert!(!is_adventcoin(md5::compute("abcdef609042".as_bytes())))
}

