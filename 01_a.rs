
use std::io;

fn counter<T: io::Read>(f: T) -> i32 {
    let mut count = 0;
    for b in f.bytes() {
        count = count + match b.unwrap() {
            40 =>  1,
            41 => -1,
            _  =>  0,
        }
    }
    count
}

fn main() {
    let stdin = io::stdin();
    println!("{}", counter(stdin));
}

