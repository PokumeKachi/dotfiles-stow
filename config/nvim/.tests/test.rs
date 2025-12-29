use std::cell::RefCell;
use std::io::{self, Read};

thread_local! {
    static INPUT_ITER: RefCell<std::vec::IntoIter<Vec<u8>>> = {
        let mut bytes = Vec::new();
        io::stdin().lock().read_to_end(&mut bytes).unwrap();
        let tokens = bytes
            .split(|&b| b == b' ' || b == b'\n')
            .filter(|s| !s.is_empty())
            .map(|s| s.to_vec())
            .collect::<Vec<_>>();
        RefCell::new(tokens.into_iter())
    };
}

macro_rules! input {
    () => {{
        INPUT_ITER.with(|iter_cell| {
            let mut iter = iter_cell.borrow_mut();
            let token = iter.next().expect("not enough input");
            let s = std::str::from_utf8(&token).expect("invalid utf-8");
            s
        })
    }};
    ($t:ty) => {{
        INPUT_ITER.with(|iter_cell| {
            let mut iter = iter_cell.borrow_mut();
            let token = iter.next().expect("not enough input");
            let s = std::str::from_utf8(&token).expect("invalid utf-8");
            s.parse::<$t>().expect("parse error")
        })
    }};
}

fn main() {}
