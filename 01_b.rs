
use std::io;

fn counter<T: io::Read>(f: T) -> Option<usize> {
    let mut count = 0;
    for (i, b) in f.bytes().enumerate() {
        count = count + match b.unwrap() {
            40 =>  1,
            41 => -1,
            _  =>  0,
        };
        if count < 0 { return Some(i + 1) }
    }
    None
}

fn main() {
    let stdin = io::stdin();
    println!("{}", counter(stdin).unwrap());
}

