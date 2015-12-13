
use std::collections::HashSet;
use std::io;
use std::io::prelude::*;

#[derive(Clone, Debug, Eq, Hash, PartialEq)]
struct Posn {
    x: i32,
    y: i32,
}

impl Posn {
    fn update(&self, dx: i32, dy: i32) -> Posn {
        Posn { x: self.x + dx, y: self.y + dy }
    }

    fn move_by(&self, ch: char) -> Posn {
        match ch {
            '^' => self.update(0, 1),
            '<' => self.update(-1, 0),
            '>' => self.update(1, 0),
            'v' => self.update(0, -1),
            _   => self.clone(),
        }
    }
}

fn main() {
    let stdin = io::stdin();
    let mut cur_posn = Posn { x: 0, y: 0 };

    let mut a_posn = Posn { x: 0, y: 0 };
    let mut b_posn = Posn { x: 0, y: 0 };
    let mut tmp;

    let mut single_visited = HashSet::new();
    let mut double_visited = HashSet::new();
    single_visited.insert(cur_posn.clone());
    double_visited.insert(a_posn.clone());

    for line in stdin.lock().lines() {
        for ch in line.unwrap().chars() {
            cur_posn = cur_posn.move_by(ch);
            a_posn = a_posn.move_by(ch);
            single_visited.insert(cur_posn.clone());
            double_visited.insert(a_posn.clone());
            tmp = a_posn; a_posn = b_posn; b_posn = tmp;
        }
    }
    println!("single: {}, double: {}",
        single_visited.len(),
        double_visited.len())
}

