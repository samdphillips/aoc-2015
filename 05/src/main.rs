
#[derive(Debug, Eq, PartialEq)]
enum CheckResult {
    Success,
    Failure,
    Uncertain,
}

trait Check {
    fn check(&mut self, i32, char) -> CheckResult;
}

#[derive(Debug)]
struct CheckVowels {
    count: i32,
}

const VOWELS: &'static [char] = &['a', 'e', 'i', 'o', 'u'];

impl Check for CheckVowels {
    #[allow(unused_variables)]
    fn check(&mut self, i: i32, c: char) -> CheckResult { 
        self.count = self.count + if VOWELS.contains(&c) { 1 } else { 0 };

        if self.count == 3 {
            CheckResult::Success
        } else {
            CheckResult::Uncertain
        }
    }
}

#[derive(Debug)]
struct CheckDoubles {
    last_char: Option<char>,
}

impl Check for CheckDoubles {
    #[allow(unused_variables)]
    fn check(&mut self, i: i32, c: char) -> CheckResult {
        match self.last_char {
            Some(prev) if prev == c => CheckResult::Success,
            _ => { self.last_char = Some(c);
                   CheckResult::Uncertain },
        }
    }
}

const BAD_STRINGS: &'static [&'static str] = &["ab", "cd", "pq", "xy"];

#[derive(Debug)]
struct CheckBad {
    last_char: Option<char>,
}

fn is_bad_digraph(s: String) -> bool {
    BAD_STRINGS.contains(&&s[..])
}

impl Check for CheckBad {
    #[allow(unused_variables)]
    fn check(&mut self, i: i32, c: char) -> CheckResult {
        match self.last_char {
            Some(prev) if is_bad_digraph(format!("{}{}", prev, c))
                => CheckResult::Failure,
            _ => { self.last_char = Some(c);
                   CheckResult::Uncertain },
        }
    }
}

fn main() {
    println!("Hello, world!");
}

#[test]
fn test_check_vowels() {
    let mut c = CheckVowels { count: 0 };
    assert_eq!(c.check(0, 'a'), CheckResult::Uncertain);
    assert_eq!(c.check(1, 'a'), CheckResult::Uncertain);
    assert_eq!(c.check(2, 'a'), CheckResult::Success);
}

#[test]
fn test_check_double() {
    let mut c = CheckDoubles { last_char: None };
    assert_eq!(c.check(0, 'a'), CheckResult::Uncertain);
    assert_eq!(c.check(1, 'b'), CheckResult::Uncertain);
    assert_eq!(c.check(2, 'b'), CheckResult::Success);
}

#[test]
fn test_check_bad() {
    let mut c = CheckBad { last_char: None };
    assert_eq!(c.check(0, 'a'), CheckResult::Uncertain);
    assert_eq!(c.check(1, 'b'), CheckResult::Failure);

    let mut c = CheckBad { last_char: None };
    assert_eq!(c.check(0, 'a'), CheckResult::Uncertain);
    assert_eq!(c.check(1, 'a'), CheckResult::Uncertain);
}
