pub struct RLE {}

impl RLE {

    // Iterate through the bytes, building up a temp buffer
    // Check first two bytes to determine whether repeated or not
    // Continues to read bytes and builds up a temp buffer as long mode doesn't change
    // When a change is detected, or the buffer hits the limit of 126, write it out and flush the buffer
    // Continue until all bytes are encoded
    // See decode function for details on how the encoding works.
    pub fn encode(input: &Vec<u8>) -> Vec<u8> {
        #[derive(Debug)]
        enum Mode {
            Normal,
            Repeated
        }
        let mut output: Vec<u8> = Vec::new(); // Final return value
        let mut temp: Vec<u8> = Vec::new(); // Temp buffer
        let mut written: bool = true; // Flag to indicate whether the temp buffer was written to output
        let mut mode = Mode::Normal; // Enum to indicate current state
        let max_buffer_len = 126;
    
    
        let mut iterator = input.iter();
    
        if let Some(byte) = iterator.next() {
            temp.push(*byte);
        }
        if let Some(byte) = iterator.next() {
            temp.push(*byte);
        }
       
        while let Some(byte) = iterator.next() {
            let len = temp.len();
    
            if len > max_buffer_len {
                // Should never hit this condition!
                // Regardless of mode, when length of temp buffer is 126, it gets written to the output
                // Could return None, but may be confusing to debug, I'd rather it just panic with a clear error.
                // May look into better ways of handling error conditions when working on the GUI.
                // Bubble up an error to the user rather than just, what I'd assume is just crashing for no good reason.
                panic!("Length of temp buffer in rle encode shouldn't be larger that 126! Was {}", len);
            }
            
            if written {
                if temp[len -1 ] == temp[len - 2] {
                    mode = Mode::Repeated;
                } else {
                    mode = Mode::Normal;
                }
    
                written = false;
            }
            match mode {
                Mode::Repeated => {
                    if *byte != temp[len - 1] || temp.len() == max_buffer_len {
                        output.push(-(temp.len() as i8) as u8);
                        output.push(temp[0]);
                        temp.clear();
                        written = true;
    
                        temp.push(*byte);
    
                        if let Some(next) = iterator.next(){
                            temp.push(*next);
                        }
    
                    } else {
                        temp.push(*byte);
                    }
                },
                Mode::Normal => {
                    if *byte == temp[len - 1] || temp.len() == max_buffer_len {
                        let prev = temp.pop();
                        output.push(temp.len() as u8);
                        output.extend_from_slice(temp.as_slice());
                        temp.clear();
                        if prev.is_some() {
                            temp.push(prev.unwrap());
                        } else {
                            panic!("Attempted to unwrap prev, but there was None"); 
                            // TODO: Look into better error handling rather than panic, as above
                        }
                        written = true;
                    }
                    
                    temp.push(*byte);
                }
            }
        }
        // When we hit the end of the Vec, the following will handle the remaining data in temp buffer
        let len = temp.len() as i8;
        if len > 0 {
            match mode {
                Mode::Normal => {
                    output.push(len as u8);
                    output.extend_from_slice(temp.as_slice());
                },
                Mode::Repeated => {
                    output.push(-(len) as u8);
                    output.push(temp[0]);
                }
            }
        }
        return output
    }
    
    
    // Reads in a byte representing a 'length'. 
    // Negative means the following byte is repeated 'length' times to the output
    // Positive means the following 'length' bytes are unmodified and written directly to output
    // Returns None if it fails to decode.
    pub fn decode(input: &Vec<u8>) -> Option<Vec<u8>> {
    
        let mut output: Vec<u8> = Vec::new();
        let mut iterator = input.iter();
    
        //while buf.read_pos < buf.data.len() {
        while let Some(length) = iterator.next() {
            let length = *length as i8;
                
            if length > 0 {
                for _i in 0..length {
                    if let Some(byte) = iterator.next() {
                        output.push(*byte);
                    } 
                    // TODO: Should maybe handle condition where Some is None? Just slap in a panic to debug later
                }
            } else if length < 0 {
                if let Some(repeated_char) = iterator.next() {
                    for _i in 0..-length {
                        output.push(*repeated_char);
                    }
                    // TODO: Should maybe handle condition where Some is None? Just slap in a panic to debug later
                }
            } else {
                return None
            }
            // TODO: Should maybe handle condition where Some is None? Just slap in a panic to debug later
        }
        Some(output)
    }
}