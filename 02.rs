
use std::cmp;
use std::io;
use std::io::prelude::*;

#[derive(Debug)]
struct Box {
    height: i32,
    width: i32,
    depth: i32,
}

impl Box {
    fn min_side(&self) -> i32 {
        cmp::min(self.height * self.width,
                 cmp::min(self.width * self.depth,
                          self.height * self.depth))
    }

    fn paper(&self) -> i32 {
        2 * self.height * self.width +
            2 * self.width * self.depth +
            2 * self.height * self.depth +
            self.min_side()
    }

    fn min_edge(&self) -> i32 {
        cmp::min(2 * (self.height + self.width),
                 cmp::min(2 * (self.width + self.depth),
                          2 * (self.height + self.depth)))
    }

    fn volume(&self) -> i32 {
        self.height * self.width * self.depth
    }

    fn ribbon(&self) -> i32 {
        self.min_edge() + self.volume()
    }
}

fn parse_line(s: String) -> Box {
    let v : Vec<i32> =
        s.split('x')
            .map(|s| i32::from_str_radix(s, 10).unwrap())
            .collect();
    Box { height: v[0], width: v[1], depth: v[2] }
}

fn main() {
    let stdin = io::stdin();
    let mut total_paper = 0;
    let mut total_ribbon = 0;
    for line in stdin.lock().lines() {
        let b = parse_line(line.unwrap());
        total_paper = total_paper + b.paper();
        total_ribbon = total_ribbon + b.ribbon()
    }
    println!("paper: {}, ribbon: {}", total_paper, total_ribbon);
}

