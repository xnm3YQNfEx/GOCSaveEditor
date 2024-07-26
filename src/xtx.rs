
pub struct XTX {}

impl XTX {
    pub fn decrypt(data: &Vec<u8>) -> Vec<u8> {
        let key = vec![175, 222, 222, 250];
        let mut decrypted = data.clone();
        
        let rounded_len = data.len() & 0xFFFFFFFC;
        for i in 0..rounded_len {
            let value = data[i] ^ key[i%4];
            decrypted[i] = value;
        }

        if data.len() % 2 == 1 {
            decrypted[rounded_len]  = decrypted[rounded_len] ^ 0xFF;
        }
        decrypted
    }
}

